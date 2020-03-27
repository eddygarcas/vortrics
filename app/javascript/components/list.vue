<template>
    <div class="list">
        <a v-on:click="deleteColumn"
           class="btn btn-link btn-flat btn-xs btn-borderless pull-right" rel="nofollow">
            <i class="fa fa-trash"></i>
        </a>
        <h5>{{list.name.toUpperCase()}}</h5>

        <draggable v-model="list.postits" group="postits" @change="postitMoved" class="dragArea">
            <postit v-for="(postit, index) in list.postits" v-bind:key="index" v-bind:postit="postit" v-bind:list_o="list"></postit>
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
                message: undefined,
                index: {type: Number,},
                id: {type: Number,}
            }
        },
        methods: {
            createPostit: function () {
                this.$store.dispatch('createPostit', this)
            },
            postitMoved: function (event) {
                const evt = event.added || event.moved
                if (evt == undefined) {
                    return
                }
                this.index = evt.newIndex
                this.id = evt.element.id
                this.$store.dispatch('postitMoved', this)
            },
            deleteColumn: function () {
                this.$store.dispatch('deleteColumn', this)
            },
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