local util = {}

function util.rgb(r, g, b)
    return {r / 255, g / 255, b / 255}
end

local floor, ceil = math.floor, math.ceil
function util.round(x)
    if x % 1 >= 0.5 then
        return ceil(x)
    else
        return floor(x)
    end
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

function util.publishPriority(namespace, levels, ...)
    namespace[#namespace + 1] = 0
    for i = 1, levels do
        namespace[#namespace] = i
        local result = glue:publish(namespace, ...)
        if #result > 0 then
            return result
        end
    end

    namespace[#namespace] = "low"
    return glue:publish(namespace, ...)
end

return util
