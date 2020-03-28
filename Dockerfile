FROM plugins/base:linux-amd64

LABEL maintainer="luoyong Wu <1228022817@qq.com>" \
  org.label-schema.name="Drone SCP" \
  org.label-schema.vendor="luoyong Wu" \
  org.label-schema.schema-version="1.0"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk add --no-cache ca-certificates && \
    apk add -U tzdata && \
    rm -rf /var/cache/apk/*

COPY drone-scp /bin/
COPY deploy.sh /
RUN chmod 777 /deploy.sh
ENTRYPOINT ["/bin/drone-scp"]
