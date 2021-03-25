FROM --platform=$BUILDPLATFORM golang:1.16.2-buster as builder
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
LABEL org.opencontainers.image.source http://github.com/hilli/myip-microservice
COPY --from=builder /ipservice/ipservice .
ENTRYPOINT ["/ipservice"]
EXPOSE 8080