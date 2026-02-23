# build stage
FROM node:18-alpine AS builder
WORKDIR /app
# copy manifest first to take advantage of Docker layer caching; lockfile
# may not exist until `npm install` has been run locally, but the wildcard
# allows the second stage to proceed if it's missing.
COPY package.json package-lock.json* ./
# use CI mode for reproducible installs and offline cache if available; the
# `--prefer-offline` flag avoids re-downloading packages when buildkit cache is
# present, which can hang if the network is slow.
RUN --mount=type=cache,id=npm-cache,target=/root/.npm \
	npm ci --prefer-offline --no-audit --progress=false
COPY . .
RUN npm run build

# runtime stage
FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
# copy public static assets so they are available at runtime (icons, etc.)
COPY --from=builder /app/package.json ./
COPY --from=builder /app/public ./public
EXPOSE 3000
CMD ["npm", "run", "start"]