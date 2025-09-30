local Speed = {}
Speed.__index = Speed

Speed.type = {}

Speed.Enabled = false
Speed.SpeedMultiplier = 2
Speed._origWalkSpeed = nil

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function Speed:_getHumanoid()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return character:FindFirstChildOfClass("Humanoid")
end

function Speed:SetEnabled(state)
    self.Enabled = state and true or false
    local humanoid = self:_getHumanoid()
    if not humanoid then return end

    if self.Enabled then
        if not self._origWalkSpeed then
            self._origWalkSpeed = humanoid.WalkSpeed
        end
        humanoid.WalkSpeed = self._origWalkSpeed * self.SpeedMultiplier
    else
        if self._origWalkSpeed then
            humanoid.WalkSpeed = self._origWalkSpeed
        end
    end
end

function Speed:SetMultiplier(value)
    self.SpeedMultiplier = tonumber(value) or 1
    if self.Enabled then
        local humanoid = self:_getHumanoid()
        if humanoid and self._origWalkSpeed then
            humanoid.WalkSpeed = self._origWalkSpeed * self.SpeedMultiplier
        end
    end
end

function Speed:drawModule(MainTab)
    local Folder = MainTab.Folder("Speed", "[Info] Acceleration of player movement")

    Folder.SwitchAndBinding("Toggle", function(Status)
        self:SetEnabled(Status)
    end)

    Folder.Slider("Speed Multiplier", {Default = self.SpeedMultiplier, Min = 1, Max = 10, Precise = true}, function(value)
        self:SetMultiplier(value)
    end)

    return self
end

return Speed
