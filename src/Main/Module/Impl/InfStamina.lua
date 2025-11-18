local InfStamina = {}
InfStamina.__index = InfStamina

InfStamina.Enabled = false

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local globals = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GlobalVariables"))
local useEnergyFunc = globals.UseEnergy

function InfStamina:Enable()
    if self.Enabled then return end
    self.Enabled = true

    if useEnergyFunc then
        local upvalues = debug.getupvalues(useEnergyFunc)
        local p_u_3 = upvalues[1]

        if p_u_3 and p_u_3.Variables then
            self._energyThread = task.spawn(function()
                while self.Enabled do
                    task.wait(0.01)
                    p_u_3.Variables.Energy = 100
                end
            end)
        end
    end
end

function InfStamina:Disable()
    self.Enabled = false
    if self._energyThread then
        task.cancel(self._energyThread)
        self._energyThread = nil
    end
end

function InfStamina:drawModule(MainTab)
    local Folder = MainTab.Folder("InfStamina", "[Info] Eliminates energy waste")
    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            self:Enable()
        else
            self:Disable()
        end
    end)

    return self
end

return InfStamina