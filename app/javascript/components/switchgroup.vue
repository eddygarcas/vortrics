<template>
    <p class="lead"><i class="fa fa-area-chart"></i><span id="">{{title}} {{subtitle}}</span>
        <switches v-for="(lever, index) in levers" v-bind:key="index" v-bind:lever="lever">
        </switches>
    </p>
</template>

<script>
    import switches from './labelswitch'
    export default {
        components: {switches},
        props: [],
        data: function () {
            return {
              description: '',
            }
        },
        computed: {
            title: {
                get() {
                    return this.$store.state.charts.title;
                }
            },
            subtitle: {
                get() {
                    return this.description
                },
                set(data){
                    this.description = data
                },
            },
            levers: {
                get() {
                    return this.$store.state.charts.levers
                }
            },
        },
        methods: {}
    }
</script>
<style scoped>

</style>