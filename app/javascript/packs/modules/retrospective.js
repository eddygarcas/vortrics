export default {
    state: {
        lists: [],
        team: {},
        message: [],
    },
    mutations: {
        createColumn(state, data) {
            state.lists.push(data)
        },
        columnMoved(state, data) {
            const index = state.lists.findIndex(item => item.id == data.id)
            state.lists.splice(index, 1)
            state.lists.splice(data.position - 1, 0, data)
        },
        deleteColumn(state, data) {
            const index = state.lists.findIndex(item => item.id == data.id)
            state.lists.splice(index, 1)
        },
        createPostit(state, data) {
            const index = state.lists.findIndex(item => item.id == data.retrospective_id)
            state.lists[index].postits.push(data)
        },
        postitMoved(state, data) {
            const old_list_index = state.lists.findIndex((list) => {
                return list.postits.find((postit) => {
                    return postit.id === data.id
                })
            })
            const old_card_index = state.lists[old_list_index].postits.findIndex((item) => item.id == data.id)
            const new_list_index = state.lists.findIndex((item) => item.id == data.retrospective_id)

            if (old_list_index != new_list_index) {
                // Remove card from old list, add to new one
                state.lists[old_list_index].postits.splice(old_card_index, 1)
                state.lists[new_list_index].postits.splice(data.position - 1, 0, data)
            } else {
                state.lists[new_list_index].postits.splice(old_card_index, 1)
                state.lists[new_list_index].postits.splice(data.position - 1, 0, data)
            }
        },
        deletePostit(state, data) {
            const index = state.lists.findIndex(item => item.id == data.retrospective_id)
            const card_index = state.lists[index].postits.findIndex((item) => item.id == data.id)
            state.lists[index].postits.splice(card_index, 1)
        },
        postitVote(state, data) {
            const index = state.lists.findIndex(item => item.id == data.retrospective_id)
            const card_index = state.lists[index].postits.findIndex((item) => item.id == data.id)
            state.lists[index].postits[card_index].dots = data.dots
        },
        savePostit(state, data) {
            const index = state.lists.findIndex(item => item.id == data.retrospective_id)
            const card_index = state.lists[index].postits.findIndex((item) => item.id == data.id)
            state.lists[index].postits[card_index].description = data.description
        },
        saveComment(state, data) {
            const index = state.lists.findIndex((list) => {
                return list.postits.find((postit) => {
                    return postit.id === data.postit_id
                })
            })
            const card_index = state.lists[index].postits.findIndex((item) => item.id == data.postit_id)
            state.lists[index].postits[card_index].comments.unshift(data)
        },
        deleteComment(state, data) {
            const index = state.lists.findIndex((list) => {
                return list.postits.find((postit) => {
                    return postit.id === data.postit_id
                })
            })
            const card_index = state.lists[index].postits.findIndex((item) => item.id == data.postit_id)
            const comment_index = state.lists[index].postits[card_index].comments.findIndex((comm) => comm.id == data.id)
            state.lists[index].postits[card_index].comments.splice(comment_index, 1)
        },
    },
    getters: {},
    actions: {
        createColumn(context, message) {
            var data = new FormData
            data.append("retrospective[name]", message)
            data.append("retrospective[team_id]", context.state.team.id)
            $.ajax({
                url: `/retrospectives`,
                dataType: "JSON",
                type: "POST",
                data: data,
                processData: false,
                contentType: false,
                success: (data) => {
                    // Don't need next line due to ActionCable is going to take care of calling createColumn. see. retrospective.coffee that calls retrospective.vue
                    // this.$store.commit('createColumn',data)
                    context.state.message = undefined
                }
            })
        },
        columnMoved(context, index) {
            var data = new FormData
            data.append("retrospective[position]", index + 1)
            $.ajax({
                url: `/retrospectives/${context.state.lists[index].id}/move`,
                dataType: "JSON",
                type: "PATCH",
                data: data,
                processData: false,
                contentType: false
            })
        },
        deleteColumn(context,info) {
            $.ajax({
                url: "/retrospectives/" + info.list.id,
                type: "DELETE",
                dataType: "JSON",
                processData: false,
                contentType: false,
                success: () => {
                    // Don't need next line due to ActionCable is going to take care of calling createColumn. see. retrospective.coffee that calls retrospective.vue
                    //this.$store.commit('deleteColumn',this.list.id)
                    info.message = undefined
                }
            })
        },
        createPostit(context, info) {
            var data = new FormData
            data.append("postit[retrospective_id]", info.list.id)
            data.append("postit[text]", info.message)

            $.ajax({
                url: "/postits",
                dataType: "JSON",
                type: "POST",
                data: data,
                processData: false,
                contentType: false,
                success: (data) => {
                    // Don't need next line due to ActionCable is going to take care of calling createColumn. see. retrospective.coffee that calls retrospective.vue
                    //this.$store.commit('createPostit', data)
                    info.message = undefined
                }
            })
        },
        postitMoved(context,info) {
            var data = new FormData
            data.append("postit[retrospective_id]", info.list.id)
            data.append("postit[position]", info.index + 1)
            $.ajax({
                url: `/postits/${info.id}/move`,
                type: "PATCH",
                data: data,
                dataType: "JSON",
                processData: false,
                contentType: false
            })
        },
        deletePostit(context,info) {
            $.ajax({
                url: `/postits/${info.postit.id}`,
                dataType: "JSON",
                type: "DELETE",
                processData: false,
                contentType: false,
                success: (data) => {
                }
            })
        },
        votePostit(context,info) {
            $.ajax({
                url: `/postits/${info.postit.id}/vote`,
                dataType: "JSON",
                type: "POST",
                data: "",
                processData: false,
                contentType: false,
                success: () => {
                    info.voting = false
                }
            })
        },
        savePostit(context,info) {
            var data = new FormData
            data.append("postit[description]", info.postit.description)
            $.ajax({
                url: `/postits/${info.postit.id}/save`,
                dataType: "JSON",
                type: "POST",
                data: data,
                processData: false,
                contentType: false,
                success: (data) => {
                    //Here you can call component emit method and update any props it has.
                    //info.$emit('update:editing', false)
                }
            })
        },
        saveComment(context,info) {
            var data = new FormData
            data.append("comment[postit_id]", info.postit.id)
            data.append("comment[description]", info.comment)
            $.ajax({
                url: "/comments",
                dataType: "JSON",
                type: "POST",
                data: data,
                processData: false,
                contentType: false,
                success: (data) => {
                    info.comment = undefined
                }
            })
        },
        deleteComment(context,id) {
            $.ajax({
                url: `/comments/${id}`,
                dataType: "JSON",
                type: "DELETE",
                processData: false,
                contentType: false,
                success: (data) => {
                }
            })
        },
    },
}