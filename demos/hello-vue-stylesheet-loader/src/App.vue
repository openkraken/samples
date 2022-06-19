<template>
  <div :style="style.home">
    <div :style="style.changeRouter">
      <div :style="style.button" @click="goToVue">
      click me to Vue
      </div>
      <div :style="style.button" @click="goToKraken">
        click me to Kraken
      </div>
    </div>
    <div :style="style.router">router is {{$route.path}}</div>
    <div>
      <router-view />
    </div>
    <HelloWorld msg="Welcome to Your Vue.js App"/>
    <div :style="style.info">More information about Vue.js</div>
    <div :style="style.info">Visit https://cn.vuejs.org/</div>
  </div>
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'
import style from './App.inline.css';

export default {
  name: 'App',
  components: {
    HelloWorld
  },
  data() {
    return {
      style,
    }
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
