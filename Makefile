NAME = devops/openresty-oauth-proxy
REGISTRY = registry.example.com
VERSION=1.11.2.2-r7
TAG = $(REGISTRY)/$(NAME):$(VERSION)

default: build

	docker run -d --name=elegant_lewin --rm emilevauge/whoami || true
	docker run -it --rm -e OID_SESSION_SECRET=$$OID_SESSION_SECRET \
	      -e OID_SESSION_CHECK_SSI=$$OID_SESSION_CHECK_SSI \
	      -e OID_SESSION_NAME=$$OID_SESSION_NAME \
	      -e OID_DISCOVERY=$$OID_DISCOVERY \
	      -e OID_CLIENT_ID=$$OID_CLIENT_ID \
	      -e OID_CLIENT_SECRET=$$OID_CLIENT_SECRET \
	      -e OID_SESSION_ID_TOKEN=$$OID_SESSION_ID_TOKEN \
 	      -e OID_SESSION_ACCESS_TOKEN_EXPIRATION=$$OID_SESSION_ACCESS_TOKEN_EXPIRATION \
	      -e OID_REDIRECT_PATH=$$OID_REDIRECT_PATH \
        -e PROXY_HOST=$$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' elegant_lewin) \
        -e PROXY_PORT=80 \
        -e PROXY_PROTOCOL=http \
        --link=elegant_lewin \
        -v $$(pwd)/../lua-resty-openidc/lib/resty/openidc.lua:/usr/local/openresty/lualib/resty/openidc.lua \
        -v $$(pwd)/nginx/lua/auth.lua:/usr/local/openresty/nginx/lua/auth.lua \
        -p 22820:80 $(TAG)


bash: build
	docker run -it --entrypoint="/bin/sh" $(TAG)

build:
	docker build -t $(TAG) .

