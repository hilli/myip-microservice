FROM --platform=$BUILDPLATFORM golang:alpine as builder
ARG TARGETARCH
ARG TARGETOS
ENV GO111MODULE=on GOOS=$TARGOS GOARCH=$TARGETARCH
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