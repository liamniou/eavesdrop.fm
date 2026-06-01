# ---------- build stage ----------
FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build

# ---------- runtime stage ----------
FROM node:20-alpine

WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000

COPY --from=builder /app/package.json /app/package-lock.json ./
RUN npm install --omit=dev --legacy-peer-deps

# copy sveltekit output
COPY --from=builder /app/build ./build

EXPOSE 3000

CMD ["node", "build/index.js"]
