# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # $(document).on('click', '#item-delete', ( ->
  $('#item-delete').click ->
    # alert "delete "+$(this).attr("action") 
    $.destroy({
      url: $(this).attr("action"),
      success: (response) ->
        window.open("/items?o=n_asc","_self")
    });
  # ));
