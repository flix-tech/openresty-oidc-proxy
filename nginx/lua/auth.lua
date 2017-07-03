
local opts = {
redirect_uri_path = os.getenv("OID_REDIRECT_PATH"),
discovery = os.getenv("OID_DISCOVERY"),
client_id = os.getenv("OID_CLIENT_ID"),
client_secret = os.getenv("OID_CLIENT_SECRET"),
session_user = os.getenv("OID_SESSION_USER") or false,
session_id_token = os.getenv("OID_SESSION_ID_TOKEN") or false,
session_enc_id_token = os.getenv("OID_SESSION_ENC_ID_TOKEN") or false,
session_refresh_token = os.getenv("OID_SESSION_REFRESH_TOKEN") or false,
session_whitelist_vars = os.getenv("OID_SESSION_WHITELIST_VARS") or false,
scope = "openid",
iat_slack = 600,
}

-- call authenticate for OpenID Connect user authentication
local res, err = require("resty.openidc").authenticate(opts)

local function html_escape(s)
return (string.gsub(s, "[}{\">/<'&]", {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&#39;",
    ["/"] = "&#47;"
}))
end

if err then
    ngx.status = 500
    ngx.header.content_type = 'text/html';
    ngx.log(ngx.ERR,err)
    ngx.say("There was an error while logging in: " .. html_escape(err) .. "<br><a href='" .. html_escape(ngx.var.uri) .. "'>Please try again.</a>")
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end
