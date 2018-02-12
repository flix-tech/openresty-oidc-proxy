FROM openresty/openresty:1.13.6.1-alpine

ENV \
 SESSION_VERSION=2.19 \
 HTTP_VERSION=0.12 \
 OPENIDC_VERSION=1.5.3 \
 JWT_VERSION=0.1.11

RUN \
 apk update && apk upgrade && apk add curl
RUN \
 cd /tmp && \
 curl -sSL https://github.com/bungle/lua-resty-session/archive/v${SESSION_VERSION}.tar.gz | tar xz && \
 curl -sSL https://github.com/pintsized/lua-resty-http/archive/v${HTTP_VERSION}.tar.gz | tar xz  && \
 curl -sSL https://github.com/zmartzone/lua-resty-openidc/archive/v${OPENIDC_VERSION}.tar.gz | tar xz && \
 curl -sSL https://github.com/SkyLothar/lua-resty-jwt/releases/download/v${JWT_VERSION}/lua-resty-jwt-${JWT_VERSION}.tar.gz | tar xz && \
 cp -r /tmp/lua-resty-session-${SESSION_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-http-${HTTP_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-openidc-${OPENIDC_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-jwt-${JWT_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 rm -rf /tmp/* && \
 true

COPY nginx /usr/local/openresty/nginx/
