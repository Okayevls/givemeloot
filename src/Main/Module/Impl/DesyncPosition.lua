local DesyncPosition = {}
DesyncPosition.__index = DesyncPosition

DesyncPosition.type = {}

function DesyncPosition:drawModule(Tabs)
    local playerGroup = Tabs.Character:AddLeftGroupbox('Position')

    playerGroup:AddToggle('desyncposition_toggle', {
        Text = 'Desync Position',
        Default = false,
        Callback = function(state)
            getgenv().desyncEnabled = state
            if state then

            else

            end
        end
    }):AddKeyPicker('desyncposition_toggle', {
        Default = 'T',
        Text = 'CDesync',
        Mode = 'Toggle',
        Callback = function(state)
            if game:GetService("UserInputService"):GetFocusedTextBox() then return end
            getgenv().cframeSpeedKeybindActive = state
        end,
    })

    return playerGroup
end

return DesyncPosition
