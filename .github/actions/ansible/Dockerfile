FROM alpine:3.12 as builder

RUN apk add ansible
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]