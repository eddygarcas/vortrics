# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class Montecarlo
  constructor: ->
    @setup()

  setup: ->
    @handleMontecarloChart()

  handleMontecarloChart: (e) ->
    return if $('#bars-cycle-time')[0] == undefined
    return if ($('#bars-cycle-time')[0].dataset.behaviour != 'chart_montecarlo')
    InitializeMontecarloGraph()

ready = ->
  jQuery ->
    new Montecarlo

$(document).on('turbolinks:load', ready)
