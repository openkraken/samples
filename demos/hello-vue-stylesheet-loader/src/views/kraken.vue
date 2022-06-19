<template>
  <div :style="style.text">
    This is Kraken Page
  </div>
</template>

<script>
import style from './kraken.inline.css';

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
