local Speed = {}
Speed.__index = Speed

Speed.type = {}

Speed.Enabled = false
Speed.SpeedMultiplier = 2

local RunService = game:GetService("RunService")
local BV
function Speed:Enable()
    if self.Enabled then return end
    self.Enabled = true

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")

    if not BV then
        BV = Instance.new("BodyVelocity")
        BV.MaxForce = Vector3.new(1e5, 0, 1e5)
        BV.Velocity = Vector3.new(0,0,0)
        BV.Parent = root
    end

    self._conn = RunService.RenderStepped:Connect(function()
        if self.Enabled then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                local moveDir = humanoid.MoveDirection
                BV.Velocity = moveDir * 16 * self.SpeedMultiplier
            end
        end
    end)
end

function Speed:Disable()
    self.Enabled = false
    if self._conn then
        self._conn:Disconnect()
        self._conn = nil
    end
    if BV then
        BV.Velocity = Vector3.new(0,0,0)
    end
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

    Folder.Slider("Speed Multiplier", {Default = self.SpeedMultiplier, Min = 1, Max = 5, Precise = true}, function(value)
        self.SpeedMultiplier = value
    end)

    return self
end

return Speed
