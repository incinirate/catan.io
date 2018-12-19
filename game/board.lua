local class = require("lib.class")
local Board = class()

local _ = require("lib.luascore")
local gfx = require("lib.gfx")
local util = require("lib.util")
local sprites = require("assets.sprites")

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

function Board:init(shape, resourcePool)
    self.shape = shape or defaultShape
    math.randomseed(os.time())

    local resourcePool = _.shuffle(resourcePool or defaultPool)

    for i, seg in pairs(self.shape) do
        for j, v in pairs(seg) do
            local resource = util.pop(resourcePool)
            
            seg[j] = resource
        end
    end
end

function Board:draw()
    love.graphics.setColor(util.rgb(255, 255, 255))
    gfx.drawHexMap(self.shape, 0, 0, nil, 1.1, "fill")

    for i, seg in pairs(self.shape) do
        for j, v in pairs(seg) do
            local resource = seg[j]
            gfx.renderResourceTile(sprites.resources[resource], i, j, 0, 0, 50)
        end
    end

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
