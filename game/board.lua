local class = require("lib.class")
local Board = class()

local _ = require("lib.luascore")
local gfx = require("gfx")
local util = require("util")
local sprites = require("sprites")

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

    local index = 0
    local function indexer(v)
        index = index + 1
        return index, v
    end

    -- local locs = _.mapWithKey(self.shape, _.c(indexer, _.uncurry(_.c(_.partial(_.c, _, _.keys), _.c(_.curry(_.zip, 2), _.repeatVal)))))
    -- for i = 1, #locs do
    --     local locList = locs[i]
    --     for k, v in pairs(locList) do
    --         local vals = _.values(sprites.resources)
    --         gfx.renderResourceTile(_.sample(vals), v[1], v[2], 0, 0, 50)
    --     end
    -- end

    for i, seg in pairs(self.shape) do
        for j, v in pairs(seg) do
            local resource = seg[j]
            gfx.renderResourceTile(sprites.resources[resource], i, j, 0, 0, 50)
        end
    end

    gfx.drawHexMap(self.shape, 0, 0, nil, 0.9)
end

return Board
