local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local NoClip = {}
NoClip.__index = NoClip

NoClip.Enabled = false
local player = Players.LocalPlayer
local connection
local character

local function SetCharacter(char)
    character = char
end

SetCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(SetCharacter)

local function StartLoop()
    if connection then return end

    connection = RunService.Stepped:Connect(function()
        if NoClip.Enabled and character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function StopLoop()
    if connection then
        connection:Disconnect()
        connection = nil
    end

    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

function NoClip:Enable()
    if self.Enabled then return end
    self.Enabled = true
    StartLoop()
end

function NoClip:Disable()
    if not self.Enabled then return end
    self.Enabled = false
    StopLoop()
end

function NoClip:drawModule(MainTab, Notifier)
    local Folder = MainTab.Folder("NoClip", "[Info] Disable walls collision")

    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            Notifier:Send("[Legacy.wip] NoClip - Enable!", 4)
            self:Enable()
        else
            Notifier:Send("[Legacy.wip] NoClip - Disable!", 4)
            self:Disable()
        end
    end)

    return self
end

return NoClip