local DesyncPosition = {}
DesyncPosition.__index = DesyncPosition

DesyncPosition.type = {}

function DesyncPosition:drawModule(Tabs)
    local playerGroup = Tabs.Character:AddLeftGroupbox('Player Position')
    playerGroup:AddToggle('desyncposition_toggle', {
        Text = 'Desync Position',
        Default = false,
        Callback = function(state)
            if state then
                print("True 1")
            else
                print("False 1")
            end
        end
    })
    return playerGroup
end

return DesyncPosition
