FROM ghcr.io/pnpm/pnpm:12 AS builder
RUN pnpm runtime set node 24 -g
WORKDIR /app
COPY . .
RUN --mount=type=cache,target=/pnpm/store,sharing=locked \
  pnpm config set store-dir /pnpm/store && \
  pnpm install --frozen-lockfile && \
  pnpm build

FROM busybox:stable
RUN adduser -D static
USER static
WORKDIR /home/static
COPY --from=builder /app/build .
CMD ["busybox", "httpd", "-f", "-p", "3000"]
