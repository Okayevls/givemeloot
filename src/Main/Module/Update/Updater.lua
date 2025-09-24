local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local Updater = {}
Updater.__index = Updater

function Updater:new()
    local self = setmetatable({}, Updater)
    self:_initKeybind()
    return self
end

function Updater:_initKeybind()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Equals or input.KeyCode == Enum.KeyCode.KeypadEquals then
            self:TeleportToSameServer()
        end
    end)
end

function Updater:TeleportToSameServer()
    local player = Players.LocalPlayer
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    print("[Updater] 🔁 Перезаход на тот же сервер...")
end

return Updater
