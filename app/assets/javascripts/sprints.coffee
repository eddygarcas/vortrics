`
    function Sprintbyday(data) {
        var graph;
        graph = new Rickshaw.Graph({
            element: document.getElementById('rickshaw-bars-sprint'),
            height: 220,
            renderer: 'multi',
            series: [
                {
                    name: 'Story Closed',
                    renderer: 'bar',
                    color: '#90caf9',
                    data: data[0]
                },
                {
                    name: 'Open Bug',
                    renderer: 'bar',
                    color: '#ffcc80',
                    data: data[2]
                },
                {
                    name: 'Burndown - Story',
                    data: data[3],
                    renderer: 'line',
                    color: '#d13b47'
                }
            ]
        });

        graph.render();

        $(window).on('resize', function () {
            graph.configure({
                width: $('#rickshaw-bars-sprint').parent('.panel-body').width(),
                height: 220
            });
            graph.render();
        });

        var hoverDetail = new Rickshaw.Graph.HoverDetail({graph: graph});


        var format = function (n) {
            if (data[1][n] === undefined) {
                return;
            }
            return data[1][n].y;

        }
        var x_ticks = new Rickshaw.Graph.Axis.X({
            graph: graph,
            orientation: 'bottom',
            element: document.getElementById('x_axis_stories'),
            pixelsPerTick: 100,
            tickFormat: format
        });
        x_ticks.render();
    }

    function ReleaseTime(data) {
        if ($('#bars-release')[0] === undefined) {
            return
        } else {
            document.getElementById('bars-release-loader').innerHTML = "";
        }
        var graph;
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
                },
                {
                    name: 'Comulative Time Blocked',
                    renderer: 'line',
                    color: '#d13b47',
                    data: data[8]
                },
                {
                    name: 'Average Cycle Time',
                    renderer: 'line',
                    color: '#0085f9',
                    data: data[9]
                }
            ]
        });
        graph.render();

        var format = function (n) {
            if (data[0][n] === undefined) {
                return;
            }
            return data[0][n].y;

        }
        var x_ticks = new Rickshaw.Graph.Axis.X({
            graph: graph,
            orientation: 'bottom',
            element: document.getElementById('bars-release-x_axis'),
            pixelsPerTick: 100,
            tickFormat: format
        });
        x_ticks.render();

        var legend = new Rickshaw.Graph.Legend({
            graph: graph,
            element: document.getElementById('bars-release-legend')

        });

        var highlighter = new Rickshaw.Graph.Behavior.Series.Highlight({
            graph: graph,
            legend: legend,
            disabledColor: function () {
                return 'rgba(0, 0, 0, 0.2)'
            }
        });

        var shelving = new Rickshaw.Graph.Behavior.Series.Toggle({
            graph: graph,
            legend: legend
        });


        var hoverDetail = new Rickshaw.Graph.HoverDetail({
            onShow: function (event) {
                $('#key')[0].value = $(".key_bug_sprint").text();
            },
            graph: graph,
            formatter: function (series, x, y) {
                var sprint = '<span class="date key_bug_sprint">' + data[0][x].y + '</span><span class="date"> ' + data[5][x].y + '</span>';
                var flagged = ' <i class="fa fa-flag"></i>'
                var bug = ' <i class="fa fa-bug"></i>'
                var firsttime = ' <i class="fa fa-bolt"></i>'
                var moreonesprint = '    <i class="fa fa-exclamation-triangle"></i>'

                var content = series.name + ": " + parseInt(y) + ' days<br>' + sprint;
                if (series.name === 'Comulative Time Blocked') return content;
                if (data[4][x].y) content += bug
                if (data[2][x].y) content += flagged
                if (data[3][x].y) content += firsttime
                if (data[6][x].y) content += moreonesprint
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

class Sprints
  constructor: ->
    @sprintid = $('#sprintid')[0].value
    @setup()

  setup: ->
    $.ajax(
      type: 'GET'
      url: '/sprints/' + @sprintid + '/graph_closed_by_day'
      success: @handleSuccess
    )
    $.ajax(
      type: 'GET'
      url: '/sprints/' + @sprintid + '/graph_release_time'
      success: @handleReleaseSuccess
    )

  handleSuccess: (data) ->
    Sprintbyday(data)

  handleReleaseSuccess: (data) ->
    ReleaseTime(data)

jQuery ->
  new Sprints
