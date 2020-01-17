

function InitializeCycleTimeGraphTeam() {

    if ($('#teamid')[0] === undefined) {
        return;
    }
    $.ajax({
        type: 'GET',
        url: '/teams/' + $('#teamid')[0].value + '/cycle_time_chart',
        success: function (data) {

            document.getElementById('bars-cycle-time-loader').innerHTML = "";

            series = data[0];
            min = Number.MAX_VALUE;
            max = Number.MIN_VALUE;
            for (_l = 0, _len2 = series.length; _l < _len2; _l++) {
                point = series[_l];
                min = Math.min(min, point.y);
                max = Math.max(max, point.y);
            }

            var axis_scale1 = d3.scale.linear().domain([min, max]);
            var axis_scale2 = d3.scale.linear().domain([0, 100]);


            graph = new Rickshaw.Graph({
                element: document.getElementById('bars-cycle-time'),
                height: 220,
                renderer: 'multi',
                series: [
                    {
                        name: 'Tickets',
                        renderer: 'bar',
                        color: '#90caf9',
                        data: data[0],
                        scale: axis_scale1
                    },
                    {
                        name: 'Cumulative',
                        renderer: 'line',
                        color: '#d13b47',
                        data: data[1],
                        scale: axis_scale2
                    }
                ]
            });


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

            var format = function (n) {
                if (data[4][n] === undefined) {
                    return;
                }
                return data[0][n].y + ' Days';

            }

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
                scale: axis_scale1,
                pixelsPerTick: 20,
                tickFormat: Rickshaw.Fixtures.Number.formatKMBT
            });

            new Rickshaw.Graph.Axis.Y.Scaled({
                element: document.getElementById('bars-cycle-time-y_axis2'),
                graph: graph,
                grid: false,
                orientation: 'left',
                scale: axis_scale2,
                pixelsPerTick: 20,
                tickFormat: function (x) {
                    return x + '%';
                }
            });


            graph.render();

            new Rickshaw.Graph.HoverDetail({
                graph: graph,
                formatter: function (series, x, y) {
                    var content = '';
                    content += 'Days: ' + x + '<br>';
                    if (data[0][x].y) content += '#Tickets: ' + data[0][x].y + '<br>';
                    if (data[1][x].y) content += 'Cumulative: ' + data[1][x].y + '%';
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
    })

}

function InitializeReleaseTimeBugsGraphTeam() {

    if ($('#searchbox')[0] === undefined) {
        return;
    }
    if ($('#teamid')[0] === undefined) {
        return;
    }
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
                    //window.open('/issues/' + $(".id_team_bug").text())
                    window.open($('#extsite')[0].value + '/browse/' + $(".key_team_bug").text())

                }
            });

            var format = function (n) {
                if (data[4][n] === undefined) {
                    return;
                }
                return data[4][n].y;

            }

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

            var hoverDetail = new Rickshaw.Graph.HoverDetail({
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
