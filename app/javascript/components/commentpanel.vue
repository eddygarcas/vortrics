<template>
    <div class="panel panel-info" style="height: 335px;" :key="componentKey">
        <div class="panel-heading">
            <label class="switch switch-info pull-right font_small"
                   v-tooltip:bottom="'First Time Response as hours or days'"> HOURS/DAYS
                <input type="checkbox" id="first_response_switch" v-on:change="refresh" v-model="isdays">
                <span style="margin-bottom: -5px;"></span>
            </label>
            <p class='lead'><i class="fa fa-fw fa-comments fa-lg fa-fw"></i> FIRST COMMENTS</p>
        </div>

        <div class="tab-content">
            <div v-model="comments" class="tab-pane fade active in" style='height: 275px; overflow: scroll;'>
                <ul class="list-group list-group-flush">
                    <li class='list-group-item' v-for="(comment, index) in comments">
                        <div class="media">
                            <a class="pull-left" href="#">
                                <img height="24" width="24" class="img-rounded"
                                     v-tooltip:right="comment.first_time.author.displayName"
                                     v-bind:src="comment.first_time.author.avatarUrls['48x48']">
                            </a>
                            <div class="media-body">
                                <h5 class="media-heading small">
                                    <img height="18" width="18" v-bind:src="comment.priority.icon"
                                         v-tooltip:right="comment.priority.name">
                                    <a v-bind:href="'/issues/key/' + comment.key">{{comment.key}}</a> Time until first
                                    comment
                                    {{ comment.first_time.created, comment.created, timein | toHours }} {{timein}}
                                    <img height="18" width="18" v-bind:src="comment.status.icon"
                                         v-tooltip:bottom="comment.status.name">
                                </h5>
                                <p class='small'>{{comment.first_time.body}}</p>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</template>

<script>
    import moment from 'moment'

    export default {
        components: {},
        filters: {
            toHours: function (start, stop, timein) {
                if (start && stop) {
                    return moment(String(start)).diff(stop, timein)
                }
            }
        },
        props: [],
        computed: {
            comments: {
                get() {
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
            return {
                timein: "hours",
                isdays: false,
                componentKey: 0
            }
        },
        created: function () {
            $.ajax({
                url: `/comments/by_board/` + this.board_id,
                dataType: "JSON",
                type: "GET",
                processData: false,
                contentType: false,
                success: (data) => {
                    this.$store.commit('byBoardComments', data);
                }
            })
        },
        methods: {
            refresh: function () {
                if (this.isdays) {
                    this.timein = "days"
                } else {
                    this.timein = "hours"
                }
                this.componentKey += 1
            }
        }
    }
</script>

<style scoped>

</style>