local DesyncPosition = {}
DesyncPosition.__index = DesyncPosition

function DesyncPosition:drawModule(MainTab)
    local Folder = MainTab:Folder("Position Player", "[Info] Server position desync")

   --Folder:SwitchAndBinding("Position Desync", function(state)
   --    if state then
   --    else
   --    end
   --end)
end

return DesyncPosition


--local DesyncPosition = {}
--DesyncPosition.__index = DesyncPosition
--
--DesyncPosition.type = {}
--
--function DesyncPosition:drawModule(MainTab)
--    local Folder = MainTab.Folder("Position Player", "[Info] Controlling player server position")
--
--    Folder.SwitchAndBinding("Position Desync", function(Status)
--        print("Switch Triggered: " .. tostring(Status))
--    end)
--end
--
--return DesyncPosition
