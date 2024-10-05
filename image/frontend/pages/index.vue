<template>
  <div>
    <p>
      {{ title }}
    </p>
    <ul>
      <li>
        <NuxtLink to="/hello/where">where</NuxtLink>
      </li>
      <li>
        <NuxtLink to="/white/newtest">New Test</NuxtLink>
      </li>
      <li>
        <a href="https://nuxt.com.cn/" target="_blank">真主黨</a>
      </li>
    </ul>
  </div>
</template>

<script setup>

  import { ref } from 'vue';

  const title = ref('doitt.white 山陀兒v2');
  const apiHost = ref('http://localhost');
</script>

<style lang="scss" scoped></style>