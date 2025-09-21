local RenderUtil = {}
RenderUtil.__index = RenderUtil

RenderUtil.shapes = {}

function RenderUtil:drawRoundedRectangle(x, y, w, h, radius, color, transparency)
    local CoreGui = game:GetService("CoreGui")

    -- если первый раз используем – создаём ScreenGui
    if not self.ScreenGui then
        self.ScreenGui = Instance.new("ScreenGui")
        self.ScreenGui.Name = "RenderUtilGUI"
        self.ScreenGui.Parent = CoreGui
    end

    -- сам фрейм (основа ректа)
    local GlassRect = Instance.new("Frame", self.ScreenGui)
    GlassRect.Size = UDim2.new(0, w, 0, h)
    GlassRect.Position = UDim2.new(0, x, 0, y)
    GlassRect.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    GlassRect.BackgroundTransparency = transparency or 0.4
    GlassRect.BorderSizePixel = 0

    -- скругление
    local UICorner = Instance.new("UICorner", GlassRect)
    UICorner.CornerRadius = UDim.new(0, radius or 20)

    -- белая полупрозрачная обводка
    local UIStroke = Instance.new("UIStroke", GlassRect)
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Transparency = 0.6

    -- градиент для стеклянного эффекта
    local UIGradient = Instance.new("UIGradient", GlassRect)
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200,200,200))
    }
    UIGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 0.5)
    }

    -- создаём blur позади, если его ещё нет
    if not game.Lighting:FindFirstChild("RenderUtilBlur") then
        local Blur = Instance.new("BlurEffect")
        Blur.Name = "RenderUtilBlur"
        Blur.Size = 20
        Blur.Parent = game.Lighting
    end

    table.insert(self.shapes, GlassRect)
    return GlassRect
end

function RenderUtil:Clear()
    for _, obj in ipairs(self.shapes) do
        if obj.Remove then obj:Remove() end
    end
    self.shapes = {}
end

return RenderUtil
