local ClassLoader = {}
ClassLoader.__index = ClassLoader
ClassLoader.loadedModules = {}

function ClassLoader:Init(modules)
    for name, url in pairs(modules) do
        local success, result = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)

        if success and result then
            self.loadedModules[name] = result
            print("[ClassLoader] ✅ Модуль загружен:", name)
        else
            warn("[ClassLoader] ❌ Ошибка при загрузке модуля:", name, result)
        end
    end
end

function ClassLoader:Get(name)
    return self.loadedModules[name]
end

return ClassLoader
