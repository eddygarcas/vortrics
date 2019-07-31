<template>
    <div class="media well-retro">
        <button v-on:click="deletePostit" class="btn btn-link btn-flat btn-xs  btn-borderless pull-right"
                rel="nofollow">
            <i class="fa fa-trash"></i>
        </button>
        <a class="pull-left" href="#">
            <img class="img-circle" height="32" width="32" v-bind:src="postit.user.avatar">
        </a>
        <div class="media-body">
            <p class="media-heading m0 mt5 mb15"><strong>{{postit.user.displayName}}</strong></p>
        </div>
        <p class="small">{{postit.text}}</p>
        <ul class="small pull-right">
            <i class="fa fa-thumbs-o-up" style="margin-right: 2px;"></i><strong>0</strong>
            <i class="fa fa-comment-o" style="margin-right: 2px;"></i><strong>0</strong>
        </ul>
    </div>
</template>

<script>
    export default {
        props: ['postit', 'list_id', 'postit_index'],
        data: function () {
            return {}
        },
        methods: {
            deletePostit: function () {
                $.ajax({
                    url: `/postits/${this.postit.id}`,
                    dataType: "JSON",
                    type: "DELETE",
                    processData: false,
                    contentType: false,
                    success: (data) => {
                        // Don't need next line due to ActionCable is going to take care of calling createColumn. see. retrospective.coffee that calls retrospective.vue
                        // const index = this.$store.state.lists.findIndex(item => item.id == this.list_id)
                        // this.$store.state.lists[index].postits.splice(this.postit_index, 1)
                    }
                })
            }
        }
    }
</script>

<style scoped>
    .well-retro {
        background: lightyellow;
        border: solid 1px #FFFF00;
        border-radius: 10px;
        box-shadow: 0 1px 0 #c9b044;
        padding: 5px;
    }
</style>