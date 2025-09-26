local GuiInstance = {}
GuiInstance.__index = GuiInstance

GuiInstance.type = {}

function GuiInstance:drawGuiCore(Window, ModuleLoader)
    local MainTab = Window.Tab("Main", 6026568198)

    ModuleLoader:loadEvent()
    ModuleLoader:drawMainModule(MainTab)
end

return GuiInstance
