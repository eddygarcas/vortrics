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
        if (data['success'] is "true")
          $("[data-behaviour='user_link']").tooltip({title: 'Saved!'})
          $("[data-behaviour='user_link']").tooltip('show');
          $("[data-behavior='user_info_" + data['message'] + "']")[0].className += ' has-success';
          $("[data-behaviour='user_link']").tooltip('hide');
        else
          $("[data-behaviour='user_link']").tooltip({title: 'Error!'})
          $("[data-behaviour='user_link']").tooltip('show');
          $("[data-behavior='user_info_" + data['message'] + "']")[0].className += ' has-error';
          $("[data-behaviour='user_link']").tooltip('hide');

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
          $("[data-behavior='user_info_" + data['message'] + "']").tooltip({title: 'Saved!'})
          $("[data-behavior='user_info_" + data['message'] + "']").tooltip('show');
          $("[data-behavior='user_info_" + data['message'] + "']")[0].className += ' has-success';
          $("[data-behavior='user_info_" + data['message'] + "']").tooltip('hide');
        else
          $("[data-behavior='user_info_" + data['message'] + "']").tooltip({title: 'Error!'})
          $("[data-behavior='user_info_" + data['message'] + "']").tooltip('show');
          $("[data-behavior='user_info_" + data['message'] + "']")[0].className += ' has-error';
          $("[data-behavior='user_info_" + data['message'] + "']").tooltip('hide');
    )

jQuery ->
  new Users
