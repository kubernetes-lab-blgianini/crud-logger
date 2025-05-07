# Etapa 1: Build
FROM node:20 AS build

WORKDIR /app

# Copia os arquivos de configuração
COPY package*.json ./
COPY tsconfig.json ./
COPY prisma ./prisma

# Instala dependências
RUN npm install

# Gera o cliente Prisma
RUN npx prisma generate

# Copia os arquivos de código
COPY src ./src

# Compila o TypeScript
RUN npx tsc

# Etapa 2: Runtime
FROM node:20

WORKDIR /app

# Copia as dependências e build da etapa anterior
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/prisma ./prisma
COPY --from=build /app/package.json ./
COPY --from=build /app/.prisma ./node_modules/.prisma

# Copia também o .env (você pode montar via docker-compose)
COPY .env .env

# Gera cliente Prisma e roda as migrações
RUN npx prisma generate
RUN npx prisma migrate deploy

EXPOSE 3000

CMD ["node", "dist/index.js"]