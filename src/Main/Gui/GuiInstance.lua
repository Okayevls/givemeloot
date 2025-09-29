local GuiInstance = {}
GuiInstance.__index = GuiInstance

GuiInstance.type = {}

function GuiInstance:drawGuiCore(ModuleLoader, GuiRenderer, ModuleManager)
    local Window = GuiRenderer.new("Morphis", "Anomic - vBeta I", 4370345701)

    local CombatTab = Window.Tab("Combat", 7485051733)
    local CharacterTab = Window.Tab("Character", 16149111790)

    print("111111111")

    local drawCategoryCombat = ModuleManager:drawCategory(ModuleLoader,"Combat", CombatTab)
    local drawCategoryCharacter = ModuleManager:drawCategory(ModuleLoader,"Character", CharacterTab)
end

return GuiInstance
