local GuiInstance = {}
GuiInstance.__index = GuiInstance

GuiInstance.type = {}

function GuiInstance:drawGuiCore(Window, ModuleLoader)
    local MainTab = Window.Tab("Combat", 6026568198)

    ModuleLoader:loadEvent()
    ModuleLoader:drawModule(MainTab)
end

return GuiInstance
