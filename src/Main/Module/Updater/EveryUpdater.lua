local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local EveryUpdater = {}
EveryUpdater.__index = EveryUpdater

function EveryUpdater:new()
    local self = setmetatable({}, EveryUpdater)
    self:_initKeybinds()
    return self
end

function EveryUpdater:_initKeybinds()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Equals then
            self:TeleportToSameServer()
        end
    end)
end

function EveryUpdater:TeleportToSameServer()
    local jobId = game.JobId
    local placeId = game.PlaceId
    print("[EveryUpdater] Teleporting to current server...")
    TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
end

return EveryUpdater
