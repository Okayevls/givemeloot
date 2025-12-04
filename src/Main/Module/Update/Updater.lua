local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local COREGUI = game:GetService("CoreGui")

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

    local Dir = COREGUI:FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay")
    Dir.DescendantAdded:Connect(function(Err)
        if Err.Name == "ErrorTitle" then
            Err:GetPropertyChangedSignal("Text"):Connect(function()
                if Err.Text:sub(0, 12) == "Disconnected" then
                    if #Players:GetPlayers() <= 1 then
                        Players.LocalPlayer:Kick("\nRejoining...")
                        wait()
                        TeleportService:Teleport(PlaceId, Players.LocalPlayer)
                    else
                        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
                    end
                end
            end)
        end
    end)
    print("[Updater] 🔁 Rejoin to the same server...")
end

return Updater
