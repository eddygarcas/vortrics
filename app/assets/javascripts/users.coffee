class Users
  constructor: ->
    @setup()

  setup: ->
    $("[data-behaviour='user_link']").on "click", @handleClick
    $("[data-behaviour='site_link']").on "change", @handleChange

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
      success: (data)  ->
        if (data['success'] is "true")
          $("[data-behavior='user_info_" + data['message'] + "']")[0].className += ' has-success';
        else
          $("[data-behavior='user_info_" + data['message'] + "']")[0].className += ' has-error';
    )

  handleChange: (e) ->
    @elems = $(this).val();
    @user = this.id;
    $.ajax(
      url: "/users/config"
      type: "JSON"
      data: JSON.stringify({"setting_id": @elems, "user_id": @user})
      method: "POST"
      contentType: "application/json"
      processData: false
      success: (data)  ->
        if (data['success'] is "true")
          $("[data-behavior='user_info_" + data['message'] + "']")[0].className += ' has-success';
        else
          $("[data-behavior='user_info_" + data['message'] + "']")[0].className += ' has-error';
    )

jQuery ->
  new Users
