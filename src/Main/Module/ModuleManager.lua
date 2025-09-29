local ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager.new()
    local self = setmetatable({}, ModuleManager)
    return self
end

function ModuleManager:LoadAndDrawCategory(ModuleLoader, category, MainTab)
    assert(ModuleLoader, "[ModuleManager] ModuleLoader required")

    local modules = {}
    if category == "Combat" then
        modules = {
            Aimbot = "src/Main/Module/Impl/Aimbot.lua"
        }
    elseif category == "Character" then
        modules = {
            DesyncPosition = "src/Main/Module/Impl/DesyncPosition.lua"
        }
    else
        warn("[ModuleManager] Unknown category:", category)
        return
    end

    ModuleLoader:Init({ [category] = modules })

    for name, _ in pairs(modules) do
        local success, mod = pcall(function()
            return ModuleLoader:Get(category, name)
        end)
        if success and mod and type(mod.drawModule) == "function" then
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
