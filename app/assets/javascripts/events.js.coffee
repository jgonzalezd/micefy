# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#event_start_at, #event_end_at").datetimepicker({
    dateFormat: "DD, dd MM, yy",
    timeFormat: "hh:mm tt"
  })
