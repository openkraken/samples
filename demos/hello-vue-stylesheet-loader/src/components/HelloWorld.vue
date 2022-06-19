<template>
  <div>
    <div :style="style.helloWorld">
      {{msg}}
    </div>
  </div>
</template>

<script>
import style from './HelloWorld.inline.css';

export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data() {
    return {
      style,
    }
  },
}
</script>
