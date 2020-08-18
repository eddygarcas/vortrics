function clearCanvas() {
    document.getElementById('rickshaw-bars').innerHTML = "";
    document.getElementById('rickshaw-bars-x_axis').innerHTML = "";
    document.getElementById('rickshaw-bars-y_axis1').innerHTML = "";
}

function onCompleteOptions(graph_i,_labels,_formatter) {
    var format = function (n) {
        if (_labels[n] === undefined) {
            return;
        }
        return _labels[n].name;
    };

    new Rickshaw.Graph.Axis.X({
        graph: graph_i,
        orientation: 'bottom',
        element: document.getElementById('rickshaw-bars-x_axis'),
        pixelsPerTick: 200,
        tickFormat: format
    });

    new Rickshaw.Graph.Axis.Y({
        element: document.getElementById('rickshaw-bars-y_axis1'),
        graph: graph_i,
        orientation: 'left',
        scale: d3.scale.linear().domain([0, 100]),
        pixelsPerTick: 20,
        tickFormat: Rickshaw.Fixtures.Number.formatKMBT
    });

    graph_i.render();

    new Rickshaw.Graph.HoverDetail({
        graph: graph_i,
        formatter: _formatter
    });

    $(window).on('resize', function () {
        graph_i.configure({
            width: $('#rickshaw-bars').parent('.panel-body').width(),
            height: 220
        });
        graph_i.render();
    });
}

function InitializePointsGraph() {

    if ($('#searchbox')[0] === undefined) {
        return;
    }
    var _labels;
    new Rickshaw.Graph.Ajax({
        element: document.getElementById('rickshaw-bars'),
        type: 'GET',
        height: 220,
        renderer: 'multi',
        dataURL: '/teams/' + $('#searchbox')[0].value + '/graph_points',
        onData: function (data) {
            _labels = data[3];
            clearCanvas();

            return [
                {
                    name: 'Commitment',
                    renderer: 'bar',
                    color: '#e9f4fb',
                    opacity: 0.5,
                    data: data[2]
                },
                {
                    name: 'Closed',
                    renderer: 'line',
                    color: '#90caf9',
                    data: data[0]
                },
                {
                    name: 'Remaining',
                    renderer: 'line',
                    color: '#ffcc80',
                    data: data[1]
                }
            ];
        },
        onComplete: function (transport) {
            var formatt = function (series, x, y) {
                var date = '<span class="date">' + _labels[x].name + '</span>';
                var content = series.name + ": " + parseInt(y) + '<br>' + date;
                return content;
            };
            onCompleteOptions(transport.graph,_labels,formatt)
        },
    })
}

function InitializeGraphStories() {

    var _labels;
    new Rickshaw.Graph.Ajax({
        element: document.getElementById('rickshaw-bars'),
        type: 'GET',
        height: 220,
        renderer: 'multi',
        dataURL: '/teams/' + $('#searchbox')[0].value + '/graph_leftovers',
        onData: function (data) {
            _labels = data[3];
            clearCanvas();
            return [
                {
                    name: 'Commitment',
                    renderer: 'bar',
                    color: '#e9f4fb',
                    opacity: 0.5,
                    data: data[2]
                },
                {
                    name: 'Stories',
                    renderer: 'line',
                    color: '#17d111',
                    data: data[0]
                },
                {
                    name: 'Leftovers',
                    renderer: 'line',
                    color: '#ffcc80',
                    data: data[1]
                }
            ];
        },
        onComplete: function (transport) {
            var formatt = function (series, x, y) {
                var date = '<span class="date">' + _labels[x].name + '</span>';
                var content = series.name + ": " + parseInt(y) + '<br>' + date;
                return content;
            };
            onCompleteOptions(transport.graph,_labels,formatt)
        },
    });
}

