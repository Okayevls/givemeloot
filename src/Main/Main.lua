
local ClassLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Core/ClassLoader.lua"))()

local modules = {
    Chat    = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Chat/UChat.lua",
    Render  = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/URender2D.lua",
    FontRender  = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/UFontRenderer.lua",

    Updater = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Update/Updater.lua",
}

ClassLoader:Init(modules)

local Chat = ClassLoader:Get("Chat")
Chat.chat.sendMessage("Скрипт запущен!")

local Updater = ClassLoader:Get("Updater")
local updaterInstance = Updater:new()

local Render = ClassLoader:Get("Render")
local FontRender = ClassLoader:Get("FontRender")

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Gui/source.lua"))()

local Window = Rayfield:CreateWindow({
    Name = "Моя GUI Панель",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "Пожалуйста, подождите",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "MyConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "discord.gg/example",
        RememberJoins = true
    },
    KeySystem = false
})

local Tab = Window:CreateTab("Настройки")

Tab:CreateToggle({
    Name = "GodMode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(value)
        print("GodMode:", value)
    end
})

Tab:CreateSlider({
    Name = "Скорость",
    Range = {16, 500},
    Increment = 1,
    Suffix = " stud/s",
    CurrentValue = 50,
    Flag = "Speed",
    Callback = function(value)
        print("Скорость:", value)
    end
})

Tab:CreateColorPicker({
    Name = "Цвет UI",
    Default = Color3.fromRGB(255, 0, 0),
    Flag = "UIColor",
    Callback = function(color)
        print("Выбран цвет:", color)
    end
})

Tab:CreateDropdown({
    Name = "Режим",
    Options = {"Easy", "Normal", "Hard"},
    CurrentOption = "Normal",
    Flag = "Mode",
    Callback = function(option)
        print("Выбран режим:", option)
    end
})