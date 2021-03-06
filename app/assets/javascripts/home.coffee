
class Home
  constructor: ->
    @setup()

  setup: ->
    @handleInitializePointsGraph()
    @handleInitializeReleaseTimeGraphTeam()
    @handleInitializeAverageStoriesGraph()

  handleInitializePointsGraph: ->
    return if ($('#rickshaw-bars')[0] == undefined)
    InitializePointsGraph()

  handleInitializeReleaseTimeGraphTeam: ->
    return if ($('#bars-team-release')[0] == undefined)
    return if ($('#bars-team-release')[0].dataset.behaviour != 'chart_historical_throughtput')
    InitializeReleaseTimeGraphTeam()

  handleInitializeAverageStoriesGraph: ->
    return if ($('#teamid')[0] == undefined)
    InitializeAverageStoriesGraph()

ready = ->
  jQuery ->
    new Home()

$(document).on('turbolinks:load', ready)
