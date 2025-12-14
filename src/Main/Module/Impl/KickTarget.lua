local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ModuleBase = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/"..
        game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.github.com/repos/Okayevls/givemeloot/commits/main"))["sha"]..
        "/src/Main/Module/Core/ModuleBase.lua?v="..os.time()))()

local KickTarget = ModuleBase.new("KickTarget")
local originalPos

KickTarget.Enabled = false
KickTarget._Switch = nil
KickTarget.max = 57000
KickTarget.min = 50000
KickTarget.Targets = {}

local desync_setback = Instance.new("Part")
desync_setback.Name = "T9AKICK"
desync_setback.Parent = workspace
desync_setback.Size = Vector3.new(2, 2, 1)
desync_setback.CanCollide = false
desync_setback.Anchored = true
desync_setback.Transparency = 1

local desync = {
    enabled = false,
    teleportPosition = Vector3.new(0, 0, 0),
    old_positionY = nil,
    old_position = nil
}

local function resetCamera()
    if Players.LocalPlayer.Character then
        local humanoid = Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
end

local function checkCarrying()
    if Players.LocalPlayer.Character then
        local carrying = Players.LocalPlayer.Character:FindFirstChild("Values"):FindFirstChild("Carrying")
        if carrying then
            return carrying.Value ~= nil
        end
    end
    return false
end

function KickTarget:EUpdate()
    if desync.enabled and Players.LocalPlayer.Character then
        local rootPart = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            desync.old_position = rootPart.CFrame
            desync.old_positionY = rootPart.CFrame

            local targetHeight = math.random(KickTarget.min, KickTarget.max)
            desync.teleportPosition = Vector3.new(rootPart.Position.X, targetHeight, rootPart.Position.Z)
            rootPart.CFrame = CFrame.new(desync.teleportPosition)
            workspace.CurrentCamera.CameraSubject = desync_setback

            RunService.RenderStepped:Wait()

            desync_setback.CFrame = desync.old_position * CFrame.new(0, rootPart.Size.Y / 2 + 0.5, 0)
            rootPart.CFrame = CFrame.new(rootPart.Position.X, desync.old_positionY, rootPart.Position.Z)
        end
    end
end

function KickTarget:teleportToTargetAndBack()
    local localChar = Players.LocalPlayer.Character
    if not localChar then return end
    local rootLocal = localChar:FindFirstChild("HumanoidRootPart")
    if not rootLocal then return end

    --local targetHeight = math.random(KickTarget.min, KickTarget.max)

    desync.enabled = true
    workspace.CurrentCamera.CameraSubject = desync_setback
   -- rootLocal.CFrame = CFrame.new(Vector3.new(rootLocal.Position.X, targetHeight, rootLocal.Position.Z))

    wait(0.5)
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Carry"):FireServer(false)
    Players.LocalPlayer.Character.Values.Carrying.Value = nil
    wait(0.5)

    if not checkCarrying() then
        desync.enabled = false
      --  rootLocal.CFrame = CFrame.new(Vector3.new(rootLocal.Position.X, originalPos, rootLocal.Position.Z))
        resetCamera()
        self.Enabled = false
        if self._Switch then
            self._Switch.Value = false
        end
    end
end

function KickTarget:Enable()
    if self.Enabled then return end
    local localChar = Players.LocalPlayer.Character
    if not localChar then return end
    local rootLocal = localChar:FindFirstChild("HumanoidRootPart")
    if not rootLocal then return end
    desync.old_positionY = rootLocal.Position.Y
    originalPos = rootLocal.Position.Y
    self.Enabled = true
    task.spawn(function()
        self:teleportToTargetAndBack()
    end)
end

function KickTarget:Disable()
    self.Enabled = false
end

function KickTarget:drawModule(MainTab, Notifier)
    local Folder = MainTab.Folder("KickTarget", "[Info] performs manipulation and kicks the player")
    self._Switch = Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            Notifier:Send("[Legacy.wip] KickTarget - Enable!", 4)
            self:Enable()
        else
            Notifier:Send("[Legacy.wip] KickTarget - Disable!", 4)
            self:Disable()
        end
    end)

    Folder.Slider("MaxY", { Min = 25000, Max = 99000000, Default = 50000, Step = 5000 }, function(value)
        self.START_RADIUS = value
    end)

    Folder.Slider("MinY", { Min = 25000, Max = 99000000, Default = 57000, Step = 5000 }, function(value)
        self.START_RADIUS = value
    end)

    return self
end

return KickTarget
