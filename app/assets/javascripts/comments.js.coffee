App.Comments =

  add_response: (parent_id, response_html) ->
    $(response_html).insertAfter($("#js-comment-form-#{parent_id}"))

  reset_and_hide_form: (id) ->
    form_container = $("#js-comment-form-#{id}")
    input = form_container.find("form textarea")
    input.val('')
    form_container.hide()

  reset_form: (id) ->
    input = $("#js-comment-form-#{id} form textarea")
    input.val('')

  toggle_form: (id) ->
    $("#js-comment-form-#{id}").toggle()

  initialize: ->
    $('body .js-add-comment-link').each ->
      $this = $(this)

      unless $this.data('initialized') is 'yes'
        $this.on('click', ->
          id = $(this).data().id
          App.Comments.toggle_form(id)
          false
        ).data 'initialized', 'yes'
