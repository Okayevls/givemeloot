local ModuleLoader = {}
ModuleLoader.__index = ModuleLoader

ModuleLoader.type = {}

function ModuleLoader:drawAllModule(Tabs)
    local TargetingGroup = Tabs.Main:AddLeftGroupbox('Targeting')
end

return ModuleLoader
