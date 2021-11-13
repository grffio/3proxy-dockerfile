FROM alpine:3.14 as builder
ARG PROXY_VER="0.9.3"
WORKDIR /3proxy
RUN apk add --update alpine-sdk linux-headers bash curl && \
    curl -LO https://github.com/z3APA3A/3proxy/archive/${PROXY_VER}.tar.gz && \
    tar -xzf ${PROXY_VER}.tar.gz -C /3proxy --strip-components=1 && \
    make -f Makefile.Linux

FROM alpine:3.14
RUN apk add --update bind-tools tini && \
    rm -rf /var/cache/apk/*
COPY --from=builder /3proxy/bin/3proxy /usr/local/bin/
COPY 3proxy.conf /etc/3proxy/
COPY run.sh /usr/local/bin/
EXPOSE 1080/tcp
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["run.sh"]
