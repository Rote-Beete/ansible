FROM alpine:3.12 as builder

RUN set -eux \
	&& apk add --no-cache \
		cmd:pip3 \
		gcc \
		libffi-dev \
		musl-dev \
		openssl-dev

RUN set -eux \
    && pip3 install --no-cache-dir --no-compile ansible \
	&& find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

FROM alpine:3.11 as production
RUN set -eux \
	&& apk add --no-cache bash git python3 \
	&& find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf
COPY --from=builder /usr/lib/python3.8/site-packages/ /usr/lib/python3.8/site-packages/
COPY --from=builder /usr/bin/ansible-lint /usr/bin/ansible-lint
WORKDIR /data
ENTRYPOINT ["ansible-playbook"]