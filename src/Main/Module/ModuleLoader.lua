local ModuleLoader = {}
ModuleLoader.__index = ModuleLoader
ModuleLoader.loadedModules = {}

function ModuleLoader:Init(modules)
    for name, url in pairs(modules) do
        local success, result = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)

        if success and result then
            self.loadedModules[name] = result
            print("[ModuleLoader] ✅ Модуль загружен:", name)
        else
            warn("[ModuleLoader] ❌ Ошибка при загрузке модуля:", name, result)
        end
    end
end

function ModuleLoader:Get(name)
    return self.loadedModules[name]
end

return ModuleLoader
