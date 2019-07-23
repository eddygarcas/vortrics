<template>
    <div class="well well-lg">
        {{postit.name.toUpperCase()}}
        <input type="text" v-model="name" v-on:change="submitMessages" style="width: 100%;" placeholder="Add status..." />
    </div>
</template>

<script>
    export default {
        props: ['postit','retrospective'],
        data: function(){
            return {
                name: this.postit.name,
            }
        },
        methods:{
            submitMessages: function (){

            }
        }
    }

</script>

<style scoped>
    .open {
        background-color: #5bc0de;
    }
    .open[href]:hover, .label-primary[href]:focus {
        background-color: #31b0d5;
    }
    .done {
        background-color: #5cb85c;
    }
    .done[href]:hover, .label-primary[href]:focus {
        background-color: #449d44;
    }
    .flagged {
        background-color: #d9534f;
    }
    .flagged[href]:hover, .label-primary[href]:focus {
        background-color: #c9302c;
    }
    .backlog {
        background-color: #f0ad4e;
    }
    .backlog[href]:hover, .label-primary[href]:focus {
        background-color: #ec971f;
    }
    .wip {
        background-color: #f0ad4e;
    }
    .wip[href]:hover, .label-primary[href]:focus {
        background-color: #ec971f;
    }
    .testing {
        background-color: #f0ad4e;
    }
    .testing[href]:hover, .label-primary[href]:focus {
        background-color: #ec971f;
    }
</style>