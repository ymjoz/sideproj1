import { defineNuxtConfig } from 'nuxt/config'
import dotenv from 'dotenv'

dotenv.config() // 读取 .env 文件

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-04-03',
  devtools: { enabled: true },
  runtimeConfig: {
    foo: 'bar',
    // 客户端和服务器端都可访问的变量
    public: {
      apiURL: process.env.VUE_APP_API_HOST || 'http://spj-sit-backend-api-1:80/',
      envAll: JSON.stringify(process.env),
    }
  },
})
