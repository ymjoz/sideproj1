<template>
  <div>
    <textarea name="txtarea1" id="txtarea1" rows="4" cols="30">
      {{ pageTitle }} - use yarn
    </textarea>
    <ul>
      <li>
        <NuxtLink to="/">Home</NuxtLink>
      </li>
      <li></li>
    </ul>
  </div>
</template>

<script setup>
  import { ref } from 'vue';

  const pageTitle = ref('ISRAEL F22');
  const apiHost = ref('http://localhost');


</script>

<style lang="scss" scoped></style>