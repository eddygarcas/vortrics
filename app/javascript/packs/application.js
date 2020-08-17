/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'
import TurbolinksAdapter from 'vue-turbolinks'

import Workflow from '../workflow.vue'
import Retrospective from '../retrospective'
import Mfilter from '../mfilter'
import Msummary from '../msummary'
import Commentpanel from '../components/commentpanel'
import Selector from '../components/selector'
import Levers from '../components/switchgroup'

import montecarlo from "./modules/montecarlo";
import retrospective from "./modules/retrospective";
import comments from "./modules/comments"
import workflow from "./modules/workflow";
import cycletime from "./modules/cycletime";
import levers from "./modules/switchgroup"

Vue.use(Vuex);
Vue.use(TurbolinksAdapter);

window.store = new Vuex.Store({
    modules: {
        metrics: montecarlo,
        retro: retrospective,
        comm: comments,
        flows: workflow,
        selector: cycletime,
        charts: levers,
    }
});

document.addEventListener('turbolinks:load', () => {
    var element = document.querySelector("#boards");
    if (element != undefined) {
        window.store.state.flows.workflows = JSON.parse(element.dataset.workflows);
        new Vue({
            el: element,
            store: window.store,
            template: "<workflow/>",
            components: {Workflow}
        })
    }

    element = document.querySelector('#retrospective');
    if (element != undefined) {
        window.store.state.retro.lists = JSON.parse(element.dataset.retrospectives);
        window.store.state.retro.team = JSON.parse(element.dataset.team);
        new Vue({
            el: element,
            store: window.store,
            template: "<retrospective/>",
            components: {Retrospective}
        })
    }

    element = document.querySelector('#filter');
    if (element != undefined) {
        new Vue({
            el: element,
            store: window.store,
            template: "<mfilter/>",
            components: {Mfilter}
        })
    }

    element = document.querySelector('#selector');
    if (element != undefined) {
        window.store.state.selector.team_id = JSON.parse(element.dataset.team);
        new Vue({
            el: element,
            store: window.store,
            template: "<selector/>",
            components: {Selector}
        })
    }

    element = document.querySelector('#levers');
    if (element != undefined) {
        window.store.state.charts = JSON.parse(element.dataset.charts);
        new Vue({
            el: element,
            store: window.store,
            template: "<levers/>",
            components: {Levers}
        })
    }

    element = document.querySelector('#summary');
    if (element != undefined) {
        new Vue({
            el: element,
            store: window.store,
            template: "<msummary/>",
            components: {Msummary}
        })
    }
    element = document.querySelector('#commentpanel');
    if (element != undefined) {
        window.store.state.comm.comments.board_id = JSON.parse(element.dataset.board);
        new Vue({
            el: element,
            store: window.store,
            template: "<commentpanel/>",
            components: {Commentpanel}
        })
    }
});