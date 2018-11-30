local gfx = require "gfx"

local amtx = math.cos(math.pi / 3)
local amty = math.sin(math.pi / 3)

function love.load()
    love.window.setMode(600,480)
end

local arr = {{1,2,3}, {1,2,3,4},{[0]=0,1,2,3,4}, {1,2,3,4}, {1,2,3}}

function love.draw()
    for i = 1, #arr do
        for k, v in pairs(arr[i]) do
            gfx.drawHexagon(50*3*amtx*i, 50*amty*(k*2 + i%2), 1)
        end
        -- gfx.drawHexagon(100 + 50*3*amtx, 100 + 50*amty, 1)
    end
end