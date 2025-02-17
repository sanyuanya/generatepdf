# 第一层：安装环境
FROM ubuntu AS build

# 更新包列表并安装必要的依赖
RUN apt-get update && apt-get install -y \
  libnss3 \
  libatk-bridge2.0-0 \
  libxss1 \
  libgdk-pixbuf2.0-0 \
  libdbus-glib-1-2 \
  libxtst6 \
  libappindicator3-1 \
  libatk1.0-0 \
  libatspi2.0-0 \
  libnspr4 \
  libnss3 \
  libx11-xcb1 \
  libgobject-2.0-0 \
  libglib2.0-0 \
  libcups2 \
  libxcomposite1 \
  libxdamage1 \
  libxi6 \
  libxt6

# 安装 bun
RUN curl -fsSL https://bun.sh/install | bash

# 将 bun 可执行文件添加到 PATH 中
ENV PATH="/root/.bun/bin:$PATH"

# 验证 bun 是否成功安装
RUN bun --version

WORKDIR /app

# Cache packages installation
COPY package.json package.json
COPY bun.lock bun.lock

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