<template>
  <div>
    <h2>
      {{ appFooterTitle }}
    </h2>
  </div>
</template>

<script setup>
  import { ref } from 'vue';

  const appFooterTitle = ref('App Footer Here')
</script>

<style lang="scss" scoped></style>