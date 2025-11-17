local AspectRatio = {}
AspectRatio.__index = AspectRatio

AspectRatio.Enabled = false
AspectRatio.Resolution = 1.0

local Camera = workspace.CurrentCamera

function AspectRatio:Enable()
    if self.Enabled then return end
    self.Enabled = true
end

function AspectRatio:Disable()
    self.Enabled = false
end

game:GetService("RunService").RenderStepped:Connect(function()
    if AspectRatio.Enabled then
        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, AspectRatio.Resolution, 0, 0, 0, 1)
    end
end)

function AspectRatio:drawModule(MainTab)
    local Folder = MainTab.Folder("AspectRatio", "[Info] Stretches the screen")
    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            self:Enable()
        else
            self:Disable()
        end
    end)

    Folder.Slider("Resolution", { Min = 0, Max = 1, Default = 1, Step = 0.01 }, function(value)
        self.Resolution = value
    end)

    return self
end

return AspectRatio