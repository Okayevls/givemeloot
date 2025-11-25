local HttpService = game:GetService("HttpService")

local branch = "main"
local repoUser = "Okayevls"
local repoName = "givemeloot"

local apiUrl = "https://api.github.com/repos/"..repoUser.."/"..repoName.."/commits/"..branch
local data = HttpService:JSONDecode(game:HttpGet(apiUrl))
local latestSHA = data["sha"]

local modules = {
    Chat          = "src/Main/Util/Chat/UChat.lua",
    Updater       = "src/Main/Module/Update/Updater.lua",
    GuiRenderer   = "src/Main/Gui/GuiRenderer.lua",
    GuiInstance   = "src/Main/Gui/GuiInstance.lua",
    ModuleManager = "src/Main/Module/ModuleManager.lua",
    ModuleLoader  = "src/Main/Core/ModuleLoader.lua",
    GuiInstance   = "src/Main/Gui/GuiPanel.lua",
    EventLoader   = "src/Main/Core/EventLoader.lua"
}

local function getRawURL(path)
    return "https://raw.githubusercontent.com/"..repoUser.."/"..repoName.."/"..latestSHA.."/"..path.."?v="..os.time()
end

local EventLoader = loadstring(game:HttpGet(getRawURL(modules.EventLoader)))()

for key, path in pairs(modules) do
    modules[key] = getRawURL(path)
end

EventLoader:Init(modules)

local Chat          = EventLoader:Get("Chat")
local Updater       = EventLoader:Get("Updater")
local GuiRenderer   = EventLoader:Get("GuiRenderer")
local GuiInstance   = EventLoader:Get("GuiInstance")
local ModuleManager = EventLoader:Get("ModuleManager")
local ModuleLoader  = EventLoader:Get("ModuleLoader")

local GuiPanel  = EventLoader:Get("GuiPanel")

local updaterReconnect = Updater:new()

--GuiInstance:drawGuiCore(ModuleLoader, GuiRenderer, ModuleManager)
GuiInstance:drawGuiCore(ModuleLoader, GuiPanel, ModuleManager)
Chat.chat.sendMessage("Created by gargon x prokosik")

