import { createApp } from 'vue'
import App from './App.vue'
import * as VueRouter from 'vue-router'
import VueComponent from './views/vue';
import KrakenComponent from './views/kraken';

const routes = [
  { path: '/vue', component: VueComponent },
  { path: '/kraken', component: KrakenComponent },
]

let history = VueRouter.createWebHashHistory();

const router = VueRouter.createRouter({
  history,
  routes,
})
  
const app = createApp(App);
app.use(router);
app.mount(document.body);
