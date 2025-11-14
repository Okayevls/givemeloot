local Fly = {}
Fly.__index = Fly

Fly.Enabled = false
Fly.FlyMultiplier = 1.2

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local character, hum, hrp
local keys = {W=false, A=false, S=false, D=false, Space=false, LeftControl=false}
local connection

local function setupCharacter()
        character = player.Character or player.CharacterAdded:Wait()
        hum = character:WaitForChild("Humanoid")
        hrp = character:WaitForChild("HumanoidRootPart")
end
setupCharacter()

player.CharacterAdded:Connect(setupCharacter)

function Fly:Enable()
   if self.Enabled then return end
   self.Enabled = true

   if hum then
       hum:ChangeState(Enum.HumanoidStateType.Physics)
   end
end

function Fly:Disable()
   self.Enabled = false

   if hum then
       hum:ChangeState(Enum.HumanoidStateType.GettingUp)
   end
end

connection = RunService.RenderStepped:Connect(function()
    if not Fly.Enabled or not hrp then return end

    local cam = workspace.CurrentCamera
    local dir = Vector3.zero

    if keys.W then dir = dir + cam.CFrame.LookVector end
    if keys.S then dir = dir - cam.CFrame.LookVector end
    if keys.A then dir = dir - cam.CFrame.RightVector end
    if keys.D then dir = dir + cam.CFrame.RightVector end
    if keys.Space then dir = dir + Vector3.yAxis end
    if keys.LeftControl then dir = dir - Vector3.yAxis end

    if dir.Magnitude > 0 then
            dir = dir.Unit
            local speed = dir * Fly.FlyMultiplier
            hrp.CFrame = CFrame.new(hrp.Position + speed, hrp.Position + speed + cam.CFrame.LookVector)
    end

    hrp.Velocity = Vector3.zero
    --hrp.RotVelocity = Vector3.zero
end)

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.W then keys.W = true
    elseif input.KeyCode == Enum.KeyCode.S then keys.S = true
    elseif input.KeyCode == Enum.KeyCode.A then keys.A = true
    elseif input.KeyCode == Enum.KeyCode.D then keys.D = true
    elseif input.KeyCode == Enum.KeyCode.Space then keys.Space = true
    elseif input.KeyCode == Enum.KeyCode.LeftControl then keys.LeftControl = true
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.W then keys.W = false
    elseif input.KeyCode == Enum.KeyCode.S then keys.S = false
    elseif input.KeyCode == Enum.KeyCode.A then keys.A = false
    elseif input.KeyCode == Enum.KeyCode.D then keys.D = false
    elseif input.KeyCode == Enum.KeyCode.Space then keys.Space = false
    elseif input.KeyCode == Enum.KeyCode.LeftControl then keys.LeftControl = false
    end
end)

function Fly:Destroy()
    if connection then
            connection:Disconnect()
    end
    self:Disable()
end

function Fly:drawModule(MainTab)
        local Folder = MainTab.Folder("Fly", "[Info] Allows the player to fly")

        Folder.SwitchAndBinding("Toggle", function(Status)
                if Status then
                        self:Enable()
                else
                        self:Disable()
                end
        end)

        Folder.Slider("Fly Multiplier", {Default = self.FlyMultiplier, Min = 1, Max = 15, Precise = true}, function(value)
                self.FlyMultiplier = value
        end)

        return self
end

return Fly