<template>
    <div>
        <div v-on:click="editing=true" class="media well-retro">
            <a v-on:click="deletePostit" class="btn btn-link btn-flat btn-xs btn-borderless pull-right"
               rel="nofollow"><i class="fa fa-trash" aria-hidden="true"></i></a>
            <div class="media-body">
                <p class="media-heading m0 mt5 mb15">
                    <img class="img-circle" height="32" width="32" v-bind:src="postit.user.avatar">
                    <strong>{{postit.user.displayName}}</strong>
                </p>
            </div>
            <div>
                <p class="small">{{postit.text}}</p>
            </div>
            <ul class="small pull-right">
                <a v-on:click="votePostit" ><i class="fa fa-thumbs-o-up" style="margin-right: 2px;"></i></a><strong>{{postit.dots}}</strong>
                <a><i class="fa fa-comment-o" style="margin-right: 2px;"></i></a><strong>0</strong>
            </ul>
        </div>
        <postitmodal :postit="postit" :list_o="list_o" :editing.sync="editing"></postitmodal>
    </div>
</template>

<script>
    import postitmodal from "./postitmodal";


    export default {
        components: {postitmodal},
        filters: {

        },
        props: ['postit', 'postit_index', 'list_o'],
        data: function () {
            return {
                editing: false,
                voting: true
            }
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
            },
            votePostit: function () {
                $.ajax({
                    url: `/postits/${this.postit.id}/vote`,
                    dataType: "JSON",
                    type: "POST",
                    data: "",
                    processData: false,
                    contentType: false,
                    success: () => {
                        this.voting = false
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
        background: #FFFFCC;
        border: solid 1px #FFFF00;
        border-radius: 10px;
        box-shadow: 0 1px 0 #FFEF00;
        padding: 5px;
        margin-top: 10px;
    }
</style>