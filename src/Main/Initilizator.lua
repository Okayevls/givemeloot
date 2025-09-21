local getRep = loadstring(game:HttpGet('https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Chat/UChat.lua'))
local loadRender = loadstring(game:HttpGet('https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/URender2D.lua'))

loadRender():drawRoundedRectangle(100, 100, 200, 100, true, Color3.fromRGB(255,0,0))

if _G.__G_injected then
    getRep().sendMessage("Скрипт уже загружен!")
    return
end
_G.__G_injected = true

local function uninject()
    getRep().sendMessage('Uninjecting...')
    if loadRender() and loadRender().Clear then
        loadRender():Clear()
    end
    _G.__G_injected = false
    getRep().sendMessage('All cleaned!')
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Equals then
        uninject()
    end
end)
