local GuiInstance = {}
GuiInstance.__index = GuiInstance

function GuiInstance:drawGuiCore(ModuleLoader, GuiRenderer, ModuleManager)
    assert(ModuleLoader, "[GuiInstance] ModuleLoader required")
    assert(GuiRenderer, "[GuiInstance] GuiRenderer required")
    assert(ModuleManager, "[GuiInstance] ModuleManager required")

    local Window = GuiRenderer.new("Morphis", "TB3 - vBeta I", 4370345701)

    -- Создаём вкладки динамически для всех категорий из ModuleLoader
    local categories = { "Combat", "Character" } -- Можно добавить новые категории сюда
    for _, category in ipairs(categories) do
        local tab = Window.Tab(category, 0)
        if tab then
            ModuleManager:LoadAndDrawCategory(ModuleLoader, category, tab)
        else
            warn("[GuiInstance] ⚠️ Failed to create tab for category:", category)
        end
    end
end

return GuiInstance
