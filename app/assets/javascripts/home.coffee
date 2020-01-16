class Home
  constructor: ->
    @setup()

  setup: ->
    @handleInitializePointsGraph()
    @handleInitializeReleaseTimeGraphTeam()
    @handleInitializeAverageStoriesGraph()
    $("#sgraph_noestimate").on "click", @handleNoEstimate
    $("#sgraph").on "click", @handleStoryPoints

  handleInitializePointsGraph: ->
    return if ($('#rickshaw-bars')[0] == undefined)
    InitializePointsGraph()

  handleInitializeReleaseTimeGraphTeam: ->
    return if ($('#bars-team-release')[0] == undefined)
    return if ($('#bars-team-release')[0].dataset.behaviour != 'chart_historical_throughtput')
    InitializeReleaseTimeGraphTeam()

  handleInitializeAverageStoriesGraph: ->
    InitializeAverageStoriesGraph()

  handleNoEstimate: ->
    return if ($('#rickshaw-bars')[0] == undefined)
    return if ($('#rickshaw-bars')[0].dataset.behaviour != 'chart_sprint_velocity')
    if ($("#sgraph_noestimate")[0].checked)
      InitializeNoEstimatesGraph()
    else
      if ($("#sgraph")[0].checked)
        InitializeGrpahStories();
      else
        InitializePointsGraph();

  handleStoryPoints: ->
    return if ($('#rickshaw-bars')[0] == undefined)
    return if ($('#rickshaw-bars')[0].dataset.behaviour != 'chart_sprint_velocity')
    $("#sgraph_noestimate")[0].checked = false
    if ($("#sgraph")[0].checked)
      InitializeGrpahStories()
    else
      InitializePointsGraph()

ready = ->
  jQuery ->
    new Home

$(document).on('turbolinks:load', ready)