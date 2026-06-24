FROM --platform=$BUILDPLATFORM golang:1.26.4-bookworm AS builder
ARG TARGETARCH
ARG TARGETOS
ENV GO111MODULE=on GOOS=$TARGETOS GOARCH=$TARGETARCH
WORKDIR /ipservice
COPY . /ipservice
RUN CGO_ENABLED=0 \
  go build -a -tags netgo \
  -ldflags '-w -extldflags "-static"' \
  -o ipservice

FROM scratch
LABEL org.opencontainers.image.source=https://github.com/hilli/myip-microservice
LABEL maintainer="hilli@github.com"
COPY --from=builder /ipservice/ipservice .
ENTRYPOINT ["/ipservice"]
EXPOSE 8080
