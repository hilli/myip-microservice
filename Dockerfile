FROM golang:1.15.6-buster as builder
ENV GO111MODULE=on
WORKDIR /ipservice
COPY . /ipservice
RUN CGO_ENABLED=0 GOOS=linux ARCH=amd64 \
  go build -a -tags netgo \
  -ldflags '-w -extldflags "-static"' \
  -o ipservice

FROM scratch
LABEL org.opencontainers.image.source http://github.com/hilli/myip-microservice
COPY --from=builder /ipservice/ipservice .
ENTRYPOINT ["/ipservice"]