FROM alpine:3.10 as builder
ARG PROXY_VER="0.8.13"
WORKDIR /3proxy
RUN apk add --update alpine-sdk bash wget && \
    wget -q https://github.com/z3APA3A/3proxy/archive/${PROXY_VER}.tar.gz && \
    tar -xzf ${PROXY_VER}.tar.gz -C /3proxy --strip-components=1 && \
    make -f Makefile.Linux
FROM alpine:3.10
RUN apk add --update bind-tools tini
COPY --from=builder /3proxy/src/3proxy /usr/local/bin/
COPY 3proxy.conf /etc/3proxy/
COPY run.sh /usr/local/bin/
EXPOSE 1080/tcp
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["run.sh"]
