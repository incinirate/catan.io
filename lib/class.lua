local _ = require("lib.luascore")

return function()
    local t = {}
    return setmetatable(t, {
        __call = function(t, ...)
            local this = setmetatable({}, {__index = t})
            this:init(...)
            return this
        end
    })
end
