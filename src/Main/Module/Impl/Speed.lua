local ModuleBase = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/"..
        game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.github.com/repos/Okayevls/givemeloot/commits/main"))["sha"]..
        "/src/Main/Module/Core/ModuleBase.lua?v="..os.time()))()

local Speed = ModuleBase.new("Speed", "Acceleration of player movement")

Speed.Settings = {
    SpeedMultiplier = {Type = "Slider", Min = 10, Max = 500, Default = 145, Step = 0.1},
    RagdollEnabled  = {Type = "SwitchB", Default = false}
}

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
    local humanoid = character:FindFirstChild("Humanoid")
    local currentHrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not currentHrp then return end

    hrp = currentHrp
    local dir = humanoid.MoveDirection
    if dir.Magnitude == 0 then return end

    if self.Enabled then
        hrp.Velocity = Vector3.new(dir.X * self.SpeedMultiplier, hrp.Velocity.Y * 0.9, dir.Z * self.SpeedMultiplier)
    elseif self.RagdollEnabled and character:GetAttribute("Ragdoll") then
        hrp.Velocity = Vector3.new(dir.X * 100, hrp.Velocity.Y * 0.9, dir.Z * 100)
    end
end

function Speed:Enable()
    ModuleBase.Enable(self)
end

function Speed:Disable()
    ModuleBase.Disable(self)
end

function Speed:drawModule(MainTab, Notifier)
    ModuleBase.drawModule(self, MainTab, Notifier)
    return self
end

return Speed
