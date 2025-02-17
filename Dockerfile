FROM oven/bun:debian AS build

WORKDIR /app

# Cache packages installation
COPY package.json package.json
COPY bun.lock bun.lock

RUN apt-get update && apt-get install -y \
  libgobject-2.0-0 
  
RUN bunx puppeteer browsers install chrome
RUN bun install

COPY ./src ./src

ENV NODE_ENV=production

RUN bun build \
  --compile \
  --minify-whitespace \
  --minify-syntax \
  --target bun \
  --outfile server \
  ./src/index.ts

FROM gcr.io/distroless/base

WORKDIR /app

COPY --from=build /root/.cache/puppeteer /root/.cache/puppeteer
COPY --from=build /app/server server

ENV NODE_ENV=production

CMD ["./server"]

EXPOSE 3000