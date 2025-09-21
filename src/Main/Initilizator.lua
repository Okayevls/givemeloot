local UChat = loadstring(game:HttpGet(
        'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Chat/UChat.lua'
))()

local ModuleInitilizator = loadstring(game:HttpGet(
        'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/ModuleInitilizator.lua'
))()

local URender2D = loadstring(game:HttpGet(
        'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/URender2D.lua'
))()

local version = 0.01

UChat.chat.sendMessage('Скрипт Загружен | Версия ' .. version)
ModuleInitilizator.get.new()

