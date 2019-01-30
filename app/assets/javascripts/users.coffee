class Users
  constructor: ->
    @setup()

  setup: ->
    $("[data-behaviour='user_link']").on "click", @handleClick

  handleClick: (e) ->
    @elems = document.activeElement
    console.log(@elems)
    $.ajax(
      url: "/users/group"
      type: "JSON"
      data: JSON.stringify({"id": @elems.id, "admin": @elems.checked})
      method: "POST"
      contentType: "application/json"
      processData: false
      success: ->
        $("[data-behavior='user_info']").text("User updated")
    )


jQuery ->
  new Users
