local apiUrl = "https://api.github.com/repos/main/givemeloot/commits/main"
local data = game:GetService("HttpService"):JSONDecode(game:HttpGet(apiUrl))
local latestSHA = data["sha"]

local rawUrl = "https://raw.githubusercontent.com/Okayevls/givemeloot/"..latestSHA.."/src/Main/Main.lua?v="..os.time()
loadstring(game:HttpGet(rawUrl))()
