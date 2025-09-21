local UChat = loadstring(game:HttpGet(
        'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Chat/UChat.lua'
))()

local RenderUtil = loadstring(game:HttpGet(
        'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/URender2D.lua'
))()

local version = 0.01

UChat().sendMessage('Скрипт Загружен | Версия ' .. version)
RenderUtil:drawRoundedRectangle(100, 100, 300, 150, 20, Color3.fromRGB(255,255,255), 0.25)
