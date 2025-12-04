local GitHubLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Core/GitHubLoader.lua"))()

local loader = GitHubLoader.new("Okayevls", "givemeloot", "main")
loader:GetLatestSHA()

local manifest = loader:Load("src/resources/devoops/manifest.json")

local EventLoader = loader:Load(manifest.EventLoader)
local ModuleLoader = loader:Load(manifest.ModuleLoader)
local GuiRenderer = loader:Load(manifest.GuiRenderer)
local GuiInstance = loader:Load(manifest.GuiInstance)
local ModuleManager = loader:Load(manifest.ModuleManager)
local Updater = loader:Load(manifest.Updater)
local Notifier = loader:Load(manifest.Notifier)

Updater:new()
GuiInstance:drawGuiCore(ModuleLoader, GuiRenderer, ModuleManager, Notifier)
print("[Dev] Created by gargon x prokosik")

