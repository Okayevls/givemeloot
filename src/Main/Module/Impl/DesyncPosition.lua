local DesyncPosition = {}
DesyncPosition.__index = DesyncPosition

DesyncPosition.type = {}

function DesyncPosition:drawModule(Tabs)
    local desyncGroup = Tabs.Character:AddLeftGroupbox('Desync Position')
end

return DesyncPosition
