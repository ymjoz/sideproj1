<template>
  <div>
    <AppHeader />
    <slot />
    <AppFooter />
  </div>
</template>

<script setup>
  // import { ref } from 'vue'
  // import { useRuntimeConfig } from '#app'

  //  runtimeConfig
  // const config = useRuntimeConfig()

  //
  // const title = ref('DOITT.WHITE 山陀兒v4')
  // const apiHost = ref(config.public.apiURL)
  // const envAll = ref(config.public.envAll)

</script>