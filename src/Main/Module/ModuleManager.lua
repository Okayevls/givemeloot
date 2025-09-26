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
    Character = {  -- категория "Combat"
        DesyncPosition = "src/Main/Module/Impl/DesyncPosition.lua"
       -- KillAura       = "src/Main/Module/Impl/KillAura.lua",
    }--,
    --Render = {
    --    ESP        = "src/Main/Module/Impl/ESP.lua",
    --    Chams      = "src/Main/Module/Impl/Chams.lua",
    --},
    --Misc = {
    --    AutoFarm   = "src/Main/Module/Impl/AutoFarm.lua"
    --}
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

function ModuleLoader:drawModule(category, MainTab)
    local modules = self.loadedModules[category]
    if not modules then
        warn(("[ModuleLoader] Category '%s' not found"):format(category))
        return
    end

    for name, module in pairs(modules) do
        if module and type(module.drawModule) == "function" then
            local success, err = pcall(function()
                module:drawModule(MainTab)
            end)
            if not success then
                warn(("[ModuleLoader] Failed to draw module '%s' in category '%s': %s"):format(name, category, err))
            end
        else
            warn(("[ModuleLoader] Module '%s' in category '%s' missing drawModule function"):format(name, category))
        end
    end
end



return ModuleLoader
