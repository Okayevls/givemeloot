local apiUrl = "https://api.github.com/repos/Okayevls/repoName/commits/main"
local data = game:GetService("HttpService"):JSONDecode(game:HttpGet(apiUrl))
local latestSHA = data["sha"]
local rawUrl = "https://raw.githubusercontent.com/Okayevls/repoName/"..latestSHA.."/src/Main/Core/GitHubLoader.lua?v="..os.time()
local GitHubLoader = loadstring(game:HttpGet(rawUrl))()

local loader = GitHubLoader.new("Okayevls", "givemeloot", "main")
loader:GetLatestSHA()

local manifest = loader:LoadJSON("src/resources/devoops/manifest.json")

local ModuleLoader = loader:Load(manifest.ModuleLoader)
local GuiRenderer = loader:Load(manifest.GuiRenderer)
local GuiInstance = loader:Load(manifest.GuiInstance)
local ModuleManager = loader:Load(manifest.ModuleManager)
local Updater = loader:Load(manifest.Updater)
local Notifier = loader:Load(manifest.Notifier)

Updater:new()
GuiInstance:drawGuiCore(ModuleLoader, GuiRenderer, ModuleManager, Notifier)
print("[Dev] Created by gargon x prokosik")

