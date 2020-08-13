# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
`
    function ReleaseTimeSprint(data) {
        document.getElementById('bars-release-loader').innerHTML = "";

        graph = new Rickshaw.Graph({
            element: document.getElementById('bars-release'),
            height: 220,
            renderer: 'multi',
            series: [
                {
                    name: 'WIP time',
                    renderer: 'bar',
                    color: '#90caf9',
                    data: data[1]
                },
                {
                    name: 'Release time',
                    renderer: 'bar',
                    color: '#cee8f9',
                    data: data[7]
                }
            ]
        });

        var format = function (n) {
            if (data[5][n] === undefined) {
                return;
            }
            return data[5][n].y;
        }

        var legend = new Rickshaw.Graph.Legend({
            graph: graph,
            element: document.getElementById('bars-release-legend')

        });

        new Rickshaw.Graph.Behavior.Series.Highlight({
            graph: graph,
            legend: legend,
            disabledColor: function () {
                return 'rgba(0, 0, 0, 0.2)'
            }
        });

        new Rickshaw.Graph.Behavior.Series.Toggle({
            graph: graph,
            legend: legend
        })

        new Rickshaw.Graph.ClickDetail({
            graph: graph,
            clickHandler: function (value) {
                window.open('/issues/' + $(".id_team_story").text(),"_self")
            }
        });

        new Rickshaw.Graph.Axis.X({
            graph: graph,
            orientation: 'bottom',
            element: document.getElementById('bars-release-x_axis'),
            pixelsPerTick: 100,
            tickFormat: format
        });

        new Rickshaw.Graph.Axis.Y({
            element: document.getElementById('bars-release-y_axis1'),
            graph: graph,
            orientation: 'left',
            scale: d3.scale.linear().domain([0, 100]),
            pixelsPerTick: 20,
            tickFormat: Rickshaw.Fixtures.Number.formatKMBT
        });

        graph.render();

        new Rickshaw.Graph.HoverDetail({
            onShow: function (event) {
                $('#key')[0].value = $(".key_bug_sprint").text();
            },
            graph: graph,
            formatter: function (series, x, y) {
                var sprint = '<span class="date key_bug_sprint">' + data[0][x].y + '</span><span class="date"> ' + data[5][x].y + '</span>';
                var flagged = '<i class="fa fa-flag"></i>'
                var bug = '<i class="fa fa-bug"></i>'
                var firsttime = '<i class="fa fa-bolt"></i>'
                var moreonesprint = '<i class="fa fa-exclamation-triangle"></i>'

                var content = series.name + ": " + parseInt(y) + ' days<br>' + sprint;
                if (series.name === 'Comulative Time Blocked') return content;
                if (data[4][x].y) content += bug
                if (data[2][x].y) content += flagged
                if (data[3][x].y) content += firsttime
                if (data[6][x].y) content += moreonesprint
                content += '<span class="id_team_story" style="visibility: hidden;">' + data[8][x].y + '</span>';
                return content;
            }
        });

        $(window).on('resize', function () {
            graph.configure({
                width: $('#bars-release').parent('.panel-body').width(),
                height: 220
            });
            graph.render();
        });
    }
`
class Issues
  constructor: ->
    @sprintid = $('#sprintid')[0].value if $('#sprintid')[0]?
    @setup() if @sprintid?

  setup: ->
    @handleSprintThroughtput()

  handleSprintThroughtput: (e) ->
    return if $('#bars-release')[0] == undefined
    return if ($('#bars-release')[0].dataset.behaviour != 'chart_throughtput')
    $.ajax(
      type: 'GET'
      url: '/sprints/' + @sprintid + '/graph_release_time'
      success: @handleReleaseSuccess
      timeout: 10000
    )

  handleReleaseSuccess: (data) ->
    ReleaseTimeSprint(data)

ready = ->
  jQuery ->
    new Issues()

$(document).on('turbolinks:load', ready)