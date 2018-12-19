local class = require("lib.class")
local GameState = class()

local Board = require("game.board")

function GameState:init(shape, resourcePool)
    self.board = Board(shape, resourcePool)
end

return GameState
