FROM node:16-alpine

ENV PORT 3000
EXPOSE 3000

# Copy files as a non-root user. The `node` user is built in the Node image.
WORKDIR /usr/src/app
RUN chown node:node ./
USER node

# Install dependencies first, as they change less often than code.
COPY package.json package-lock.json ./
RUN npm ci && npm cache clean --force

COPY ./tsconfig.json ./tsconfig.json
COPY ./public ./public
COPY ./src ./src

# build and serve the frontend; bring in production now
ENV NODE_ENV production
CMD ["npm", "run", "serve"]