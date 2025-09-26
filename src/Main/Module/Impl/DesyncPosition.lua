local DesyncPosition = {}
DesyncPosition.__index = DesyncPosition

DesyncPosition.type = {}

function DesyncPosition:drawModule(MainTab)
    local Folder = MainTab.Folder("[Info]", "Controlling player server position")

    Folder.SwitchAndBinding("Position Desync", function(Status)
        print("Switch Triggered: " .. tostring(Status))
    end)
end

return DesyncPosition
