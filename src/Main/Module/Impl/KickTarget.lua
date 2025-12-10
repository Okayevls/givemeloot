local Players = game:GetService("Players")

local ModuleBase = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/"..
        game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.github.com/repos/Okayevls/givemeloot/commits/main"))["sha"]..
        "/src/Main/Module/Core/ModuleBase.lua?v="..os.time()))()

local KickTarget = ModuleBase.new("KickTarget")
local originalPos

KickTarget.Enabled = false
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

local function teleportToTargetAndBack()
    local localChar = Players.LocalPlayer.Character
    if not localChar then return end
    local rootLocal = localChar:FindFirstChild("HumanoidRootPart")
    if not rootLocal then return end

    originalPos = rootLocal.Position.Y
    local targetHeight = math.random(15000, 17000)

    rootLocal.CFrame = CFrame.new(Vector3.new(rootLocal.Position.X, targetHeight, rootLocal.Position.Z))
    wait(0.5)
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Carry"):FireServer(false)
    wait(0.8)
    self.Enabled = false
end

function KickTarget:Enable()
    if self.Enabled then return end
    self.Enabled = true
    teleportToTargetAndBack()
end

function KickTarget:Disable()
    if not self.Enabled then return end
    local localChar = Players.LocalPlayer.Character
    local rootLocal = localChar:FindFirstChild("HumanoidRootPart")
    if not checkCarrying() then
        rootLocal.CFrame = CFrame.new(Vector3.new(rootLocal.Position.X, originalPos, rootLocal.Position.Z))
    end
    self.Enabled = false
end

function KickTarget:drawModule(MainTab, Notifier)
    local Folder = MainTab.Folder("KickTarget", "[Info]")
    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            Notifier:Send("[Legacy.wip] KickTarget - Enable!", 4)
            self:Enable()
        else
            Notifier:Send("[Legacy.wip] KickTarget - Disable!", 4)
            self:Disable()
        end
    end)
    return self
end

return KickTarget
