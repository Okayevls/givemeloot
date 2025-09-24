local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local Updater = {}
Updater.__index = Updater

function Updater:TeleportToSameServer()
    local player = Players.LocalPlayer
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    print("[Updater] 🔁 Перезаход на тот же сервер...")
end

return Updater
