local Fly = {}
Fly.__index = Fly

Fly.Enabled = false
Fly.FlySpeed = 50  -- переименовал в Speed для ясности

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local character, hum, hrp
local keys = {W=false, A=false, S=false, D=false, Space=false, LeftControl=false}
local connection, spoofConnection, bv, ao, att0

local function setupCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    hum = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")

    -- Пересоздаём если включено
    if Fly.Enabled then
        Fly:Disable()
        Fly:Enable()
    end
end
setupCharacter()
player.CharacterAdded:Connect(setupCharacter)

function Fly:Enable()
    if self.Enabled then return end
    self.Enabled = true

    if not hrp then return end

    -- BodyVelocity для движения
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(40000, 40000, 40000)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = hrp

    -- Attachment для AO
    att0 = Instance.new("Attachment")
    att0.Parent = hrp

    -- AlignOrientation для поворота к камере
    ao = Instance.new("AlignOrientation")
    ao.Attachment0 = att0
    ao.MaxTorque = 40000
    ao.RigidityEnabled = true
    ao.Parent = hrp

    -- PlatformStand для флая
    hum.PlatformStand = true

    -- Основной луп
    connection = RunService.Heartbeat:Connect(function()
        if not self.Enabled or not hrp then return end

        local cam = workspace.CurrentCamera
        local moveVector = Vector3.new(0,0,0)

        if keys.W then moveVector = moveVector + cam.CFrame.LookVector end
        if keys.S then moveVector = moveVector - cam.CFrame.LookVector end
        if keys.A then moveVector = moveVector - cam.CFrame.RightVector end
        if keys.D then moveVector = moveVector + cam.CFrame.RightVector end
        if keys.Space then moveVector = moveVector + cam.CFrame.UpVector end
        if keys.LeftControl then moveVector = moveVector - cam.CFrame.UpVector end

        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit
        end

        bv.Velocity = moveVector * self.FlySpeed

        -- Поворот к направлению камеры
        ao.CFrame = cam.CFrame
    end)

    -- Spoof velocity (главный байпас — античит видит низкую скорость)
    spoofConnection = RunService.Heartbeat:Connect(function()
        if self.Enabled and hrp and bv.Velocity.Magnitude > 0 then
            -- Имитируем легит (16-65 studs/sec + шум)
            local spoofVel = (bv.Velocity.Unit * math.random(45, 65)) + Vector3.new(math.random(-2,2), 0, math.random(-2,2))
            hrp.AssemblyLinearVelocity = spoofVel  -- Клиентский спуф
        end
    end)
end

function Fly:Disable()
    self.Enabled = false

    if bv then bv:Destroy() bv = nil end
    if ao then ao:Destroy() ao = nil end
    if att0 then att0:Destroy() att0 = nil end

    if hum then
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end

    if connection then connection:Disconnect() connection = nil end
    if spoofConnection then spoofConnection:Disconnect() spoofConnection = nil end
end

-- Input (твой код без изменений)
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
    self:Disable()
end

function Fly:drawModule(MainTab, Notifier)
    local Folder = MainTab.Folder("Fly", "[Info] Allows the player to fly (Bypass 2025)")
    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            Notifier:Send("[Legacy.wip] Fly - Enable! (Safe Speed)",6)
            self:Enable()
        else
            Notifier:Send("[Legacy.wip] Fly - Disable!",6)
            self:Disable()
        end
    end)

    Folder.Slider("Fly Speed", { Min = 0, Max = 200, Default = 50, Step = 1 }, function(value)
        Fly.FlySpeed = value
    end)

    return self
end

return Fly