class Chat::Message < Chat::Model
	def self.create(sender_id, message, room_id)
		#$redis.multi do
			id = $redis.incr("room:#{room_id}:message:messageid")
      		timestamp = Time.now.to_i
			$redis.hmset("room:#{room_id}:message:#{id}", "sender", sender_id, "timestamp", timestamp, "content", message)
			$redis.zadd("room:#{room_id}",timestamp, "message:#{id}")
      		{content: message, id: id, sender: sender_id, timestamp: timestamp}
		#end
	end

	def self.get_message(key)
		$redis.hgetall(key)
	end
end
