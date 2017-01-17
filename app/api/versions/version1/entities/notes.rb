module Versions
  module Version1
    module Entities
      class Notes < Grape::Entity
        format_with(:default) {|dt| dt.to_s :default}
        expose :id
        expose :content
        with_options(format_with: :default) do
          expose :created_at
          expose :updated_at
        end
      end
    end
  end
end

