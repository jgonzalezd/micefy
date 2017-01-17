class Chat::Room < Chat::Model
	def self.get_room(owner_id, invited_id)
		puts "Getting room for owner_id #{owner_id}"
		id = $redis.sinter("user:#{owner_id}:rooms:active","user:#{invited_id}:rooms:active")
		if id.empty?
			# can't use to_s inside a multi block as in room:#{id}
			#$redis.multi do
				id = $redis.incr("room:roomid")
				$redis.sadd("user:#{owner_id}:rooms:active","room:#{id}")
				$redis.sadd("user:#{invited_id}:rooms:active","room:#{id}")
				$redis.sadd("room:#{id}:users","user:#{owner_id}")
				$redis.sadd("room:#{id}:users","user:#{invited_id}")
				id.to_s
			#end
		else
			id.first.split(':').last # returns "id"
		end
	end

	def self.user_ids_by_room_id(id)
		members = $redis.smembers("room:#{id}:users")
		room_user_ids = members.map {|m| m.split(":")[1]}.compact
	end

	def self.get_roommates(owner_id)
		rooms = $redis.smembers("user:#{owner_id}:rooms:active")
		result = []
		if rooms.empty?
			result
		else
			rooms.each do |room|
				hashed_room = Hash[*room.split(':')] 			#{room: 1}
				rommates = $redis.smembers("#{room}:users")
				rommates.delete("user:#{owner_id}")
		        hashed_user = Hash[*rommates.first.split(':')] 	#{user: 2}
		        #TODO: Get name from cache
		        user = User.find(hashed_user["user"])
		        hashed_user["name"] = user.name 				#{user: 2, name: "ronaldinho"}
				result.push(hashed_room.merge(hashed_user).with_indifferent_access)			#{room: 1, user: 2, name: "ronaldinho"}
			end
			result
		end
	end
end
