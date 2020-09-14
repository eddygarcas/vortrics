`
    function TimeToFirstResponse(data) {
        document.getElementById('bars-first-response-loader').innerHTML = "";

        graph_f = new Rickshaw.Graph({
            element: document.getElementById('bars-first-response'),
            height: 220,
            renderer: 'multi',
            series: [
                {
                    name: 'Time First Response',
                    renderer: 'bar',
                    color: '#90caf9',
                    data: data[2]
                },
                {
                    name: 'Average First Time Response',
                    renderer: 'line',
                    color: '#d13b47',
                    data: data[3]
                }
            ]
        });

        var format = function (n) {
            if (data[1][n] === undefined) {
                return;
            }
            return data[1][n].y;
        }

        var legend = new Rickshaw.Graph.Legend({
            graph: graph_f,
            element: document.getElementById('bars-first-response-legend')

        });

        new Rickshaw.Graph.Behavior.Series.Highlight({
            graph: graph_f,
            legend: legend,
            disabledColor: function () {
                return 'rgba(0, 0, 0, 0.2)'
            }
        });

        new Rickshaw.Graph.Behavior.Series.Toggle({
            graph: graph_f,
            legend: legend
        })

        new Rickshaw.Graph.ClickDetail({
            graph: graph_f,
            clickHandler: function (value) {
                window.open('/issues/key/' + $(".key_bug_sprint").text(), "_self")
            }
        });

        new Rickshaw.Graph.Axis.X({
            graph: graph_f,
            orientation: 'bottom',
            element: document.getElementById('bars-first-response-x_axis'),
            pixelsPerTick: 100,
            tickFormat: format
        });

        new Rickshaw.Graph.Axis.Y({
            element: document.getElementById('bars-first-response-y_axis1'),
            graph: graph_f,
            orientation: 'left',
            scale: d3.scale.linear().domain([0, 100]),
            pixelsPerTick: 20,
            tickFormat: Rickshaw.Fixtures.Number.formatKMBT
        });

        graph_f.render();

        new Rickshaw.Graph.HoverDetail({
            onShow: function (event) {
                $('#key')[0].value = $(".key_bug_sprint").text();
            },
            graph: graph_f,
            formatter: function (series, x, y) {
                var sprint = '<span class="date key_bug_sprint">' + data[0][x].y + '</span><span class="date"> created on ' + data[1][x].y + '</span>';

                var content = series.name + " " + parseInt(y) + ' Hours<br>' + sprint;
                if (series.name === 'Time First Response') return content;
                return content;
            }
        });

        $(window).on('resize', function () {
            graph_f.configure({
                width: $('#bars-first-response').parent('.panel-body').width(),
                height: 220
            });
            graph_f.render();
        });
    }

    function InitializeCycleTimeGraphTeam() {

        graph = new Rickshaw.Graph.Ajax({
            element: document.getElementById('bars-cycle-time'),
            height: 220,
            renderer: 'multi',
            method: 'POST',
            dataURL: '/teams/' + $('#teamid')[0].value + '/cycle_time_chart',
            onData: function (data) {
                document.getElementById('bars-cycle-time-loader').innerHTML = "";

                series = data[0];
                min = Number.MAX_VALUE;
                max = Number.MIN_VALUE;
                for (_l = 0, _len2 = series.length; _l < _len2; _l++) {
                    point = series[_l];
                    min = Math.min(min, point.y);
                    max = Math.max(max, point.y);
                }
                var scale_x = d3.scale.linear().domain([min, max]);

                window.store.state.selector.mseries = [
                    {
                        name: 'Tickets',
                        renderer: 'bar',
                        color: '#90caf9',
                        data: data[0],
                        scale: scale_x
                    },
                    {
                        name: 'Cumulative',
                        renderer: 'line',
                        color: '#d13b47',
                        data: data[1],
                        scale: d3.scale.linear().domain([0, 100])
                    }
                ];
                return window.store.state.selector.mseries
            },
            onComplete: function (transport) {
                graph = transport.graph;

                var legend = new Rickshaw.Graph.Legend({
                    graph: graph,
                    element: document.getElementById('bars-cycle-time-legend')
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
                });

                new Rickshaw.Graph.Axis.X({
                    graph: graph,
                    orientation: 'bottom',
                    element: document.getElementById('bars-cycle-time-x_axis'),
                    pixelsPerTick: 100,
                    tickFormat: function (x) {
                        return x + ' days';
                    }
                });

                new Rickshaw.Graph.Axis.Y.Scaled({
                    element: document.getElementById('bars-cycle-time-y_axis1'),
                    graph: graph,
                    orientation: 'left',
                    scale: window.store.state.selector.mseries[0].scale,
                    pixelsPerTick: 20,
                    tickFormat: Rickshaw.Fixtures.Number.formatKMBT
                });


                new Rickshaw.Graph.Axis.Y.Scaled({
                    element: document.getElementById('bars-cycle-time-y_axis2'),
                    graph: graph,
                    grid: false,
                    orientation: 'left',
                    scale: d3.scale.linear().domain([0, 100]),
                    pixelsPerTick: 20,
                    tickFormat: function (x) {
                        return x + '%';
                    }
                });

                graph.render();

                new Rickshaw.Graph.HoverDetail({
                    graph: graph,
                    formatter: function (series, x, y) {
                        var content = 'Days: ' + x + '<br>';
                        window.store.state.selector.summary.days = x
                        if (window.store.state.selector.mseries[0].data[x]) {
                            window.store.state.selector.summary.tickets = window.store.state.selector.mseries[0].data[x].y
                            content += '#Tickets: ' + window.store.state.selector.mseries[0].data[x].y + '<br>';
                        }
                        if (window.store.state.selector.mseries[1].data[x]) {
                            window.store.state.selector.summary.cumulative = window.store.state.selector.mseries[1].data[x].y
                            content += 'Cumulative: ' + window.store.state.selector.mseries[1].data[x].y + '%';
                        }
                        return content;
                    }
                });

                $(window).on('resize', function () {
                    graph.configure({
                        width: $('#bars-cycle-time').parent('.container-fluid').width(),
                        height: 220
                    });
                    graph.render();
                });
            },
            timeout: 5000
        });
    }

    function InitializeReleaseTimeBugsGraphTeam() {

        $.ajax({
            type: 'GET',
            url: '/teams/' + $('#teamid')[0].value + '/graph_lead_time_bugs',
            success: function (data) {

                if ($('#bars-team-release-bugs')[0] === undefined) {
                    return;
                } else {
                    document.getElementById('bars-team-release-bugs-loader').innerHTML = "";

                }

                var graph;
                graph = new Rickshaw.Graph({
                    element: document.getElementById('bars-team-release-bugs'),
                    height: 220,
                    renderer: 'multi',
                    series: [
                        {
                            name: 'Waiting Time',
                            renderer: 'bar',
                            color: '#ff9642',
                            data: data[1]
                        },
                        {
                            name: 'Working Time',
                            renderer: 'bar',
                            color: '#ffcc80',
                            data: data[9]
                        },
                        {
                            name: 'Rolling Average',
                            renderer: 'line',
                            color: '#d13b47',
                            data: data[8]
                        }
                    ]
                });

                var legend = new Rickshaw.Graph.Legend({
                    graph: graph,
                    element: document.getElementById('bars-team-release-bugs-legend')

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
                });

                new Rickshaw.Graph.ClickDetail({
                    graph: graph,
                    clickHandler: function (value) {
                        window.open('/issues/key/' + $(".key_team_bug").text(), "_self")
                    }
                });

                var format = function (n) {
                    if (data[4][n] === undefined) {
                        return;
                    }
                    return data[4][n].y;

                };

                new Rickshaw.Graph.Axis.X({
                    graph: graph,
                    orientation: 'bottom',
                    element: document.getElementById('bars-team-release-bugs-x_axis'),
                    pixelsPerTick: 100,
                    tickFormat: format
                });

                new Rickshaw.Graph.Axis.Y({
                    element: document.getElementById('bars-team-release-bugs-y_axis1'),
                    graph: graph,
                    orientation: 'left',
                    scale: d3.scale.linear().domain([0, 100]),
                    pixelsPerTick: 20,
                    tickFormat: Rickshaw.Fixtures.Number.formatKMBT
                });

                graph.render();

                new Rickshaw.Graph.HoverDetail({
                    onShow: function (event) {
                        $('#key')[0].value = $(".key_team_bug").text();
                    },
                    graph: graph,
                    formatter: function (series, x, y) {

                        var sprint = '<span class="date key_team_bug">' + data[0][x].y + '</span><span class="date"> ' + data[7][x].y + ' ' + data[4][x].y + '</span>';
                        var flagged = ' <i class="fa fa-flag"></i>';
                        var bug = ' <i class="fa fa-bug"></i>';
                        var firsttime = ' <i class="fa fa-bolt"></i>';
                        var moreonesprint = '    <i class="fa fa-exclamation-triangle"></i>';

                        var content = series.name + ": " + parseInt(y) + ' days<br>' + sprint;
                        if (data[2][x].y) content += flagged;
                        if (data[3][x].y) content += firsttime;
                        if (data[5][x].y) content += moreonesprint;
                        return content;
                    }
                });

                $(window).on('resize', function () {
                    graph.configure({
                        width: $('#bars-team-release-bugs').parent('.panel-body').width(),
                        height: 220
                    });
                    graph.render();
                });
            },
            timeout: 5000
        })
    }

    function InitializeOpenClosedBugsGraphTeam(id) {
        var _id = ''
        if (id === undefined) {
            _id = 'bars-team-openclosed-bugs'
        }
        if ($('#teamid')[0] === undefined) {
            return;
        }
        $.ajax({
            type: 'GET',
            url: '/teams/' + $('#teamid')[0].value + '/graph_ratio_bugs_closed',
            success: function (data) {

                if ($('#' + _id)[0] === undefined) {
                    return;
                } else {
                    document.getElementById(_id).innerHTML = "";
                    document.getElementById(_id + '-x_axis').innerHTML = "";

                }

                var graph;
                graph = new Rickshaw.Graph({
                    element: document.getElementById(_id),
                    height: 220,
                    renderer: 'multi',
                    series: [
                        {
                            name: 'Closed',
                            renderer: 'stack',
                            color: '#ffcc80',
                            data: data[1]
                        },
                        {
                            name: 'Open/Backlog',
                            renderer: 'stack',
                            color: '#ff9642',
                            data: data[0]
                        }
                    ]
                });

                var format = function (n) {
                    if (data[2][n] === undefined) {
                        return;
                    }
                    return data[2][n].y;

                }

                new Rickshaw.Graph.Axis.X({
                    graph: graph,
                    orientation: 'bottom',
                    element: document.getElementById(_id + '-x_axis'),
                    pixelsPerTick: 100,
                    tickFormat: format
                });

                new Rickshaw.Graph.Axis.Y({
                    element: document.getElementById(_id + '-y_axis1'),
                    graph: graph,
                    orientation: 'left',
                    scale: d3.scale.linear().domain([0, 100]),
                    pixelsPerTick: 20,
                    tickFormat: Rickshaw.Fixtures.Number.formatKMBT
                });

                graph.render();

                new Rickshaw.Graph.HoverDetail({
                    onShow: function (event) {
                        $('#key')[0].value = $(".key_team_bug").text();
                    },
                    graph: graph,
                    formatter: function (series, x, y) {
                        var sprint = '<span class="date key_team_bug">' + data[2][x].y + '</span>';
                        var content = series.name + ": " + parseInt(y) + ' Bugs<br>' + sprint;
                        return content;
                    }
                });

                $(window).on('resize', function () {
                    graph.configure({
                        width: $('#' + _id).parent('.panel-body').width(),
                        height: 220
                    });
                    graph.render();
                });


            }
        })

    }

    function InitializeComulativeFlowChart(id) {
        var _id = ''
        if (id === undefined) {
            _id = 'team-comulative-flow'
        }
        if ($('#teamid')[0] === undefined) {
            return;
        }
        $.ajax({
            type: 'GET',
            url: '/teams/' + $('#teamid')[0].value + '/graph_comulative_flow_diagram',
            success: function (data) {

                if ($('#' + _id)[0] === undefined) {
                    return;
                } else {
                    document.getElementById(_id).innerHTML = "";
                    document.getElementById(_id + '-x_axis').innerHTML = "";

                }

                var axis_scale = d3.scale.linear().domain([0, 100]);

                graph = new Rickshaw.Graph({
                    element: document.getElementById(_id),
                    height: 440,
                    renderer: 'multi',
                    series: [
                        {
                            name: 'Closed',
                            renderer: 'stack',
                            color: '#0085f9',
                            data: data[1],
                            scale: axis_scale

                        },
                        {
                            name: 'In Progress',
                            renderer: 'stack',
                            color: '#90caf9',
                            data: data[0],
                            scale: axis_scale

                        },
                        {
                            name: 'Todo',
                            renderer: 'stack',
                            color: '#ffcc80',
                            data: data[3],
                            scale: axis_scale

                        }
                    ]
                });

                var format = function (n) {
                    if (data[2][n] === undefined) {
                        return;
                    }
                    return data[2][n].y;

                };
                new Rickshaw.Graph.Axis.X({
                    graph: graph,
                    orientation: 'bottom',
                    element: document.getElementById(_id + '-x_axis'),
                    pixelsPerTick: 50,
                    tickFormat: format
                });

                new Rickshaw.Graph.Axis.Y.Scaled({
                    element: document.getElementById(_id + '-y_axis1'),
                    graph: graph,
                    orientation: 'left',
                    scale: axis_scale,
                    pixelsPerTick: 15,
                    tickFormat: Rickshaw.Fixtures.Number.formatKMBT
                });

                new Rickshaw.Graph.RangeSlider.Preview({
                    graph: graph,
                    element: document.querySelector("#rangeSlider")
                });

                graph.render();


                new Rickshaw.Graph.HoverDetail({
                    onShow: function (event) {
                    },
                    graph: graph,
                    formatter: function (series, x, y) {
                        var sprint = '<span class="date key_team_bug">' + data[2][x].y + '</span>';
                        var leadime = data[4][x].y;
                        var content = series.name + ": " + parseInt(y) + ' User Stories<br>Acumlated: ' + leadime + '<br>' + sprint;
                        return content;
                    }
                });

                $(window).on('resize', function () {
                    graph.configure({
                        width: $('#' + _id).parent('.panel-body').width(),
                        height: 440
                    });
                    graph.render();
                });


            }
        })

    }
    function InitializeAverageStoriesGraph(_id) {
        $.ajax({
            type: 'GET',
            url: '/teams/' + _id + '/graph_stories',
            success: function (data) {
                flotMetric($('#metric-monthly-earnings'), data);
            }

        });
    }

`

