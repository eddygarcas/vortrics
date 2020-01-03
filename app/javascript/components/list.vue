<template>
    <div class="list">
        <a v-on:click="deleteColumn"
           class="btn btn-link btn-flat btn-xs btn-borderless pull-right" rel="nofollow">
            <i class="fa fa-trash"></i>
        </a>
        <h5>{{list.name.toUpperCase()}}</h5>

        <draggable v-model="list.postits" group="postits" @change="postitMoved" class="dragArea">
            <postit v-for="(postit, index) in list.postits" v-bind:key="index" :postit="postit" :postit_index="index"
                    :list_id="list.id" :list_o="list"></postit>
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
                        // Don't need next line due to ActionCable is going to take care of calling createColumn. see. retrospective.coffee that calls retrospective.vue
                        //this.$store.commit('createPostit', data)
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
                    success: () => {
                        // Don't need next line due to ActionCable is going to take care of calling createColumn. see. retrospective.coffee that calls retrospective.vue
                        //this.$store.commit('deleteColumn',this.list.id)
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