-- ModuleManager.lua
local ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager.new()
    return setmetatable({}, ModuleManager)
end

function ModuleManager:drawCategory(ModuleLoader, category, MainTab)
    assert(ModuleLoader, "[ModuleManager] ModuleLoader required")
    assert(category and type(category)=="string", "[ModuleManager] category required")

    local modules = {
        Combat = { Aimbot = "src/Main/Module/Impl/Aimbot.lua" },
        Character = { DesyncPosition = "src/Main/Module/Impl/DesyncPosition.lua" }
    }

    local categoryModules = modules[category]
    if not categoryModules then
        warn("[ModuleManager] Unknown category:", category)
        return
    end

    ModuleLoader:Init({ [category] = categoryModules })

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
