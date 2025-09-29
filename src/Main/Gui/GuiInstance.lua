local GuiInstance = {}
GuiInstance.__index = GuiInstance

GuiInstance.type = {}

function GuiInstance:drawGuiCore(ModuleLoader, GuiRenderer, ModuleManager)
    local Window = GuiRenderer.new("Morphis", "Anomic - vBeta I", 4370345701)

    ModuleManager:drawCategory(Window, ModuleLoader)
end

return GuiInstance
