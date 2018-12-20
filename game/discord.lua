local class = require("lib.class")
local DiscordPresence = class()

local discordRPC = require("lib.discordRPC")
local discordAppID = require("assets.discordAppKey")

function DiscordPresence:init()
    discordRPC.initialize(discordAppID, true)
    local now = os.time(os.date("*t"))

    self.presence = {
        state = "In Game",
        details = "Playing Classic",
        largeImageKey = "classic",
        largeImageText = "Classic", 
        startTimestamp = now,
        partyId = "ae488379-351d-4a4f-ad32-2b9b01c91657",
        partySize = 2,
        partyMax = 6
    }

    self.lastUpdate = os.clock()
    self.dirty = true
end

function DiscordPresence:update(dt)
    if self.lastUpdate + 2 < os.clock() then
        if self.dirty then
            self.dirty = false
            discordRPC.updatePresence(self.presence)
        end

        self.nextUpdate = os.clock()
    end

    discordRPC.runCallbacks()
end

function DiscordPresence:shutdown()
    discordRPC.shutdown()
end

function discordRPC.ready(userId, username, discriminator, avatar)
    print(string.format("Discord: ready (%s, %s, %s, %s)", userId, username, discriminator, avatar))
end

function discordRPC.disconnected(errorCode, message)
    print(string.format("Discord: disconnected (%d: %s)", errorCode, message))
end

function discordRPC.errored(errorCode, message)
    print(string.format("Discord: error (%d: %s)", errorCode, message))
end

function discordRPC.joinGame(joinSecret)
    print(string.format("Discord: join (%s)", joinSecret))
end

function discordRPC.spectateGame(spectateSecret)
    print(string.format("Discord: spectate (%s)", spectateSecret))
end

function discordRPC.joinRequest(userId, username, discriminator, avatar)
    print(string.format("Discord: join request (%s, %s, %s, %s)", userId, username, discriminator, avatar))
    discordRPC.respond(userId, "yes")
end

return DiscordPresence
