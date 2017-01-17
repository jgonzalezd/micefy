module Versions
  module Version2
    module Helpers
      module Messages
        
        def paginated_messages(user_id, receiver_id, last_message_id)
          last_message = last_message_id
          invited_id = receiver_id
          result = []
          # return "Unathorized room" unless api_current_user.in_this room
          # retrieve room based in current user and another given user id (invited_id)
          owner_id = user_id
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
                  result.push(message_values.with_indifferent_access)
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
                result.push(message_values.with_indifferent_access)
              end
            end
            result
          end
          result
        end

        def create_message(sender_id, sender_name, receiver_id, content)
          room_id = Chat::Room.get_room(sender_id, receiver_id)
          message = Chat::Message.create(sender_id, content, room_id)
          room_mates_ids = Chat::Room.user_ids_by_room_id(room_id)
          begin
            receiver_ids = room_mates_ids - [sender_id]

            receiver_ids.each do |re_id|
              ::Pusher.trigger("user-#{re_id}", "message-new", {sender_id: sender_id, name: sender_name })
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
