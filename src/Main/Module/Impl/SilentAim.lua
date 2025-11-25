local SilentAim = {}
SilentAim.__index = SilentAim

SilentAim.Enabled = false
SilentAim.EnabledAutoStomp = false
SilentAim.EnabledAntiBuy = false
SilentAim.EnabledTarget = nil
SilentAim.TargetBind = nil

SilentAim._StompSwitch = nil

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer

local randomTarget = nil
local selectedTarget = nil
local line = nil
local isShooting = false

local SupportedWeapons = {
    ["AW1"] = true, ["Ak"] = true, ["Barrett"] = true, ["Deagle"] = true, ["Double Barrel"] = true, ["Draco"] = true,
    ["Glock"] = true, ["Heli"] = true, ["M249"] = true, ["M37"] = true, ["M4"] = true, ["Micro Uzi"] = true,
    ["Rpg"] = true, ["Silencer"] = true, ["Spas"] = true, ["Taser"] = true, ["Tec"] = true, ["Ump"] = true
}

local function getEquippedWeapon()
    local char = LocalPlayer.Character
    if not char then return nil end

    for name, _ in pairs(SupportedWeapons) do
        if char:FindFirstChild(name) and char[name]:FindFirstChild("Communication") then
            return char[name]
        end
    end

    return nil
end

local function findNearestToMouse()
    local mouseLocation = UserInputService:GetMouseLocation()
    local closestPlayer = nil
    local closestDist = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local headPos = char.Head.Position
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(headPos)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mouseLocation).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function create3DTracer(fromAttachment, targetPosition)
    -- Стартовая точка (дула)
    local startPart = Instance.new("Part")
    startPart.Size = Vector3.new(0.1, 0.1, 0.1)
    startPart.Anchored = true
    startPart.CanCollide = false
    startPart.Transparency = 1
    startPart.Position = fromAttachment.WorldPosition
    startPart.Parent = workspace

    local attachStart = Instance.new("Attachment")
    attachStart.Position = Vector3.new(0,0,0)
    attachStart.Parent = startPart

    -- Конечная точка (цель)
    local endPart = Instance.new("Part")
    endPart.Size = Vector3.new(0.1, 0.1, 0.1)
    endPart.Anchored = true
    endPart.CanCollide = false
    endPart.Transparency = 1
    endPart.Position = targetPosition
    endPart.Parent = workspace

    local attachEnd = Instance.new("Attachment")
    attachEnd.Position = Vector3.new(0,0,0)
    attachEnd.Parent = endPart

    -- Beam
    local beam = Instance.new("Beam")
    beam.Attachment0 = attachStart
    beam.Attachment1 = attachEnd
    beam.FaceCamera = true
    beam.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 190, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 140, 255))
    })
    beam.Width0 = 0.2
    beam.Width1 = 0.2
    beam.LightEmission = 0.9
    beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.8)
    })
    beam.Parent = workspace

    -- Плавное исчезновение
    task.spawn(function()
        local steps = 40
        local delayPerStep = 0.025
        for i = 1, steps do
            local factor = 1 - (i / steps)
            beam.Width0 = 0.2 * factor
            beam.Width1 = 0.2 * factor
            task.wait(delayPerStep)
        end

        if beam and beam.Parent then beam:Destroy() end
        if startPart and startPart.Parent then startPart:Destroy() end
        if endPart and endPart.Parent then endPart:Destroy() end
    end)
end

local function updateLine()
    if not selectedTarget or not selectedTarget.Character or not selectedTarget.Character:FindFirstChild("Head") then
        if line then line:Remove() line = nil end
        return
    end

    local localChar = LocalPlayer.Character
    if not localChar or not localChar:FindFirstChild("Head") then
        if line then line:Remove() line = nil end
        return
    end

    if not line then
        line = Drawing.new("Line")
        line.Visible = true
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Thickness = 2
        line.Transparency = 1
    end

    local fromPos = localChar.Head.Position
    local toPos = selectedTarget.Character.Head.Position

    local fromScreen, fromVisible = workspace.CurrentCamera:WorldToViewportPoint(fromPos)
    local toScreen, toVisible = workspace.CurrentCamera:WorldToViewportPoint(toPos)

    if fromVisible and toVisible then
        line.From = Vector2.new(fromScreen.X, fromScreen.Y)
        line.To = Vector2.new(toScreen.X, toScreen.Y)
        line.Visible = true
    else
        line.Visible = false
    end
end

local lastAmmoPerAmmoObject = {}

local function smartShoot(targetPlayer)
    local gun = getEquippedWeapon()
    if not gun then return end

    local ammo = gun:FindFirstChild("Ammo")
    if not ammo then return end

    if lastAmmoPerAmmoObject[ammo] == nil then
        lastAmmoPerAmmoObject[ammo] = ammo.Value
    end

    local char = targetPlayer.Character
    if not char then return end

    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not head or not root then return end

    local predicted = head.Position + root.Velocity * 0.15

    local muzzle
    if gun:FindFirstChild("Main") and gun.Main:FindFirstChild("Front") then
        muzzle = gun.Main.Front
    elseif gun:FindFirstChild("Muzzle") then
        muzzle = gun.Muzzle
    end

    gun.Communication:FireServer(
            {
                { head, predicted, CFrame.new() }
            },
            { head },
            true
    )

    if ammo.Value == lastAmmoPerAmmoObject[ammo] then
        return
    end

    lastAmmoPerAmmoObject[ammo] = ammo.Value

    if muzzle then
        local attach = muzzle:FindFirstChildOfClass("Attachment")
        if not attach then
            attach = Instance.new("Attachment")
            attach.Parent = muzzle
            task.spawn(function()
                task.wait(1.5)
                if attach and attach.Parent then attach:Destroy() end
            end)
        end

        create3DTracer(attach, predicted)
    end
