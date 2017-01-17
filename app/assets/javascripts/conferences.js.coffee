# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#conference_start_at, #conference_end_at").datetimepicker({
    dateFormat: "DD, dd MM, yy",
    timeFormat: "hh:mm tt"
  })
