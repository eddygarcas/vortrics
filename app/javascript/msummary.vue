<template>
    <div class="panel panel-metric">
        <div class="panel-body">
            <div class="metric-content">
                <div class="row">
                    <header class="col-xs-12">
                        <h3>MONTECARLO</h3>
                    </header>

                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                        <div class="metric-value col-xs-12">
                            <strong>{{ summary.confidence_at_50.x }}</strong>
                            <small>CONFIDENCE AT {{ summary.confidence_at_50.y }}%</small>
                        </div>
                        <div class="metric-value col-xs-12">
                            <strong>{{ summary.confidence_at_85.x }}</strong>
                            <small>CONFIDENCE AT {{ summary.confidence_at_85.y }}%</small>
                        </div>
                        <div class="metric-value col-xs-12">
                            <strong>{{ summary.max_likelihood.x }}</strong>
                            <small>MAX. LIKELIHOOD {{summary.max_likelihood.y}}%</small>
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
                    return this.$store.state.summary;
                }
            }
        },
        methods: {}
    }
</script>

<style scoped>
</style>