function InitializeNoEstimatesGraph() {

    var _labels;
    new Rickshaw.Graph.Ajax({
        element: document.getElementById('rickshaw-bars'),
        type: 'GET',
        height: 220,
        renderer: 'line',
        dataURL: '/teams/' + $('#searchbox')[0].value + '/graph_no_estimates',
        onData: function (data) {

            document.getElementById('rickshaw-bars').innerHTML = "";
            document.getElementById('rickshaw-bars-x_axis').innerHTML = "";
            document.getElementById('rickshaw-bars-y_axis1').innerHTML = "";

            _labels = data[2];
            return [
                {
                    name: 'Stories',
                    color: '#2ed126',
                    data: data[0]
                },
                {
                    name: 'Points',
                    color: '#90caf9',
                    data: data[1]
                }
            ];
        },
        onComplete: function (transport) {
            var formatt = function (series, x, y) {
                var date = '<span class="date">' + _labels[x].name + '</span>';
                var swatch = '<span class="detail_swatch" style="background-color: ' + series.color + '"></span>';
                var content = swatch + series.name + ": " + parseInt(y) + '<br>' + date;
                return content;
            };
            onCompleteOptions(transport.graph,_labels,formatt);
        },
    });
}


function InitializeReleaseTimeGraphTeam() {
    if ($('#searchbox')[0] === undefined) {
        return;
    }
    if ($('#teamid')[0] === undefined) {
        return;
    }
    $.ajax({
        type: 'GET',
        url: '/teams/' + $('#teamid')[0].value + '/graph_release_time',
        success: function (data) {

            document.getElementById('bars-team-release-loader').innerHTML = "";

            graph = new Rickshaw.Graph({
                element: document.getElementById('bars-team-release'),
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
                        data: data[8]
                    },
                    {
                        name: 'Accumulated Average',
                        renderer: 'line',
                        color: '#ffcc80',
                        data: data[9]
                    }
                ]
            });

            var legend = new Rickshaw.Graph.Legend({
                graph: graph,
                element: document.getElementById('bars-team-release-legend')

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
                    window.open('/issues/' + $(".id_team_story").text(), "_self")
                }
            });

            var format = function (n) {
                if (data[0][n] === undefined) {
                    return;
                }
                return data[5][n].y;
            };

            new Rickshaw.Graph.Axis.X({
                graph: graph,
                orientation: 'bottom',
                element: document.getElementById('bars-team-release-x_axis'),
                pixelsPerTick: 100,
                tickFormat: format
            });

            new Rickshaw.Graph.Axis.Y({
                element: document.getElementById('bars-team-release-y_axis1'),
                graph: graph,
                orientation: 'left',
                scale: d3.scale.linear().domain([0, 100]),
                pixelsPerTick: 20,
                tickFormat: Rickshaw.Fixtures.Number.formatKMBT
            });

            graph.render();

            new Rickshaw.Graph.HoverDetail({
                onShow: function (event) {
                    $('#key')[0].value = $(".key_team_story").text();
                },
                graph: graph,
                formatter: function (series, x, y) {
                    var sprint = '<span class="date key_team_story">' + data[0][x].y + '</span><span class="date"> ' + data[5][x].y + '</span>';
                    var flagged = ' <i class="fa fa-flag"></i>';
                    var bug = ' <i class="fa fa-bug"></i>';
                    var firsttime = ' <i class="fa fa-bolt"></i>';
                    var moreonesprint = '    <i class="fa fa-exclamation-triangle"></i>';

                    var content = series.name + ": " + parseInt(y) + ' days';
                    content += '<br>' + sprint;
                    if (data[4][x].y) content += bug;
                    if (data[2][x].y) content += flagged;
                    if (data[3][x].y) content += firsttime;
                    if (data[6][x].y) content += moreonesprint;
                    content += '<span class="id_team_story" style="visibility: hidden;">' + data[11][x].y + '</span>';

                    return content;
                }
            });

            $(window).on('resize', function () {
                graph.configure({
                    width: $('#bars-team-release').parent('.panel-body').width(),
                    height: 220
                });
                graph.render();
            });


        },
        timeout: 15000
    })

}


function InitializeAverageStoriesGraph() {
    if ($('#searchbox')[0] === undefined) {
        return;
    }
    $.ajax({
        type: 'GET',
        url: '/teams/' + $('#searchbox')[0].value + '/graph_stories',
        success: function (data) {
            flotMetric($('#metric-monthly-earnings'), data);
        }

    });
}