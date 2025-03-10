# Etapa 1: build da aplicação
FROM node:18 AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

# Etapa 2: imagem final, somente com arquivos prontos
FROM node:18-alpine AS runner

WORKDIR /app

# Copia somente o necessário da etapa de build
COPY --from=builder /app/package.json ./
COPY --from=builder /app/.next .next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

# Define variável de ambiente obrigatória para Next.js
ENV NODE_ENV production
ENV PORT 3001

EXPOSE 3001

CMD ["npm", "start"]
