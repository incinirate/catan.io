local _ = require("lib.luascore")

local class = {}

function class.makeClass()
    local t = {}
    return setmetatable(t, {
        __call = function(t, ...)
            local this = setmetatable({}, {__index = t})
            this:init(...)
            return this
        end,
        __index = class
    })
end

function class:static(fnName, fnBody)
    self[fnName] = function(this, ...)
        -- error(this .. ", " .. (...))
        -- Make static
        if type(this) == "number" then
            return fnBody(this, ...)
        end

        return fnBody(...)
    end
end

return setmetatable(class, {
    __call = class.makeClass
})
