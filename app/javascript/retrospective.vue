<template>
    <div id="retrospective">
        <div class="sheet sheet-condensed">
            <div class="sheet-inner">
                <draggable v-model="retrospectives" group="retrospectives" class="row dragArea"
                           @end="listMoved">
                    <div v-for="(retrospective,index) in retrospectives" class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
                        <h5>{{retrospective.name.toUpperCase()}}</h5>
                        <hr/>

                        <draggable v-model="retrospective.postits" group="postits" @change="cardMoved"
                                   class="dragArea">
                            <div v-for="(postit,index) in retrospective.postits" class="well well-lg">
                                <button v-on:click="deleteCard(postit.id,index,retrospective.id)"
                                        class="btn btn-link btn-flat btn-xs btn-borderless pull-right" rel="nofollow">
                                    <i class="fa fa-trash"></i>
                                </button>
                                <span v-bind:class="[retrospective.name]" class="label" style="font-size:12px;">{{postit.name.toUpperCase()}}</span>
                            </div>
                        </draggable>

                        <div class="well">
                            <input type="text" v-model="messages[retrospective.id]"
                                   v-on:change="submitMessages(retrospective.id)" style="width: 100%;"
                                   placeholder="Add insight..."/>
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
        props: ["column_list"],
        data: function () {
            return {
                messages: {},
                retrospectives: this.column_list
            }
        },
        methods: {
        }
    }
</script>

<style scoped>
    .dragArea {
        min-height: 10px;
    }
</style>