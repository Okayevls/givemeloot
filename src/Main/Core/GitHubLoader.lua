local HttpService = game:GetService("HttpService")

local GitHubLoader = {}
GitHubLoader.__index = GitHubLoader

function GitHubLoader.new(user, repo, branch)
    return setmetatable({
        user = user,
        repo = repo,
        branch = branch,
        sha = nil,
        cache = {}
    }, GitHubLoader)
end

function GitHubLoader:GetLatestSHA()
    local apiUrl = "https://api.github.com/repos/"..self.user.."/"..self.repo.."/commits/"..self.branch
    local data = HttpService:JSONDecode(game:HttpGet(apiUrl))
    self.sha = data.sha
end

function GitHubLoader:Raw(path)
    return "https://raw.githubusercontent.com/"..self.user.."/"..self.repo.."/"..self.sha.."/"..path.."?v="..os.time()
end

function GitHubLoader:Load(path)
    if self.cache[path] then
        return self.cache[path]
    end

    local code = game:HttpGet(self:Raw(path))
    local module = loadstring(code)()

    self.cache[path] = module
    return module
end

return GitHubLoader
