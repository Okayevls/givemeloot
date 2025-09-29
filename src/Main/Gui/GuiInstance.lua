local GuiInstance = {}
GuiInstance.__index = GuiInstance

GuiInstance.type = {}

function GuiInstance:drawGuiCore(GuiRenderer, ModuleManager)
    local Window = GuiRenderer.new("Morphis", "TB3 3 - vBeta I", 4370345701)

    local CombatTab = Window.Tab("Combat", 7485051733)--6026568198)
    local CharacterTab = Window.Tab("Character", 16149111790)--6026568198)

    ModuleManager:loadEvent()

    ModuleManager:drawCategory("Combat", CombatTab)
    ModuleManager:drawCategory("Character", CharacterTab)
end

return GuiInstance
