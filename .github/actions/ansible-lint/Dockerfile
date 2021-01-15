
FROM alpine 

RUN apk add ansible-lint
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]