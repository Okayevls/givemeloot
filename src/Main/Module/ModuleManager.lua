local ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager:drawCategory(Window, ModuleLoader)
    local loader = ModuleLoader

    loader:Init({
        AimBot = "src/Main/Module/Impl/AimBot.lua",
        DesyncPosition = "src/Main/Module/Impl/DesyncPosition.lua",
        Speed = "src/Main/Module/Impl/Speed.lua"
    })

    local CombatTab = Window.Tab("Combat", 7485051733)
    local CharacterTab = Window.Tab("Character", 16149111790)

    local Aimbot = loader:Get("AimBot"):drawModule(CombatTab)

    local DesyncPosition = loader:Get("DesyncPosition"):drawModule(CharacterTab)
    local Speed = loader:Get("Speed"):drawModule(CharacterTab)

end

return ModuleManager
