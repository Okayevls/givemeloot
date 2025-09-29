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

local ModuleManager = {}
ModuleManager.__index = ModuleManager

ModuleManager.modules = {
    Combat = {
        Aimbot = "src/Main/Module/Impl/Aimbot.lua",
    },
    Character = {
        DesyncPosition = "src/Main/Module/Impl/DesyncPosition.lua",
    }
}

function ModuleManager:loadEvent()
    self.loadedModules = {}

    for category, mods in pairs(self.modules) do
        self.loadedModules[category] = {}
        for name, path in pairs(mods) do
            print("[DEBUG] Загружаем модуль:", name, "из категории:", category)
            local success, result = pcall(function()
                local code = LoadGitHubScript(path)
                print("[DEBUG] Загруженный код модуля "..name..":\n", code)
                local result = loadstring(code)()
            end)

            if success then
                self.loadedModules[category][name] = result
                print("[ModuleManager] ✅ Loaded:", category, "/", name)
            else
                warn("[ModuleManager] ❌ Error loading:", category, "/", name, "->", result)
            end
        end
    end
end

function ModuleManager:drawCategory(category, MainTab)
    local categoryModules = self.loadedModules[category]
    if not categoryModules then
        warn(("[ModuleManager] ⚠️ Category '%s' not found or no modules loaded."):format(category))
        return
    end

    for name, module in pairs(categoryModules) do
        if module and type(module.drawModule) == "function" then
            local success, err = pcall(function()
                module:drawModule(MainTab)
            end)
            if not success then
                warn(("[ModuleManager] ❌ Failed to draw module '%s' in '%s': %s"):format(name, category, err))
            end
        else
            warn(("[ModuleManager] ⚠️ Module '%s' in '%s' missing drawModule()"):format(name, category))
        end
    end
end

return ModuleManager
