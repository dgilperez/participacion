App.ModeratorComments =

  show_all_hidden: ->
    $(".comment.hidden .comment-body").addClass("faded")
    $(".comment.hidden").removeClass("hidden")

  add_class_faded: (id) ->
    $("##{id} .comment-body:first").addClass("faded")

  remove_class_faded: (id) ->
    $("##{id} .comment-body:first").removeClass("faded")

  refresh_moderator_actions: (id, response_html) ->
    $("##{id} #moderator-comment-actions:first").html(response_html)

  initialize: ->
    $('body').on 'click', '#js-show-all-hidden-link', ->
      App.ModeratorComments.show_all_hidden()
      false