-- Загружаем и выполняем Util.lua с GitHub
local successHttp, body = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/main/util/Util.lua")
end)

if not successHttp or not body then
    error("Не удалось скачать Util.lua: " .. tostring(body))
end

-- Компилируем Lua-код
local chunk, compileErr = loadstring(body)
if not chunk then
    error("Ошибка компиляции Util.lua: " .. tostring(compileErr))
end

-- Выполняем chunk безопасно
local successRun, Util = pcall(chunk)
if not successRun or type(Util) ~= "table" then
    error("Ошибка выполнения Util.lua или возвращено не таблица: " .. tostring(Util))
end

-- Теперь Util готов к использованию
local ok, callErr = pcall(function()
    Util.chat.sendMessage("Hello World!!!")
end)

if not ok then
    error("Ошибка при вызове метода Util.chat.sendMessage: " .. tostring(callErr))
end
