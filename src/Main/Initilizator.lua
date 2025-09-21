if _G.__G_injected then
    getRep().sendMessage("Скрипт уже загружен!")
    return
end
_G.__G_injected = true

local getRep = 'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/'
local loadRender = loadstring(game:HttpGet(getRep .. 'Util/Render/URender2D.lua'))
local RenderUtil = loadRender()

RenderUtil:drawRoundedRectangle(100, 100, 200, 100, true, Color3.fromRGB(255,0,0))

local function uninject()
    getRep().sendMessage('Uninjecting...')
    if RenderUtil and RenderUtil.Clear then
        RenderUtil:Clear()
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
