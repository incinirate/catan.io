local gfx = {}

function gfx.drawHexagon(x, y, scale)
    scale = scale or 1

    love.graphics.circle("line", x, y, scale * 50, 6)
end

return gfx