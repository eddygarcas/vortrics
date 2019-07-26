<template>
    <div id="retrospective">
            <div class="sheet-inner">

                <draggable v-model="retrospectives" group="retrospectives" class="board dragArea" @end="columnMoved">

                    <div v-for="(retrospective,index) in retrospectives" class="list">

                        <h5>{{retrospective.name.toUpperCase()}}</h5>
                        <button v-on:click="deleteColumn(retrospective.id,index)"
                                class="btn btn-link btn-flat btn-xs btn-borderless pull-right" rel="nofollow">
                            <i class="fa fa-trash"></i>
                        </button>
                        <hr/>

                        <draggable v-model="retrospective.postits" group="postits" @change="postitMoved"
                                   class="dragArea">

                            <div v-for="(postit,index) in retrospective.postits" class="media well-retro">
                                <button v-on:click="deletePostit(postit.id,index,retrospective.id)"
                                        class="btn btn-link btn-flat btn-xs  btn-borderless pull-right" rel="nofollow">
                                    <i class="fa fa-trash"></i>
                                </button>
                                <a class="pull-left" href="#">
                                    <img class="img-circle" height="32" width="32" v-bind:src="postit.user.avatar">
                                </a>
                                <div class="media-body">
                                    <p class="media-heading m0 mt5 mb15">
                                        <strong>{{postit.user.displayName}}</strong>
                                    </p>
                                    <p class="small">{{postit.text}}</p>
                                </div>
                                <ul class="small pull-right">
                                    <i class="fa fa-thumbs-o-up" style="margin-right: 2px;"></i><strong>0</strong>
                                    <i class="fa fa-comment-o" style="margin-right: 2px;"></i><strong>0</strong>
                                </ul>
                            </div>
                        </draggable>
                        <input type="text" v-model="messages[retrospective.id]"
                               v-on:change="submitPostit(retrospective.id)" class="insight"
                               placeholder="Add insight..."/>

                    </div>

                    <div class="list">
                        <input type="text" v-if="!editing" ref="message" v-model="message"
                               class="column-name" v-on:change="createColumn(team_list.id)"
                               placeholder="Add column..."/>
                    </div>


                </draggable>
            </div>
    </div>
</template>

<script>
    import draggable from 'vuedraggable'

    export default {
        components: {draggable},
        props: ["column_list", "team_list"],
        data: function () {
            return {
                editing: false,
                messages: {},
                message: "",
                retrospectives: this.column_list,
                team: this.team_list
            }
        },
        methods: {
            submitPostit: function (retrospective_id) {
                var data = new FormData
                data.append("postit[retrospective_id]", retrospective_id)
                data.append("postit[text]", this.messages[retrospective_id])

                $.ajax({
                    url: "/postits",
                    dataType: "JSON",
                    type: "POST",
                    data: data,
                    processData: false,
                    contentType: false,
                    success: (data) => {
                        const index = this.retrospectives.findIndex(item => item.id == retrospective_id)
                        console.log(this.retrospectives[index])

                        this.retrospectives[index].postits.push(data)
                        this.messages[retrospective_id] = undefined
                    }
                })
            },
            deletePostit: function (postit_id, postit_index, retrospective_id) {
                $.ajax({
                    url: `/postits/${postit_id}`,
                    dataType: "JSON",
                    type: "DELETE",
                    processData: false,
                    contentType: false,
                    success: (data) => {
                        const index = this.retrospectives.findIndex(item => item.id == retrospective_id)
                        this.retrospectives[index].postits.splice(postit_index, 1)
                        this.messages[retrospective_id] = undefined
                    }
                })
            },
            postitMoved: function (event) {
                const evt = event.added || event.moved
                if (evt == undefined) {
                    return
                }

                const element = evt.element
                const retrospective_index = this.retrospectives.findIndex((retrospective) => {
                    return retrospective.postits.find((postit) => {
                        return postit.id === element.id
                    })
                })

                var data = new FormData
                data.append("postit[retrospective_id]", this.retrospectives[retrospective_index].id)
                data.append("postit[position]", evt.newIndex + 1)
                $.ajax({
                    url: `/postits/${element.id}/move`,
                    type: "PATCH",
                    data: data,
                    dataType: "JSON",
                    processData: false,
                    contentType: false
                })
            },
            createColumn: function (team_id) {
                var data = new FormData
                data.append("retrospective[name]", this.message)
                data.append("retrospective[team_id", team_id)

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

    .well-retro {
        background: #FFFF99;
        border: solid 1px #FFFF00;
        border-radius: 10px;
        box-shadow: 0 1px 0 #c9b044;
        padding: 5px;
        margin-bottom: 1.6153846154;
    }

    .board {
        overflow-x: auto;
        white-space: nowrap;
    }

    .list {
        background: whitesmoke;
        border-radius: 10px;
        display: inline-block;
        margin-right: 10px;
        padding: 10px;
        vertical-align: top;
        width: 320px;
    }
    .insight {
        background: white;
        width: 100%;
        margin-top: 10px;
        border-radius: 5px;
    }
    .column-name {
        background: white;
        width: 100%;
        border-radius: 5px;
    }
</style>