end

local function stomp(targetPlayer)
    local args = { targetPlayer.Character }
    game:GetService("ReplicatedStorage")
        :WaitForChild("RemoteEvents")
        :WaitForChild("Stomp")
        :InvokeServer(unpack(args))
    SilentAim.EnabledAutoStomp = false
    if SilentAim._StompSwitch then SilentAim._StompSwitch.Value = false end
end

local function blockShoot(_, state)
    if SilentAim.Enabled then
        if state == Enum.UserInputState.Begin then
            if getEquippedWeapon() and (randomTarget or selectedTarget) then
                isShooting = true
                return Enum.ContextActionResult.Sink
            end
        end
    end
    return Enum.ContextActionResult.Pass
end

RunService.RenderStepped:Connect(function()
    local target = selectedTarget ~= nil and selectedTarget or randomTarget

    if SilentAim.EnabledAutoStomp and SilentAim.Enabled then
        if randomTarget ~= nil or selectedTarget ~= nil then
            stomp(target)
        end
    end
end)

ContextActionService:BindAction("BlockShoot", blockShoot, false, Enum.UserInputType.MouseButton1)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if SilentAim.Enabled then
        if input.KeyCode == SilentAim.TargetBind and SilentAim.TargetBind ~= nil then
            if selectedTarget then
                selectedTarget = nil
                if line then line:Remove() line = nil end
            else
                randomTarget = nil
                selectedTarget = findNearestToMouse()
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if SilentAim.Enabled then
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isShooting = false
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if SilentAim.Enabled then
        if selectedTarget ~= nil then
            updateLine()
            randomTarget = nil
        else
            randomTarget = findNearestToMouse()
        end

        local target = selectedTarget ~= nil and selectedTarget or randomTarget

        if isShooting and (randomTarget or selectedTarget) then
            smartShoot(target)
        end

        ProximityPromptService.Enabled = not SilentAim.EnabledAntiBuy
    else
        randomTarget = nil
        selectedTarget = nil
        ProximityPromptService.Enabled = true
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if SilentAim.Enabled then
        selectedTarget = nil
        if line then line:Remove() line = nil end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if SilentAim.Enabled then
        if player == selectedTarget then
            selectedTarget = nil
            if line then line:Remove() line = nil end
        end
    end
end)


function SilentAim:Enable()
    self.Enabled = true
end

function SilentAim:Disable()
    isShooting = false
    randomTarget = nil
    selectedTarget = nil

    if line then
        line:Remove()
        line = nil
    end

    ProximityPromptService.Enabled = true
    self.Enabled = false

    if self._StompSwitch then
        self._StompSwitch.Value = false
    end
end

function SilentAim:drawModule(MainTab)
    local Group = MainTab:AddLeftGroupbox('SilentAim')

    local Toggle = Group:AddToggle("SilentAimToggle", {
        Text = "Toggle",
        Default = false,
        Callback = function(v)
            if v then
                self:Enable()
            else
                self:Disable()
            end
        end
    })
    Toggle:AddKeyPicker("SilentAimBind", {
        Default = "None",
        Text = "Toggle Keybind",
        Mode = "Toggle",
        NoUI = false,
        Callback = function()
            Toggle:SetValue(not Toggle.Value)
        end
    })


    local Toggle2 = Group:AddToggle("SelectTargetToggle", {
        Text = "Select Target",
        Default = false,
        Callback = function(v)
            self.EnabledTarget = v
        end
    })
    Toggle2:AddKeyPicker("SelectTargetBind", {
        Default = "None",
        Text = "Select Target",
        Mode = "Toggle",
        NoUI = false,
        Callback = function(key)
            self.TargetBind = key
            Toggle2:SetValue(true)
            if Toggle2 then
                Toggle2:SetValue(false)
            end
        end
    })

    --local Folder = MainTab.Folder("SilentAim", "[Info] Automatically finds the target and destroys it")

   --Folder.SwitchAndBinding("Toggle", function(Status)
   --    if Status then
   --        Notifier:Send("[Legacy.wip] SilentAim - Enable!", 4)
   --        self:Enable()
   --    else
   --        Notifier:Send("[Legacy.wip] SilentAim - Disable!", 4)
   --        self:Disable()
   --    end
   --end)

   --local MyBind = Folder.Binding("Select Target", function(key)
   --    self.TargetBind = key
   --end)

   --self._StompSwitch = Folder.SwitchAndBinding("Stomp", function(st)
   --    self.EnabledAutoStomp = st
   --end)

   --Folder.SwitchAndBinding("AntiBuy", function(st)
   --    self.EnabledAntiBuy = st
   --end)

    return self
end

return SilentAim
