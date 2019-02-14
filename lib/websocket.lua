local ffi = require("ffi")
local wsi = ffi.load("wsi")

ffi.cdef [[
void *connect_ws(const char *);

const char *poll_ws(void *);

void send_ws(void *, const char *);

void destroy_ws(void *);
]]

local ws = {}

function ws.connect(url)
  local t = {cdata = wsi.connect_ws(url), gcdummy = newproxy(true), open = true}
  getmetatable(t.gcdummy).__gc = function()
    if open then
      ws.close(t)
    end
  end

  return setmetatable(t, {__index = ws})
end

function ws:poll()
  local cstr = wsi.poll_ws(self.cdata)
  local response = ffi.string(cstr)
  if response == "none" then
    return false
  elseif response == "disconnected" then
    return false
  else
    return response
  end
end

function ws:send(message)
  wsi.send_ws(self.cdata, message)
end

function ws:close()
  wsi.send_ws(self.cdata, "disconnect")
  wsi.destroy_ws(self.cdata)
  self.open = false
end

return ws
