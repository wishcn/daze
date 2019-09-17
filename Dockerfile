FROM golang:1.13-alpine AS builder

RUN apk upgrade \
    && apk add git \
    && go get -u -v github.com/mohanson/daze/cmd/daze

FROM alpine:3.10 AS dist

ARG TZ="Asia/Shanghai"

ENV TZ ${TZ}

RUN apk upgrade --update \
    && apk add tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && rm -rf /var/cache/apk/*

COPY --from=builder /go/bin/daze /usr/bin/daze
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
