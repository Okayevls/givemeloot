-- Initilizator.lua
local Util = require(script.Parent.Parent.util.Util)
-- ↑ путь: из init/ идём в родительскую папку (src), затем в util/, затем Util.lua

local Initilizator = {}
Initilizator.__index = Initilizator

function Initilizator.new()
    local self = setmetatable({}, Initilizator)
    return self
end

function Initilizator:run()
    Util.chat.sendMessage("Hello from Initilizator!")
end

return Initilizator
