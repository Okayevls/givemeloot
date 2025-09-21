local Util = {}
Util.__index = Util

Util.chat = {}

function Util.chat.sendMessage(msg)
    print("[Dev] " + msg)
end

return Util
