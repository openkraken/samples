<template>
  <div>
    <img :style="style.img" alt="Vue logo" src="//img.alicdn.com/imgextra/i3/O1CN01HmN4l21lpai7j2p3H_!!6000000004868-2-tps-200-200.png">
  </div>
</template>

<script>
const style = {
  img: {
    margin: '10px 0px'
  }
}

export default {
  name: 'about',
  components: {
  },
  data() {
    return {
      style,
    }
  },
}
</script>
