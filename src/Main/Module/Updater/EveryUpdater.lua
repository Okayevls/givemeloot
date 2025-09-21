local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local EveryUpdater = {}
EveryUpdater.__index = EveryUpdater

EveryUpdater.get = {}

function EveryUpdater.get.new()
    local self = setmetatable({}, EveryUpdater)
    self:_initKeybinds()
    return self
end

function EveryUpdater.get._initKeybinds()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Equals then
            self.get.TeleportToSameServer()
        end
    end)
end

function EveryUpdater.get.TeleportToSameServer()
    local jobId = game.JobId
    local placeId = game.PlaceId
    print("[EveryUpdater] Teleporting to current server...")
    TeleportService.get.TeleportToPlaceInstance(placeId, jobId, player)
end

