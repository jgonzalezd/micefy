module Versions
  module Version1
    module Resources
      class Chatrooms < Grape::API
        resource :chatrooms do
          helpers Versions::Version1::Helpers::Authentication

          get do
            authenticate!
            Chat::Room.get_roommates(api_current_user.id)
          end


          namespace :messages do
            params do
              requires :user_id, type: Integer
            end
            get do
              authenticate!
              last_message = params[:last_message_id]
              invited_id = params[:user_id]
              result = []
              # return "Unathorized room" unless api_current_user.in_this room
              # retrieve room based in current user and another given user id (invited_id)
              owner_id = api_current_user.id
              puts "Getting room_id for owner_id: #{owner_id} and invited_id: #{invited_id}"
              room = $redis.sinter("user:#{owner_id}:rooms:active","user:#{invited_id}:rooms:active")
              if room.empty?
                return result
              else
                room = room.first.split(':').last
              end

              if last_message
                last_message_timestamp= $redis.hget("room:#{room}:message:#{last_message.to_i + 1}", "timestamp")
                if last_message_timestamp.nil?
                  result
                else
                  unseen_messages = $redis.zrangebyscore("room:#{room}", last_message_timestamp,"+inf", withscores:true)
                  unseen_messages.each do |zmessage|
                    message_values = $redis.hgetall("room:#{room}:#{zmessage[0]}")
                    if message_values.present?
                      message_values[:id] = zmessage[0].split(':').last
                      result.push(message_values)
                    end
                  end
                  result
                end
              else
                unseen_messages = $redis.zrange("room:#{room}", 0,-1, withscores:true)
                unseen_messages.each do |zmessage|
                  message_values = $redis.hgetall("room:#{room}:#{zmessage[0]}")
                  if message_values.present?
                    message_values[:id] = zmessage[0].split(':').last
                    result.push(message_values)
                  end
                end
                result
              end
            end

            post do
              authenticate!
              room_id = Chat::Room.get_room(api_current_user.id, params[:receiver_id])
              message = Chat::Message.create(params[:sender_id], params[:content], room_id)
              room_mates_ids = Chat::Room.user_ids_by_room_id(room_id)
              begin
                receiver_ids = room_mates_ids - [api_current_user.id]

                receiver_ids.each do |receiver_id|
                  ::Pusher.trigger("user-#{receiver_id}", "message-new", {sender_id: api_current_user.id, name: api_current_user.name })
                end
              rescue Exception => e
                puts "[ERROR]: Unable to deliver message to receiver due to an error in Pusher:\n #{e}"
              end
              message
            end
          end

        end
      end
    end
  end
end
