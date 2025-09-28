local DesyncPosition = {}
DesyncPosition.__index = DesyncPosition

DesyncPosition.type = {}

function DesyncPosition:drawModule(MainTab)
    local Folder = MainTab.Folder("Position Player", "[Info] Controlling player server position")

    Folder.SwitchAndBinding("Fake Position", function(Status)
        
    end)
end

return DesyncPosition
