local glyphs = {}

local renderSize = 32
local renderHalf = renderSize / 2
local fontOffset = renderSize * 13/32

local oldFont = love.graphics.getFont()
local glyphFont = love.graphics.newFont("assets/fonts/BebasNeue Bold.ttf", renderSize * 3/4)

love.graphics.setFont(glyphFont)
love.graphics.setColor(1, 1, 1)

for i = 2, 12 do
    local canvas = love.graphics.newCanvas(renderSize, renderSize, {msaa = 8})
    love.graphics.setCanvas(canvas)

    -- love.graphics.setColor(1, 1, 1)
    -- love.graphics.circle("fill", renderHalf, renderHalf, renderHalf)

    local dX = (i == 10 or i == 12) and -renderSize/20 or 0
    love.graphics.printf(i, dX, renderHalf - fontOffset, renderSize, "center")

    love.graphics.setCanvas()

    glyphs[i] = canvas
end

glyphs.font = glyphFont

love.graphics.setFont(oldFont)

function glyphs.scaleTo(rad)
    return rad / renderHalf, rad / renderHalf
end

return glyphs
