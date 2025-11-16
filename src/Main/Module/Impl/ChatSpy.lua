local ChatSpy = {}
ChatSpy.__index = ChatSpy

ChatSpy.Enabled = false

local TextChatService = game:GetService("TextChatService")

function ChatSpy:Enable()
    if self.Enabled then return end
    self.Enabled = true
    TextChatService.ChatWindowConfiguration.Enabled = true
end

function ChatSpy:Disable()
    self.Enabled = false
    TextChatService.ChatWindowConfiguration.Enabled = false
end


function ChatSpy:drawModule(MainTab)
    local Folder = MainTab.Folder("Fly", "[Info] Allows the player to fly")
    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            self:Enable()
        else
            self:Disable()
        end
    end)

    return self
end

return ChatSpy