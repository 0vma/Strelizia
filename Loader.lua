if not game:IsLoaded() then game.Loaded:Wait() end 

local GameId = game.PlaceId
local Player = game.Players.LocalPlayer
local HttpService = game:GetService('HttpService')
local States = loadstring(game:HttpGet("https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Dependencies/States.lua", true))()

local Format_Mattched = function(name: string)
    local m = (name:match(string.format("Games/%s/Modules/", game.PlaceId)) or name:match(string.format("Dependencies/Modules/")))
    if m then 
        local parts = string.split(name, "/")
        local res = string.gsub(parts[#parts], "%.lua$", "")
        return res
    end
    return nil
end 

local function from_base64(a)local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'a=string.gsub(a,'[^'..b..'=]','')return a:gsub('.',function(c)if c=='='then return''end;local d,e='',b:find(c)-1;for f=6,1,-1 do d=d..(e%2^f-e%2^(f-1)>0 and'1'or'0')end;return d end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(c)if#c~=8 then return''end;local g=0;for f=1,8 do g=g+(c:sub(f,f)=='1'and 2^(8-f)or 0)end;return string.char(g)end)end

if (not States) then 
    Player:Kick('No States Provided')
end 

local GameState = States.data.Games[tostring(GameId)]
if not (GameState) then 
    Player:Kick('Unsupported Game')
end 

if GameState.Shutdown.Status == true then 
    Player:Kick(string.format('Temporary Shutdown: %s', GameState.Shutdown.Reason))
end 

if GameState.Script == nil then 
    Player:Kick('Script not Provided')
end

getgenv().Strelizia = {
    Modules = {},
    States = States
}

setmetatable(getgenv().Strelizia.Modules, {
    __index = function(t, i)
        print(string.format('Failed to index Module: %s', i))
        return nil 
    end 
})

do -- // Module Loading
    local Success, Result = pcall(game.HttpGet, game, string.format(States.data.DefaultTreeFormat, States.data.Creator, States.data.Repo, "main"), true)
    if Success then 
        Result = HttpService:JSONDecode(Result)

        for _, Module in pairs(Result.tree) do
            local Matches = Format_Mattched(Module.path)
            if Matches then
                local Success, Result = pcall(game.HttpGet, Module.url, true)
                if Success then
                    Result = HttpService:JSONDecode(Result)

                    local Decoded = from_base64(Result.content)

                    getgenv().Strelizia.Modules[Matches] = loadstring(Decoded)()
                    print(string.format('Finished loading Module: %s', Matches))
                end
            end
        end
    end
end

loadstring(
    game:HttpGet(
        GameState.Script,
        true
    )
)()
