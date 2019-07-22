<template>
    <div id="app">
        <div class="sheet sheet-condensed">
            <div class="sheet-inner">
            <draggable v-model="workflows" group="workflows" class="row dragArea" @end="listMoved">
                <div v-for="(workflow,index) in workflows" class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
                    <h5>{{workflow.name.toUpperCase()}}</h5>
                    <hr/>

                    <draggable v-model="workflow.cards" group="cards" @change="cardMoved" class="dragArea">
                    <div v-for="(card,index) in workflow.cards" class="well well-lg">
                        <button v-on:click="deleteCard(card.id,index,workflow.id)"
                                class="btn btn-link btn-flat btn-xs btn-borderless pull-right" rel="nofollow">
                            <i class="fa fa-trash"></i>
                        </button>
                        <span v-bind:class="[workflow.name]" class="label" style="font-size:12px;">{{card.name.toUpperCase()}}</span>
                    </div>
                    </draggable>

                    <div class="well">
                        <input type="text" v-model="messages[workflow.id]" v-on:change="submitMessages(workflow.id)" style="width: 100%;" placeholder="Add status..." />
                    </div>
                </div>
            </draggable>
            </div>
        </div>
    </div>
</template>


<script>
    import draggable from 'vuedraggable'
    export default {
        components: { draggable },
        props: ["original_lists"],
        data: function () {
            return {
                messages: {},
                workflows: this.original_lists,
            }
        },
        methods: {
            cardMoved: function (event) {
                const evt = event.added || event.moved
                if (evt == undefined) {return}

                const element = evt.element
                const workflow_index = this.workflows.findIndex((workflow) => {
                    return workflow.cards.find((card) => {
                        return card.id === element.id
                    })
                })

                var data = new FormData
                data.append("card[workflow_id]", this.workflows[workflow_index].id)
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
            listMoved: function(event) {
                var data = new FormData
                data.append("workflow[position]",event.newIndex + 1)

                $.ajax({
                    url: `/workflows/${this.workflows[event.newIndex].id}/move`,
                    type: "PATCH",
                    data: data,
                    dataType: "JSON",
                    processData: false,
                    contentType: false
                })

            },
            submitMessages: function (workflow_id) {
                var data = new FormData
                data.append("card[workflow_id]", workflow_id)
                data.append("card[name]", this.messages[workflow_id])

                $.ajax({
                    url: "/cards",
                    type: "POST",
                    data: data,
                    dataType: "JSON",
                    processData: false,
                    contentType: false,
                    success: (data) => {
                        const index = this.workflows.findIndex(item => item.id == workflow_id)
                        this.workflows[index].cards.push(data)
                        this.messages[workflow_id] = undefined
                    }
                })
            },
            deleteCard: function (card_id, card_index, workflow_id) {
                $.ajax({
                    url: "/cards/" + card_id,
                    type: "DELETE",
                    dataType: "JSON",
                    processData: false,
                    contentType: false,
                    success: (data) => {
                        const index = this.workflows.findIndex(item => item.id == workflow_id)
                        this.workflows[index].cards.splice(card_index, 1)
                        this.messages[workflow_id] = undefined
                    }
                })
            }
        }
    }
</script>

<style scoped>
    .dragArea {
        min-height: 10px;
    }
    p {
        font-size: 2em;
        text-align: center;
    }
    .open {
        background-color: #5bc0de;
    }
    .open[href]:hover, .label-primary[href]:focus {
        background-color: #31b0d5;
    }
    .done {
        background-color: #5cb85c;
    }
    .done[href]:hover, .label-primary[href]:focus {
        background-color: #449d44;
    }
    .flagged {
        background-color: #d9534f;
    }
    .flagged[href]:hover, .label-primary[href]:focus {
        background-color: #c9302c;
    }
    .backlog {
        background-color: #f0ad4e;
    }
    .backlog[href]:hover, .label-primary[href]:focus {
        background-color: #ec971f;
    }
    .wip {
        background-color: #f0ad4e;
    }
    .wip[href]:hover, .label-primary[href]:focus {
        background-color: #ec971f;
    }
    .testing {
        background-color: #f0ad4e;
    }
    .testing[href]:hover, .label-primary[href]:focus {
        background-color: #ec971f;
    }

</style>
