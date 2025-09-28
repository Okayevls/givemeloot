local GuiInstance = {}
GuiInstance.__index = GuiInstance

GuiInstance.type = {}

function GuiInstance:drawGuiCore(Window, ModuleManager)
    local MainTab = Window.Tab("Character", 6026568198)

    ModuleManager:loadEvent()
    ModuleManager:drawModule(MainTab)
end

return GuiInstance
