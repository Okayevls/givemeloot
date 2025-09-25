local EventLoader = {}
EventLoader.__index = EventLoader
EventLoader.loadedModules = {}

function EventLoader:Init(modules)
    for name, url in pairs(modules) do
        local success, result = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)

        if success and result then
            self.loadedModules[name] = result
            print("[EventLoader] ✅ Module loaded :", name)
        else
            warn("[EventLoader] ❌ Error loading module :", name, result)
        end
    end
end

function EventLoader:Get(name)
    return self.loadedModules[name]
end

return EventLoader
