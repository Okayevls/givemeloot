local RenderUtil = {}
RenderUtil.__index = RenderUtil

RenderUtil.shapes = {}

function RenderUtil:drawRoundedRectangle(parent, size, position, color, cornerRadius)
    local frame = Instance.new("Frame")
    frame.Size = size or UDim2.new(0, 100, 0, 50)
    frame.Position = position or UDim2.new(0.5, -50, 0.5, -25)
    frame.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Parent = parent

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, cornerRadius or 10)
    uiCorner.Parent = frame

    table.insert(self.shapes, frame)

    return frame
end

function RenderUtil:Clear()
    for _, obj in ipairs(self.shapes) do
        if obj and obj.Destroy then
            obj:Destroy()
        end
    end
    self.shapes = {}
end

return RenderUtil
