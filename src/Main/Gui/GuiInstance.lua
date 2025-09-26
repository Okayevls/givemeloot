local GuiInstance = {}
GuiInstance.__index = GuiInstance

GuiInstance.type = {}

function GuiInstance:drawGuiCore(Window, ModuleLoader)
    local MainTab = Window.Tab("Character", 6026568198)

    ModuleLoader:loadEvent()
    ModuleLoader:drawModule("Character", MainTab)
end

return GuiInstance