class Teams
  boards = this
  constructor: ->
    @teamid = $('#teamid')[0].value if $('#teamid')[0]?
    @setup()

  setup: ->
    $("[data-behaviour='team_project_change']").on "change", @handleChange
    $("[data-behaviour='team_board_id_change']").on "change", @handleBoardChange
    @handleFirstResponse()
    @handleCycleTime()
    @handleHistoricalCFD()
    @handleSupportBugsCharts()

  handleChange: (e) ->
    return if $('#team_project').val() == undefined
    $.ajax(
      url: "/teams/full_project_details/" + $('#team_project').val()
      type: "JSON"
      method: "GET"
      success: (data) ->
        if (data != undefined)
          $("#project_image")[0].src = data['icon']
        else
          $("[data-behaviour='board_type']").html("Error")
    )
    $.ajax(
      url: "/teams/boards_by_team/" + $('#team_project').val()
      type: "JSON"
      method: "GET"
      contentType: "application/json"
      success: (data) ->
        boards = data
        $('#team_board_id').empty()
        $('#team_board_id').append($('<option>', {value: '', text: 'Select board...'}))
        data.map (board) ->
          $('#team_board_id').append($('<option>', {value: board['id'], text: board['name']}))
    )
  handleBoardChange: (e) ->
    $("[data-behaviour='board_type']").val(boards[$('select#team_board_id option:selected').index() - 1].type)
    if ($("[data-behaviour='board_type']").val() == "" )
      $("[data-behaviour='board_type']").val("kanban");

    $.ajax(
      url: "/teams/custom_fields_by_board/" + $('select#team_board_id').val()
      type: "JSON"
      method: "GET"
      contentType: "application/json"
      success: (resp) ->
        $('select#team_estimated').empty()
        $('select#team_estimated').append($('<option>', {value: '', text: 'Select estimation field...'}))
        resp.map (board) ->
          $('select#team_estimated').append($('<option>', {value: board['id'], text: board['name']}))
    )

  handleFirstResponse: (e) ->
    return if $('#teamid').val() == undefined
    return if $('#bars-first-response')[0] == undefined
    return if ($('#bars-first-response')[0].dataset.behaviour != 'chart_first_response')
    $.ajax(
      url: "/teams/" + $('#teamid')[0].value + "/graph_time_first_response/"
      type: "JSON"
      method: "GET"
      success: (data) ->
        if (data != undefined)
          TimeToFirstResponse(data);
    )

  handleCycleTime: (e) ->
    return if $('#bars-cycle-time')[0] == undefined
    return if ($('#bars-cycle-time')[0].dataset.behaviour != 'chart_cycle_time')
    InitializeCycleTimeGraphTeam()
    InitializeAverageStoriesGraph(@teamid)
    return 0

  handleHistoricalCFD: (e) ->
    return if $('#team-comulative-flow')[0] == undefined
    return if ($('#team-comulative-flow')[0].dataset.behaviour != 'chart_historical_stories_cfd')
    InitializeComulativeFlowChart()
    return 0

  handleSupportBugsCharts: ->
    return if $('#bars-team-release-bugs')[0] == undefined
    return if ($('#bars-team-release-bugs')[0].dataset.behaviour != 'chart_release_bugs')
    InitializeReleaseTimeBugsGraphTeam()
    InitializeOpenClosedBugsGraphTeam()
    return 0


ready = ->
  jQuery ->
    new Teams

$(document).on('turbolinks:load', ready)