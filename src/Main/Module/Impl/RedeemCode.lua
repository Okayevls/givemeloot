local RedeemCode = {}
RedeemCode.__index = RedeemCode

RedeemCode.Enabled = false
RedeemCode._Switch = nil

local CODES = {
    "20MVISITS",
    "20KLIKES"
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RedeemRemote = nil
local isFunction = false

local redeemed = {}
for _, code in ipairs(CODES) do
    redeemed[code] = false
end

local function findRemote()
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj.Name == "RedeemCode" and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            RedeemRemote = obj
            isFunction = obj:IsA("RemoteFunction")
            return true
        end
    end

    RedeemRemote = ReplicatedStorage:WaitForChild("RedeemCode", 10)
    if RedeemRemote then
        isFunction = RedeemRemote:IsA("RemoteFunction")
        return true
    end

    warn("[RedeemCode] Remote 'RedeemCode' не найден!")
    return false
end

local function redeem(code)
    if redeemed[code] then return end
    if not RedeemRemote then return end

    local success, result = pcall(function()
        if isFunction then
            return RedeemRemote:InvokeServer(code)
        else
            RedeemRemote:FireServer(code)
        end
    end)

    if success then
        redeemed[code] = true
        print("[RedeemCode] Активирован код:", code)
    else
        warn("[RedeemCode] Ошибка при вводе", code, ":", result)
    end
end

function RedeemCode:Run()
    if not self.Enabled then return end

    if not RedeemRemote then
        if not findRemote() then
            warn("[RedeemCode] Не найден Remote — остановка.")
            return
        end
    end

    for _, code in ipairs(CODES) do
        redeem(code)
        task.wait(1)
    end

    print("[RedeemCode] Все коды введены.")
    self.Enabled = false

    if self._Switch then
        self._Switch.Value = false
    end

    print("[RedeemCode] Модуль отключён автоматически.")
end

function RedeemCode:Enable()
    if self.Enabled then return end
    self.Enabled = true

    task.spawn(function()
        self:Run()
    end)
end

function RedeemCode:Disable()
    self.Enabled = false
end

function RedeemCode:drawModule(MainTab)
    local Group = MainTab:AddLeftGroupbox('Redeem Code')

    self._Switch = Group:AddToggle("code", {
        Text = "Activation",
        Default = false,
        Callback = function(Value)
            if Value then
                self:Enable()
            else
                self:Disable()
            end
        end
    })

    return self
end

return RedeemCode
