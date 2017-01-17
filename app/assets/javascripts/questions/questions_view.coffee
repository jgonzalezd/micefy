root = exports ? this

class QuestionsView extends Backbone.View
  el: ".questions"

  initialize: ->
    @questions = new Questions
    @listenTo @questions, "reset", @render
    @conference_id = $("#conference_id").val()
    @token = $("#token").val()
    @fetch()

  fetch: ->
    @questions.fetch(
      data:
        conference_id: @conference_id
        token: @token
      reset: true
    )

  render: ->
    @$el.html("")
    @questions.each (question) =>
      @addQuestion(question)

  addQuestion: (question) ->
    question_view = new QuestionView(model: question)
    @$el.append(question_view.el)

root.QuestionsView = QuestionsView
