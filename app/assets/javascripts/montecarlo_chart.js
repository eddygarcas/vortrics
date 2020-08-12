
function InitializeMontecarloGraph() {

    var axis_scale1;
    var axis_scale2;

    graph = new Rickshaw.Graph.Ajax({
        element: document.getElementById('bars-cycle-time'),
        height: 500,
        renderer: 'multi',
        method: 'POST',
        dataURL: '/montecarlo/chart',
        onData: function (data) {

            document.getElementById('bars-cycle-time-loader').innerHTML = "";
            min = Number.MAX_VALUE;
            max = Number.MIN_VALUE;

            for (_l = 0, _len2 = data[0].length; _l < _len2; _l++) {
                point = data[0][_l];
                min = Math.min(min, point.y);
                max = Math.max(max, point.y);
            }

            axis_scale1 = d3.scale.linear().domain([min, max]);
            axis_scale2 = d3.scale.linear().domain([0, 100]);

            window.store.state.metrics.mseries =  [
                {
                    name: 'Iterations',
                    renderer: 'area',
                    color: '#79BEDB',
                    data: data[0],
                    scale: axis_scale1
                },
                {
                    name: 'Confidence',
                    renderer: 'line',
                    color: '#C13100',
                    data: data[2],
                    scale: axis_scale2
                },
                {
                    name: 'Likelihood',
                    renderer: 'line',
                    color: '#FF9900',
                    data: data[1],
                    scale: axis_scale2
                }
            ];
            window.store.state.metrics.summary = data[3];
            return window.store.state.metrics.mseries
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
                    return x + '';
                }
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

            new Rickshaw.Graph.Axis.Y.Scaled({
                element: document.getElementById('bars-cycle-time-y_axis1'),
                graph: graph,
                orientation: 'left',
                scale: axis_scale1,
                pixelsPerTick: 20,
                tickFormat: Rickshaw.Fixtures.Number.formatKMBT
            });


            new Rickshaw.Graph.RangeSlider.Preview({
                graph: graph,
                element: document.querySelector("#rangeSlider")
            });


            new Rickshaw.Graph.HoverDetail({
                graph: graph,
                formatter: function (series, x, y) {
                    var content = '';
                    content += '<span class="detail_swatch" style="background-color: ' + series.color + '"></span>';
                    content += '<strong>' + x + ' Sprint</strong><br>';
                    if (series.name === 'Likelihood') content += 'Likelihood % ' + y + '<br>';
                    if (series.name === 'Iterations') content += 'Iterations ' + y + '<br>';
                    if (series.name === 'Confidence') content += 'Confidence % ' + y + '<br>';
                    return content;
                }
            });

            graph.render();

            $(window).on('resize', function () {
                graph.configure({
                    width: $('#bars-cycle-time').parent('.container-fluid').width(),
                    height: 500
                });
                graph.render();
            });
        }
    });
}
