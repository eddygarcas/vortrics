<template>
    <div v-model="comments" class="tab-pane fade active in" style='height: 275px; overflow: scroll;'>
        <ul class="list-group list-group-flush">
            <li class='list-group-item'  v-for="(comment, index) in comments">
                <div class="media">
                    <a class="pull-left" href="#">
                        <img height="24" width="24" class="img-rounded" v-tooltip:right="comment.first_time.author.displayName"
                             v-bind:src="comment.first_time.author.avatarUrls['48x48']">
                    </a>
                    <div class="media-body">
                        <h5 class="media-heading small">
                            <img height="18" width="18" v-bind:src="comment.priority.icon" v-tooltip:right="comment.priority.name">
                            <a v-bind:href="'/issues/key/' + comment.key">{{comment.key}}</a> Time until first comment
                            {{ comment.first_time.created, comment.created | toHours }} hours
                            <img height="18" width="18" v-bind:src="comment.status.icon" v-tooltip:bottom="comment.status.name">
                        </h5>
                        <p class='small'>{{comment.first_time.body}}</p>
                    </div>
                </div>
            </li>
        </ul>
    </div>
</template>

<script>
    import moment from 'moment'



    export default {
        components: {},
        filters: {
            toHours: function (start,stop) {
                if (start && stop) {
                    return moment(String(start)).diff(stop,"hour")
                }
            }
        },
        props: [],
        computed: {
            comments: {
                get(){
                    return this.$store.state.comments.list;
                }
            },
            board_id: {
                get() {
                    return this.$store.state.comments.board_id
                }
            }

        },
        data: function () {
            return {}
        },
        created: function () {
            $.ajax({
                url: `/comments/by_board/` + this.board_id,
                dataType: "JSON",
                type: "GET",
                processData: false,
                contentType: false,
                success: (data) => {
                    this.$store.commit('byBoardComments',data);
                }
            })
        },
        methods: {}
    }
</script>

<style scoped>

</style>