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
                            <input type="text" v-model="messages[workflow.id]" v-on:change="submitMessages(workflow.id)"
                                   style="width: 100%;" placeholder="Add status..."/>
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
        components: {draggable},
        props: {},
        computed: {
            workflows: {
                get() {
                    return this.$store.state.flows.workflows;
                },
                set(value) {
                    this.$store.state.flows.workflows = value
                },
            },
            messages: {
                get() {
                    return this.$store.state.flows.messages
                },
                set(value) {
                    this.$store.state.flows.messages = value
                },
            },
        },
        methods: {
            cardMoved: function (event) {
                const evt = event.added || event.moved
                if (evt == undefined) {
                    return
                }
                this.$store.dispatch('cardMoved', evt)
            },
            listMoved: function (evt) {
                this.$store.dispatch('listMoved', evt)
            },
            submitMessages: function (workflow_id) {
                this.$store.dispatch('submitMessages',{id: workflow_id, text: this.messages[workflow_id]})
            },
            deleteCard: function (card_id, card_index, workflow_id) {
                this.$store.dispatch('deleteCard', {id: card_id, index: card_index, flowId: workflow_id})
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
