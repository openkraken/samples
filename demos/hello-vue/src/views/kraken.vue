<template>
  <div>
    <img :style="style.img" alt="Kraken logo" src="//img.alicdn.com/imgextra/i1/O1CN01CUE2IL1FdAGnYPawX_!!6000000000509-2-tps-350-116.png">
  </div>
</template>

<script>
import axios from 'axios';

axios.get('https://kraken.oss-cn-hangzhou.aliyuncs.com/logs/00a4c78b0ca4cc0f1fa32c198ab3da0d209f5150.log').then(response => {
  console.log(response);
})

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
