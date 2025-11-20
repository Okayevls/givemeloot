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


function ChatSpy:drawModule(MainTab, Notifier)
    local Folder = MainTab.Folder("ChatSpy", "[Info] Makes the chat visible")
    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            Notifier:Send("[Legacy.wip] ChatSpy - Enable!",6)
            self:Enable()
        else
            Notifier:Send("[Legacy.wip] ChatSpy - Disable!",6)
            self:Disable()
        end
    end)

    return self
end

return ChatSpy