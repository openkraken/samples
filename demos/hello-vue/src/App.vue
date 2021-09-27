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

const style = {
  router: {
    margin: '30px 0px',
  },
  home: {
    display: 'flex',
    position: 'relative',
    flexDirection: 'column',
    margin: '27vw 0vw 0vw',
    padding: '0vw',
    minWidth: '0vw',
    alignItems: 'center',
  },
  info: {
    alignItems: 'center',
    fontSize: '18px',
    margin: '5px 0',
    color: '#555555',
  },
  button: {
    padding: '10px 10px',
    border: '1px solid #333333',
    margin: '0px 10px'
  },
  changeRouter: {
    display: 'flex',
    marginTop: '20px',
  }
}

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
