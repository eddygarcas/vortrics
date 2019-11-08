<template>
    <div class="panel panel-metric">
        <div class="panel-body">
            <div class="metric-content">
                <div class="row">
                    <header class="col-xs-12">
                        <h3>FILTER</h3>
                    </header>
                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 mt15 mb15">
                        <div class="form-group col-xs-12">
                            <small class="form-label">NUMBER OF SIMULATIONS</small>
                            <input ref="number" v-model.number="number" type="number" min="100" max="1000" readonly
                                   class="form-control add-column-name"
                                   placeholder="1000"/>
                        </div>
                        <div class="form-group col-xs-12">
                            <small class="form-label">BACKLOG LENGTH</small>
                            <input ref="backlog" v-model.number="backlog" type="number"
                                   class="form-control add-column-name"
                                   placeholder="500"/>
                        </div>
                        <div class="form-group col-xs-12">
                            <small class="form-label">ITERATION LENGTH</small>
                            <select v-model="selected" class="form-control add-column-name">
                                <option v-for="option in options" v-bind:value="option.value">
                                    {{ option.text }}
                                </option>
                            </select>
                        </div>
                        <div class="form-group col-xs-12">
                            <small class="form-label">FOCUS %</small>
                            <input v-model.number="focus" type="number" ref="focus" min="1" max="100" placeholder="100" class="form-control add-column-name">
                        </div>
                        <div class="form-group col-xs-12">
                            <button v-on:click="callForecast" class="btn  btn-primary pull-right">Forecast</button>
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
                number: '1000',
                backlog: '50',
                focus: '100',
                selected: '5',
                options: [
                    { text: '1 week', value: '5' },
                    { text: '2 weeks', value: '10' },
                    { text: '3 weeks', value: '15' },
                    { text: '4 weeks', value: '20' },
                ]
            }
        },
        computed: {
            mseries: {
                get(){
                    return this.$store.state.mseries;
                }
            }
        },
        methods: {
            callForecast: function () {
                var data = new FormData
                data.append("montecarlo[number]",this.number);
                data.append("montecarlo[backlog]",this.backlog);
                data.append("montecarlo[focus]",this.focus);
                data.append("montecarlo[iteration]",this.selected);
                $.ajax({
                    url: `/montecarlo/chart`,
                    dataType: "JSON",
                    type: "POST",
                    data: data,
                    processData: false,
                    contentType: false,
                    success: (data) => {
                        this.$store.commit('callForecast',data);
                    }
                })
            }
        }
    }
</script>

<style scoped>
    .add-column-name {
        background: white;
        width: 100%;
        border-radius: 5px;
    }
</style>