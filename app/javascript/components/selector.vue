<template>
    <div class="panel panel-metric" style="margin-right:-15px;">
        <div class="metric-content">
            <header>
                <h3>SELECTOR</h3>
            </header>
            <div class="row">
                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12"  style="min-height:292px;">
                        <div class="mybox mt5 mr5">
                            <small class="form-label">INITIAL STATE</small>
                            <select v-model="initial" class="form-control btn-sm">
                                <option v-for="option in options" v-bind:value="option.value">
                                    {{ option.text }}
                                </option>
                            </select>
                        </div>
                        <div class="mybox mt5 mr5">
                            <small class="form-label">END STATE</small>
                            <select v-model="end" class="form-control btn-sm">
                                <option v-for="option in options" v-bind:value="option.value">
                                    {{ option.text }}
                                </option>
                            </select>
                        </div>
                        <div class="mybox pull-right mt5 mr5">
                            <button v-on:click="callCycletime" class="btn btn-xs btn-primary">Update</button>
                        </div>
                    </div>
                </div>
            </div>
    </div>
</template>

<script>
    export default {
        components: {},
        props: [],
        data: function () {
            return {
                team_id: 0,
                initial: 'wip',
                end: 'done',
                options: [
                    {text: 'Open', value: 'first'},
                    {text: 'Backlog', value: 'backlog'},
                    {text: 'In Progress', value: 'wip'},
                    {text: 'Testing', value: 'testing'},
                    {text: 'Done', value: 'done'},
                ]
            }
        },
        computed: {},
        methods: {
            callCycletime() {
                this.$store.dispatch('postCycletime', this)
            }
        }
    }
</script>

<style scoped>
    select {
        display: inline-block;
        height: 27px;
        width: 100%;
        outline: none;
        color: #74646e;
        border: 1px solid #ccc;
        border-radius: 5px;
        background: white;
    }
    .mybox {
        position: relative;
        display: inline-block;
        left: 3px;
    }
</style>