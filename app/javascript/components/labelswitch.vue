<template>
    <label class="switch switch-info pull-right font_small">{{title}}
        <input type="checkbox" data-toggle="tooltip" :data-title="title" v-on:change="callSwitch" :id="lever.id">
        <span style="margin-bottom: -5px;"></span>
    </label>
</template>

<script>
    export default {
        components: {},
        filters: {},
        props: ['lever'],
        data: function () {
            return {}
        },
        computed: {
            title: function() {
                return this.lever.title.toUpperCase()
            }
        },
        methods: {
            callSwitch(event) {
                this.$parent.subtitle = this.title;
                if (event.target.checked) {
                    this.$store.dispatch('checkLever',this.lever)
                }else{
                    this.$store.dispatch('uncheckLever',this.lever)
                }
            }
        }
    }
</script>

<style scoped>

</style>