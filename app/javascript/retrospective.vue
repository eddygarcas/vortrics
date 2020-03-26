<template>
    <div id="retrospective">
        <div class="sheet-inner">
            <div class="list">
                <input type="text" v-if="!editing" ref="message" v-model="message"
                       class="add-column-name pull-right" v-on:change="createColumn"
                       placeholder="Add column..."/>
            </div>
            <draggable v-model="lists" group="lists" class="board dragArea" @end="columnMoved">
                <list v-for="(list, index) in lists" v-bind:key="index" :list="list" :list_index="index"></list>
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
            }
        },

        computed: {
            lists: {
                get(){
                    return this.$store.state.retro.lists;
                },
                set(value) {
                    this.$store.state.retro.lists = value
                },
            },
            team: {
                get() {
                    return this.$store.state.retro.team;
                },
            },
            message: {
                get() {
                    return this.$store.state.retro.message
                },
                set(value) {
                    this.$store.state.retro.message = value
                }
            }
        },
        methods: {
            createColumn() {
                this.$store.dispatch('createColumn',this.message)
            },
            columnMoved(event) {
                this.$store.dispatch('columnMoved', event.newIndex)
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