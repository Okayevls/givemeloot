local Players = game:GetService("Players")

local ModuleBase = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/"..
        game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.github.com/repos/Okayevls/givemeloot/commits/main"))["sha"]..
        "/src/Main/Module/Core/ModuleBase.lua?v="..os.time()))()

local KickTarget = ModuleBase.new("KickTarget")
local originalPos

KickTarget.Enabled = false
KickTarget.HealthArg = false
KickTarget._Switch = nil
KickTarget.max = 57000
KickTarget.min = 50000
KickTarget.healthCheck = 26
KickTarget.Targets = {}

local function checkCarrying()
    if Players.LocalPlayer.Character then
        local carrying = Players.LocalPlayer.Character:FindFirstChild("Values"):FindFirstChild("Carrying")
        if carrying then
            return carrying.Value ~= nil
        end
    end
    return false
end

function KickTarget:teleportToTargetAndBack()
    local localChar = Players.LocalPlayer.Character
    if not localChar then return end
    local rootLocal = localChar:FindFirstChild("HumanoidRootPart")
    if not rootLocal then return end

    local targetHeight = math.random(KickTarget.min, KickTarget.max)

    if self.HealthArg then
        rootLocal.CFrame = CFrame.new(Vector3.new(rootLocal.Position.X, targetHeight, rootLocal.Position.Z))

        wait(0.5)
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Carry"):FireServer(false)
        Players.LocalPlayer.Character.Values.Carrying.Value = nil
        wait(0.5)

        if not checkCarrying() then
            rootLocal.CFrame = CFrame.new(Vector3.new(rootLocal.Position.X, originalPos, rootLocal.Position.Z))
            self.Enabled = false
            self.HealthArg = false
            if self._Switch then
                self._Switch.Value = false
            end
        end
    else
        self.HealthArg = localChar:WaitForChild("Humanoid").Health >= self.healthCheck
    end
end

function KickTarget:Enable()
    if self.Enabled then return end
    local localChar = Players.LocalPlayer.Character
    if not localChar then return end
    local rootLocal = localChar:FindFirstChild("HumanoidRootPart")
    if not rootLocal then return end
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

    Folder.Slider("Check health", { Min = 0, Max = 30, Default = 26, Step = 0.1 }, function(value)
        self.healthCheck = value
    end)

    Folder.Slider("MaxY", { Min = 25000, Max = 99000000, Default = 50000, Step = 5000 }, function(value)
        self.max = value
    end)

    Folder.Slider("MinY", { Min = 25000, Max = 99000000, Default = 57000, Step = 5000 }, function(value)
        self.min = value
    end)

    return self
end

return KickTarget
