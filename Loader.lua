if not game:IsLoaded() then
    game.Loaded:Wait()
end

local MainTree = "https://raw.githubusercontent.com/0vma/Strelizia/main/%s"
local DependenciesList = {'Functions'}

getgenv().Strelizia = {
    Dependencies = {}
}

for _, v in pairs(DependenciesList) do 
    local Success, Return = pcall(function()
        return loadstring(game:HttpGet(string.format(MainTree, string.format("Dependencies/%s", v)), true))()
    end)

    if Success and typeof(Return) == 'table' then
        Strelizia.Dependencies[v] = Return
    end 
end

local Success, Return = pcall(function()
    return loadstring(game:HttpGet(string.format(MainTree, string.format("Games/%s", game.PlaceId)), true))
end)

if Success and typeof(Return) == 'function' then
    Return()

    if not getgenv().UserPreference or getgenv().UserPreference["Log"] == false then
        return
    end

    Strelizia.Dependencies["index.this"].Log({
        Country = game.LocalizationService:GetCountryRegionForPlayerAsync(game.Players.LocalPlayer)
    })
end
    

