-- Утилита для загрузки скриптов с GitHub
local function LoadGitHubScript(user, repo, path, branch)
    branch = branch or "main"
    local apiUrl = "https://api.github.com/repos/"..user.."/"..repo.."/commits/"..branch
    local latestSHA = game:GetService("HttpService"):JSONDecode(game:HttpGet(apiUrl))["sha"]
    local rawUrl = "https://raw.githubusercontent.com/"..user.."/"..repo.."/"..latestSHA.."/"..path.."?v="..os.time()
    return loadstring(game:HttpGet(rawUrl))()
end

local ModuleLoader = {}
ModuleLoader.__index = ModuleLoader

ModuleLoader.modules = {
    DesyncPosition = "src/Main/Module/Impl/DesyncPosition.lua"
}

function ModuleLoader:loadEvent()
    self.loadedModules = {}
    for name, path in pairs(self.modules) do
        local success, module = pcall(LoadGitHubScript, "Okayevls", "givemeloot", path)
        if success then
            self.loadedModules[name] = module
        else
            warn("[ModuleLoader] Error loading module:", name, module)
        end
    end
end

function ModuleLoader:drawMainModule(MainTab)
    local desyncModule = self.loadedModules.DesyncPosition
    if desyncModule and desyncModule.drawModule then
        desyncModule:drawModule(MainTab)
    else
        warn("[ModuleLoader] Module 'DesyncPosition' not loaded or missing drawModule function")
    end
end

return ModuleLoader
