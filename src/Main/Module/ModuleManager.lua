local ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager:drawCategory(ModuleLoader, Category, MainTab)
    local loader = ModuleLoader

    loader:Init({
        Aimbot = "src/Main/Module/Impl/Aimbot.lua",
        DesyncPosition = "src/Main/Module/Impl/DesyncPosition.lua"
    })

    if Category == "Combat" then
        local Aimbot = loader:Get("Aimbot")
        Aimbot:drawModule(MainTab)
    end

    if Category == "Character" then
        local Desync = loader:Get("DesyncPosition")
        Desync:drawModule(MainTab)
    end
end

return ModuleManager
