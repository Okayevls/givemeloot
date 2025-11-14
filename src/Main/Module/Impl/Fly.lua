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
    if Fly.Enabled and hrp then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if keys.W then dir += cam.CFrame.LookVector end
        if keys.S then dir -= cam.CFrame.LookVector end
        if keys.A then dir -= cam.CFrame.RightVector end
        if keys.D then dir += cam.CFrame.RightVector end
        if keys.Space then dir += Vector3.new(0,1,0) end
        if keys.LeftControl then dir -= Vector3.new(0,1,0) end
        if dir.Magnitude > 0 then dir = dir.Unit end
        hrp.CFrame = CFrame.new(hrp.Position + dir * Fly.flySpeed, hrp.Position + dir * Fly.flySpeed + cam.CFrame.LookVector)
        hrp.Velocity = Vector3.zero
    end
end)

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, processed)
    if kc == Enum.KeyCode.W then keys.W = true
    elseif kc == Enum.KeyCode.A then keys.A = true
    elseif kc == Enum.KeyCode.S then keys.S = true
    elseif kc == Enum.KeyCode.D then keys.D = true
    elseif kc == Enum.KeyCode.LeftControl then keys.LeftControl = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    local kc = input.KeyCode
    if kc == Enum.KeyCode.W then keys.W = false end
    if kc == Enum.KeyCode.A then keys.A = false end
    if kc == Enum.KeyCode.S then keys.S = false end
    if kc == Enum.KeyCode.D then keys.D = false end
    if kc == Enum.KeyCode.Space then keys.Space = false end
    if kc == Enum.KeyCode.LeftControl then keys.LeftControl = false end
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