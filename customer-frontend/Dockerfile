FROM node:alpine AS build-stage
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
ENV VUE_APP_BASE_URL=
RUN sed -i "s/<serverIP>/${VUE_APP_BASE_URL}/" .env
RUN npm run build

FROM nginx:latest
WORKDIR /app
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY --from=build-stage /app/vue-frontend.conf /etc/nginx/conf.d/
EXPOSE 8081
CMD [ "nginx", "-g", "daemon off;" ]