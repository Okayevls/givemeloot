
local EventLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Core/EventLoader.lua"))()

local modules = {
    Chat    = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Chat/UChat.lua",
    Render  = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/URender2D.lua",
    FontRender  = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/UFontRenderer.lua",

    Updater = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Update/Updater.lua",

    GuiRenderer = 'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Gui/GuiRenderer.lua',
    GuiThemeManager = 'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Gui/ThemeManager.lua',
    GuiSaveManager = 'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Gui/SaveManager.lua',

    Category = 'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Category.lua',

    ModuleLoader = 'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/ModuleLoader.lua'
}

EventLoader:Init(modules)

local Chat = EventLoader:Get("Chat")
local Updater = EventLoader:Get("Updater")
local Render = EventLoader:Get("Render")
local FontRender = EventLoader:Get("FontRender")

local GuiRenderer = EventLoader:Get("GuiRenderer")
local Category = EventLoader:Get("Category")
local GuiThemeManager = EventLoader:Get("ThemeManager")
local GuiSaveManager = EventLoader:Get("SaveManager")

local ModuleLoader = EventLoader:Get("ModuleLoader")

local updaterReconnect = Updater:new()

local Window = GuiRenderer:CreateWindow({ Title = '                     $ ClosedPvP.lucky | Beta $                     ', AutoShow = true, TabPadding = 15, MenuFadeTime = 0.2 })
local Tabs = {
Main = Window:AddTab('Main'),
Character = Window:AddTab('Character'),
Visuals = Window:AddTab('Visuals'),
Misc = Window:AddTab('Misc'),
Players = Window:AddTab('Players'),
['UI Settings'] = Window:AddTab('Settings')
}

ModuleLoader:drawAllModule(Tabs)

Chat.chat.sendMessage("Created by Prokosik x Flyaga other sucked dick")



