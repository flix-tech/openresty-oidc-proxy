local opts = {
    redirect_uri_path = os.getenv("OID_REDIRECT_PATH"),
    discovery = os.getenv("OID_DISCOVERY"),
    client_id = os.getenv("OID_CLIENT_ID"),
    client_secret = os.getenv("OID_CLIENT_SECRET"),
    scope = "openid",
    iat_slack = 600,
}

-- call authenticate for OpenID Connect user authentication
local res, err = require("resty.openidc").authenticate(opts)

if err then
    ngx.status = 500
    ngx.header.content_type = 'text/html';

    ngx.say("There was an error while logging in: " .. err .. "<br><a href='" .. url .. "'>Please try again.</a>")
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end
