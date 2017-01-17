root = exports ? this

class QuestionView extends Backbone.View

  tagName: "li"
  className: "question"

  template: questionTemplate

  events:
    "click": "open"

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(@model))

  open: ->
    console.log(@model)

root.QuestionView = QuestionView
