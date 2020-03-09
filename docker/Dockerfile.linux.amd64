FROM plugins/base:linux-amd64

LABEL maintainer="luoyong Wu <1228022817@qq.com>" \
  org.label-schema.name="Drone SCP" \
  org.label-schema.vendor="luoyong Wu" \
  org.label-schema.schema-version="1.0"

RUN apk add --no-cache ca-certificates && \
  rm -rf /var/cache/apk/*

COPY drone-scp /bin/
COPY autodeploy.sh /
RUN chmod 777 /autodeploy.sh
ENTRYPOINT ["/bin/drone-scp"]
