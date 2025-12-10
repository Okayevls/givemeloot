local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local ModuleBase = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/"..
        game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.github.com/repos/Okayevls/givemeloot/commits/main"))["sha"]..
        "/src/Main/Module/Core/ModuleBase.lua?v="..os.time()))()

local KickTarget = ModuleBase.new("KickTarget")
KickTarget.Enabled = false
KickTarget.Targets = {}

local function checkCarrying(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Chaufrei") then
        local carrying = targetPlayer.Character.Chaufrei:FindFirstChild("Values"):FindFirstChild("Carrying")
        if carrying and carrying:IsA("ObjectValue") then
            return carrying.Value ~= nil
        end
    end
    return false
end

-- Телепорт к игроку и замер времени полета
local function teleportToTargetAndBack(targetPlayer)
    local localChar = Players.LocalPlayer.Character
    local targetChar = targetPlayer.Character
    if not localChar or not targetChar then return end

    local rootLocal = localChar:FindFirstChild("HumanoidRootPart")
    local rootTarget = targetChar:FindFirstChild("HumanoidRootPart")
    if not rootLocal or not rootTarget then return end

    local originalPos = rootLocal.Position
    local targetPos = rootTarget.Position + Vector3.new(0, 2, 0) -- почти вплотную

    rootLocal.CFrame = CFrame.new(targetPos)
    local startTime = tick()

    -- Проверяем условия полета
    local success = false
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not targetPlayer or not targetPlayer.Character then
            print("Error Kicked Target: Player left or reset")
            connection:Disconnect()
            success = false
        elseif rootTarget.Position.Y < 500 then
            print("Error Kicked Target: Player too low")
            connection:Disconnect()
            success = false
        elseif tick() - startTime > 5 then -- допустим, максимум 5 секунд
            print("Successful Kicked Target: "..targetPlayer.Name.." | Flight time: "..string.format("%.2f", tick() - startTime).."s")
            connection:Disconnect()
            success = true
        end
    end)

    wait(0.8) -- немного держим
    rootLocal.CFrame = CFrame.new(originalPos)
    return success
end

Players.PlayerRemoving:Connect(function(player)
    if KickTarget.Targets[player] then
        print("kicked Target: "..player.Name)
        KickTarget.Targets[player] = nil
    end
end)

function KickTarget:EUpdate()
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= Players.LocalPlayer and checkCarrying(target) then
            KickTarget.Targets[target] = true
            teleportToTargetAndBack(target)
        end
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
