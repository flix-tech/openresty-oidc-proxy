

local escape_lua_pattern
do
    local matches =
    {
        ["^"] = "%^";
        ["$"] = "%$";
        ["("] = "%(";
        [")"] = "%)";
        ["%"] = "%%";
        ["."] = "%.";
        ["["] = "%[";
        ["]"] = "%]";
        ["*"] = "%*";
        ["+"] = "%+";
        ["-"] = "%-";
        ["?"] = "%?";
    }

    escape_lua_pattern = function(s)
        return (string.gsub(s, ".", matches))
    end
end

local function upstream_cookie(session_name)
    local cookies = ngx.req.get_headers()["Cookie"]
    local new_cookie = ""
    if cookies then
        local gsub = string.gsub
        new_cookie = gsub(cookies, escape_lua_pattern(session_name) .. "_?%d*=[^;]*;?", "")
        ngx.log(ngx.ERR, new_cookie)
    end
    return  new_cookie
end

return upstream_cookie(os.getenv("OID_SESSION_NAME"))