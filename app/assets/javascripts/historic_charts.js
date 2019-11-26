function InitializeNoEstimatesGraph() {

    $.ajax({
        type: 'GET',
        url: '/teams/' + $('#searchbox')[0].value + '/graph_no_estimates',
        success: function (data) {

            if ($('#rickshaw-bars')[0] === undefined) {
                return;
            } else {
                document.getElementById('rickshaw-bars').innerHTML = "";
                document.getElementById('rickshaw-bars-x_axis').innerHTML = "";
                document.getElementById('rickshaw-bars-y_axis1').innerHTML = "";
                document.getElementById('graphtitle').innerText = "No Estimate VS Closed Story Points"
            }
            var graph;

            graph = new Rickshaw.Graph({
                element: document.getElementById('rickshaw-bars'),
                height: 220,
                renderer: 'line',
                series: [
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
                ]
            });

            var format = function (n) {
                if (data[2][n] === undefined) {
                    return;
                }
                return data[2][n].name;

            }

            new Rickshaw.Graph.Axis.X({
                graph: graph,
                orientation: 'bottom',
                element: document.getElementById('rickshaw-bars-x_axis'),
                pixelsPerTick: 200,
                tickFormat: format
            });

            new Rickshaw.Graph.Axis.Y({
                element: document.getElementById('rickshaw-bars-y_axis1'),
                graph: graph,
                orientation: 'left',
                scale: d3.scale.linear().domain([0, 100]),
                pixelsPerTick: 20,
                tickFormat: Rickshaw.Fixtures.Number.formatKMBT
            });

            graph.render();

            new Rickshaw.Graph.HoverDetail({
                graph: graph,
                formatter: function (series, x, y) {
                    var date = '<span class="date">' + data[2][x].name + '</span>';
                    var swatch = '<span class="detail_swatch" style="background-color: ' + series.color + '"></span>';
                    var content = swatch + series.name + ": " + parseInt(y) + '<br>' + date;
                    return content;
                }
            });

            $(window).on('resize', function () {
                graph.configure({
                    width: $('#rickshaw-bars').parent('.panel-body').width(),
                    height: 220
                });
                graph.render();
            });

        }
    })

}

function InitializeAverageStoriesGraph() {

    if ($('#searchbox')[0] === undefined) {
        return;
    }
    // Will get data with total Stories per sprint
    $.ajax({
        type: 'GET',
        url: '/teams/' + $('#searchbox')[0].value + '/graph_stories',
        success: function (data) {
            flotMetric($('#metric-monthly-earnings'), data);
        }

    });
}

function InitializeAverageBugsGraph() {

    if ($('#searchbox')[0] === undefined) {
        return;
    }

    // Will get data with total bugs per sprint
    $.ajax({
        type: 'GET',
        url: '/teams/' + $('#searchbox')[0].value + '/graph_bugs',
        success: function (data) {
            flotMetric($('#metric-cancellations'), data);
        }

    })
}

function InitializePointsGraph() {

    if ($('#searchbox')[0] === undefined) {
        return;
    }

    $.ajax({
        type: 'GET',
        url: '/teams/' + $('#searchbox')[0].value + '/graph_points',
        success: function (data) {

            if ($('#rickshaw-bars')[0] === undefined) {
                return;
            } else {
                document.getElementById('rickshaw-bars').innerHTML = "";
                document.getElementById('rickshaw-bars-x_axis').innerHTML = "";
                document.getElementById('rickshaw-bars-y_axis1').innerHTML = "";

                document.getElementById('graphtitle').innerText = "Closed VS Remaining - Story Points"
                document.getElementById('sgraph').dataset.title = "Closed VS Leftover - User Stories"

            }
            var graph;
            graph = new Rickshaw.Graph({
                element: document.getElementById('rickshaw-bars'),
                height: 220,
                renderer: 'multi',
                series: [
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
                ]
            });

            var format = function (n) {
                if (data[3][n] === undefined) {
                    return;
                }
                return data[3][n].name;
            }

            new Rickshaw.Graph.Axis.X({
                graph: graph,
                orientation: 'bottom',
                element: document.getElementById('rickshaw-bars-x_axis'),
                pixelsPerTick: 200,
                tickFormat: format
            });

            new Rickshaw.Graph.Axis.Y({
                element: document.getElementById('rickshaw-bars-y_axis1'),
                graph: graph,
                orientation: 'left',
                scale: d3.scale.linear().domain([0, 100]),
                pixelsPerTick: 20,
                tickFormat: Rickshaw.Fixtures.Number.formatKMBT
            });

            graph.render();

            var hoverDetail = new Rickshaw.Graph.HoverDetail({
                graph: graph,
                formatter: function (series, x, y) {
                    var date = '<span class="date">' + data[3][x].name + '</span>';
                    var swatch = '' //'<span class="detail_swatch" style="background-color: ' + series.color + '"></span>';
                    var content = swatch + series.name + ": " + parseInt(y) + '<br>' + date;
                    return content;
                }
            });

            $(window).on('resize', function () {
                graph.configure({
                    width: $('#rickshaw-bars').parent('.panel-body').width(),
                    height: 220
                });
                graph.render();
            });
        }
    })
}

