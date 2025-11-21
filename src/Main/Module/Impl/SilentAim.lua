local SilentAim = {}
SilentAim.__index = SilentAim

SilentAim.Enabled = false
SilentAim.EnabledAutoStomp = false
SilentAim.EnabledAntiBuy = false
SilentAim.TargetBind = nil

SilentAim._StompSwitch = nil

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer

local selectedTarget = nil
local line = nil
local isShooting = false

local proximityEnabled = true
local connection

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

local function createBulletTracer(fromPos, toPos)
    local cam = workspace.CurrentCamera
    local fromScreen, fromVisible = cam:WorldToViewportPoint(fromPos)
    local toScreen, toVisible = cam:WorldToViewportPoint(toPos)

    if not fromVisible or not toVisible then return end

    -- tracer
    local tracer = Drawing.new("Line")
    tracer.From = Vector2.new(fromScreen.X, fromScreen.Y)
    tracer.To = Vector2.new(toScreen.X, toScreen.Y)
    tracer.Color = Color3.fromRGB(255, 200, 80)
    tracer.Thickness = 1.5
    tracer.Transparency = 1
    tracer.Visible = true

    -- glow
    local glow = Drawing.new("Line")
    glow.From = tracer.From
    glow.To = tracer.To
    glow.Color = Color3.fromRGB(255, 150, 0)
    glow.Thickness = 6
    glow.Transparency = 0.35
    glow.Visible = true

    -- fade-out
    task.spawn(function()
        for i = 1, 12 do
            tracer.Transparency = tracer.Transparency - 0.08
            glow.Transparency = glow.Transparency - 0.04
            task.wait(0.016)
        end
        tracer:Remove()
        glow:Remove()
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
        line.Color = Color3.fromRGB(255, 0, 0)
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

local function smartShoot(targetPlayer)
    local gun = getEquippedWeapon()
    if not gun then return end

    local targetHead = targetPlayer.Character:FindFirstChild("Head")
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHead or not targetRoot then return end

    local velocity = targetRoot.Velocity
    local predictedPos = targetHead.Position + (velocity * 0.15)

    local args = {
        {
            {    targetHead,    predictedPos,    CFrame.new()   }
        },
        {targetHead},
        true
    }

    gun.Communication:FireServer(unpack(args))

    local muzzle = nil

    if gun:FindFirstChild("Main") and gun.Main:FindFirstChild("Front") then
        muzzle = gun.Main.Front.Position   --> из дула
    else
        muzzle = LocalPlayer.Character.Head.Position --> запасной вариант
    end

    createBulletTracer(muzzle, predictedPos)
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

local function blockShoot(actionName, inputState, inputObject)
    if SilentAim.Enabled then
        if inputState == Enum.UserInputState.Begin then
            if getEquippedWeapon() and selectedTarget then
                isShooting = true
                return Enum.ContextActionResult.Sink
            end
        end
    end
    return Enum.ContextActionResult.Pass
end

RunService.RenderStepped:Connect(function()
    if SilentAim.EnabledAutoStomp and SilentAim.Enabled then
        if selectedTarget ~= nil then
            stomp(selectedTarget)
        end
    end
end)

ContextActionService:BindAction("BlockShoot", blockShoot, false, Enum.UserInputType.MouseButton1)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if SilentAim.Enabled then
        --if input.KeyCode == SilentAim.TargetBind and SilentAim.TargetBind ~= nil then
        --    if selectedTarget then
        --        selectedTarget = nil
        --        if line then line:Remove() line = nil end
        --    else
        --        selectedTarget = findNearestToMouse()
        --        if selectedTarget then
        --            print("[Legacy.win] New Target:", selectedTarget.Name)
        --        else
        --            print("[Legacy.win] Target nil")
        --        end
        --    end
        --end
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
        selectedTarget = findNearestToMouse()

        --updateLine()

        if isShooting and selectedTarget then
            smartShoot(selectedTarget)
        end
        
        ProximityPromptService.Enabled = SilentAim.EnabledAntiBuy
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
    if self.Enabled then return end
    self.Enabled = true
end

function SilentAim:Disable()
    isShooting = false
    selectedTarget = nil
    line:Remove()
    line = nil
    ProximityPromptService.Enabled = true
    self.Enabled = false
    if self._StompSwitch then self._StompSwitch.Value = false end
end

function SilentAim:drawModule(MainTab, Notifier)
    local Folder = MainTab.Folder("SilentAim", "[Info] Automatically finds the target and destroys it")

    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            Notifier:Send("[Legacy.wip] SilentAim - Enable!",6)
            self:Enable()
        else
            Notifier:Send("[Legacy.wip] SilentAim - Disable!",6)
            self:Disable()
        end
    end)

    local MyBind = Folder.Binding("Target Search", function(key)
        self.TargetBind = key
    end)

    self._StompSwitch = Folder.SwitchAndBinding("Stomp", function(st)
        self.EnabledAutoStomp = st
    end)

    Folder.SwitchAndBinding("AntiBuy", function(st)
        self.EnabledAntiBuy = st
    end)

    return self
end

return SilentAim
