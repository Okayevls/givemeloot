local GuiInstance = {}
GuiInstance.__index = GuiInstance

GuiInstance.type = {}

function GuiInstance:drawGuiCore(GuiRenderer, ModuleManager)
    local Window = GuiRenderer.new("Morphis", "vBeta I", 4370345701)
    local MainTab = Window.Tab("Character", 6026568198)

    ModuleManager:loadEvent()
    ModuleManager:drawModule(MainTab)
end

return GuiInstance
