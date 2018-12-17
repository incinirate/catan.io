local gfx = require("gfx")
local _ = require("luascore")

local sprites = require("sprites")

function love.load()
end

local arr = {
    [-2] = {       [-1]=2,[0]=3,4  },
    [-1] = {[-2]=1,[-1]=2,[0]=3,4  },
    [ 0] = {[-2]=1,[-1]=2,[0]=3,4,5},
    [ 1] = {[-2]=1,[-1]=2,[0]=3,4  },
    [ 2] = {       [-1]=2,[0]=3,4  }
}

function love.draw()
    love.graphics.clear(0.0352941176, 0.517647059, 0.890196078)--0.454901961, 0.725490196, 1)

    local w, h = love.window.getMode()

    -- Tiles
    local tx, ty = gfx.screenToHex(love.mouse.getX(), love.mouse.getY(), w / 2, h / 2, 50)
    gfx.drawHexagonTC(tx, ty, w / 2, h / 2, 50, "fill", 0.5)

    -- Edges
    -- local tx, ty = gfx.screenToHex(love.mouse.getX(), love.mouse.getY(), w / 2, h / 2, 25)
    -- gfx.drawHexagonTC(tx, ty, w / 2, h / 2, 25, "fill", 0.9)
    
    -- Corners
    -- local mx, my = w / 2, h / 2 -- - math.cos(math.pi/3)*50, h/2
    -- local rad = 2*25/math.sqrt(3)--25*((2*math.sqrt(3) + 1)/4)
    -- local x, y = gfx.screenToHex(love.mouse.getY(), love.mouse.getX(), my, mx, rad)
    -- gfx.drawHexagonTCI(x, y, mx, my, rad, "fill")

    -- love.graphics.setColor(rgb(44, 44, 84)) -- Rock
    -- love.graphics.setColor(rgb(255, 121, 63)) -- Wheat
    -- love.graphics.setColor(rgb(179, 57, 57)) -- Brick
    -- love.graphics.setColor(rgb(23, 99, 82)) -- Wood
    -- love.graphics.setColor(rgb(0,0,0)) -- Wool
    -- gfx.drawHexagonTC(0, 0, w / 2, h / 2, nil, "fill", 0.9)
    
    -- -- Rock
    -- love.graphics.setColor(rgb(112, 111, 211))
    -- love.graphics.translate((w / 2), (h / 2))
    -- for i = 1, #rock do
    --     love.graphics.line(rock[i])
    -- end
    -- love.graphics.translate(-(w / 2), -(h / 2))
    -- love.graphics.setColor(1, 1, 1)

    -- -- Wheat
    -- love.graphics.setColor(rgb(255, 218, 121))
    -- love.graphics.translate((w / 2), (h / 2))
    -- for i = 1, #wheat do
    --     love.graphics.line(wheat[i])
    -- end
    -- love.graphics.translate(-(w / 2), -(h / 2))
    -- love.graphics.setColor(1, 1, 1)

    -- -- Brick
    -- love.graphics.setColor(rgb(255, 218, 121))
    -- love.graphics.translate((w / 2), (h / 2))
    -- for i = 1, #brick do
    --     love.graphics.line(brick[i])
    -- end
    -- love.graphics.translate(-(w / 2), -(h / 2))
    -- love.graphics.setColor(1, 1, 1)

    -- -- Wood
    -- love.graphics.setColor(rgb(43, 29, 14))
    -- love.graphics.translate((w / 2), (h / 2))
    -- for i = 1, #wood do
    --     love.graphics.line(wood[i])
    -- end
    -- love.graphics.translate(-(w / 2), -(h / 2))
    -- love.graphics.setColor(1, 1, 1)

    -- -- Wool
    -- love.graphics.setColor(rgb(255, 255, 255))
    -- love.graphics.translate((w / 2), (h / 2))
    -- for i = 1, #wool do
    --     love.graphics.line(wool[i])
    -- end
    -- love.graphics.translate(-(w / 2), -(h / 2))
    -- love.graphics.setColor(1, 1, 1)

    -- print(sprites)

    local index = 0
    local function indexer(v)
        index = index + 1
        return index, v
    end

    math.randomseed(563782)

    local locs = _.mapWithKey(arr, _.c(indexer, _.uncurry(_.c(_.partial(_.c, _, _.keys), _.c(_.curry(_.zip, 2), _.repeatVal)))))
    for i = 1, #locs do
        local locList = locs[i]
        for k, v in pairs(locList) do
            local vals = _.values(sprites.resources)
            gfx.renderResourceTile(_.sample(vals), v[1], v[2], w / 2, h / 2, 50)
        end
        
    end
    -- error(#locs)

    gfx.renderResourceTile(sprites.resources.rock, tx, ty, w / 2, h / 2, 50)

    gfx.drawHexMap(arr, w / 2, h / 2, nil, 0.9)
end
