<template>
  <div class="home">
    <div class="change_router">
      <div class="button" @click="goToVue">
      click me to Vue
      </div>
      <div class="button" @click="goToKraken">
        click me to Kraken
      </div>
    </div>
    <div class="router">router is {{$route.path}}</div>
    <div>
      <router-view />
    </div>
    <HelloWorld msg="Welcome to Your Vue.js App"/> 
    <div class="info">More information about Vue.js</div>
    <div class="info">Visit https://cn.vuejs.org/</div>
  </div>
</template>

<style>

.router {
  margin: 30px 0px;
}

.home {
  display: flex;
  position: relative;
  flex-direction: column;
  margin: 27vw 0vw 0vw;
  padding: 0;
  min-width: 0;
  align-items: center;
}

.info {
  align-items: center;
  font-size: 18px;
  margin: 5px 0;
  color: #555555;
}

.button {
  padding: 10px 10px;
  border: 1px solid #333;
  margin: 0 10px;
}

.change_router {
  display: flex;
  margin-top: 20px;
}

</style>

<script>
import HelloWorld from './components/HelloWorld.vue'

export default {
  name: 'App',
  components: {
    HelloWorld
  },
  methods: {
    goToVue () {
      this.$router.replace('vue')
    },
    goToKraken () {
      this.$router.replace('kraken')
    }
  }
}
</script>
