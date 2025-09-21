local UChat = loadstring(game:HttpGet('https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Chat/UChat.lua'))()
local RenderUtil = loadstring(game:HttpGet('https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/URender2D.lua'))()

if _G.__G_injected then
    UChat.chat.sendMessage("Скрипт уже загружен!")
    return
end
_G.__G_injected = true

RenderUtil:drawRoundedRectangle(100, 100, 200, 100, true, Color3.fromRGB(255,0,0))

local function uninject()
    UChat.chat.sendMessage('Uninjecting...')
    if RenderUtil and RenderUtil.Clear then
        RenderUtil:Clear()
    end
    _G.__G_injected = false
    UChat.chat.sendMessage('All cleaned!')
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Equals then
        uninject()
    end
end)
