local Util = {}
Util.__index = Util

Util.chat = {}

function Util.chat.sendMessage(msg)
    print("[Dev1] " .. msg)
end

return Util
