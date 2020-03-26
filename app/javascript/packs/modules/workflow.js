export default {
    state: {
        workflows: [],
        messages: [],
    },
    mutations: {
        removeCard(state,data) {
            const index = state.workflows.findIndex(item => item.id == data.flowId)
            state.workflows[index].cards.splice(data.index, 1)
        },
        addCard(state,data) {
            const index = state.workflows.findIndex(item => item.id == data.workflow_id)
            state.workflows[index].cards.push(data)
            state.messages[data.workflow_id] = undefined
        },
    },
    getters: {
        workflow: (state) => (id) => {
           return state.workflows.findIndex((workflow) => {
                return workflow.cards.find((card) => {
                    return card.id === id
                })
            })
        },
    },
    actions: {
        cardMoved(context,evt) {
            const element = evt.element
            const workflow_index = context.getters.workflow(element.id)

            var data = new FormData
            data.append("card[workflow_id]", context.state.workflows[workflow_index].id)
            data.append("card[position]", evt.newIndex + 1)
            $.ajax({
                url: `/cards/${element.id}/move`,
                type: "PATCH",
                data: data,
                dataType: "JSON",
                processData: false,
                contentType: false
            })
        },
        listMoved(context,evt) {
            var data = new FormData
            data.append("workflow[position]",evt.newIndex + 1)
            $.ajax({
                url: `/workflows/${context.state.workflows[evt.newIndex].id}/move`,
                type: "PATCH",
                data: data,
                dataType: "JSON",
                processData: false,
                contentType: false
            })
        },
        deleteCard(context,data) {
            $.ajax({
                url: "/cards/" + data.id,
                type: "DELETE",
                dataType: "JSON",
                processData: false,
                contentType: false,
                success: () => {
                    context.commit('removeCard',data)
                }
            })
        },
        submitMessages(context,cardData) {
            var data = new FormData
            data.append("card[workflow_id]", cardData.id)
            data.append("card[name]", cardData.text)

            $.ajax({
                url: "/cards",
                type: "POST",
                data: data,
                dataType: "JSON",
                processData: false,
                contentType: false,
                success: (data) => {
                    context.commit('addCard',data)
                }
            })
        },
    },
}