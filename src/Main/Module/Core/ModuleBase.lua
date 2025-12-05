local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ModuleBase = {}
ModuleBase.__index = ModuleBase

function ModuleBase.new(name)
    return setmetatable({
        Name = name,
        Enabled = false,
        Connections = {},
        UI = {}
    }, ModuleBase)
end

function ModuleBase:AddConnection(conn)
    table.insert(self.Connections, conn)
end

function ModuleBase:DisconnectAll()
    for _, conn in ipairs(self.Connections) do
        if conn.Disconnect then conn:Disconnect() end
    end
    self.Connections = {}
end

function ModuleBase:Enable()
    if self.Enabled then return end
    self.Enabled = true

    self:AddConnection(RunService.RenderStepped:Connect(function(dt)
        if self.ERender then self:ERender(dt) end
    end))

    self:AddConnection(RunService.Heartbeat:Connect(function()
        if self.EUpdate then self:EUpdate() end
    end))

    self:AddConnection(UserInputService.InputBegan:Connect(function(input, gp)
        if self.EKeyInput then self:EKeyInput(input, gp) end
    end))

    self:AddConnection(UserInputService.InputEnded:Connect(function(input, gp)
        if self.EKeyUnInput then self:EKeyUnInput(input, gp) end
    end))
end

function ModuleBase:DrawUI(MainTab, Notifier)
    if not self.UI then return end
        local Folder = MainTab.Folder(self.Name, "[Info] Module controls")

    for _, item in ipairs(self.UI) do
        if item.type == "Switch" then
            Folder.SwitchAndBinding(item.name, function(state)
                self[item.prop] = state
            end)
        elseif item.type == "Slider" then
            Folder.Slider(item.name, {Min = item.min, Max = item.max, Default = item.default, Step = item.step or 1}, function(value)
                self[item.prop] = value
            end)
        end
    end
end

function ModuleBase:Disable()
    self.Enabled = false
    self:DisconnectAll()
end

return ModuleBase
