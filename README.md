# 3proxy-dockerfile
Dockerfile for "3proxy" SOCKS5 proxy server on Alpine Linux for Telegram

Build
-----
```
$ docker build -t grffio/3proxy .
```
- Supported Args: `PROXY_VER=0.8.12`

Quick Start
-----------
```
$ docker run --name 3proxy -d -p 1080:1080 -e PROXY_SECRET="user:P@SSw0rd" grffio/3proxy
```
- Supported Environment variables:
  - `PROXY_MAXCONN` - Maximum number of simultaneous connections (default: 32)
  - `PROXY_SECRET` - Login and password for proxy user, format: user1:pass1,user2:pass2 (desirable)

- Exposed Ports:
  - 1080/tcp
