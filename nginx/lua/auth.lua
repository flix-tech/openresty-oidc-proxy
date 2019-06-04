
function is_authenticated()
  local session = require("resty.session").start()

  -- if we have no id_token then redirect to the OP for authentication
  if not session.present or not (session.data.id_token or session.data.authenticated) then
    return false
  end
  return true
end


if not features then
    features = {}
    for f in string.gmatch(os.getenv("OID_FEATURES") or "", "[^,]+") do
        features[f] = true
    end
end

local opts = {
    redirect_uri_path = os.getenv("OID_REDIRECT_PATH"),
    discovery = os.getenv("OID_DISCOVERY"),
    client_id = os.getenv("OID_CLIENT_ID"),
    client_secret = os.getenv("OID_CLIENT_SECRET"),
    scope = "openid",
    iat_slack = 600,
    session_contents = features,
}

local function html_escape(s)
    if not s then return "" end
    return (string.gsub(s, "[}{\">/<'&]", {
        ["&"] = "&amp;",
        ["<"] = "&lt;",
        [">"] = "&gt;",
        ['"'] = "&quot;",
        ["'"] = "&#39;",
        ["/"] = "&#47;"
    }))
end

if not is_authenticated() and ngx.header.http_x_requested_with and string.lower(ngx.header.http_x_requested_with) == "xmlhttprequest" then
    ngx.status = 401
    ngx.header.content_type = 'text/html';
    ngx.say("Unauthenticated AJAX request. Please (re-)load the page to be authenticated.")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- call authenticate for OpenID Connect user authentication
local res, err, target_url, session = require("resty.openidc").authenticate(opts)

if err then
    ngx.status = 500
    ngx.header.content_type = 'text/html';

    ngx.say("There was an error while logging in: " .. html_escape(err) .. "<br><a href='" .. html_escape(target_url) .. "'>Please try again.</a>")
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

if features.user then
    if ngx.var.user_email then ngx.var.user_email = res.user.upn end
    if ngx.var.user_name then
      ngx.var.user_name = ( res.user.given_name and res.user.family_name )
        and string.lower( res.user.given_name .. '.' .. res.user.family_name )
        or res.user.upn
    end
end
