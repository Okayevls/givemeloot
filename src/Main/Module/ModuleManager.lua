local ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager:drawCategory(ModuleLoader, MainTab)
    local loader = ModuleLoader

    loader:Init({
        Combat = {
            Aimbot = "src/Main/Module/Impl/Aimbot.lua"
        },
        Character = {
            DesyncPosition = "src/Main/Module/Impl/DesyncPosition.lua"
        }
    })

    if MainTab == "Combat" then
        local Aimbot = loader:Get("Aimbot"):drawModule(MainTab)
    end

    if MainTab == "Character" then
        local Desync = loader:Get("DesyncPosition"):drawModule(MainTab)
    end

end

return ModuleManager
