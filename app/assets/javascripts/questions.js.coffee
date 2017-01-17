# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require underscore
#= require backbone
#= require select2
#= require_tree ./questions

$ ->
  seconds = (n) ->
    1000 * n

  $("#conference_id").select2()
  $("#conference_id_select").on "click", ->
    questions = new QuestionsView
    setInterval( ->
      questions.fetch()
    , seconds(30))
