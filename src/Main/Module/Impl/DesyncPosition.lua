local DesyncPosition = {}
DesyncPosition.__index = DesyncPosition

DesyncPosition.type = {}

function DesyncPosition:drawModule(MainTab)
    local Folder = MainTab.Folder("Position Player", "[Info1] Controlling player server position")

    Folder.SwitchAndBinding("Position Desync", function(Status)
        print("Switch Triggered: " .. tostring(Status))
    end)
end

return DesyncPosition
