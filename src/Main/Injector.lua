local branch = "main"
local repoUser = "Okayevls"
local repoName = "givemeloot"

local apiUrl = "https://api.github.com/repos/"..repoUser.."/"..repoName.."/commits/"..branch
local data = game:GetService("HttpService"):JSONDecode(game:HttpGet(apiUrl))
local latestSHA = data["sha"]

local rawUrl = "https://raw.githubusercontent.com/"..repoUser.."/"..repoName.."/"..latestSHA.."/src/Main/Main.lua?v="..os.time()
loadstring(game:HttpGet(rawUrl))()
