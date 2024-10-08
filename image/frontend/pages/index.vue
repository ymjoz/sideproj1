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
        <a href="https://nuxt.com.cn/" target="_blank">NUXT3</a>
      </li>
    </ul>
    <div>
      <label for="apiResponse">API Response:</label>
      <pre id="apiResponse">{{ apiResonse }}</pre>

      <!-- <input type="text" id="apiResponse" v-model="apiResponse" readonly /> -->
    </div>
  </div>
</template>

<script setup>

  import { ref, onMounted } from 'vue';
  import axios from 'axios';
  import { useRuntimeConfig } from '#app';

  const config = useRuntimeConfig();

  const title = ref('doitt.white 山陀兒v3');
  const apiHost = ref(config.public.apiURL);
  console.log('hello apiHost:', apiHost.value);
  const apiResonse = ref('xxxxx-xxxxx');

  onMounted(async () => {
    try {
      console.log('hello2 apiHost:', apiHost.value);
      const res = await axios.get(apiHost.value);
      apiResonse.value = res.data;
    } catch (error) {
      console.error('Error fetch API data:', error);
      apiResonse.value = 'Error fetching data';
    }
  })
</script>

<style lang="scss" scoped></style>