
local function LoadGitHubScript(user, repo, path, branch)
    branch = branch or "main"
    local HttpService = game:GetService("HttpService")

    local apiUrl = ("https://api.github.com/repos/%s/%s/commits/%s"):format(user, repo, branch)
    local data = HttpService:JSONDecode(game:HttpGet(apiUrl))
    local sha = data["sha"]

    local rawUrl = ("https://raw.githubusercontent.com/%s/%s/%s/%s?v=%d"):format(user, repo, sha, path, os.time())
    return loadstring(game:HttpGet(rawUrl))()
end

local ModuleLoader = {}
ModuleLoader.__index = ModuleLoader

ModuleLoader.type = {}

local EventLoader = LoadGitHubScript("Okayevls", "givemeloot", "src/Main/Core/ModuleLoader.lua")

local modules = {
    DesyncPosition = "src/Main/Module/Impl/DesyncPosition.lua",
}

function ModuleLoader:loadEvent()
    for name, path in pairs(modules) do
        modules[name] = LoadGitHubScript("Okayevls", "givemeloot", path)
    end
    EventLoader:Init(modules)
end

function ModuleLoader:drawMainModule(MainTab)
    local desyncLoader = EventLoader:Get("DesyncPosition"):drawModule(MainTab)
end

return ModuleLoader
