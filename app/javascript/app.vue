<template>
    <div id="app">
        <div class="sheet sheet-condensed">
            <div class="sheet-inner">
            <div class="row">
                <div v-for="(workflow,index) in workflows" class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
                    <h5>{{workflow.name}}</h5>
                    <hr/>
                    <div v-for="(card,index) in workflow.cards" class="well well-lg">
                        <button v-on:click="deleteCard(card.id,index,workflow.id)"
                                class="btn btn-link btn-flat btn-xs btn-borderless pull-right" rel="nofollow">
                            <i class="fa fa-trash"></i>
                        </button>
                        <span class="label label-default" style="font-size:12px;">{{card.name}}</span>
                    </div>
                    <div class="well">
                        <input type="text" v-model="messages[workflow.id]" v-on:change="submitMessages(workflow.id)" style="width: 100%;" placeholder="Add status..." />
                    </div>
                </div>
            </div>
            </div>
        </div>
    </div>
</template>


<script>
    export default {
        props: ["original_lists"],
        data: function () {
            return {
                messages: {},
                workflows: this.original_lists,
            }
        },
        methods: {
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
    p {
        font-size: 2em;
        text-align: center;
    }
</style>
