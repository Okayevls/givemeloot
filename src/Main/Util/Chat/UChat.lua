local Chat = {}
Chat.__index = Chat

Chat.chat = {}

function Chat.chat.sendMessage(msg)
    print("[Dev] " .. msg)
end

return Chat

