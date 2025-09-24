local UFontRenderer = {}
UFontRenderer.__index = UFontRenderer

UFontRenderer.texts = {}

function UFontRenderer:renderText(parent, text, size, x, y, color)
    local label = Instance.new("TextLabel")
    label.Text = text or "Text"
    label.Font = Enum.Font.SourceSans
    label.TextSize = size or 18
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, x or 0, 0, y or 0)
    label.Size = UDim2.new(0, 500, 0, size or 18)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.Parent = parent

    table.insert(self.texts, label)
    return label
end

function UFontRenderer:Clear()
    for _, obj in ipairs(self.texts) do
        if obj and obj.Destroy then
            obj:Destroy()
        end
    end
    self.texts = {}
end

return UFontRenderer
