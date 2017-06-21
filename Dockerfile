FROM openresty/openresty:1.11.2.3-alpine-fat

ENV \
 SESSION_VERSION=2.15 \
 HTTP_VERSION=0.10 \
 OPENIDC_VERSION=1.3.0 \
 JWT_VERSION=0.1.9
RUN apk update
RUN luarocks install lua-resty-session ${SESSION_VERSION}
RUN luarocks install lua-resty-http ${HTTP_VERSION}
RUN apk add openssl openssl-dev git
RUN luarocks install lua-resty-openidc ${OPENIDC_VERSION}
RUN luarocks install lua-resty-jwt ${JWT_VERSION}
RUN mkdir -p /usr/local/openresty/nginx/conf/hostsites/ && \
 true
RUN apk del --purge git
RUN rm -R /usr/libexec/gcc
COPY nginx /usr/local/openresty/nginx/
