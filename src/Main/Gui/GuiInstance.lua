local GuiInstance = {}
GuiInstance.__index = GuiInstance

GuiInstance.type = {}

function GuiInstance:drawGuiCore(ModuleLoader, GuiRenderer, ModuleManager)
    local Window = GuiRenderer.new("Morphis", "Anomic - vBeta I", 4370345701)

    local CombatTab = Window.Tab("Combat", 7485051733)
    local CharacterTab = Window.Tab("Character", 16149111790)

    ModuleManager:LoadAndDrawCategory(ModuleLoader, "Combat", CombatTab)
    ModuleManager:LoadAndDrawCategory(ModuleLoader, "Character", CharacterTab)
end

return GuiInstance
