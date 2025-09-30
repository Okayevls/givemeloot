local Speed = {}
Speed.__index = Speed

Speed.Enabled = false
Speed.SpeedMultiplier = 2

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BV
local conn

function Speed:Enable()
    if self.Enabled then return end
    self.Enabled = true

    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    if not BV then
        BV = Instance.new("BodyVelocity")
        BV.MaxForce = Vector3.new(1e5, 0, 1e5)
        BV.Velocity = Vector3.new(0,0,0)
        BV.Parent = root
    end

    humanoid.PlatformStand = false

    conn = RunService.RenderStepped:Connect(function()
        if self.Enabled and humanoid then
            local moveDir = humanoid.MoveDirection
            BV.Velocity = moveDir * 16 * self.SpeedMultiplier
        end
    end)
end

function Speed:Disable()
    self.Enabled = false

    if conn then
        conn:Disconnect()
        conn = nil
    end

    if BV then
        BV.Velocity = Vector3.new(0,0,0)
        BV.MaxForce = Vector3.new(0,0,0)
        BV:Destroy()
        BV = nil
    end

    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
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

    Folder.Slider("Speed Multiplier", {Default = self.SpeedMultiplier, Min = 1, Max = 15, Precise = true}, function(value)
        self.SpeedMultiplier = value
    end)

    return self
end

return Speed
