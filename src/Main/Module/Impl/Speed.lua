local ModuleBase = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/"..game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.github.com/repos/Okayevls/givemeloot/commits/main"))["sha"].."/src/Main/Module/Core/ModuleBase.lua?v="..os.time()))()
local Speed = ModuleBase.new("Speed")

Speed.RagdollEnabled = false
Speed.SpeedMultiplier = 145

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp

local function setupCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    hrp = character:WaitForChild("HumanoidRootPart")
end

setupCharacter()

function Speed:ELocalPlayerSpawned()
    setupCharacter()
end

function Speed:EUpdate()
    if not character then return end
    local currentHrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")

    if not currentHrp or not humanoid then return end
    hrp = currentHrp

    local dir = humanoid.MoveDirection

    if self.Enabled then
        if dir.Magnitude > 0 then
            hrp.Velocity = Vector3.new(dir.X * self.SpeedMultiplier, hrp.Velocity.Y * 0.9, dir.Z * self.SpeedMultiplier)
        end
    elseif self.RagdollEnabled and character:GetAttribute("Ragdoll") then
        if dir.Magnitude > 0 then
            hrp.Velocity = Vector3.new(dir.X * 100, hrp.Velocity.Y * 0.9, dir.Z * 100)
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

    Folder.ModeSettingCycle("Speed Mode", {"Normal", "Fast", "Ultra"}, function(selected)
        print("Выбран режим: " .. selected)
        if selected == "Normal" then
            Speed.SpeedMultiplier = 100
        elseif selected == "Fast" then
            Speed.SpeedMultiplier = 200
        elseif selected == "Ultra" then
            Speed.SpeedMultiplier = 500
        end
    end)
    
    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then self:Enable() Notifier:Send("[Legacy.wip] Speed - Enable!", 6) else self:Disable() Notifier:Send("[Legacy.wip] Speed - Disable!", 6) end
    end)

    Folder.Slider("Boost Multiple", { Min = 10, Max = 500, Default = 145, Step = 0.1 }, function(value) self.SpeedMultiplier = value end)
    Folder.Switch("Ragdoll Enabled", function(State) self.RagdollEnabled = State end)
    return self
end

return Speed
