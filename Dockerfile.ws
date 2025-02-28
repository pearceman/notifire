FROM node:15.11.0

WORKDIR /usr/src/app

RUN npm i pnpm -g --loglevel notice --force
RUN pnpm i pm2 -g

COPY package.json .

COPY apps/ws ./apps/ws
COPY libs/dal ./libs/dal
COPY libs/shared ./libs/shared
COPY libs/testing ./libs/testing

COPY lerna.json .
COPY tsconfig.json .
COPY tsconfig.base.json .

RUN pnpm install
RUN pnpm build:ws

WORKDIR /usr/src/app/apps/ws
RUN cp src/.env.test dist/src/.env.test
RUN cp src/.env.development dist/src/.env.development
RUN cp src/.env.production dist/src/.env.production
RUN cp src/.env.local dist/src/.env.local

CMD [ "pm2-runtime", "dist/src/main.js" ]
