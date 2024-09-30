FROM node:18-alpine AS build-stage
WORKDIR /app
COPY ./ .
RUN npm install -g pnpm
RUN pnpm install 
RUN pnpm run build
RUN pnpm run generate

# 設置環境變數
ARG VUE_APP_API_HOST=http://localhost:3010
ARG VUE_APP_DEV_MODE=false
ENV VUE_APP_API_HOST=${VUE_APP_API_HOST}
ENV VUE_APP_DEV_MODE=${VUE_APP_DEV_MODE}

# production stage
FROM nginx:stable-alpine AS production-stage
RUN mkdir /app
COPY --from=build-stage /app/.output /app
COPY entrypoint.sh /usr/share/nginx/
RUN chmod +x /usr/share/nginx/entrypoint.sh
ENTRYPOINT [ "/usr/share/nginx/entrypoint.sh" ]
COPY nginx.conf /etc/nginx/nginx.conf

# 安裝必要的工具，例如 curl
RUN apk add --no-cache curl

EXPOSE 80
