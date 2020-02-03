class Settings
  constructor: ->
    @setup()

  setup: ->
    @handleSettings()
    $("[data-behaviour='oauthswitch']").on "change", @handleSettings

  handleSettings: () ->
    return if $('#oauthswitch')[0] == undefined
    if ($('#oauthswitch')[0].checked)
      $('#basic')[0].style.display = 'none'
      $('#oauth')[0].style.display = 'block'
    else
      $('#basic')[0].style.display = 'block'
      $('#oauth')[0].style.display = 'none'

ready = ->
  jQuery ->
    new Settings()

$(document).on('turbolinks:load', ready)
