local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local NoClip = {}
NoClip.__index = NoClip

NoClip.Enabled = false
local player = Players.LocalPlayer
local connection
local character
local originalCollisions = {}

local function SetCharacter(char)
    character = char
    originalCollisions = {}
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            originalCollisions[part] = part.CanCollide
        end
    end
end

SetCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(SetCharacter)

local function StartLoop()
    if connection then return end

    connection = RunService.Stepped:Connect(function()
        if NoClip.Enabled and character then
            for part, _ in pairs(originalCollisions) do
                if part and part:IsA("BasePart") then
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

    for part, canCollide in pairs(originalCollisions) do
        if part and part:IsA("BasePart") then
            part.CanCollide = canCollide
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

return NoClip
