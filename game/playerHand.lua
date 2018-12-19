local class = require("lib.class")
local playerHand = class()

local Card = require("game.card")
local Tween = require("lib.tween")()

function playerHand:init(initialCards)
    self.cards = initialCards or {}
end

function playerHand:addCard(type)
    local card = Card(type, -10, 0)
    self.cards[#self.cards + 1] = card
    Tween:sweep(card, "x", 0, 5)
    Tween:overshoot(card, "y", -25, 1, 5)
end

function playerHand:draw()
    for i = #self.cards, 1, -1 do
        self.cards[i]:draw()
    end
end

function playerHand:update(dt)
    Tween:update(dt)
end

return playerHand
