local EventLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Core/EventLoader.lua"))()

local GuiRenderer = {}
GuiRenderer.__index = GuiRenderer
GuiRenderer.shapes = {}

function GuiRenderer:drawGui()
    local Render = EventLoader:Get("Render")
    local Chat = EventLoader:Get("Chat")
    if not Render then
        warn("[GuiRenderer] ❌ Render модуль не найден!")
        return
    end

    local player = game.Players.LocalPlayer
    if not player then
        warn("[GuiRenderer] ❌ LocalPlayer не найден! Этот код нужно запускать в LocalScript.")
        return
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MyGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local success, err = pcall(function()
        Render:drawRoundedRectangle(screenGui, 100, 100, 200, 100, 15, Color3.fromRGB(15, 15, 15), 0.25)
    end)

    if not success then
        warn("[GuiRenderer] ❌ Ошибка при отрисовке: ", err)
    else
        print("[GuiRenderer] ✅ GUI успешно создан!")
    end

    if Chat and Chat.chat and Chat.chat.sendMessage then
        pcall(function()
            Chat.chat.sendMessage("Loading GUI...")
        end)
    else
        warn("[GuiRenderer] ⚠️ Chat модуль не найден или не поддерживает sendMessage")
    end
end

return GuiRenderer
