module Versions
  module Version1
    module Resources
      class Questions < Grape::API
        resource :questions do
          helpers Versions::Version1::Helpers::Authentication
          params do
            optional :page, type: Integer, default: 1, desc: "Page."
            optional :limit, type: Integer, default: 10, desc: "Quantity."
            optional :conditions, type: Hash, default: {}, desc: "Conditions."
          end
          get do
            conference = Conference.find(params[:conference_id])
            questions = conference.questions.tally.page(params[:page]).per(params[:per])
            present questions, with: Versions::Version1::Entities::Questions, user: api_current_user
          end
          post do
            authenticate!
            conference = Conference.find(params[:conference_id])
            white_list_attributes = ["content"]
            attributes = params.select {|key, value| white_list_attributes.include?(key)}
            question = conference.questions.new attributes
            question.user = api_current_user
            question.save
            present question, with: Versions::Version1::Entities::Questions, user: api_current_user
          end
          put do
            authenticate!
            conference = Conference.find(params[:conference_id])
            case params[:vote]
            when 'up'
              question = conference.questions.find_by(id: params[:question_id])
              api_current_user.vote_for(question)
            when 'down'
              question = conference.questions.find_by(id: params[:question_id])
              api_current_user.unvote_for(question)
            else
              question = conference.questions.find_by(id: params[:question_id], user_id: api_current_user.id)
            end
            present question, with: Versions::Version1::Entities::Questions, user: api_current_user
          end
          delete do
            authenticate!
            conference = Conference.find(params[:conference_id])
            question = conference.questions.find_by(id: params[:question_id], user_id: api_current_user.id)
            question.destroy
            present question, with: Versions::Version1::Entities::Questions, user: api_current_user
          end
        end
      end
    end
  end
end
