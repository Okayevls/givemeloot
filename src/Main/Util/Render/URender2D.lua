local RenderUtil = {}
RenderUtil.__index = RenderUtil

RenderUtil.shapes = {}

function RenderUtil:drawRoundedRectangle()

end

function RenderUtil:Clear()
    for _, obj in ipairs(self.shapes) do
        if obj.Remove then obj:Remove() end
    end
    self.shapes = {}
end

return RenderUtil
