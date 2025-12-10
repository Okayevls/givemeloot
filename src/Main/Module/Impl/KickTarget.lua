local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local ModuleBase = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/"..
        game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.github.com/repos/Okayevls/givemeloot/commits/main"))["sha"]..
        "/src/Main/Module/Core/ModuleBase.lua?v="..os.time()))()

local KickTarget = ModuleBase.new("KickTarget")
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

    local originalPos = rootLocal.Position
    local targetHeight = math.random(15000, 17000)

    local nearestPlayer = nil
    local minDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local rootTarget = player.Character:FindFirstChild("HumanoidRootPart")
            if rootTarget then
                local dist = (rootTarget.Position - rootLocal.Position).Magnitude
                if dist < minDistance then
                    nearestPlayer = player
                    minDistance = dist
                end
            end
        end
    end

    if not nearestPlayer then return end
    KickTarget.Targets[nearestPlayer] = true
    local rootTarget = nearestPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootTarget then return end

    local targetPos = rootTarget.Position
    targetPos = Vector3.new(targetPos.X, targetHeight, targetPos.Z)
    local offset = (rootTarget.Position - rootLocal.Position).Unit * 5
    rootLocal.CFrame = CFrame.new(targetPos + offset)
    local success = false

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not nearestPlayer or not nearestPlayer.Character then
            print("kicked Target: "..nearestPlayer.Name)
            KickTarget.Targets[nearestPlayer] = nil
            connection:Disconnect()
            success = true
        elseif rootTarget.Position.Y < 500 then
            print("Error Kicked Target: "..nearestPlayer.Name)
            KickTarget.Targets[nearestPlayer] = nil
            connection:Disconnect()
            success = false
        end
    end)

    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Carry"):FireServer(false)
    wait(1.5)

    if not checkCarrying() then
        rootLocal.CFrame = CFrame.new(Vector3.new(originalPos.X, originalPos.Y, originalPos.Z))
    end
    return success
end

function KickTarget:EUpdate()
    if checkCarrying() then
        teleportToTargetAndBack()
    end
end

function KickTarget:Enable()
    if self.Enabled then return end
    self.Enabled = true
    self.Heartbeat = RunService.Heartbeat:Connect(function()
        self:EUpdate()
    end)
end

function KickTarget:Disable()
    if not self.Enabled then return end
    self.Enabled = false
    if self.Heartbeat then
        self.Heartbeat:Disconnect()
        self.Heartbeat = nil
    end
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
