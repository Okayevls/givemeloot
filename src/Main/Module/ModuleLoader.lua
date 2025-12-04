local ModuleLoader = {}
ModuleLoader.__index = ModuleLoader
ModuleLoader.loadedModules = {}

local function LoadGitHubScript(path)
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

function ModuleLoader:Init(modules)
    for name, path in pairs(modules) do
        local code = LoadGitHubScript(path)
        if code then
            local success, result = pcall(function()
                return loadstring(code)()
            end)

            if success and result then
                self.loadedModules[name] = result
                print("[ModuleLoader] ✅ Module loaded:", name)
            else
                warn("[ModuleLoader] ❌ Error loading module:", name, result)
            end
        else
            warn("[ModuleLoader] ❌ Could not fetch module code:", name)
        end
    end
end

function ModuleLoader:Get(name)
    return self.loadedModules[name]
end

return ModuleLoader
