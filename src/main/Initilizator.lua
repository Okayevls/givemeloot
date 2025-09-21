
local chunk = loadstring(game:HttpGet('https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/main/util/Util.lua'))
if not chunk then
    error("Не удалось скомпилировать Util.lua")
end

local Util = chunk()
if not Util then
    error("Util.lua вернул nil")
end

Util.chat.sendMessage("Hello World!!!")
