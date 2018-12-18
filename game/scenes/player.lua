local class = require("lib.class")
local Player = class()

local gfx = require("gfx")
local Board = require("game.board")

function Player:init(shape, resourcePool)
    self.board = Board(shape, resourcePool)
    self.zoom = 1
    self.targetZoom = 1
    self.translate = {0, 0}
    self.translateTarget = {0, 0}
end

function Player:draw()
    local w, h = love.window.getMode()
    local mx, my = love.mouse.getPosition()

    local ow, oh = w, h

    self.targetZoom = math.min(w, h) / 600
    self.translateTarget = {0.2*(w/2 - mx), 0.2*(h/2 - my)}

    love.graphics.push()
    love.graphics.scale(self.zoom, self.zoom)
    w, h = w/self.zoom, h/self.zoom

    love.graphics.translate(w / 2 + self.translate[1]/self.zoom, h / 2 + self.translate[2]/self.zoom)
    
    do
        self.board:draw()

        -- local bx, by = (mx / self.zoom) - (w / 2 + self.translate[1]/self.zoom),
        --                 (my / self.zoom) - (h / 2 + self.translate[2]/self.zoom)

        local bx, by = love.graphics.inverseTransformPoint(mx, my)

-- fx = x*s + t
-- x = (fx - t)/s

-- fx = (x + t)*s
-- x = fx/s - t

        -- Tiles
        local tx, ty = gfx.screenToHex(bx, by, 0, 0, 25)
        if (tx + 2*(ty % 2)) % 4 ~= 0 then
            love.graphics.setColor(1, 1, 1, 0.5)
            gfx.drawHexagonTC(tx, ty, 0, 0, 25, "fill", 1)
        end

        love.graphics.print(tx .. ", " .. ty, love.graphics.inverseTransformPoint(0, 0))

        -- Edges
        -- local tx, ty = gfx.screenToHex(love.mouse.getX(), love.mouse.getY(), w / 2, h / 2, 25)
        -- gfx.drawHexagonTC(tx, ty, w / 2, h / 2, 25, "fill", 0.9)
        
        -- Corners
        -- local mx, my = w / 2, h / 2 -- - math.cos(math.pi/3)*50, h/2
        -- local rad = 2*25/math.sqrt(3)--25*((2*math.sqrt(3) + 1)/4)
        -- local x, y = gfx.screenToHex(love.mouse.getY(), love.mouse.getX(), my, mx, rad)
        -- gfx.drawHexagonTCI(x, y, mx, my, rad, "fill")
    end

    love.graphics.pop()
end

function Player:update(dt)
    self.zoom = self.zoom + (self.targetZoom - self.zoom)*5*dt
    self.translate[1] = self.translate[1] + (self.translateTarget[1] - self.translate[1])*5*dt
    self.translate[2] = self.translate[2] + (self.translateTarget[2] - self.translate[2])*5*dt
end

return Player
