module Versions
  module Version1
    module Resources
      class Interests < Grape::API
        resource :interests do
          helpers Versions::Version1::Helpers::Authentication
          params do
            optional :page, type: Integer, default: 1, desc: "Page."
            optional :limit, type: Integer, default: 10, desc: "Quantity."
            optional :conditions, type: Hash, default: {}, desc: "Conditions."
          end
          desc "Autocomplete interests"
          get do
            context = :interests
            interests_list = api_current_user.interest_list
            q = params[:q].present? ? "#{params[:q]}%" : ""
            exclude_interests = params[:exclude].present? ? params[:exclude].split(",") : []
            ActsAsTaggableOn::Tag.select("DISTINCT #{ActsAsTaggableOn::Tag.table_name}.*").joins(:taggings).where([%(#{
              ActsAsTaggableOn::Tagging.table_name}.context = ? AND #{
              ActsAsTaggableOn::Tag.table_name}.name LIKE ? AND #{
              ActsAsTaggableOn::Tag.table_name}.name NOT IN (?)
            ), context, q, exclude_interests])
          end

          get :conference do
            conference = Conference.find(params[:conference_id])
            owner = conference
            context = :interests
            ActsAsTaggableOn::Tag.joins(:taggings).where([%(#{ActsAsTaggableOn::Tagging.table_name}.context = ? AND
              #{ActsAsTaggableOn::Tagging.table_name}.tagger_id = ? AND #{ActsAsTaggableOn::Tagging.table_name}.tagger_type = ?),
              context.to_s, owner.id, owner.class.base_class.to_s])
          end
          put 'conference/update' do
            conference = Conference.find(params[:conference_id])
            conference.tag(api_current_user, tags, on: :interests)
          end
        end
      end
    end
  end
end
