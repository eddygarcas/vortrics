<template>
    <div id="retrospective">
        <div class="sheet sheet-condensed">
            <div class="sheet-inner">

                <draggable v-model="retrospectives" group="retrospectives" class="row dragArea"
                           @end="columnMoved">
                    <div v-for="(retrospective,index) in retrospectives" class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
                        <h5>{{retrospective.name.toUpperCase()}}</h5>
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
                </draggable>

                <div class="list">
                    <a v-if="!editing" v-on:click="startEditing">Add a List</a>
                    <input type="text" v-if="editing" ref="message" v-model="message" class="form-control mb-1"></input>
                    <button v-if="editing" v-on:click="createColumn" class="btn btn-secondary">Add</button>
                    <a v-if="editing" v-on:click="editing=false">Cancel</a>
                </div>


            </div>
        </div>
    </div>
</template>

<script>
    import draggable from 'vuedraggable'

    export default {
        components: {draggable},
        props: ["column_list"],
        data: function () {
            return {
                editing: false,
                messages: {},
                retrospectives: this.column_list
            }
        },
        methods: {
            startEditing: function () {
                this.editing = true
            },
            createColumn: function () {
                var data = new FormData
                data.append("retrospective[name]",this.message)

                $.ajax({
                    url: '/retrospectives',
                    data: data,
                    type: "JSON",
                    dataType: "POST",
                    success: (data) => {
                        this.message = ""
                        this.editing = false
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
            }
        }
    }
</script>

<style scoped>
    .dragArea {
        min-height: 10px;
    }
</style>