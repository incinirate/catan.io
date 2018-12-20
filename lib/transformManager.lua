local class = require("lib.class")
local transformManager = class()

function transformManager:init()
    self.currentTransform = love.math.newTransform()
    self.stack = {}
end

function transformManager:apply()
    love.graphics.replaceTransform(self.currentTransform)
end

function transformManager:push()
    self.stack[#self.stack + 1] = self.currentTransform:clone()
end

function transformManager:pop()
    self.currentTransform = table.remove(self.stack)
    self:apply()
end

function transformManager:translate(x, y)
    self.currentTransform:translate(x, y)
    self:apply()
end

function transformManager:scale(sx, sy)
    self.currentTransform:scale(sx, sy)
    self:apply()
end

function transformManager:doWithoutTransform(func, ...)
    self:push()
    self:reset()

    func(...)

    self:pop()
end

local identityTransform = love.math.newTransform()
function transformManager:reset()
    self.currentTransform = identityTransform
    self:apply()
end

function transformManager:getDimensions()
    return self.currentTransform:inverseTransformPoint(love.window.getMode())
end

function transformManager:getWidth()
    return (self:getDimensions())
end

function transformManager:getHeight()
    local _, h = self:getDimensions()
    return h
end

return transformManager
