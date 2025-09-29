local ModuleLoader = {}
ModuleLoader.__index = ModuleLoader
ModuleLoader.loadedModules = {}

-- Загрузка кода модуля с GitHub
local function LoadGitHubScript(path)
    if type(path) ~= "string" then
        warn("[LoadGitHubScript] ❌ Expected string path, got", type(path))
        return nil
    end

    local repoUser = "Okayevls"
    local repoName = "givemeloot"
    local branch = "main"

    local rawUrl = "https://raw.githubusercontent.com/"..repoUser.."/"..repoName.."/"..branch.."/"..path
    local success, result = pcall(function()
        return game:HttpGet(rawUrl, true)
    end)

    if success then
        return result
    else
        warn("[LoadGitHubScript] ❌ Failed to fetch:", path)
        return nil
    end
end

-- modules: table вида Category -> { Name -> path (string) }
function ModuleLoader:Init(modules)
    for category, mods in pairs(modules) do
        self.loadedModules[category] = self.loadedModules[category] or {}

        for name, path in pairs(mods) do
            if type(path) ~= "string" then
                warn(("[ModuleLoader] ❌ Path for %s/%s is not a string, got %s"):format(category, name, type(path)))
            else
                local code = LoadGitHubScript(path)
                if code then
                    local success, result = pcall(function()
                        return loadstring(code)()
                    end)
                    if success and result then
                        self.loadedModules[category][name] = result
                        print(("[ModuleLoader] ✅ Loaded: %s / %s"):format(category, name))
                    else
                        warn(("[ModuleLoader] ❌ Error loading module %s/%s -> %s"):format(category, name, result))
                    end
                end
            end
        end
    end
end

function ModuleLoader:Get(category, name)
    return self.loadedModules[category] and self.loadedModules[category][name]
end

return ModuleLoader
