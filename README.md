# Usage
You can pull it from: https://hub.docker.com/r/flixtech/openresty-oidc-proxy/

You need to configure your credentials and upstream identity provider by providing a `env`.
`env.dist` can serve as a reference.
Don't forget to also set `PROXY_PASS=http://127.0.0.1:8000`.
The openresty is listening by default on port 80.

# Testing
There is a development environment baked in that can be used by running make:

    make
    
The authentication proxy should now be accessible at `:22820`
