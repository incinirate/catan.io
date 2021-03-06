local gfx = {}

local segmentWidth = math.cos(math.pi / 3)
local segmentHeight = math.sin(math.pi / 3)
function gfx.drawHexagon(x, y, radius, mode)
    radius = radius or 50

    love.graphics.circle(mode or "line", math.floor(x), math.floor(y), radius, 6)
end

function gfx.drawHexagonI(x, y, radius, mode)
    radius = radius or 50

    love.graphics.arc(mode or "line", "closed", math.floor(x), math.floor(y), radius, math.pi / 2, 13*math.pi/6, 5)
end

function gfx.drawHexagonTC(x, y, mx, my, radius, mode, fillPct)
    radius = radius or 50

    gfx.drawHexagon(mx + radius*(3*segmentWidth)*x, my + radius*segmentHeight*(y*2 + x%2), radius*fillPct, mode)
end

function gfx.drawHexagonTCI(x, y, mx, my, radius, mode)
    radius = radius or 50
    
    gfx.drawHexagonI(mx + radius*segmentHeight*(y*2 + x%2), my + radius*(3*segmentWidth)*x, radius, mode)
end

function gfx.drawHexMap(map, x, y, radius, fillPct, mode)
    radius = radius or 50
    fillPct = fillPct or 1
    x = x or 0
    y = y or 0

    for i, col in pairs(map) do
        for j, tile in pairs(col) do
            -- gfx.drawHexagon(x + radius*(3*segmentWidth)*i, y + radius*segmentHeight*(j*2 + i%2), radius)
            gfx.drawHexagonTC(i, j, x, y, radius, mode, fillPct)
        end
    end
end

function gfx.renderResourceTile(sprite, x, y, mx, my, radius)
    local dx, dy = mx + radius*(3*segmentWidth)*x, my + radius*segmentHeight*(y*2 + x%2)

    local image, colors = sprite[1], sprite[2]

    love.graphics.setColor(unpack(colors.bg))
    gfx.drawHexagonTC(0, 0, dx, dy, nil, "fill", 0.85)--0.95)

    love.graphics.setColor(unpack(colors.fg))
    gfx.renderLineSprite(image, dx, dy)
    love.graphics.setColor(1, 1, 1)
end

function gfx.renderLineSprite(sprite, x, y)
    transform:push()
    transform:translate(x, y)
    
    for i = 1, #sprite do
        love.graphics.line(sprite[i])
    end

    transform:pop()
end

function gfx.hexToScreen(x, y, mx, my, radius)
    return mx + radius*(3*segmentWidth)*x, my + radius*segmentHeight*(y*2 + x%2)
end

function gfx.screenToHex(x, y, mx, my, radius)
    radius = radius or 50
    x = x - mx
    y = y - my

    local hexHeight = radius*segmentHeight
    local yroll = math.abs(((y + hexHeight) % (hexHeight*2)) - hexHeight) / hexHeight

    local double = 2*(radius*(2 - segmentWidth))

    x = x + radius
    local xBase = math.floor((x - yroll*segmentWidth*radius) / double)
    local xOver = (x - yroll*segmentWidth*radius) % double

    local xPos = 2*xBase + (xOver > (radius*2 - 2*segmentWidth*radius*yroll) and 1 or 0)

    if xPos % 2 == 0 then
        y = y + radius*segmentHeight
    end
    local yPos = math.floor(y / (2*radius*segmentHeight))

    return xPos, yPos
end

return gfx
