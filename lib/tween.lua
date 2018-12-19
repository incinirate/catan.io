local class = require("lib.class")
local Tween = class()

local abs = math.abs

function Tween:init()
    self.objects = {}
end

function Tween:removeByKey(tab, key)
    for i = 1, #self.objects do
        local obj = self.objects[i]
        if obj.tab == tab and obj.key == key then
            table.remove(self.objects, i)
            return
        end
    end
end

function Tween:sweep(tab, key, newValue, speed, threshold)
    speed = speed or 5
    threshold = threshold or 0.1

    self:removeByKey(tab, key)

    local obj
    obj = {
        tab = tab,
        key = key,
        updateFn = function(dt)
            local current = tab[key]
            if abs(newValue - current) <= threshold then
                self:stop(obj)
                return newValue
            else
                return current + (newValue - current)*speed*dt
            end
        end
    }

    self.objects[#self.objects + 1] = obj
    return obj
end

function Tween:overshoot(tab, key, newValue, duration, amount)
    self:removeByKey(tab, key)

    local start = os.clock()
    local orig = tab[key]

    local s = amount or 1.70158

    local obj
    obj = {
        tab = tab,
        key = key,
        updateFn = function(dt, time)
            local current = tab[key]
            if time - start >= duration then
                self:stop(obj)
                return newValue
            else
                local t = time - start
                local d = duration
                local b = orig
                local c = (newValue - orig)
                t = t / d - 1
                return c*(t*t*((s+1)*t + s) + 1) + b
            end
        end
    }

    self.objects[#self.objects + 1] = obj
    return obj
end

function Tween:stop(obj)
    for i = 1, #self.objects do
        if self.objects[i] == obj then
            table.remove(self.objects, i)
            return
        end
    end
end

function Tween:update(dt)
    local time = os.clock()
    for i = #self.objects, 1, -1 do
        local obj = self.objects[i]
        obj.tab[obj.key] = obj.updateFn(dt, time)
    end
end

return Tween
