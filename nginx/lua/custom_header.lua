


-- example for extracting values from the session
local function generate_internal_header(session_opts)
    local session = require("resty.session").open(session_opts)
    return session.data.user
end

