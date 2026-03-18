# Stage 1: Build React app
FROM node:20-alpine AS build

WORKDIR /app/frontend

COPY package*.json ./
RUN npm install

COPY . .

# Enable legacy OpenSSL provider required by older webpack/CRA versions
ENV NODE_OPTIONS=--openssl-legacy-provider

RUN npm run build

# Stage 2: Serve with nginx
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/frontend/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]