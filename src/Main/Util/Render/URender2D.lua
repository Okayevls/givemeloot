local RenderUtil = {}
RenderUtil.__index = RenderUtil

RenderUtil.shapes = {}

function RenderUtil:drawRoundedRectangle(x, y, width, height, glasses, color)
    local radius = math.min(width, height) * 0.1
    color = color or Color3.fromRGB(255,255,255)

    if glasses then
        local thickness = 2
        table.insert(self.shapes, self:CreateLine(Vector2.new(x+radius, y), Vector2.new(x+width-radius, y), color, thickness))
        table.insert(self.shapes, self:CreateLine(Vector2.new(x+radius, y+height), Vector2.new(x+width-radius, y+height), color, thickness))
        table.insert(self.shapes, self:CreateLine(Vector2.new(x, y+radius), Vector2.new(x, y+height-radius), color, thickness))
        table.insert(self.shapes, self:CreateLine(Vector2.new(x+width, y+radius), Vector2.new(x+width, y+height-radius), color, thickness))
        table.insert(self.shapes, self:CreateCircle(Vector2.new(x+radius, y+radius), radius, color, thickness))
        table.insert(self.shapes, self:CreateCircle(Vector2.new(x+width-radius, y+radius), radius, color, thickness))
        table.insert(self.shapes, self:CreateCircle(Vector2.new(x+radius, y+height-radius), radius, color, thickness))
        table.insert(self.shapes, self:CreateCircle(Vector2.new(x+width-radius, y+height-radius), radius, color, thickness))
    else
        table.insert(self.shapes, self:CreateRoundedRect(Vector2.new(x, y), Vector2.new(width, height), radius, color))
    end
end

function RenderUtil:CreateLine(from, to, color, thickness)
    local line = Drawing.new("Line")
    line.From = from
    line.To = to
    line.Color = color
    line.Thickness = thickness or 1
    line.Visible = true
    return line
end

function RenderUtil:CreateCircle(position, radius, color, thickness)
    local circle = Drawing.new("Circle")
    circle.Position = position
    circle.Radius = radius
    circle.Color = color
    circle.Thickness = thickness or 1
    circle.Filled = false
    circle.Visible = true
    return circle
end

function RenderUtil:CreateRoundedRect(position, size, radius, color)
    local rect = Drawing.new("Square")
    rect.Position = Vector2.new(position.X+radius, position.Y+radius)
    rect.Size = Vector2.new(size.X-2*radius, size.Y-2*radius)
    rect.Color = color
    rect.Filled = true
    rect.Visible = true

    return rect
end

function RenderUtil:Clear()
    for _, obj in ipairs(self.shapes) do
        if obj.Remove then obj:Remove() end
    end
    self.shapes = {}
end

return RenderUtil
