local Speed = {}
Speed.__index = Speed

Speed.Enabled = false
Speed.SpeedMultiplier = 2

function Speed:Enable()
    if self.Enabled then return end
    self.Enabled = true

end

function Speed:Disable()
    self.Enabled = false
end

function Speed:drawModule(MainTab)
    local Folder = MainTab.Folder("Speed", "[Info] Acceleration of player movement")

    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            self:Enable()
        else
            self:Disable()
        end
    end)

    Folder.Slider("Speed Multiplier", {Default = self.SpeedMultiplier, Min = 1, Max = 15, Precise = true}, function(value)
        self.SpeedMultiplier = value
    end)

    return self
end

return Speed
