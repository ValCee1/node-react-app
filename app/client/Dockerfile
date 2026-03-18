# Stage 1: Build React app
FROM node:20-alpine AS build

WORKDIR /app/frontend

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Serve with nginx
FROM nginx:alpine

# Custom config required to handle React Router client-side routing
# Without this, hard refreshes on any route other than / return 404
COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /app/frontend/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]