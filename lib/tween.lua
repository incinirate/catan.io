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

function Tween:sweep(tab, key, newValue, speed, threshold, delay)
    speed = speed or 5
    threshold = threshold or 0.1

    self:removeByKey(tab, key)

    local obj
    obj = {
        tab = tab,
        key = key,
        delay = delay,
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

function Tween:linear(tab, key, newValue, duration, delay)
    self:removeByKey(tab, key)

    local orig = tab[key]

    local obj
    obj = {
        tab = tab,
        key = key,
        delay = delay,
        updateFn = function(dt, time)
            local current = tab[key]
            if time - obj.start >= duration then
                self:stop(obj)
                return newValue
            else
                local t = time - obj.start
                local d = duration
                local b = orig
                local c = (newValue - orig)
                t = t / d
                return c*t + b
            end
        end
    }

    self.objects[#self.objects + 1] = obj
    return obj
end

function Tween:overshoot(tab, key, newValue, duration, amount, delay)
    self:removeByKey(tab, key)

    local orig = tab[key]

    local s = amount or 1.70158

    local obj
    obj = {
        tab = tab,
        key = key,
        delay = delay,
        updateFn = function(dt, time)
            local current = tab[key]
            if time - obj.start >= duration then
                self:stop(obj)
                return newValue
            else
                local t = time - obj.start
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
        if obj.delay and obj.delay > 0 then
            obj.delay = obj.delay - dt
            if obj.delay <= 0 then
                obj.start = os.clock()
            end
        elseif not obj.delay then
            obj.delay = 0
        end

        if obj.delay <= 0 then
            if not obj.start then
                obj.start = os.clock()
            end

            obj.tab[obj.key] = obj.updateFn(dt, time)
        end
    end
end

return Tween
