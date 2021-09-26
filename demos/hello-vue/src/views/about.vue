<template>
  <div :style="style.about">
    <div>about</div>
  </div>
</template>

<script>
const style = {
  about: {
    backgroundColor: 'black'
  },
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
