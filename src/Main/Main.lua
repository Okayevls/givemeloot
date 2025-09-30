local HttpService = game:GetService("HttpService")

local branch = "main"
local repoUser = "Okayevls"
local repoName = "givemeloot"

local apiUrl = "https://api.github.com/repos/"..repoUser.."/"..repoName.."/commits/"..branch
local data = HttpService:JSONDecode(game:HttpGet(apiUrl))
local latestSHA = data["sha"]

local modules = {
    Chat        = "src/Main/Util/Chat/UChat.lua",
    Render      = "src/Main/Util/Render/URender2D.lua",
    FontRender  = "src/Main/Util/Render/UFontRenderer.lua",
    Updater     = "src/Main/Module/Update/Updater.lua",
    GuiRenderer = "src/Main/Gui/GuiRenderer.lua",
    GuiInstance = "src/Main/Gui/GuiInstance.lua",
    ModuleManager = "src/Main/Module/ModuleManager.lua",
    ModuleLoader  = "src/Main/Core/ModuleLoader.lua",
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

local Chat         = EventLoader:Get("Chat")
local Updater      = EventLoader:Get("Updater")
local Render       = EventLoader:Get("Render")
local FontRender   = EventLoader:Get("FontRender")
local GuiRenderer  = EventLoader:Get("GuiRenderer")
local GuiInstance  = EventLoader:Get("GuiInstance")
local ModuleManager= EventLoader:Get("ModuleManager")
local ModuleLoader = EventLoader:Get("ModuleLoader")

local updaterReconnect = Updater:new()

GuiInstance:drawGuiCore(ModuleLoader, GuiRenderer, ModuleManager)

Chat.chat.sendMessage("Created by Prokosik x Flyaga other sucked dick")
