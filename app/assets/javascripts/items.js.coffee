# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on('click', '#item-delete', ( ->
    # alert $(this).attr("action")
    $.destroy($(this).attr("action"))
    window.open("/items","_self")
  ));
