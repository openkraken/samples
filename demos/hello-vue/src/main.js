import { createApp } from 'vue'
import App from './App.vue'
import * as VueRouter from 'vue-router'
import Home from './views/home';
import About from './views/about';

const routes = [
  { path: '/', component: Home },
  { path: '/about', component: About },
]

const router = VueRouter.createRouter({
  history: VueRouter.createWebHashHistory(),
  routes,
})
  
const app = createApp(App);
app.use(router);
app.mount(document.body);
