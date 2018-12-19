local class = require("lib.class")
local ResourceCard = class()

local gfx = require("lib.gfx")
local sprites = require("assets.sprites")

function ResourceCard:init(type, x, y)
    self.type = type
    self.x = x or 0
    self.y = y or 0
end

function ResourceCard:draw(x, y)
    x, y = x or self.x, y or self.y

    local sprite = sprites.resources[self.type]
    local image, colors = sprite[1], sprite[2]

    love.graphics.setColor(colors.bg)
    love.graphics.rectangle("fill", x, y, 100, 175, 5, 5)

    love.graphics.setColor(colors.fg)
    gfx.renderLineSprite(image, x + 50, y + 175/2)

    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("line", x, y, 100, 175, 5, 5)
end

return ResourceCard
