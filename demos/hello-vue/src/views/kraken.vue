<template>
  <div>
    <img :style="style.img" alt="Kraken logo" src="//img.alicdn.com/imgextra/i1/O1CN01CUE2IL1FdAGnYPawX_!!6000000000509-2-tps-350-116.png">
  </div>
</template>

<script>
const style = {
  img: {
    margin: '10px 0px'
  }
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
