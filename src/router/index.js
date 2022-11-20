import Vue from 'vue'
import VueRouter from 'vue-router'
import Index from '@/views/Index'

Vue.use(VueRouter)

const routes = [
  { name: 'home', path: '/', component: Index, props: true }
]

export default new VueRouter({
  routes,
  mode: 'history'
})
