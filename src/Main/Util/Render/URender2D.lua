local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local RenderUtil = {}
RenderUtil.__index = RenderUtil

RenderUtil.shapes = {}

function RenderUtil:drawRoundedRectangle(x, y, width, height, cornerRadius, color, alpha)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, width or 100, 0, height or 50)
    frame.Position = UDim2.new(0, x or 0, 0, y or 0)
    frame.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = alpha or 0
    frame.BorderSizePixel = 0
    frame.Parent = screenGui.Parent

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
