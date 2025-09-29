local ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager.new()
    return setmetatable({ loadedCategories = {} }, ModuleManager)
end

-- Загружает и отрисовывает все модули категории на вкладке
function ModuleManager:LoadAndDrawCategory(ModuleLoader, category, MainTab)
    assert(ModuleLoader, "[ModuleManager] ModuleLoader required")
    assert(category and type(category)=="string", "[ModuleManager] category required")
    assert(MainTab, "[ModuleManager] MainTab required")

    -- Таблица модулей для каждой категории
    local modules = {
        Combat = { Aimbot = "src/Main/Module/Impl/Aimbot.lua" },
        Character = { DesyncPosition = "src/Main/Module/Impl/DesyncPosition.lua" }
    }

    local categoryModules = modules[category]
    if not categoryModules then
        warn("[ModuleManager] Unknown category:", category)
        return
    end

    -- Загружаем модули категории только если ещё не загружены
    if not self.loadedCategories[category] then
        ModuleLoader:Init({ [category] = categoryModules })
        self.loadedCategories[category] = true
    end

    -- Отрисовываем каждый модуль
    for name, _ in pairs(categoryModules) do
        local mod = ModuleLoader:Get(category, name)
        if mod and type(mod.drawModule) == "function" then
            local ok, err = pcall(function()
                mod:drawModule(MainTab)
            end)
            if not ok then
                warn(("[ModuleManager] ❌ Failed to draw module '%s' in '%s': %s"):format(name, category, err))
            end
        else
            warn(("[ModuleManager] ⚠️ Module '%s' in '%s' missing or invalid"):format(name, category))
        end
    end
end

return ModuleManager
