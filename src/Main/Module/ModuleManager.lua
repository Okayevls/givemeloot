local ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager:drawCategory(Window, ModuleLoader)
    local loader = ModuleLoader

    loader:Init({
        SilentAim = "src/Main/Module/Impl/SilentAim.lua",
        Fly = "src/Main/Module/Impl/Fly.lua",
        ChatSpy = "src/Main/Module/Impl/ChatSpy.lua",
        Speed = "src/Main/Module/Impl/Speed.lua"
    })

    local CombatTab = Window.Tab("Combat", 7485051733)
    local CharacterTab = Window.Tab("Character", 16149111790)
    local OtherTab = Window.Tab("Other", 16149111790)

    local SilentAim = loader:Get("SilentAim"):drawModule(CombatTab)

    local Speed = loader:Get("Speed"):drawModule(CharacterTab)
    local Fly = loader:Get("Fly"):drawModule(CharacterTab)

    local ChatSpy = loader:Get("ChaySpy"):drawModule(OtherTab)

    print("Base ModuleManager Build | 0x000000000115")

end

return ModuleManager
