local Fly = {}
Fly.__index = Fly

Fly.Enabled = false
Fly.FlyMultiplier = 1.2

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local hum = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local keys = {W=false, A=false, S=false, D=false, Space=false, LeftControl=false}

function Fly:Enable()
    if self.Enabled then return end
    self.Enabled = true

    RunService.RenderStepped:Connect(function()
        if self.Enabled and hrp then
            local cam, dir = workspace.CurrentCamera, Vector3.zero
            if keys.W then dir += cam.CFrame.LookVector end
            if keys.S then dir -= cam.CFrame.LookVector end
            if keys.A then dir -= cam.CFrame.RightVector end
            if keys.D then dir += cam.CFrame.RightVector end
            if keys.Space then dir += Vector3.new(0,1,0) end
            if keys.LeftControl then dir -= Vector3.new(0,1,0) end
            if dir.Magnitude > 0 then dir = dir.Unit end
            hrp.CFrame = CFrame.new(hrp.Position + dir * self.FlyMultiplier, hrp.Position + dir * self.FlyMultiplier + cam.CFrame.LookVector)
            hrp.Velocity = Vector3.zero
        end
    end)

end

function Fly:Disable()
    self.Enabled = false
end

function Fly:drawModule(MainTab)
    local Folder = MainTab.Folder("Fly", "[Info] Allows the player to fly")

    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            self:Enable()
        else
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            self:Disable()
        end
    end)

    Folder.Slider("Fly Multiplier", {Default = self.FlyMultiplier, Min = 1, Max = 15, Precise = true}, function(value)
        self.FlyMultiplier = value
    end)

    return self
end

return Fly
