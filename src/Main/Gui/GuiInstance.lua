
local GuiInstance = {}
GuiInstance.__index = GuiInstance

function GuiInstance:drawGuiCore(ModuleLoader, GuiRenderer, ModuleManager)
    local Window = GuiRenderer.new("Morphis", "Anomic - vBeta I", 4370345701)

    local tabs = {
        Combat = Window.Tab("Combat", 7485051733),
        Character = Window.Tab("Character", 16149111790)
    }

    for category, tab in pairs(tabs) do
        if tab then
            ModuleManager:drawCategory(ModuleLoader, category, tab)
        end
    end
end

return GuiInstance
