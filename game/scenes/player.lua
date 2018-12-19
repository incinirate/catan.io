local class = require("lib.class")
local Player = class()

local _ = require("lib.luascore")
local gfx = require("lib.gfx")
local Board = require("game.board")
local GameState = require("game.gameState")

local vignetteShader = love.graphics.newShader(love.filesystem.read("assets/shaders/vignette.glsl"))
local refreshCanvas, pCanvas = _.partial(love.graphics.newCanvas, w, h, {msaa = 8})
do
    local w, h = love.window.getMode()
    pCanvas = refreshCanvas()
end

function Player:init(shape, resourcePool)
    self.state = GameState(shape, resourcePool)
    self.zoom = 1
    self.targetZoom = 1
    self.translate = {0, 0}
    self.translateTarget = {0, 0}
end

function Player:draw()
    local w, h = love.window.getMode()
    local mx, my = love.mouse.getPosition()

    if pCanvas:getWidth() ~= w or pCanvas:getHeight() ~= h then
        pCanvas = refreshCanvas()
    end

    local ow, oh = w, h

    self.targetZoom = math.min(w, h) / 600
    self.translateTarget = {0.2*(w/2 - mx), 0.2*(h/2 - my)}

    love.graphics.setCanvas(pCanvas)

    love.graphics.clear(0.0352941176, 0.517647059, 0.890196078)
    love.graphics.setColor(0.0352941176, 0.517647059, 0.890196078)
    love.graphics.rectangle("fill", 0, 0, w, h)

    love.graphics.push()
    love.graphics.scale(self.zoom, self.zoom)
    w, h = w/self.zoom, h/self.zoom

    love.graphics.translate(w / 2 + self.translate[1]/self.zoom, h / 2 + self.translate[2]/self.zoom)
    
    do
        self.state.board:draw()

        local bx, by = love.graphics.inverseTransformPoint(mx, my)

        -- Tiles
        if false then
            do
                local tx, ty = gfx.screenToHex(bx, by, 0, 0, 50)
                love.graphics.print(tx .. ", " .. ty, love.graphics.inverseTransformPoint(0, 0))
                love.graphics.setColor(1, 1, 1, 0.5)
                gfx.drawHexagonTC(tx, ty, 0, 0, 50, "fill", 1)
                love.graphics.setColor(1, 1, 1, 1)

                -- local edges = Board.getEdges(tx, ty)
                -- for i = 1, #edges do
                --     local ex, ey = edges[i][1], edges[i][2]
                --     gfx.drawHexagonTC(ex, ey, 0, 0, 25, "fill", 1)
                -- end

                -- local corners = Board.getCorners(tx, ty)
                -- for i = 1, #corners do
                --     local ex, ey = corners[i][1], corners[i][2]
                --     local rad = 2*25/math.sqrt(3)
                --     gfx.drawHexagonTCI(ex, ey, 0, 0, rad, "fill")
                -- end
            end
        end

        if false then
            -- Edges
            do
                local tx, ty = gfx.screenToHex(bx, by, 0, 0, 25)
                love.graphics.print(tx .. ", " .. ty, love.graphics.inverseTransformPoint(0, 20))
                if (tx + 2*(ty % 2)) % 4 ~= 0 then
                    love.graphics.setColor(1, 1, 1, 0.5)
                    gfx.drawHexagonTC(tx, ty, 0, 0, 25, "fill", 1)

                    local tiles = Board.getEdgeTiles(tx, ty)
                    for i = 1, #tiles do
                        local ex, ey = tiles[i][1], tiles[i][2]
                        gfx.drawHexagonTC(ex, ey, 0, 0, 50, "fill", 1)
                    end
                end
                love.graphics.setColor(1, 1, 1, 1)
            end
        end    
        
        if true then
            -- Corners
            do
                local rad = 2*25/math.sqrt(3)
                local tx, ty = gfx.screenToHex(by, bx, 0, 0, rad)
                love.graphics.print(ty .. ", " .. tx, love.graphics.inverseTransformPoint(0, 40))
                if ((ty + 1) % 3 == 0) or ((tx + (ty % 3 - 1)) % 2 == 0) then
                    love.graphics.setColor(1, 1, 1, 0.5)
                    gfx.drawHexagonTCI(tx, ty, 0, 0, rad, "fill")

                    local tiles = Board.getCornerTiles(tx, ty)
                    for i = 1, #tiles do
                        local ex, ey = tiles[i][1], tiles[i][2]
                        gfx.drawHexagonTC(ex, ey, 0, 0, 50, "fill", 1)
                    end
                end
                love.graphics.setColor(1, 1, 1, 1)
            end
        end
    end

    love.graphics.pop()

    love.graphics.setCanvas()


    love.graphics.setShader(vignetteShader)
    vignetteShader:send("resolution", {ow, oh})
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(pCanvas)
    love.graphics.setShader()
end

function Player:update(dt)
    self.zoom = self.zoom + (self.targetZoom - self.zoom)*5*dt
    self.translate[1] = self.translate[1] + (self.translateTarget[1] - self.translate[1])*5*dt
    self.translate[2] = self.translate[2] + (self.translateTarget[2] - self.translate[2])*5*dt
end

return Player
