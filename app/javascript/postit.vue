<template>
        <div v-for="postit" class="well well-lg">
            <button v-on:click="deleteCard(postit.id,retrospective.id)"
                    class="btn btn-link btn-flat btn-xs btn-borderless pull-right" rel="nofollow">
                <i class="fa fa-trash"></i>
            </button>
            <span v-bind:class="[retrospective.name]" class="label" style="font-size:12px;">{{postit.name.toUpperCase()}}</span>
        </div>
</template>

<script>
    export default {
        name: "postit"
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