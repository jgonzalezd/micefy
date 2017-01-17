module Versions
  module Version1
    module Resources
      class Notes < Grape::API
        resource :notes do
          helpers Versions::Version1::Helpers::Authentication
          params do
            optional :page, type: Integer, default: 1, desc: "Page."
            optional :limit, type: Integer, default: 10, desc: "Quantity."
            optional :conditions, type: Hash, default: {}, desc: "Conditions."
          end
          get do
            conference = Conference.find(params[:conference_id])
            notes = conference.notes.where(user_id: api_current_user.id).page(params[:page]).per(params[:per])
            present notes, with: Versions::Version1::Entities::Notes
          end
          post do
            authenticate!
            conference = Conference.find(params[:conference_id])
            white_list_attributes = ["content"]
            attributes = params.select {|key, value| white_list_attributes.include?(key)}
            note = conference.notes.new attributes
            note.user = api_current_user
            note.save
            present note, with: Versions::Version1::Entities::Notes
          end
          put do
            authenticate!
            conference = Conference.find(params[:conference_id])
            note = conference.notes.find_by(id: params[:note_id], user_id: api_current_user.id)
            white_list_attributes = ["content"]
            attributes = params.select {|key, value| white_list_attributes.include?(key)}
            note.update_attributes(attributes)
            present note, with: Versions::Version1::Entities::Notes
          end
          delete do
            authenticate!
            conference = Conference.find(params[:conference_id])
            note = conference.notes.find_by(id: params[:note_id], user_id: api_current_user.id)
            note.destroy
            present note, with: Versions::Version1::Entities::Notes
          end
        end
      end
    end
  end
end
