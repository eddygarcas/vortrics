function InitializeMontecarloGraph() {

    if ($('#teamid')[0] === undefined) {
        return;
    }
    $.ajax({
        type: 'GET',
        url: '/montecarlo/chart',
        success: function (data) {
            if ($('#bars-cycle-time')[0] === undefined) {
                return;
            } else {
                document.getElementById('bars-cycle-time-loader').innerHTML = "";

            }
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
                height: 500,
                renderer: 'multi',
                series: [
                    {
                        name: 'Iterations',
                        renderer: 'bar',
                        color: '#90caf9',
                        data: data[0],
                        scale: axis_scale1
                    },
                    {
                        name: 'Confidence',
                        renderer: 'line',
                        color: '#d13b47',
                        data: data[2],
                        scale: axis_scale2
                    },
                    {
                        name: 'Likelihood',
                        renderer: 'line',
                        color: 'grey',
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

            new Rickshaw.Graph.Axis.X({
                graph: graph,
                orientation: 'bottom',
                element: document.getElementById('bars-cycle-time-x_axis'),
                pixelsPerTick: 100,
                tickFormat: function (x) {
                    return x + '';
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

            new Rickshaw.Graph.RangeSlider.Preview({
                graph: graph,
                element: document.querySelector("#rangeSlider")
            });

            graph.render();

            new Rickshaw.Graph.HoverDetail({
                graph: graph,
                formatter: function (series, x, y) {
                    var content = '';
                    content += '<span class="detail_swatch" style="background-color: ' + series.color + '"></span>';
                    content += '<strong>' + x + '</strong><br>';
                    if (series.name === 'Likelihood') content += 'Likelihood % ' + y + '<br>';
                    if (series.name === 'Iterations') content += 'Iterations ' + y + '<br>';
                    if (series.name === 'Confidence') content += 'Confidence % ' + y + '<br>';
                    return content;
                }
            });

            $(window).on('resize', function () {
                graph.configure({
                    width: $('#bars-cycle-time').parent('.container-fluid').width(),
                    height: 500
                });
                graph.render();
            });


        },
        timeout: 5000
    })

}
