# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class Notifications
  constructor: ->
    @advices = $("[data-behaviour='notifications']")
    @setup() if @advices.length > 0

  setup: ->
    $("[data-behaviour='notifications-read']").on "click", @handleClick
    $.ajax(
      url: "/notifications.json"
      dataType: "JSON"
      method: "GET"
      success: @handleSuccess
    )

  handleClick: (e) ->
    $.ajax(
      url: "/notifications/mark_as_read"
      dataType: "JSON"
      method: "POST"
      success: ->
        $("[data-behaviour='notifications-count']").text(0)
    )

  handleSuccess: (data) ->
    items = data.map (notification) ->
      "<a href='#{notification.url}' class='media list-group-item'><span class='pull-left'><img src='#{notification.actor.avatar}' class='img-circle profile-image' height='35' width='35'></span><span class='media-body'><small class='text-muted'>#{notification.actor.name} #{notification.action} #{notification.notifiable.type} #{notification.advice.title}</small></span></a>"

    $("[data-behaviour='notifications-count']").text(items.length)
    $("[data-behaviour='notifications-items']").html(items)

jQuery ->
  new Notifications