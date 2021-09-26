<template>
  <div :style="style.home">
    <div>home</div>
  </div>
</template>

<script>
const style = {
  home: {
    backgroundColor: 'yellow'
  },
}

export default {
  name: 'home',
  components: {
  },
  data() {
    return {
      style,
    }
  },
}
</script>
