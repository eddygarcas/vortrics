<template>
    <div class="panel panel-metric">
        <div class="panel-body">
            <div class="metric-content">
                <div class="row">
                    <header class="col-xs-12">
                        <h3>MONTECARLO</h3>
                    </header>

                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                        <div class="metric-value col-xs-12" v-if="summary.confidence_at_50">
                            <strong>{{ summary.confidence_at_50.x }}</strong> Iteration
                            <small style="font-size: 12px">CONFIDENCE AT {{ summary.confidence_at_50.y }}%</small>
                        </div>
                        <div v-else class="metric-value col-xs-12">
                            <i class="fa fa-fw fa-spinner fa-pulse"></i>
                            <strong></strong> Iteration
                            <small style="font-size: 12px">CONFIDENCE AT </small>

                        </div>

                        <div class="metric-value col-xs-12" v-if="summary.confidence_at_85">
                            <strong>{{ summary.confidence_at_85.x }}</strong> Iteration
                            <small style="font-size: 12px">CONFIDENCE AT {{ summary.confidence_at_85.y }}%</small>
                        </div>
                        <div v-else class="metric-value col-xs-12">
                            <i class="fa fa-fw fa-spinner fa-pulse"></i>
                            <strong></strong> Iteration
                            <small style="font-size: 12px">CONFIDENCE AT </small>

                        </div>

                        <div class="metric-value col-xs-12" v-if="summary.max_likelihood">
                            <strong>{{ summary.max_likelihood.x }}</strong> Iteration
                            <small style="font-size: 12px">MAX. LIKELIHOOD {{summary.max_likelihood.y}}%</small>
                        </div>
                        <div v-else class="metric-value col-xs-12">
                            <i class="fa fa-fw fa-spinner fa-pulse"></i>
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
            return {}
        },
        computed: {
            summary: {
                get() {
                    return this.$store.state.metrics.summary;
                }
            }
        },
        methods: {}
    }
</script>

<style scoped>
</style>