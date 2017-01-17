module Versions
  module Version2
    module Helpers
      module Conversations
        def paginated_conversations(user_id)
	        _conversations = Chat::Room.get_roommates(user_id)
	        _conversations
      	end
      end
    end
  end
end
