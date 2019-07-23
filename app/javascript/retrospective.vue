<template>
    <div id="retrospective">
        <div class="sheet sheet-condensed">
            <div class="sheet-inner">



                <draggable v-model="retrospectives" group="retrospectives" class="row dragArea"
                           @end="columnMoved">





                    <div v-for="(retrospective,index) in retrospectives" class="col-xs-2 col-sm-2 col-md-2 col-lg-2">

                        <h5>{{retrospective.name.toUpperCase()}}</h5>
                        <button v-on:click="deleteColumn(retrospective.id,index)"
                                class="btn btn-link btn-flat btn-xs btn-borderless pull-right" rel="nofollow">
                            <i class="fa fa-trash"></i>
                        </button>
                        <hr/>


                        <draggable v-model="retrospective.postits" group="postits" @change="postitMoved"
                                   class="dragArea">
                            <div v-for="(postit,index) in retrospective.postits" class="well well-lg">
                                <button v-on:click="deletePostit(postit.id,index,retrospective.id)"
                                        class="btn btn-link btn-flat btn-xs btn-borderless pull-right" rel="nofollow">
                                    <i class="fa fa-trash"></i>
                                </button>
                                <span v-bind:class="[retrospective.name]" class="label" style="font-size:12px;">{{postit.name.toUpperCase()}}</span>
                            </div>
                        </draggable>

                        <div class="well">
                            <input type="text" v-model="messages[retrospective.id]"
                                   v-on:change="submitPostit(retrospective.id)" style="width: 100%;"
                                   placeholder="Add insight..."/>
                        </div>
                    </div>

                    <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
                        <input type="text" v-if="!editing" ref="message" v-model="message" class="form-control form-control-lg" v-on:change="createColumn(team_list.id)" placeholder="Add column..." />
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
        props: ["column_list","team_list"],
        data: function () {
            return {
                editing: false,
                messages: {},
                retrospectives: this.column_list,
                team: this.team_list
            }
        },
        methods: {
            createColumn: function (team_id) {
                var data = new FormData
                data.append("retrospective[name]",this.message)
                data.append("retrospective[team_id",team_id)

                $.ajax({
                    url: `/retrospectives`,
                    dataType: "JSON",
                    type: "POST",
                    data: data,
                    processData: false,
                    contentType: false,
                    success: (data) => {
                        this.retrospectives.push(data)
                        this.message = ""
                    }
                })
            },
            columnMoved: function (event) {
                var data = new FormData
                data.append("retrospective[position]", event.newIndex + 1)
                $.ajax({
                    url: `/retrospectives/${this.retrospectives[event.newIndex].id}/move`,
                    dataType: "JSON",
                    type: "PATCH",
                    data: data,
                    processData: false,
                    contentType: false
                })
            },
            deleteColumn: function (retrospective_id, retrospective_index) {
                $.ajax({
                    url: "/retrospectives/" + retrospective_id,
                    type: "DELETE",
                    dataType: "JSON",
                    processData: false,
                    contentType: false,
                    success: (data) => {
                        this.retrospectives.splice(retrospective_index, 1)
                        this.messages[retrospective_id] = undefined
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
</style>