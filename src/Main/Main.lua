
local ClassLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Core/ClassLoader.lua"))()

local modules = {
    Chat    = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Chat/UChat.lua",
    Render  = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/URender2D.lua",
    FontRender  = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/UFontRenderer.lua",

    Updater = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Update/Updater.lua",
}

ClassLoader:Init(modules)

local Chat = ClassLoader:Get("Chat")
local Updater = ClassLoader:Get("Updater")
local Render = ClassLoader:Get("Render")
local FontRender = ClassLoader:Get("FontRender")

local updaterInstance = Updater:new()

Chat.chat.sendMessage("Created By Prokosik x Flyaga other Sucked Dick")

--Render:drawRoundedRectangle(screenGui, 100, 50, 200, 100, 15, Color3.fromRGB(25, 25, 25), 0.2)
--FontRender:renderText(screenGui, "Привет, Roblox!", 24, 100, 50, Color3.fromRGB(255, 255, 255), 0.2)
