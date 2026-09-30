FROM rust:1 AS builder
WORKDIR /build
COPY . .
RUN --mount=type=cache,target=/usr/local/cargo/registry,sharing=locked \
  --mount=type=cache,target=/build/target,sharing=locked \
  cargo build --release && \
  PACKAGE_NAME=$(grep -m1 '^name' Cargo.toml | sed -E 's/name = "(.*)"/\1/') && \
  cp target/release/$PACKAGE_NAME app

FROM gcr.io/distroless/cc-debian13
WORKDIR /runtime
COPY --from=builder /build/app .
EXPOSE 3000
CMD ["./app"]
