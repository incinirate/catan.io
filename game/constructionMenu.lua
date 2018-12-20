local class = require("lib.class")
local constructionMenu = class()

local Tween = require("lib.tween")()

function constructionMenu:init()
    self.items = {{0},{0},{0},{0},{0}}
    self.myTransform = transform.currentTransform:clone()
    self.x, self.y = 0, 0
    self.open = false

    glue:subscribe({"input", "mouseMoved", 1}, function(x, y)
        x, y = self.myTransform:inverseTransformPoint(x, y)

        if (self.x - x)^2 + (self.y - y)^2 <= 25*25 then
            if not self.open then
                self.open = true
                for i = 1, #self.items do
                    Tween:overshoot(self.items[i], 1, 25, 0.5, 1.15, i * 0.05)
                end
            end
        elseif self.open then
            if (self.x - x)^2 >= 25*25 then
                self.open = false
                for i = 1, #self.items do
                    Tween:linear(self.items[i], 1, 0, 0.15, (#self.items - i) * 0.05)
                end
            end
        end
    end)
end

function constructionMenu:draw()
    local w, h = transform:getDimensions()
    self.myTransform = transform.currentTransform:clone()
    self.x, self.y = w - 50, h - 50

    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", w - 50, h - 50, 25)

    for i = 1, #self.items do
        love.graphics.circle("fill", w - 50, h - 75*i - 50, self.items[i][1])
    end
end

function constructionMenu:update(dt)
    Tween:update(dt)
end

return constructionMenu
