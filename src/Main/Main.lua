
local EventLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Core/EventLoader.lua"))()

local modules = {
    Chat    = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Chat/UChat.lua",
    Render  = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/URender2D.lua",
    FontRender  = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/UFontRenderer.lua",

    Updater = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Update/Updater.lua",

    GuiRenderer = 'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Gui/GuiRenderer.lua',

    ModuleLoader = 'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/ModuleManager.lua'
}

EventLoader:Init(modules)

local Chat = EventLoader:Get("Chat")
local Updater = EventLoader:Get("Updater")
local Render = EventLoader:Get("Render")
local FontRender = EventLoader:Get("FontRender")
local GuiRenderer = EventLoader:Get("GuiRenderer")
local ModuleLoader = EventLoader:Get("ModuleLoader")

local updaterReconnect = Updater:new()

local Window = GuiRenderer.new("ClosedPvP UI", "v0.0.1", 4370345701)

local Tab1 = Window.Tab("Tab 1", 6026568198)

local Folder = Tab1.Folder("Options", "A bunch of options you can use")
Folder.Button("Button", function()
    print("Button Clicked")
end)
Folder.Switch("Switch", function(Status)
    print("Switch Triggered: " .. tostring(Status))
end)
Folder.Toggle("Toggle", function(Status)
    print("Toggle Triggered: " .. tostring(Status))
end)

Folder.Button("Test Button", function()
    print("Button Triggered!")
end):Keybind(Enum.KeyCode.E)



Chat.chat.sendMessage("Created by Prokosik x Flyaga other sucked dick")
Chat.chat.sendMessage("Build to loading 000000002")



