local class = require("lib.class")
local playerHand = class()

local _ = require("lib.luascore")
local Card = require("game.card")
local Tween = require("lib.tween")()

function playerHand:init(initialCards)
    self.cards = initialCards or {}

    self.open = false

    glue:subscribe({"input", "mousePressed", 9}, function(x, y)
        if self.x <= x and x < self.x2 then
            if self.y2 <= y and y < self.y then
                if not self.open then
                    self.open = true

                    for i = 1, #self.cards do
                        local card = self.cards[i]
                        Tween:sweep(card, "x", (i - 1) * 40, 12)
                        Tween:sweep(card, "y", -200, 10)
                    end

                    return true
                end
            end
        end

        if self.open then
            self.open = false

            for i = 1, #self.cards do
                local card = self.cards[i]
                Tween:sweep(card, "x", 0, 15)
                Tween:sweep(card, "y", -25, 8 - i*(2/(#self.cards)))
            end

            return true
        end
    end)
end

function playerHand:addCard(type)
    local card = Card(type, -10, 0)
    local index = 1
    while index <= #self.cards and type >= self.cards[index].type do
        index = index + 1
    end
    table.insert(self.cards, index, card)
    Tween:sweep(card, "x", 0, 5)
    Tween:overshoot(card, "y", -25, 1, 5)
end

function playerHand:draw()
    self.x, self.y = love.graphics.transformPoint(0, 0)
    self.x2, self.y2 = love.graphics.transformPoint(100, -25)

    for i = #self.cards, 1, -1 do
        self.cards[i]:draw()
    end
end

function playerHand:update(dt)
    Tween:update(dt)
end

return playerHand
