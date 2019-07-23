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
import App from '../app.vue'
import Retrospective from '../retrospective'
import TurbolinksAdapter from 'vue-turbolinks'

Vue.use(TurbolinksAdapter)


// document.addEventListener('DOMContentLoaded', () => {
//   const el = document.body.appendChild(document.createElement('hello'))
//   const app = new Vue({
//     el,
//     render: h => h(App)
//   });
// });


// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   });
// });

document.addEventListener('turbolinks:load', () => {
    var element = document.querySelector("#boards")
    if (element != undefined) {
        const app = new Vue({
            el: element,
            data: {
                workflows: JSON.parse(element.dataset.workflows)
            },
            template: "<App :original_lists='workflows'/>",
            components: {App}
        })
    }
    element = document.querySelector('#retrospective')
    if (element != undefined) {
        console.log(element)
        const retrospective = new Vue({
            el: element,
            data: {
                retrospectives: JSON.parse(element.dataset.retrospectives),
                team: JSON.parse(element.dataset.team)
            },
            template: "<Retrospective :column_list='retrospectives' :team_list='team'/>",
            components: {Retrospective}
        })
    }
});