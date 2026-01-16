local ModuleBase = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/"..game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.github.com/repos/Okayevls/givemeloot/commits/main"))["sha"].."/src/Main/Module/Core/ModuleBase.lua?v="..os.time()))()
local Speed = ModuleBase.new("Speed")

Speed.RagdollEnabled = false
Speed.SpeedMultiplier = 145

local Players = game:GetService("Players")

function Speed:EUpdate()
    if not Players.LocalPlayer.Character then return end
    local currentHrp = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if not currentHrp or not humanoid then return end

    local dir = humanoid.MoveDirection

    if self.Enabled then
        if dir.Magnitude > 0 then
            currentHrp.Velocity = Vector3.new(dir.X * self.SpeedMultiplier, currentHrp.Velocity.Y * 0.9, dir.Z * self.SpeedMultiplier)
        end
    elseif self.RagdollEnabled and Players.LocalPlayer.Character:GetAttribute("Ragdoll") then
        if dir.Magnitude > 0 then
            currentHrp.Velocity = Vector3.new(dir.X * 100, currentHrp.Velocity.Y * 0.9, dir.Z * 100)
        end
    end
end

function Speed:Enable()
    ModuleBase.Enable(self)
end

function Speed:Disable()
    ModuleBase.Disable(self)
end

function Speed:drawModule(MainTab, Notifier)
    local Folder = MainTab.Folder("Speed", "[Info] Acceleration of player movement")

    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then self:Enable() Notifier:Send("[Legacy.wip] Speed - Enable!", 6) else self:Disable() Notifier:Send("[Legacy.wip] Speed - Disable!", 6) end
    end)

    Folder.Slider("Boost Multiple", { Min = 10, Max = 500, Default = 145, Step = 0.1 }, function(value) self.SpeedMultiplier = value end)
    Folder.Switch("Ragdoll Enabled", function(State) self.RagdollEnabled = State end)
    return self
end

return Speed


--Folder.ModeSetting("Speed Mode", {"Normal", "Fast", "Ultra"}, function(selected)
--    print("Выбран режим: " .. selected)
--
--    if selected == "Normal" then
--        Speed.SpeedMultiplier = 100
--    elseif selected == "Fast" then
--        Speed.SpeedMultiplier = 200
--    elseif selected == "Ultra" then
--        Speed.SpeedMultiplier = 500
--    end
--end)