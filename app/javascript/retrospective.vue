<template>
    <div id="retrospective">
        <div class="sheet-inner">
            <div class="list">
                <input type="text" v-if="!editing" ref="message" v-model="message"
                       class="add-column-name pull-right" v-on:change="createColumn"
                       placeholder="Add column..."/>
            </div>
            <draggable v-model="lists" group="lists" class="board dragArea" @end="columnMoved">
                <list v-for="(list, index) in lists" :list="list" :list_index="index">

                </list>

            </draggable>

        </div>
    </div>
</template>

<script>
    import draggable from 'vuedraggable'
    import list from 'components/list'

    export default {
        components: {list, draggable},
        props: [],
        data: function () {
            return {
                editing: false,
                message: "",
            }
        },

        computed: {
            lists: {
                get(){
                    return this.$store.state.lists;
                },
                set(value) {
                    this.$store.state.lists = value
                },
            },
            team: {
                get() {
                    return this.$store.state.team;
                },
            }
        },
        methods: {
            createColumn: function () {
                var data = new FormData
                data.append("retrospective[name]", this.message)
                data.append("retrospective[team_id", this.$store.state.team.id)

                $.ajax({
                    url: `/retrospectives`,
                    dataType: "JSON",
                    type: "POST",
                    data: data,
                    processData: false,
                    contentType: false,
                    success: (data) => {
                        this.$store.commit('createColumn',data)
                        this.message = ""
                    }
                })
            },
            columnMoved: function (event) {
                var data = new FormData
                data.append("retrospective[position]", event.newIndex + 1)
                $.ajax({
                    url: `/retrospectives/${this.lists[event.newIndex].id}/move`,
                    dataType: "JSON",
                    type: "PATCH",
                    data: data,
                    processData: false,
                    contentType: false
                })
            }
        }
    }
</script>

<style scoped>
    .dragArea {
        min-height: 10px;
    }

    .board {
        overflow-x: auto;
        white-space: normal;
    }

    .list {
        background: whitesmoke;
        border-radius: 10px;
        display: inline-block;
        margin-right: 10px;
        padding: 10px;
        vertical-align: top;
        width: 320px;
        margin-bottom: 10px;
    }

    .add-column-name {
        background: white;
        width: 100%;
        border-radius: 5px;
    }
</style>