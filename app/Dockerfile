# F3A Microservice Dockerfile
FROM node:18-alpine AS builder

# Install build dependencies for SQLite
RUN apk add --no-cache python3 make g++

WORKDIR /app
COPY package*.json ./
RUN npm install --only=production

FROM node:18-alpine AS runtime

# Install SQLite runtime
RUN apk add --no-cache sqlite

# Create app user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

WORKDIR /app

# Copy dependencies
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules

# Copy application files
COPY --chown=nodejs:nodejs server.js ./
COPY --chown=nodejs:nodejs healthcheck.js ./
COPY --chown=nodejs:nodejs package*.json ./

# Copy database schema and data
COPY --chown=nodejs:nodejs database/ ./database/
COPY --chown=nodejs:nodejs data/ ./data/
COPY --chown=nodejs:nodejs public/ ./public/

# Create database directory with proper permissions
RUN mkdir -p /app/database && chown nodejs:nodejs /app/database

USER nodejs

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

CMD ["node", "server.js"]
