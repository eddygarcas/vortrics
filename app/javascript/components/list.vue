<template>
    <div class="list">
        <h5>{{list.name.toUpperCase()}}</h5>
        <button v-on:click="deleteColumn"
                class="btn btn-link btn-flat btn-xs btn-borderless pull-right" rel="nofollow">
            <i class="fa fa-trash"></i>
        </button>
        <hr/>

        <draggable v-model="list.postits" group="postits" @change="postitMoved" class="dragArea">
            <postit v-for="(postit, index) in list.postits" :postit="postit" :postit_index="index"
                    :list_id="list.id"></postit>
        </draggable>
        <input type="text" v-model="message"
               v-on:change="createPostit" class="insight"
               placeholder="Add insight..."/>

    </div>

</template>

<script>
    import draggable from 'vuedraggable'
    import postit from "./postit";

    export default {
        components: {postit, draggable},
        props: ["list", "list_index"],
        data: function () {
            return {
                message: ""
            }
        },
        methods: {
            createPostit: function () {
                var data = new FormData
                data.append("postit[retrospective_id]", this.list.id)
                data.append("postit[text]", this.message)

                $.ajax({
                    url: "/postits",
                    dataType: "JSON",
                    type: "POST",
                    data: data,
                    processData: false,
                    contentType: false,
                    success: (data) => {
                        this.$store.commit('createPostit', data)
                        this.message = ""
                    }
                })
            },
            postitMoved: function (event) {
                const evt = event.added || event.moved
                if (evt == undefined) {
                    return
                }

                const element = evt.element
                const retrospective_index = window.store.lists.findIndex((retrospective) => {
                    return this.list.postits.find((postit) => {
                        return postit.id === element.id
                    })
                })

                var data = new FormData
                data.append("postit[retrospective_id]", this.list.id)
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
            deleteColumn: function () {
                $.ajax({
                    url: "/retrospectives/" + this.list.id,
                    type: "DELETE",
                    dataType: "JSON",
                    processData: false,
                    contentType: false,
                    success: (data) => {
                        const index = window.store.lists.findIndex(item => item.id == this.list.id)
                        window.store.lists.splice(index, 1)
                        this.message = ""
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
</style>