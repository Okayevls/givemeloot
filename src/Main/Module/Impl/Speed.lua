-- src/Main/Module/Impl/Speed.lua
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Speed = {}
Speed.__index = Speed

-- дефолтные поля
Speed.Enabled = false
Speed.SpeedMultiplier = 1         -- множитель (1 = обычная скорость)
Speed._origWalkSpeed = nil        -- хранит оригинальную скорость Humanoid
Speed._updateConn = nil           -- коннектор для Heartbeat/RenderStepped

-- вспомогательная: получить humanoid игрока (без ошибки)
function Speed:_getHumanoid()
    if not LocalPlayer then return nil end
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if not character then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid
end

-- применить текущие настройки
function Speed:Apply()
    local humanoid = self:_getHumanoid()
    if not humanoid then
        print("[Speed] Humanoid not found, cannot apply.")
        return
    end

    -- если оригинальная скорость еще не сохранена, сохраняем
    if not self._origWalkSpeed then
        self._origWalkSpeed = humanoid.WalkSpeed or 16
        print("[Speed] Saved original WalkSpeed =", self._origWalkSpeed)
    end

    if self.Enabled then
        local newSpeed = (self._origWalkSpeed or 16) * (tonumber(self.SpeedMultiplier) or 1)
        humanoid.WalkSpeed = newSpeed
        print(string.format("[Speed] Enabled — WalkSpeed set to %.2f (multiplier %.2f)", newSpeed, self.SpeedMultiplier))
    else
        humanoid.WalkSpeed = self._origWalkSpeed or 16
        print("[Speed] Disabled — WalkSpeed restored to", self._origWalkSpeed)
    end
end

-- начать следить (например, при включении)
function Speed:Start()
    if self._updateConn then return end
    -- Обновляем каждый кадр, чтобы учесть смену персонажа и быстрые изменения
    self._updateConn = RunService.Heartbeat:Connect(function()
        -- если персонаж исчез/сменился, восстановим оригинальную скорость при необходимости
        local humanoid = self:_getHumanoid()
        if humanoid then
            -- если Enabled — убедимся, что WalkSpeed соответствует настройке
            if self.Enabled then
                local desired = (self._origWalkSpeed or humanoid.WalkSpeed) * (tonumber(self.SpeedMultiplier) or 1)
                if humanoid.WalkSpeed ~= desired then
                    humanoid.WalkSpeed = desired
                end
            else
                -- если выключен, убедимся, что скорость равна оригинальной
                if self._origWalkSpeed and humanoid.WalkSpeed ~= self._origWalkSpeed then
                    humanoid.WalkSpeed = self._origWalkSpeed
                end
            end
        end
    end)
end

-- остановить следить (например, при выгрузке)
function Speed:Stop()
    if self._updateConn then
        self._updateConn:Disconnect()
        self._updateConn = nil
    end
end

-- переключение включения
function Speed:SetEnabled(state)
    self.Enabled = state and true or false
    print("[Speed] SetEnabled ->", tostring(self.Enabled))
    self:Apply()
    if self.Enabled then
        self:Start()
    else
        -- Restore will be applied in Apply(); можно остановить цикл
        self:Stop()
    end
end

-- смена множителя
function Speed:SetMultiplier(value)
    local num = tonumber(value) or 1
    if num < 0.1 then num = 0.1 end
    self.SpeedMultiplier = num
    print("[Speed] SetMultiplier ->", tostring(self.SpeedMultiplier))
    if self.Enabled then
        self:Apply()
    end
end

function Speed:drawModule(MainTab)
    local Folder = MainTab.Folder("Speed", "[Info] Acceleration of player movement")

    if not self.SpeedMultiplier then self.SpeedMultiplier = 1 end
    if self.Enabled == nil then self.Enabled = false end

    Folder.SwitchAndBinding("Toggle", function(Status)
        local enabled = false
        if type(Status) == "boolean" then
            enabled = Status
        elseif type(Status) == "table" and Status.Value ~= nil then
            enabled = Status.Value
        end
        self:SetEnabled(enabled)
    end)

    Folder.Slider("Speed Multiplier", {Default = self.SpeedMultiplier, Min = 1, Max = 150, Precise = true}, function(value)
        -- value должен быть числом
        self:SetMultiplier(value)
    end)

    -- дополнительный вывод в GUI: показать текущую скорость (можно добавить Label, если GUI поддерживает)
    print("[Speed] drawModule complete (Enabled="..tostring(self.Enabled)..", Mult="..tostring(self.SpeedMultiplier)..")")

    return self
end

-- если модуль создаётся через require, вернём объект-прототип
return Speed
