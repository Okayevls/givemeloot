local http = require("socket.http")
local url = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/main/util/Util.lua"

local body, code = http.request(url)
if not body then
    error("Не удалось загрузить скрипт: " .. tostring(code))
end

local chunk = loadstring(body)
local Util = chunk()

Util.chat.sendMessage("Hello World!!!")
