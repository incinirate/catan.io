local ffi = require("ffi")
local wsi = ffi.load("wsi")

ffi.cdef [[
void *connect_ws(const char *);

const char *poll_ws(void *);

void send_ws(void *, const char *);
]]

local ws = {}

function ws.connect(url)
  local t = {cdata = wsi.connect_ws(url)}
  return setmetatable(t, {__index = ws})
end

function ws:poll()
  local cstr = wsi.poll_ws(self.cdata)
  local response = ffi.string(cstr)
  if response == "none" then
    return false
  else
    return response
  end
end

function ws:send(message)
  wsi.send_ws(self.cdata, message)
end

return ws
