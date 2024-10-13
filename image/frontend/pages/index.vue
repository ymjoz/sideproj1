<template>
  <div>
    <h1>DOITT WHITE -
      {{ tromsoLocalTime }}
    </h1>
  </div>
</template>

<script setup>

  import { ref, onMounted, computed } from 'vue';
  import axios from 'axios';
  import { useRuntimeConfig } from '#app';

  const config = useRuntimeConfig();

  const title = ref('doitt.white 山陀兒v3');
  const apiHost = ref(config.public.apiURL);
  console.log('hello apiHost:', apiHost.value);
  const apiResonse = ref('xxxxx-xxxxx');
  const tromsoTime = ref(new Date().toLocaleString('en-US', {
    timeZone: 'Europe/Oslo',
    hour12: false,
    hour: 'numeric',
    minute: 'numeric',
    second: 'numeric'
  }))

  // 計算属性
  const tromsoLocalTime = computed(() => tromsoTime.value)

  // 更新時間的方法
  const updateTime = () => {
    tromsoTime.value = new Date().toLocaleString('en-US', {
      timeZone: 'Europe/Oslo',
      hour12: false,
      hour: 'numeric',
      minute: 'numeric',
      second: 'numeric'
    })
  }

  // 在组件挂载时启动定时器
  onMounted(() => {
    updateTime()
    setInterval(updateTime, 1000)

  })

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