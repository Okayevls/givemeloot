local Speed = {}
Speed.__index = Speed

Speed.type = {}

function Speed:drawModule(MainTab)
    local Folder = MainTab.Folder("Speed", "[Info] Acceleration of player movement")

    Folder.SwitchAndBinding("Toggle", self.Enabled, function(Status)

    end)

    Folder.Slider("Speed Multiplier", {Default = self.SpeedMultiplier, Min = 1, Max = 150, Precise = true}, function(value)

    end)

    return self
end

return Speed
