class Micropost
	def self.create(user_id, event_id, content)
		#TODO: Get name from cache
		name = User.find_by_id(user_id).name
		data = {user_id: user_id, user: name, content: content}
		$redis.zadd("micropost:#{event_id}",Time.now.to_i, data.to_json)
		data
	end

	def self.get_all(event_id)
		puts "[DEBUG]: event_id: #{event_id}"
		posts=$redis.zrange("micropost:#{event_id}", 0, -1)
		result = Array.new
		posts.each do |json_string|
			result << JSON.parse(json_string)
		end
		result
	end
end
