# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#save-draft-button").on("click", (event) ->
    $("#conference_archived").prop("checked", true)
    $(".new_conference, .edit_conference").submit()
  )

  $(".new_conference, .edit_conference").on "submit", (event) ->
    if ($("#conference_start_at").val() is "" or $("#conference_end_at").val() is "") and not $("#conference_archived").prop("checked")
      event.preventDefault()
      $('#save-draft-modal').modal()
