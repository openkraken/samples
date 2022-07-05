<template>
  <div>
    <div class="helloworld">
      {{msg}}
    </div>
  </div>
</template>

<style>
.helloworld {
  box-sizing: border-box;
  display: flex;
  position: relative;
  flex-direction: column;
  flex-shrink: 0;
  align-content: flex-start;
  border-width: 0;
  border-style: solid;
  border-color: black;
  margin: 2.66667vw 0;
  padding: 0;
  min-width: 0;
  align-items: center;
  font-size: 20px;
  color: red;
}

</style>

<script>
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
}
</script>
