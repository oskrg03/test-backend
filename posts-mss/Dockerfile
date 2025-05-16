# Etapa de build
FROM node:18 AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY prisma ./prisma
COPY tsconfig*.json ./
COPY src ./src
RUN npx prisma generate

COPY . .
RUN npm run build

# Etapa final
FROM node:18

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev
COPY .env .env

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma ./node_modules/@prisma
COPY --from=builder /app/prisma ./prisma

EXPOSE 3001


CMD ["node", "dist/main"]