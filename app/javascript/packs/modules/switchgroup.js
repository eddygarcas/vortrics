export default {
    state: {
        charts: {
            title: "",
            levers: [{
                id: "",
                title: "",
            }],
        },
    },
    mutations: {
        resetLevers(state, data) {
            state.levers.forEach(function (item) {
                var i = state.levers.findIndex(x => x.id != data.id);
                if (i > -1) {
                    $('#' + state.levers[i].id).attr('checked', false);
                }
            });
        },
    },
    getters: {},
    actions: {
        checkLever(context, data) {
            window[data.chkd]();
            context.commit('resetLevers', data);
        },
        uncheckLever(context, data) {
            window[data.unchkd]();
            context.commit('resetLevers', data);
        },
    },
}