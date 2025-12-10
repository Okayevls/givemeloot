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

local function teleportToTargetAndBack(targetPlayer)
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
    local rootTarget = nearestPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootTarget then return end

    local targetPos = rootTarget.Position
    targetPos = Vector3.new(targetPos.X, targetHeight, targetPos.Z)
    local offset = (rootTarget.Position - rootLocal.Position).Unit * 5
    rootLocal.CFrame = CFrame.new(targetPos + offset)

    local startTime = tick()
    local success = false

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not nearestPlayer or not nearestPlayer.Character then
            print("Error Kicked Target: Player left or reset")
            connection:Disconnect()
            success = false
        elseif rootTarget.Position.Y < 500 then
            print("Error Kicked Target: Player too low")
            connection:Disconnect()
            success = false
        elseif tick() - startTime > 5 then
            print("Successful Kicked Target: "..nearestPlayer.Name.." | Flight time: "..string.format("%.2f", tick() - startTime).."s")
            connection:Disconnect()
            success = true
        end
    end)

    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Carry"):FireServer(false)
    wait(0.8)
    rootLocal.CFrame = CFrame.new(Vector3.new(originalPos.X, originalPos.Y, originalPos.Z))
    return success
end

Players.PlayerRemoving:Connect(function(player)
    if KickTarget.Targets[player] then
        print("kicked Target: "..player.Name)
        KickTarget.Targets[player] = nil
    end
end)

function KickTarget:EUpdate()
    if checkCarrying() then
        KickTarget.Targets[target] = true
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
