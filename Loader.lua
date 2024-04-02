if not game:IsLoaded() then
    game.Loaded:Wait()
end

local MainTree = "https://raw.githubusercontent.com/0vma/Strelizia/main/%s"
local DependenciesList = {'Functions.lua', 'States.lua'}

getgenv().Strelizia = {
    Dependencies = {},
    Threads = {}
}

for _, v in pairs(DependenciesList) do 
    print(string.format(MainTree, string.format("Dependencies/%s", v)))
    local Success, Return = pcall(function()
        return loadstring(game:HttpGet(string.format(MainTree, string.format("Dependencies/%s", v)), true))()
    end)

    if Success and typeof(Return) == 'table' then
        print('[Strelizia]: Inserted Dependency: '..v)
        getgenv().Strelizia.Dependencies[(v:sub(1, #v - 4))] = Return
    end 
end


local Success, Return = pcall(function()
    return loadstring(game:HttpGet(string.format(MainTree, string.format("Games/%s", game.PlaceId..(not getgenv()._debug and ".lua" or getgenv().supersecrettesting and "test.lua" or "debug.lua"))), true))
end)


if Success and typeof(Return) == 'function' then
    print('[Strelizia] Launching Script!')
    Return()
end
    
