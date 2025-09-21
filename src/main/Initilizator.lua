local body = game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/main/util/chat/UChat.lua")
local chunk = loadstring(body)
local Util = chunk()

Util.chat.sendMessage("Hello World!!!")
