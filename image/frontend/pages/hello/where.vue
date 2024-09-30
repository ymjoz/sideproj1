<template>
  <div>
    <h1>Where</h1>
    <p>{{ msg }}</p>
    <ul>
      <li>
        <NuxtLink to="/">Home</NuxtLink>
      </li>
      <li></li>
      <li></li>
    </ul>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        msg: 'Hello World'
      }
    }
  }
</script>

<style lang="scss" scoped></style>