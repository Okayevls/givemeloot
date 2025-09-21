local RenderUtil = {}
RenderUtil.__index = RenderUtil

RenderUtil.shapes = {}

function RenderUtil:drawRoundedRectangle(x, y, w, h, radius, color, transparency)
    color = color or Color3.fromRGB(255, 255, 255)
    radius = radius or 12
    transparency = transparency or 0.3

    -- центральный квадрат
    local rect = Drawing.new("Square")
    rect.Position = Vector2.new(x + radius, y + radius)
    rect.Size = Vector2.new(w - 2 * radius, h - 2 * radius)
    rect.Color = color
    rect.Filled = true
    rect.Transparency = transparency
    rect.Visible = true
    table.insert(self.shapes, rect)

    -- 4 боковые прямоугольные вставки (имитация боков)
    local top = Drawing.new("Square")
    top.Position = Vector2.new(x + radius, y)
    top.Size = Vector2.new(w - 2 * radius, radius)
    top.Color = color
    top.Filled = true
    top.Transparency = transparency
    top.Visible = true
    table.insert(self.shapes, top)

    local bottom = Drawing.new("Square")
    bottom.Position = Vector2.new(x + radius, y + h - radius)
    bottom.Size = Vector2.new(w - 2 * radius, radius)
    bottom.Color = color
    bottom.Filled = true
    bottom.Transparency = transparency
    bottom.Visible = true
    table.insert(self.shapes, bottom)

    local left = Drawing.new("Square")
    left.Position = Vector2.new(x, y + radius)
    left.Size = Vector2.new(radius, h - 2 * radius)
    left.Color = color
    left.Filled = true
    left.Transparency = transparency
    left.Visible = true
    table.insert(self.shapes, left)

    local right = Drawing.new("Square")
    right.Position = Vector2.new(x + w - radius, y + radius)
    right.Size = Vector2.new(radius, h - 2 * radius)
    right.Color = color
    right.Filled = true
    right.Transparency = transparency
    right.Visible = true
    table.insert(self.shapes, right)

    -- скругления (круги)
    local circles = {}
    local positions = {
        Vector2.new(x + radius, y + radius), -- TL
        Vector2.new(x + w - radius, y + radius), -- TR
        Vector2.new(x + radius, y + h - radius), -- BL
        Vector2.new(x + w - radius, y + h - radius) -- BR
    }

    for _, pos in ipairs(positions) do
        local circle = Drawing.new("Circle")
        circle.Position = pos
        circle.Radius = radius
        circle.Color = color
        circle.Filled = true
        circle.Transparency = transparency
        circle.Visible = true
        table.insert(self.shapes, circle)
        table.insert(circles, circle)
    end

    return {
        rect = rect,
        circles = circles,
        sides = { top, bottom, left, right }
    }
end

function RenderUtil:Clear()
    for _, obj in ipairs(self.shapes) do
        if obj.Remove then obj:Remove() end
    end
    self.shapes = {}
end

return RenderUtil
