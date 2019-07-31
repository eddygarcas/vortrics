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
import App from '../app.vue'
import Retrospective from '../retrospective'
import TurbolinksAdapter from 'vue-turbolinks'

Vue.use(Vuex)
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


window.store = new Vuex.Store({
    state: {
        lists: [],
        team: {}
    },
    mutations: {
        createColumn(state, data) {
            state.lists.push(data)
        },
        columnMoved(state,data) {
            const index = state.lists.findIndex(item => item.id == data.id)
            state.lists.splice(index, 1)
            state.lists.splice(data.position - 1, 0, data)
        },
        createPostit(state,data){
            const index = state.lists.findIndex(item => item.id == data.retrospective_id)
            state.lists[index].postits.push(data)
        },
        postitMoved(state,data) {
            const old_list_index = state.lists.findIndex((list) => {
                return list.postits.find((postit) => {
                    return postit.id === data.id
                })
            })
            const old_card_index = state.lists[old_list_index].postits.findIndex((item) => item.id == data.id)
            const new_list_index = state.lists.findIndex((item) => item.id == data.retrospective_id)

            if (old_list_index != new_list_index) {
                // Remove card from old list, add to new one
                state.lists[old_list_index].postits.splice(old_card_index, 1)
                state.lists[new_list_index].postits.splice(data.position - 1, 0, data)
            } else {
                state.lists[new_list_index].postits.splice(old_card_index, 1)
                state.lists[new_list_index].postits.splice(data.position - 1, 0, data)
            }
        },
        deleteColumn(state,data) {
            const index = state.lists.findIndex(item => item.id == data.id)
            state.lists.splice(index, 1)
        },
        deletePostit(state,data) {
            const index = state.lists.findIndex(item => item.id == data.retrospective_id)
            const card_index = state.lists[index].postits.findIndex((item) => item.id == data.id)
            state.lists[index].postits.splice(card_index, 1)
        }

    }
});

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
        window.store.state.lists = JSON.parse(element.dataset.retrospectives)
        window.store.state.team = JSON.parse(element.dataset.team)
        const retrospective = new Vue({
            el: element,
            store: window.store,
            template: "<Retrospective/>",
            components: {Retrospective}
        })
    }
});