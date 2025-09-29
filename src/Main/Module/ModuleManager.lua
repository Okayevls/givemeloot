local ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager:drawCategory(Window, ModuleLoader)
    local loader = ModuleLoader

    loader:Init({
        Aimbot = "src/Main/Module/Impl/AimBot.lua",
        DesyncPosition = "src/Main/Module/Impl/DesyncPosition.lua"
    })

    local CombatTab = Window.Tab("Combat", 7485051733)
    local CharacterTab = Window.Tab("Character", 16149111790)

    local Aimbot = loader:Get("Aimbot")
    if Aimbot then
        Aimbot:drawModule(CombatTab)
    else
        warn("[ModuleManager] ❌ Aimbot module is nil!")
    end

    local DesyncPosition = loader:Get("DesyncPosition")
    if DesyncPosition then
        DesyncPosition:drawModule(CharacterTab)
    else
        warn("[ModuleManager] ❌ DesyncPosition module is nil!")
    end
end


return ModuleManager
