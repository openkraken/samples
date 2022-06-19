<template>
  <div :style="style.text">

    This is Vue Page.
  </div>
</template>

<script>
import style from './vue.inline.css';

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
