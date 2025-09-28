local HttpService = game:GetService("HttpService")

local function LoadGitHubScript(user, repo, path, branch)
    branch = branch or "main"

    -- Получаем SHA последнего коммита
    local apiUrl = ("https://api.github.com/repos/%s/%s/commits/%s"):format(user, repo, branch)
    local success, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(apiUrl, true))
    end)

    if not success or not data or #data == 0 then
        error("[LoadGitHubScript] Failed to fetch commits for "..repo)
    end

    local latestSHA = data[1].sha

    -- Формируем URL для raw файла
    local rawUrl = ("https://raw.githubusercontent.com/%s/%s/%s/%s"):format(user, repo, latestSHA, path)

    local codeSuccess, code = pcall(function()
        return game:HttpGet(rawUrl, true)
    end)

    if not codeSuccess then
        error("[LoadGitHubScript] Failed to fetch raw script: "..path)
    end

    return code
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
            local func = assert(loadstring(code), "[ModuleLoader] loadstring failed for "..name)
            return func()
        end)
        if success then
            self.loadedModules[name] = result
        else
            warn("[ModuleLoader] Error loading module:", name, result)
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
