local ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager:drawCategory(Window, ModuleLoader)
    local loader = ModuleLoader

    loader:Init({
        AimBot = "src/Main/Module/Impl/AimBot.lua",
        Speed = "src/Main/Module/Impl/Speed.lua",
        Penis = "src/Main/Module/Impl/Penis.lua"
    })

    local CombatTab = Window.Tab("Combat", 7485051733)
    local CharacterTab = Window.Tab("Character", 16149111790)

    local Aimbot = loader:Get("AimBot"):drawModule(CombatTab)

    local Speed = loader:Get("Speed"):drawModule(CharacterTab)
    local Penis = loader:Get("Penis"):drawModule(CharacterTab)

end

return ModuleManager
