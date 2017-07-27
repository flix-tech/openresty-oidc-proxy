local opts = {
    redirect_uri_path = os.getenv("OID_REDIRECT_PATH"),
    discovery = os.getenv("OID_DISCOVERY"),
    client_id = os.getenv("OID_CLIENT_ID"),
    client_secret = os.getenv("OID_CLIENT_SECRET"),
    scope = "openid",
    iat_slack = 600,
}

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

-- call authenticate for OpenID Connect user authentication
local res, err = require("resty.openidc").authenticate(opts)

if err then
    ngx.status = 500
    ngx.header.content_type = 'text/html';

    ngx.say("There was an error while logging in: " .. html_escape(err) .. "<br><a href='" .. html_escape(url) .. "'>Please try again.</a>")
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

ngx.var.user_email = session.data.user.upn
ngx.var.user_name = string.lower(session.data.user.given_name .. '.' .. session.data.user.family_name)
