FROM node:20-alpine

WORKDIR /home/backend

# Copy dependency files first to maximise layer cache reuse
COPY package*.json ./

# Install production dependencies only
RUN npm install --omit=dev

COPY . .

# Run as non-root user for security
RUN addgroup -S app && adduser -S app -G app
USER app

EXPOSE 5000

CMD ["node", "server.js"]