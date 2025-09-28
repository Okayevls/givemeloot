local function LoadGitHubScript(path)
    local branch = "main"
    local repoUser = "Okayevls"
    local repoName = "givemeloot"

    local apiUrl = "https://api.github.com/repos/"..repoUser.."/"..repoName.."/commits/"..branch
    local data = game:GetService("HttpService"):JSONDecode(game:HttpGet(apiUrl))
    local latestSHA = data["sha"]

    local rawUrl = "https://raw.githubusercontent.com/"..repoUser.."/"..repoName.."/"..latestSHA.."/"..path
    return game:HttpGet(rawUrl, true)
end


local ModuleLoader = {}
ModuleLoader.__index = ModuleLoader

ModuleLoader.modules = {
    DesyncPosition = "src/Main/Module/Impl/DesyncPosition.lua"
}

function ModuleLoader:loadEvent()
    self.loadedModules = {}
    for name, path in pairs(self.modules) do
        local success, result = pcall(function()
            local code = LoadGitHubScript(path)
            return loadstring(code)()
        end)
        if success then
            self.loadedModules[name] = result
        else
            warn("[ModuleLoader] X Error loading module:", name, result)
        end
    end
end

function ModuleLoader:drawModule(MainTab)
    for name, module in pairs(self.loadedModules) do
        if module and type(module.drawModule) == "function" then
            local success, err = pcall(function()
                module:drawModule(MainTab)
            end)
            if not success then
                warn(("[ModuleLoader] Failed to draw module '%s': %s"):format(name, err))
            end
        else
            warn(("[ModuleLoader] Module '%s' missing drawModule function"):format(name))
        end
    end
end


return ModuleLoader
