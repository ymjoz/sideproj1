<template>
  <div>
    <h2>TROMSO: {{ tromsoLocalTime }}</h2>
    <p>所有vue共享.0.1.4</p>
    <p>{{ title }} - use yarn</p>
    <h3>API URL: {{ apiHost }}</h3>
    <h4>API URL 2: {{ apiHost2 }}</h4>
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
        apiHost: config.public.apiURL,  // 从 runtimeConfig 中获取 apiHost
        apiHost2: config.public.apiHost2,  // 从环境变量中获取 apiHost
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

      console.log('apiHost2:', this.apiHost2)
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