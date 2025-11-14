local Speed = {}
Speed.__index = Speed

Speed.Enabled = false
Speed.SpeedMultiplier = 50

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local character, hum, hrp
local player = Players.LocalPlayer

local connection

local function setupCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    hum = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
end
setupCharacter()

player.CharacterAdded:Connect(setupCharacter)

connection = RunService.Heartbeat:Connect(function()
    if Speed.Enabled then
        local dir = hum.MoveDirection
        if dir.Magnitude > 0 then
            hrp.Velocity = Vector3.new(
                    dir.X * Speed.SpeedMultiplier,
                    hrp.Velocity.Y * 0.9,
                    dir.Z * Speed.SpeedMultiplier
            )
        end
    end
end)

function Speed:Enable()
    if self.Enabled then return end
    self.Enabled = true
end

function Speed:Disable()
    self.Enabled = false
end

function Speed:drawModule(MainTab)
    local Folder = MainTab.Folder("Speed", "[Info] Acceleration of player movement")

    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            self:Enable()
        else
            self:Disable()
        end
    end)

    Folder.Slider("Boost Multiple", { Min = 10, Max = 500, Default = 50, Step = 0.1 }, function(value)
         self.SpeedMultiplier = value
    end)

    return self
end

return Speed
