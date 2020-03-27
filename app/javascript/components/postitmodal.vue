<template>
    <div>
        <div v-if='editing' class="modal-example show"></div>

        <div v-if='editing' @click="closeModal" class="modal show" style="display: block">

            <div class="modal-dialog modal-lg">
                <div class="modal-content modal-round">


                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" v-on:click="emitCloseModal">
                            <span aria-hidden="true">×</span><span class="sr-only">Close</span></button>
                        <h3 class="media-heading m0 mt5">
                            <i class="fa fa-pencil-square-o"></i>
                            {{postit.text}}
                            <small>in column {{list_o.name}}</small>
                        </h3>
                    </div>


                    <div class="modal-body">

                        <div class="row mb15" style="margin-top: -15px;">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <div>
                                    <small><strong>CREATED BY</strong></small>
                                </div>
                                <div>
                                    <img class="img-circle" height="32" width="32" v-bind:src="postit.user.avatar">
                                    <small>{{postit.user.displayName}}</small>
                                </div>
                            </div>
                        </div>


                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <h5 class="media-heading m0 mt5 mb15">
                                    <i class="fa fa-file-text-o"></i>
                                    Description
                                </h5>
                                <textarea v-model="postit.description" placeholder="Add more details..."
                                          class="form-control" rows="5" style="resize: none;"></textarea>
                                <button type="button" class="btn btn-outline-success mt5 pull-right"
                                        data-dismiss="modal"
                                        v-on:click="savePostit">Save
                                </button>
                            </div>
                        </div>
                        <comments v-bind:postit="postit"></comments>
                    </div>

                    <div class="modal-footer text-center">
                        <button type="button" class="btn btn-outline-default" data-dismiss="modal"
                                v-on:click="emitCloseModal">Close
                        </button>
                    </div>

                </div><!-- /.modal-content -->
            </div>
        </div>
    </div>
</template>

<script>
    import Comments from "./comments";

    export default {
        components: {Comments},
        filters: {},
        props: ['postit', 'list_o', 'editing'],
        methods: {
            emitCloseModal: function () {
                this.$emit('update:editing', false)
            },
            closeModal: function (event) {
                if (event.target.classList.contains("modal")) {
                    this.$emit('update:editing', false)
                }
            },
            savePostit: function () {
                this.$store.dispatch('savePostit',this)
            }
        }
    }
</script>

<style scoped>
    .modal-round {
        border-radius: 10px;
        padding: 5px;
    }
</style>