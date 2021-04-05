
# FROM mcr.microsoft.com/appsvc/node:12-lts as build-stage
# RUN npm install npm@latest -g
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY ./ .
# RUN npm run build

FROM node:latest as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY ./ .
RUN npm run build

FROM mcr.microsoft.com/appsvc/node:12-lts as production-stage
RUN mkdir /app
COPY --from=build-stage /app/dist /home/site/wwwroot

EXPOSE 8080
ENTRYPOINT [ "pm2", "serve", "/home/site/wwwroot", "--no-daemon" ]