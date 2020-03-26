export default {
    state: {
        mseries: [[], [], []],
        summary: {
            confidence_at_50: 0,
            confidence_at_85: 0,
            max_likelihood: 0
        },
    },
    mutations: {
        callForecast(state, data) {
            state.mseries[0].data = data[0];
            state.mseries[1].data = data[2];
            state.mseries[2].data = data[1];
            state.summary = data[3];
            graph.update();
        },
    },
    getters: {},
    actions: {
        postForecast(context, componentData) {
            var data = new FormData
            data.append("montecarlo[number]", componentData.number);
            data.append("montecarlo[backlog]", componentData.backlog);
            data.append("montecarlo[focus]", componentData.focus);
            data.append("montecarlo[iteration]", componentData.selected);
            $.ajax({
                url: `/montecarlo/chart`,
                dataType: "JSON",
                type: "POST",
                data: data,
                processData: false,
                contentType: false,
                success: (data) => {
                    context.commit('callForecast', data);
                }
            })
        }
    },
}