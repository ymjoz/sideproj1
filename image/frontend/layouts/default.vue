<template>
  <div>
    <h2>TROMSO {{ tromsoLocalTime }}</h2>
    <p>{{ title }}</p>
    <h3>API URL: {{ apiHost }}</h3>
    <slot />
  </div>
</template>

<script setup>
  import { ref, computed, onMounted } from 'vue'
  import { useRuntimeConfig } from '#app'

  // 获取 runtimeConfig
  const config = useRuntimeConfig()

  // 定义响应式变量
  const title = ref('DOITT.WHITE 山陀兒v4')
  const apiHost = ref(config.public.apiURL)
  const tromsoTime = ref(new Date().toLocaleString('en-US', {
    timeZone: 'Europe/Oslo',
    hour12: false,
    hour: 'numeric',
    minute: 'numeric',
    second: 'numeric'
  }))
  const envAll = ref(config.public.envAll)

  // 计算属性
  const tromsoLocalTime = computed(() => tromsoTime.value)

  // 更新时间的方法
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
    console.log('apiHost:', apiHost.value)

    console.log('envAll:', envAll.value)
  })
</script>