function InitializeGrpahStories() {
    $.ajax({
        type: 'GET',
        url: '/teams/' + $('#searchbox')[0].value + '/graph_leftovers',
        success: function (data) {

            if ($('#rickshaw-bars')[0] === undefined) {
                return;
            } else {
                document.getElementById('rickshaw-bars').innerHTML = "";
                document.getElementById('rickshaw-bars-x_axis').innerHTML = "";
                document.getElementById('rickshaw-bars-y_axis1').innerHTML = "";

                document.getElementById('graphtitle').innerText = "Closed VS Leftovers - User Stories"
                document.getElementById('sgraph').dataset.title = "Closed VS Remaining - Story Points"
            }
            var graph_s;

            graph_s = new Rickshaw.Graph({
                element: document.getElementById('rickshaw-bars'),
                height: 220,
                renderer: 'multi',
                series: [
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
                ]
            });

            var format = function (n) {
                if (data[3][n] === undefined) {
                    return;
                }
                return data[3][n].name;

            }

            new Rickshaw.Graph.Axis.X({
                graph: graph_s,
                orientation: 'bottom',
                element: document.getElementById('rickshaw-bars-x_axis'),
                pixelsPerTick: 200,
                tickFormat: format
            });

            new Rickshaw.Graph.Axis.Y({
                element: document.getElementById('rickshaw-bars-y_axis1'),
                graph: graph_s,
                orientation: 'left',
                scale: d3.scale.linear().domain([0, 100]),
                pixelsPerTick: 20,
                tickFormat: Rickshaw.Fixtures.Number.formatKMBT
            });

            graph_s.render();

            var hoverDetail = new Rickshaw.Graph.HoverDetail({
                graph: graph_s,
                formatter: function (series, x, y) {
                    var sprint = '<span class="date">' + data[3][x].name + '</span>';
                    var title = '' //'<span class="detail_swatch" style="background-color: ' + series.color + '"></span>';
                    var content = title + series.name + ": " + parseInt(y) + '<br>' + sprint;
                    return content;
                }
            });

            $(window).on('resize', function () {
                graph_s.configure({
                    width: $('#rickshaw-bars').parent('.panel-body').width(),
                    height: 220
                });
                graph_s.render();
            });

        }
    })

}

function InitializeClosedByDayGraph() {

    if ($('#searchbox')[0] === undefined) {
        return;
    }

    $.ajax({
        type: 'GET',
        url: '/teams/' + $('#searchbox')[0].value + '/graph_closed_by_day',
        success: function (data) {

            if ($('#rickshaw-bars-stories')[0] === undefined) {
                return;
            }
            var graph;
            graph = new Rickshaw.Graph({
                element: document.getElementById('rickshaw-bars-stories'),
                height: 220,
                renderer: 'multi',
                series: [
                    {
                        name: 'Story Closed',
                        renderer: 'bar',
                        color: '#9cc1e0',
                        data: data[0]
                    },
                    {
                        name: 'Story Working',
                        renderer: 'bar',
                        color: '#cee8f9',
                        data: data[2]
                    },
                    {
                        name: 'Burndown - Story',
                        data: data[3],
                        renderer: 'line',
                        color: '#d13b47'
                    },
                    {
                        name: 'Burndown - Points',
                        data: data[4],
                        renderer: 'line',
                        color: '#9cc1e0'
                    }
                ]
            });
            graph.render();


            $(window).on('resize', function () {
                graph.configure({
                    width: $('#rickshaw-bars-stories').parent('.panel-body').width(),
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
    })

}
