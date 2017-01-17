module Versions
  module Version2
    module Resources
      class Questions < Grape::API
        resource :questions do
          helpers Versions::Version2::Helpers::Authentication
          get do
            authenticate!
            conference = Conference.find(params[:conference_id])
            questions = conference.questions.tally.page(params[:page]).per(params[:per])
            present questions, with: Versions::Version2::Entities::Questions, user: api_current_user
          end
          post do
            authenticate!
            conference = Conference.find(params[:conference_id])
            question = conference.questions.new params[:question]
            question.user = api_current_user
            question.save
            present question, with: Versions::Version2::Entities::Questions, user: api_current_user
          end
          route_param :id do
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
                question.update_attributes(params[:question])
              end
              present question, with: Versions::Version2::Entities::Questions, user: api_current_user
            end
            delete do
              authenticate!
              conference = Conference.find(params[:conference_id])
              question = conference.questions.find_by(id: params[:id], user_id: api_current_user.id)
              question.destroy
              present question, with: Versions::Version2::Entities::Questions, user: api_current_user
            end
          end
        end
      end
    end
  end
end
