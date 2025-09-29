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

function ModuleManager:loadModules()
    self.loadedModules = {}

    for category, mods in pairs(self.modules) do
        self.loadedModules[category] = {}
        for name, path in pairs(mods) do
            print("[ModuleManager] 🔄 Loading module:", name, "from category:", category)
            local code = LoadGitHubScript(path)

            if code then
                local success, result = pcall(function()
                    return loadstring(code)()
                end)

                if success then
                    self.loadedModules[category][name] = result
                    print("[ModuleManager] ✅ Loaded:", category, "/", name)
                else
                    warn("[ModuleManager] ❌ Failed to load:", category, "/", name, "->", result)
                end
            else
                warn("[ModuleManager] ❌ Could not fetch module code:", name)
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