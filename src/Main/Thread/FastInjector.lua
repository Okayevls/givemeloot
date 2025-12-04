local apiUrl = "https://api.github.com/repos/Okayevls/repoName/commits/main"
local data = game:GetService("HttpService"):JSONDecode(game:HttpGet(apiUrl))
local latestSHA = data["sha"]

local rawUrl = "https://raw.githubusercontent.com/Okayevls/repoName/"..latestSHA.."/src/Main/Main.lua?v="..os.time()
loadstring(game:HttpGet(rawUrl))()
