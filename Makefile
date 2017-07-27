NAME = devops/openresty-oauth-proxy
REGISTRY = registry.example.com
VERSION=1.11.2.4-r2
TAG = $(REGISTRY)/$(NAME):$(VERSION)

default: build

	docker run -d --name=elegant_lewin --rm emilevauge/whoami || true
	docker run -it --rm \
	    --env-file=$$(pwd)/env \
	    -e PROXY_HOST=$$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' elegant_lewin) \
	    --link=elegant_lewin \
	    -v $$(pwd)/../lua-resty-openidc/lib/resty/openidc.lua:/usr/local/openresty/lualib/resty/openidc.lua \
	    -v $$(pwd)/nginx/lua/auth.lua:/usr/local/openresty/nginx/lua/auth.lua \
	    -p 22820:80 $(TAG)


bash: build
	docker run -it --entrypoint="/bin/sh" $(TAG)

build:
	docker build -t $(TAG) .

