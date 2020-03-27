<template>
    <div>
        <div class="media well-retro">
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
                <a v-on:click="editing=true"><i class="fa fa-comment-o" style="margin-right: 2px;"></i></a><strong>{{commentsSize}}</strong>
            </ul>
        </div>
        <postitmodal v-bind:postit="postit" v-bind:list_o="list_o" :editing.sync="editing"></postitmodal>
    </div>
</template>

<script>
    import postitmodal from "./postitmodal";

    export default {
        components: {postitmodal},
        filters: {},
        props: ['postit', 'list_o'],
        data: function () {
            return {
                editing: false,
                voting: true,
            }
        },
        computed: {
            commentsSize: function() {
                return this.postit.comments.length
            }
        },
        methods: {
            deletePostit: function () {
                this.$store.dispatch('deletePostit',this)
            },
            votePostit: function () {
                this.$store.dispatch('votePostit',this)
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