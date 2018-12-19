local class = require("lib.class")
local Board = class()

local _ = require("lib.luascore")
local gfx = require("lib.gfx")
local util = require("lib.util")
local sprites = require("assets.sprites")

local rareGlyphs = require("assets.rareGlyphs")

local defaultShape = {
    [-2] = {        [-1]=2,[0]=3,4   },
    [-1] = { [-2]=1,[-1]=2,[0]=3,4   },
    [ 0] = { [-2]=1,[-1]=2,[0]=3,4,5 },
    [ 1] = { [-2]=1,[-1]=2,[0]=3,4   },
    [ 2] = {        [-1]=2,[0]=3,4   }
}

local defaultPool = util.mapData {
    rock = 3,
    wood = 4,
    wool = 4,
    brick = 3,
    wheat = 4,
    desert = 1 
}

local defaultRarities = util.mapData {
    [2] = 1,
    [3] = 2,
    [4] = 2,
    [5] = 2,
    [6] = 2,
    [8] = 2,
    [9] = 2,
    [10] = 2,
    [11] = 2,
    [12] = 1
}

function Board:init(shape, resourcePool, rarities)
    self.shape = shape or defaultShape

    local resourcePool = _.shuffle(resourcePool or defaultPool)
    local rarityPool = _.shuffle(rarities or defaultRarities)

    for i, seg in pairs(self.shape) do
        for j, v in pairs(seg) do
            local resource = util.pop(resourcePool)
            
            seg[j] = {resource}
            if resource ~= "desert" then
                seg[j][2] = util.pop(rarityPool)
            end
        end
    end
end

function Board:draw()
    love.graphics.setColor(util.rgb(255, 255, 255))
    gfx.drawHexMap(self.shape, 0, 0, nil, 1.1, "fill")

    for i, seg in pairs(self.shape) do
        for j, v in pairs(seg) do
            local resource = seg[j][1]
            gfx.renderResourceTile(sprites.resources[resource], i, j, 0, 0, 50)

            local dx, dy = gfx.hexToScreen(i, j, 0, 0, 50)
            local rarity = seg[j][2]
            if rarity then
                if rarity == 6 or rarity == 8 then
                    love.graphics.setColor(1, 0.9, 0.9, 0.8)
                else
                    love.graphics.setColor(1, 1, 1, 0.8)
                end
                -- love.graphics.circle("fill", dx, dy - 26, 10, 30)
                love.graphics.arc("fill",dx - math.cos(math.pi / 3)*50 + 2, dy - math.sin(math.pi / 3)*50 + 4, 20, 0, 2 * math.pi / 3)

                if rarity == 6 or rarity == 8 then
                    love.graphics.setColor(1, 0, 0)
                else
                    love.graphics.setColor(0, 0, 0)
                end
                love.graphics.draw(rareGlyphs[rarity], dx - math.cos(math.pi / 3)*50 - 2, dy - math.sin(math.pi / 3)*50 + 4, 0, rareGlyphs.scaleTo(10))
            end
        end
    end

    love.graphics.setColor(util.rgb(255, 255, 255))
    gfx.drawHexMap(self.shape, 0, 0, nil, 0.9)
end

--   /----1----\
--  2           3 
-- /             \
-- \             /
--  4           5
--   \----6----/
Board:static("getEdges", function(x, y)
    local x2 = 2*x
    local y2 = 2*y
    if x % 2 ~= 0 then
        y2 = y2 + 1
    end

    return {
        {x2    , y2 - 1},
        {x2 - 1, y2 - 1},
        {x2 + 1, y2 - 1},
        {x2 - 1, y2    },
        {x2 + 1, y2    },
        {x2    , y2 + 1}
    }
end)

--   2-----3
--  /       \
-- 1         4
--  \       /
--   6-----5
Board:static("getCorners", function(x, y)
    local x2 = 2*x
    local y2 = 2*y
    if x % 2 ~= 0 then
        y2 = y2 + 1
    end

    x2 = x2 - math.floor((x + 1)/2)

    return {
        {y2    , x2 - 1          },
        {y2 - 1, x2 - 1 + (x % 2)},
        {y2 - 1, x2     + (x % 2)},
        {y2    , x2 + 1          },
        {y2 + 1, x2 - 1 + (x % 2)},
        {y2 + 1, x2     + (x % 2)}
    }
end)

-- Returns the coordinates of the 2 tiles that share the given edge
Board:static("getEdgeTiles", function(x, y)
    if x % 2 == 0 then
        y = y + ((x + 2) % 4)/2

        return {
            {x / 2, y / 2},
            {x / 2, y / 2 - 1}
        }
    else
        local which = (x + ((y + (((x + 1) % 4) / 2)) % 2)) % 4
        if which == 0 then
            return {
                {(x - 1) / 2, (y - 1) / 2},
                {(x + 1) / 2, (y + 1) / 2}
            }
        elseif which == 1 then
            return {
                {(x - 1) / 2, (y + 1) / 2},
                {(x + 1) / 2, (y - 1) / 2}
            }
        else
            return {
                {(x - 1) / 2, y / 2},
                {(x + 1) / 2, y / 2}
            }
        end
    end
end)

Board:static("getCornerTiles", function(x,y)
    local x2 = x / 2
    local y23 = 2 * y / 3

    if (y % 3 == 2 and x % 2 == 0) then
        return {
            {y23 + 2/3, x2    },
            {y23 - 1/3, x2    },
            {y23 - 1/3, x2 - 1}
        }
    elseif (y % 3 == 0 and x % 2 == 1) then
        return {
            {y23 + 1, x2 - 1/2},
            {y23    , x2 - 1/2},
            {y23    , x2 + 1/2}
        }
    elseif (y % 3 == 2 and x % 2 == 1) then
        return {
            {y23 - 1/3, x2 - 1/2},
            {y23 + 2/3, x2 + 1/2},
            {y23 + 2/3, x2 - 1/2}
        }
    else
        return {
            {y23 - 2/3, x2    },
            {y23 + 1/3, x2    },
            {y23 + 1/3, x2 - 1}
        }
    end
end)

return Board
