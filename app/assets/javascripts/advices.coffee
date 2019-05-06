class Advices
  constructor: ->
    @advices = $("[data-behaviour='advices']")
    @setup() if @advices.length > 0

  setup: ->
    $("[data-behaviour='advices-read']").on "click", @handleClick
    $.ajax(
        url: "/advices.json"
        dataType: "JSON"
        method: "GET"
        success: @handleSuccess
    )

  handleClick: (e) ->
    $.ajax(
      url: "/advices/mark_as_read"
      dataType: "JSON"
      method: "POST"
      success: ->
        $("[data-behaviour='advices-count']").text(0)
    )

  handleSuccess: (data) ->
    console.log(data)
    items = data.map (advice) ->
      "<a href='#{advice.url}' class='media list-group-item'><span class='pull-left'><i class='fa fa-fw fa-eye'></i></span><span class='media-body'><small class='text-muted'>#{advice.description}</small></span></a>"

    $("[data-behaviour='advices-count']").text(items.length)
    $("[data-behaviour='advices-items']").html(items)

jQuery ->
  new Advices
