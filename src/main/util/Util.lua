local Util = {}
Util.__index = Util

Util.chat = {}

function Util.chat.sendMessage(msg)
    print("[CHAT] " .. tostring(msg))
end

return Util
