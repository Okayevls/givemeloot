local ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager:drawCategory(Window, ModuleLoader, Notifier)
    local loader = ModuleLoader

    loader:Init({
        SilentAim = "src/Main/Module/Impl/SilentAim.lua",
        Fly = "src/Main/Module/Impl/Fly.lua",
        ChatSpy = "src/Main/Module/Impl/ChatSpy.lua",
        RedeemCode = "src/Main/Module/Impl/RedeemCode.lua",
        Esp = "src/Main/Module/Impl/Esp.lua",
        AspectRatio = "src/Main/Module/Impl/AspectRatio.lua",
        NoClip = "src/Main/Module/Impl/NoClip.lua",
        JumpCircle = "src/Main/Module/Impl/JumpCircle.lua",
        FastInteract = "src/Main/Module/Impl/FastInteract.lua",
        StaffList = "src/Main/Module/Impl/StaffList.lua",
        Speed = "src/Main/Module/Impl/Speed.lua"
    })

    local CombatTab = Window.Tab("Combat", 7485051733)
    local CharacterTab = Window.Tab("Character", 16149111790)
    local VisualTab = Window.Tab("Visuals", 16149111790)
    local PlayerTab = Window.Tab("Player", 16149111790)
    local OtherTab = Window.Tab("Other", 16149111790)

    local SilentAim = loader:Get("SilentAim"):drawModule(CombatTab, Notifier)

    local Speed = loader:Get("Speed"):drawModule(CharacterTab, Notifier)
    local Fly = loader:Get("Fly"):drawModule(CharacterTab, Notifier)

    local Esp = loader:Get("Esp"):drawModule(VisualTab, Notifier)
    local AspectRatio = loader:Get("AspectRatio"):drawModule(VisualTab, Notifier)
    local JumpCircle = loader:Get("JumpCircle"):drawModule(VisualTab, Notifier)
    local StaffList = loader:Get("StaffList"):drawModule(VisualTab, Notifier)

    local NoClip = loader:Get("NoClip"):drawModule(PlayerTab, Notifier)
    local FastInteract = loader:Get("FastInteract"):drawModule(PlayerTab, Notifier)

    local ChatSpy = loader:Get("ChatSpy"):drawModule(OtherTab, Notifier)
    local AutoRedeem = loader:Get("RedeemCode"):drawModule(OtherTab, Notifier)

    Notifier:Send("Base ModuleManager Build | 0x000000000170", 6)
end

return ModuleManager
