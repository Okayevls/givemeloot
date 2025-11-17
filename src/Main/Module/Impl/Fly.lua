local Fly = {}
Fly.__index = Fly

Fly.Enabled = false
Fly.FlyMultiplier = 1.2

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local character, hum, hrp, animate
local keys = {W=false, A=false, S=false, D=false, Space=false, LeftControl=false}
local connection

local function setupCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    hum = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
    animate = character:FindFirstChild("Animate")
end
setupCharacter()

player.CharacterAdded:Connect(setupCharacter)

function Fly:Enable()
    if self.Enabled then return end
    self.Enabled = true

    if animate then
        animate.Disabled = true
    end

    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Physics)
    end
end

function Fly:Disable()
    self.Enabled = false

    if animate then
        animate.Disabled = false
    end

    if hum then
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end


connection = RunService.RenderStepped:Connect(function()
    if Fly.Enabled and hrp then

        if hum and hum.Animator then
            for _, track in ipairs(hum.Animator:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end

        local cam = workspace.CurrentCamera
        local dir = Vector3.zero

        if keys.W then dir += cam.CFrame.LookVector end
        if keys.S then dir -= cam.CFrame.LookVector end
        if keys.A then dir -= cam.CFrame.RightVector end
        if keys.D then dir += cam.CFrame.RightVector end
        if keys.Space then dir += Vector3.new(0,1,0) end
        if keys.LeftControl then dir -= Vector3.new(0,1,0) end

        if dir.Magnitude > 0 then
            dir = dir.Unit
        end

        hrp.CFrame = CFrame.new(
                hrp.Position + dir * Fly.FlyMultiplier,
                hrp.Position + dir * Fly.FlyMultiplier + cam.CFrame.LookVector
        )
        hrp.Velocity = Vector3.zero
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    local kc = input.KeyCode
    if kc == Enum.KeyCode.W then keys.W = true
    elseif kc == Enum.KeyCode.A then keys.A = true
    elseif kc == Enum.KeyCode.S then keys.S = true
    elseif kc == Enum.KeyCode.D then keys.D = true
    elseif kc == Enum.KeyCode.Space then keys.Space = true
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

    Folder.Slider("Fly Speed", { Min = 0, Max = 5, Default = 1, Step = 0.01 }, function(value)
        Fly.FlyMultiplier = value
    end)

    return self
end

return Fly
