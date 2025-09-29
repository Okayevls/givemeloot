local ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager:drawCategory(Window, ModuleLoader)
    local loader = ModuleLoader

    loader:Init({
        Aimbot = "src/Main/Module/Impl/Aimbot.lua",
        DesyncPosition = "src/Main/Module/Impl/DesyncPosition.lua"
    })

    local CombatTab = Window.Tab("Combat", 7485051733)
    local CharacterTab = Window.Tab("Character", 16149111790)

    local Aimbot = loader:Get("Aimbot"):drawModule(CombatTab)
    local DesyncPosition = loader:Get("DesyncPosition"):drawModule(CharacterTab)

end

return ModuleManager
