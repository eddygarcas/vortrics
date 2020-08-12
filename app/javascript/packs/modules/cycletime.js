export default {
    state: {
        mseries: [[], []],
        team_id: 0,
        initial: 'wip',
        end: 'done',
        scale_y: {},
    },
    mutations: {
        callCycleUpdate(state, data) {
            state.mseries[0].data = data[0];
            state.mseries[1].data = data[1];
            series = data[0];
            min = Number.MAX_VALUE;
            max = Number.MIN_VALUE;
            for (_l = 0, _len2 = series.length; _l < _len2; _l++) {
                point = series[_l];
                min = Math.min(min, point.y);
                max = Math.max(max, point.y);
            }
            state.mseries[0].scale = d3.scale.linear().domain([min, max]);
            graph.update();
        },
    },
    getters: {},
    actions: {
        postCycletime(context, componentData) {
            var data = new FormData
            data.append("initial", componentData.initial);
            data.append("end", componentData.end);
            $.ajax({
                url: `/teams/${context.state.team_id}/cycle_time_chart`,
                dataType: "JSON",
                type: "POST",
                data: data,
                processData: false,
                contentType: false,
                success: (data) => {
                    context.commit('callCycleUpdate', data);
                }
            })
        }
    },
}