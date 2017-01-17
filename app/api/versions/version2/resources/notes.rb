module Versions
  module Version2
    module Resources
      class Notes < Grape::API
        resource :notes do
          helpers Versions::Version2::Helpers::Authentication

          get do
            conference = Conference.find(params[:conference_id])
            notes = conference.notes.where(user_id: api_current_user.id).page(params[:page]).per(params[:per])
            present notes, with: Versions::Version2::Entities::Notes
          end

          params do
            requires :content, type: String
          end
          post do
            authenticate!
            conference = Conference.find(params[:conference_id])
            note = conference.notes.new declared(params)
            note.user = api_current_user
            note.save
            present note, with: Versions::Version2::Entities::Notes
          end

          route_param :id do
            params do
              requires :content, type: String
            end

            put do
              authenticate!
              conference = Conference.find(params[:conference_id])
              note = conference.notes.find_by(id: params[:id], user_id: api_current_user.id)
              note.update_attributes(declared(params))
              present note, with: Versions::Version2::Entities::Notes
            end

            delete do
              authenticate!
              conference = Conference.find(params[:conference_id])
              note = conference.notes.find_by(id: params[:id], user_id: api_current_user.id)
              note.destroy
              present note, with: Versions::Version2::Entities::Notes
            end
          end

        end
      end
    end
  end
end
