import tooltip from './directives'

export default {
    state: {
        comments: {
            board_id: 0,
            list: {}
        },
    },
    mutations: {
        byBoardComments(state,data) {
            state.comments.list = data
        }
    },
    getters: {

    },
    actions: {

    },
}