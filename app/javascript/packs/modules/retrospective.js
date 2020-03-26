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
        columnMoved(state,data) {
            const index = state.lists.findIndex(item => item.id == data.id)
            state.lists.splice(index, 1)
            state.lists.splice(data.position - 1, 0, data)
        },
        createPostit(state,data){
            const index = state.lists.findIndex(item => item.id == data.retrospective_id)
            state.lists[index].postits.push(data)
        },
        postitMoved(state,data) {
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
        deleteColumn(state,data) {
            const index = state.lists.findIndex(item => item.id == data.id)
            state.lists.splice(index, 1)
        },
        deletePostit(state,data) {
            const index = state.lists.findIndex(item => item.id == data.retrospective_id)
            const card_index = state.lists[index].postits.findIndex((item) => item.id == data.id)
            state.lists[index].postits.splice(card_index, 1)
        },
        postitVote(state,data) {
            const index = state.lists.findIndex(item => item.id == data.retrospective_id)
            const card_index = state.lists[index].postits.findIndex((item) => item.id == data.id)
            state.lists[index].postits[card_index].dots = data.dots
        },
        savePostit(state,data){
            const index = state.lists.findIndex(item => item.id == data.retrospective_id)
            const card_index = state.lists[index].postits.findIndex((item) => item.id == data.id)
            state.lists[index].postits[card_index].description = data.description
        },
        saveComment(state,data) {
            const index = state.lists.findIndex((list) => {
                return list.postits.find((postit) => {
                    return postit.id === data.postit_id
                })
            })
            const card_index = state.lists[index].postits.findIndex((item) => item.id == data.postit_id)
            state.lists[index].postits[card_index].comments.unshift(data)
        },
        deleteComment(state,data) {
            const index = state.lists.findIndex((list) => {
                return list.postits.find((postit) => {
                    return postit.id === data.postit_id
                })
            })
            const card_index = state.lists[index].postits.findIndex((item) => item.id == data.postit_id)
            const comment_index =  state.lists[index].postits[card_index].comments.findIndex((comm) => comm.id == data.id)
            state.lists[index].postits[card_index].comments.splice(comment_index, 1)
        },
    },
    getters: {},
    actions: {
      createColumn(context,message) {
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
      columnMoved(context,index) {
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
      }
    },
}