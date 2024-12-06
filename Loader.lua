if not game:IsLoaded() then game.Loaded:Wait() end 

local GameId = game.PlaceId
local Player = game.Players.LocalPlayer
local HttpService = game:GetService('HttpService')
local States = loadstring(game:HttpGet("https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Dependencies/States.lua", true))()

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

if not getgenv().Strelizia then	
	getgenv().Strelizia = {
		Modules = {},
		States = States
	}

	getgenv().Strelizia.GetModule = function(self, Module)
		if Strelizia.Modules[Module] then 
			return Strelizia.Modules[Module]
		end
		
		local Link = (States.data.Modules[Module] or GameState.Modules[Module]) 
		assert(Link, string.format("Failed to obtain the repo for Module: %s", Module))

		local Success, Error = pcall(
			game.HttpGet, 
			game, 
			Link,
			true
		)

		if (not Success or typeof(Error) ~= 'string') then 
			error(string.format("Failed to get Module: %s (%s)", Module, tostring(Error)))
			return 
		end

		Strelizia.Modules[Module] = loadstring(Error)()
		
		return Strelizia.Modules[Module]
	end
end	

if (not script_key) then
	if isfile('strelizia.key') then
		script_key = readfile('strelizia.key')
	end
end

loadstring(
	game:HttpGet(
		GameState.Script,
		true
	)
)()
