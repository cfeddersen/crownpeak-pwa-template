FROM node:18-alpine3.17 as build
WORKDIR /usr/fsxa-pwa


COPY package*.json ./
RUN npm ci --silent

COPY . .

ENV NODE_ENV production
RUN npm run build

FROM node:18-alpine3.17 as production
RUN apk update && apk add dumb-init

ENV NODE_ENV production

WORKDIR /usr/fsxa-pwa

COPY --chown=node:node --from=build /usr/fsxa-pwa/.output ./.output
COPY --chown=node:node  --from=build /usr/fsxa-pwa/package*.json ./

EXPOSE 3000

USER node

CMD ["dumb-init", "node",  "./.output/server/index.mjs"]
