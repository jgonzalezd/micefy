# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  targetAnchorMap = undefined
  setPlaceData = (name, result) ->
    if result.address_components?
      address = [
        result.address_components[0] and result.address_components[0].short_name or ""
        result.address_components[1] and result.address_components[1].short_name or ""
        result.address_components[2] and result.address_components[2].short_name or ""
      ].join(" ")
    location = $(targetAnchorMap).parents(".list-group-item:first")
    latitude = result.geometry.location.lat()
    longitude = result.geometry.location.lng()
    location.find('[name$="[name]"]').val(name)
    location.find('[name$="[address]"]').val(address)
    location.find('[name$="[latitude]"]').val(latitude)
    location.find('[name$="[longitude]"]').val(longitude)
    timestamp = Math.round((new Date().getTime())/1000)
    latlng = result.geometry.location.toUrlValue()
    $.ajax(
      url:"https://maps.googleapis.com/maps/api/timezone/json?location=#{latlng}&timestamp=#{timestamp.toString()}&sensor=false"
    ).done((response) ->
       if(response.timeZoneId != null)
         #rawOffset = response.rawOffset
         #dstOffset = response.dstOffset
         #timezone = (rawOffset + dstOffset) / 3600
         timezone = response.timeZoneId
         $("[name='event[timezone]']").val(timezone)
         $("[name='event[timezone]']").trigger("change")
    )

  initialize = ->
    mapOptions =
    center: new google.maps.LatLng(-33.8688, 151.2195)
    zoom: 13
    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
    geocoder = new google.maps.Geocoder()
    input = document.getElementById("pac-input")
    map.controls[google.maps.ControlPosition.TOP_LEFT].push input
    autocomplete = new google.maps.places.Autocomplete(input)
    autocomplete.bindTo "bounds", map
    infowindow = new google.maps.InfoWindow()
    marker = new google.maps.Marker(
      map: map
      draggable: true
      anchorPoint: new google.maps.Point(0, -29)
    )
    google.maps.event.addListener marker, "dragend", (event) ->
      infowindow.close()
      $(input).val("")
      geocoder.geocode
        latLng: @position
      , (results, status) ->
        if status is google.maps.GeocoderStatus.OK
          if results[0]
            setPlaceData($(input).val(), results[0])
          else
            alert "No results found"
        else
          alert "Geocoder failed due to: " + status
        return

      return

    google.maps.event.addListener autocomplete, "place_changed", =>
      infowindow.close()
      marker.setVisible false
      place = autocomplete.getPlace()
      return unless place.geometry

      # If the place has a geometry, then present it on a map.
      if place.geometry.viewport
        map.fitBounds place.geometry.viewport
      else
        map.setCenter place.geometry.location
        map.setZoom 17 # Why 17? Because it looks good.
      marker.setIcon (
        url: place.icon
        size: new google.maps.Size(71, 71)
        origin: new google.maps.Point(0, 0)
        anchor: new google.maps.Point(17, 34)
        scaledSize: new google.maps.Size(35, 35)
      )
      marker.setPosition place.geometry.location
      marker.setVisible true
      address = ""
      if place.address_components
        address = [
          place.address_components[0] and place.address_components[0].short_name or ""
          place.address_components[1] and place.address_components[1].short_name or ""
          place.address_components[2] and place.address_components[2].short_name or ""
        ].join(" ")
      infowindow.setContent "<div><strong>" + place.name + "</strong><br>" + address
      infowindow.open map, marker
      latlng = place.geometry.location #new google.maps.LatLng(6.265345, -75.56678799999997);
      geocoder.geocode
        latLng: place.geometry.location
      , (results, status) ->
        if status is google.maps.GeocoderStatus.OK
          if results[0]
            setPlaceData(place.name, place)
          else
            alert "No results found"
        else
          alert "Geocoder failed due to: " + status
        return
      return
    types = []
    autocomplete.setTypes types
    return

  $("#place-selector").on "shown.bs.modal", (event) =>
    targetAnchorMap = event.relatedTarget

  $("#place-selector").one "shown.bs.modal", ->
    initialize();

  $(".edit_event, .new_event").on "keypress", "#pac-input", (event) =>
    if event.which is 13
      event.preventDefault()

  $(".edit_event").on "submit", (event, data) ->
    locations = $(this).find(".location")
    name = $(this).find(".location input[name$='[name]']")
    id = $(this).find(".location input[name$='[id]']")
    if locations.length is 1 and name.val() isnt "" and id.val() is "" and not data?
      event.preventDefault()
      $("#conferences-default-location-modal").modal()

  $("#conferences-default-location-not-set").on "click", (event) ->
    $("#conferences-default-location-modal").modal('hide')
    $(".edit_event").trigger("submit", set_default_location: false)

  $("#conferences-default-location-set").on "click", (event) ->
    $("#event_set_location_to_all_confs").val("true")
    $("#conferences-default-location-modal").modal('hide')
    $(".edit_event").trigger("submit", set_default_location: true)

  $("#event_description").on "keypress", (event) ->
    if event.target.value.length >= 500
      event.preventDefault()
      message = $(event.target).next()
      if message.length is 0
        message = """
          <span class="pull-right">Limite maximo de caracteres alcanzado</span>
        """
        $(event.target).after(message)

  $("#event_description").on "keyup", (event) ->
    if event.which is 8 and event.target.value.length < 500
      message = $(event.target).next()
      message.remove()

  checkTimeZone = ->
    if $("#event_timezone").val() is ""
      $("#event_start_at").attr("disabled", "disabled")
      $("#event_end_at").attr("disabled", "disabled")
      $("#warning-location-date").removeClass( "hide" ).addClass("show text-danger")
    else
      $("#event_start_at").removeAttr("disabled")
      $("#event_end_at").removeAttr("disabled")
      $("#warning-location-date").removeClass("show").addClass("hide")
  $("#event_timezone").change(->
    console.log("changed")
    checkTimeZone()
  )
  checkTimeZone()
