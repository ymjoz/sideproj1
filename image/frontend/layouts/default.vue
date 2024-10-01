<template>
  <div>
    <p>所有vue共享.0.1.2</p>
    <p>{{ title }}</p>
    <p>Tromso time: {{ tromsoLocalTime }}</p>
    <p>API URL: {{ apiHost }}</p>
    <slot />
  </div>
</template>

<script>
  export default {
    name: 'DefaultLayoutVue',

    data() {
      const config = useRuntimeConfig()  // 获取 runtimeConfig
      return {
        title: 'doitt.white 山陀兒',
        // apiHost: config.public.VUE_APP_API_HOST,
        apiHost: config.public.apiURL,  // 从 runtimeConfig 中获取 apiHost
        // apiHost: process.env.VUE_APP_API_HOST,  // 从环境变量中获取 apiHost
        tromsoTime: new Date().toLocaleString('en-US', {
          timeZone: 'Europe/Oslo',
          hour12: false,
          hour: 'numeric',
          minute: 'numeric',
          second: 'numeric'
        })
      }
    },

    computed: {
      tromsoLocalTime() {
        return this.tromsoTime;
      }
    },

    mounted() {
      this.updateTime();
      setInterval(this.updateTime, 1000);
    },

    methods: {
      updateTime() {
        this.tromsoTime = new Date().toLocaleString('en-US', {
          timeZone: 'Europe/Oslo',
          hour12: false,
          hour: 'numeric',
          minute: 'numeric',
          second: 'numeric'
        });
      }
    }
  }
</script>