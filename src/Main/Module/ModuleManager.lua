local function LoadGitHubScript(user, repo, path, branch)
    branch = branch or "main"
    local httpService = game:GetService("HttpService")

    local apiUrl = "https://api.github.com/repos/"..user.."/"..repo.."/commits/"..branch
    local data = httpService:JSONDecode(game:HttpGet(apiUrl, true))
    local latestSHA = data["sha"]

    local rawUrl = "https://raw.githubusercontent.com/"..user.."/"..repo.."/"..latestSHA.."/"..path
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
            local code = LoadGitHubScript("Okayevls", "givemeloot", path)
            return loadstring(code)()
        end)
        if success then
            self.loadedModules[name] = result
        else
            warn("[ModuleLoader] X Error loading module:", name, result)
        end
    end
end

function ModuleLoader:drawMainModule(MainTab)
    local module = self.loadedModules.DesyncPosition
    if module and module.drawModule then
        module:drawModule(MainTab)
    else
        warn("[ModuleLoader] Module 'DesyncPosition' not loaded or missing drawModule function")
    end
end

return ModuleLoader
