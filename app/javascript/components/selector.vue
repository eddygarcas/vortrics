<template>
    <div class="panel panel-metric" style="margin-right:-15px;height:336px;">
        <div class="metric-content">
            <header>
                <h3>SELECTOR</h3>
            </header>
            <div class="row">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <div class="mybox mt10 mr5">
                        <small class="form-label">INITIAL STATE</small>
                        <select v-model="initial" class="form-control btn-sm" v-on:change="callCycletime">
                            <option v-for="option in options" v-bind:value="option.value">
                                {{ option.text }}
                            </option>
                        </select>
                    </div>
                    <div class="mybox mt10 mr5">
                        <small class="form-label">END STATE</small>
                        <select v-model="end" class="form-control btn-sm" v-on:change="callCycletime">
                            <option v-for="option in options" v-bind:value="option.value">
                                {{ option.text }}
                            </option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <div class="metric-content">
                        <div class="metric-value col-xs-12 mt20" style="font-size:20px">
                            <i v-if='summary.cumulative === undefined' class="fa fa-fw fa-spinner fa-pulse"></i>
                            <strong>{{ summary.days }}</strong> Days
                            <small style="font-size: 12px">CUMULATIVE AT {{ summary.cumulative }}%</small>
                        </div>
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
        computed: {
            summary: {
                get() {
                    return this.$store.state.selector.summary;
                }
            }
        },
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