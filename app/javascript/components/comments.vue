<template>
    <div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                <h5 class="media-heading  m0 mt15 mb15">
                    <i class="fa fa-comment-os"></i>
                    Comments
                </h5>
            </div>
        </div>

        <div class="row">
            <div v-model="postit.comments" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                <div class="tab-pane pane-fixed fade active in">
                    <ul class="list-group list-group-flush">
                        <li class='list-group-item' v-for="(comment, index) in postit.comments" :comment="comment">

                            <div class="media">
                                <a class="pull-left" href="#">
                                    <img class="img-circle" height="32" width="32"
                                         v-bind:src="comment.actor.avatar">
                                </a>
                                <a v-on:click="deleteComment(comment.id)"
                                   class="btn btn-link btn-flat btn-xs btn-borderless pull-right"
                                   rel="nofollow">
                                    <i class="fa fa-trash" aria-hidden="true"></i>
                                </a>
                                <div class="media-body">
                                    <h5 class="media-heading">
                                        {{comment.actor.displayName}}
                                        <small>at {{comment.created_at | formatDate}}</small>
                                    </h5>
                                    <p>{{comment.description}}</p>
                                </div>
                            </div>

                        </li>
                    </ul>
                </div>
            </div>
        </div>


        <div class="row">
            <div class="col-xs-1 col-sm-1 col-md-1 col-lg-1">
                <img class="img-circle" height="32" width="32" v-bind:src="postit.user.avatar">
            </div>
            <div class="col-xs-10 col-sm-10 col-md-10 col-lg-10 pull-left">
                <input v-model="comment" class="form-control" placeholder="Add a comment..."></input>
            </div>
            <div class="col-xs-1 col-sm-1 col-md-1 col-lg-1">
                <button type="button" class="btn btn-outline-success pull-right"
                        v-on:click="saveComment">Add
                </button>
            </div>
        </div>

    </div>
    
</template>

<script>
    import moment from 'moment'

    export default {
        components: {},
        filters: {
            formatDate: function (value) {
                if (value) {
                    return moment(String(value)).format('MM/DD/YYYY hh:mm')
                }
            }
        },
        props: ['postit'],
        data: function () {
            return {
                comment: undefined,
            }
        },
        methods: {
            saveComment: function () {
                this.$store.dispatch('saveComment',this)

            },
            deleteComment: function (id) {
                this.$store.dispatch('deleteComment',id)
            },
        }
    }
</script>

<style scoped>
    .pane-fixed {
        max-height: 350px;
        overflow-y: auto;
        overflow-x: hidden
    }
</style>