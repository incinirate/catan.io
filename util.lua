local util = {}

function util.rgb(r, g, b)
    return {r / 255, g / 255, b / 255}
end

function util.mapData(tab)
    local out = {}
    for k, v in pairs(tab) do
        for i = 1, v do
            out[#out + 1] = k
        end
    end

    return out
end

function util.pop(tab)
    local v = tab[#tab]
    tab[#tab] = nil
    return v
end

return util
