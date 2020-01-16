class Users
  constructor: ->
    @setup()

  setup: ->
    $("[data-behaviour='user_link']").on "click", @handleClick
    $("[data-behaviour='site_link']").on "change", @handleChange

  handleClick: (e) ->
    @elems = e.currentTarget
    $.ajax(
      url: "/users/group"
      type: "JSON"
      data: JSON.stringify({"id": this.id, "admin": @elems.checked})
      method: "POST"
      contentType: "application/json"
      processData: false
      success: (data)  ->
        setInterval(@completeClick,3000)
        if (data['success'] is "true")
          $("[data-behavior='user_info_" + data['message'] + "']").toggleClass("valid");
        else
          $("[data-behavior='user_info_" + data['message'] + "']").toggleClass('invalid');

      completeClick: (data) ->
        elems = document.getElementsByClassName('valid')
        while (elems.length)
          elems[0].classList.remove('valid')
        elems = document.getElementsByClassName('invalid')
        while (elems.length)
          elems[0].classList.remove('invalid')

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
        setInterval(@completeClick,3000)
        if (data['success'] is "true")
          $("[data-behavior='user_info_" + data['message'] + "']").toggleClass('valid');
        else
          $("[data-behavior='user_info_" + data['message'] + "']").toggleClass('invalid');

    )

ready = ->
  jQuery ->
    new Users()

$(document).on('turbolinks:load', ready)