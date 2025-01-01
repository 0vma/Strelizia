if not game:IsLoaded() then game.Loaded:Wait() end 

local GameId = game.PlaceId
local Player = game.Players.LocalPlayer
local HttpService = game:GetService('HttpService')
local VirtualUser = game:GetService("VirtualUser")
local States = loadstring(game:HttpGet("https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Dependencies/States.lua", true))()
local Unsupported = {"Solara", "Xeno", "Fluxus", "Lunar"}
local Supported = {"Wave", "Synapse Z", "Codex Android/iOS", "Delta Android/iOS", "Some others"}

for _, Executor in pairs(Unsupported) do 
	if string.find(identifyexecutor(), Executor) then 
		Player:Kick('\nUnsupported Executor: '..Executor..'\nSupported Executors:\n'..table.concat(Supported, '\n'))
		return
	end
end

if (not States) then 
	Player:Kick('No States Provided')
end 

local GameState = States.GetGameState(game.PlaceId)
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
		local IsFileJson, Result = pcall(HttpService.JSONDecode, HttpService, (readfile('strelizia.key')))
		if (IsFileJson) then
			if (os.time() >= tonumber(Result.Expiry)) then 
				delfile('strelizia.key')
			else 
				script_key = string.reverse(Result.Key)
			end
		else 
			delfile('strelizia.key')
		end
	end
end

do -- // Anti AFK
	Player.Idled:connect(function()
	    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	    task.wait(1)
	    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	end)
end	

loadstring(
	("--!native\n\n") ..
	game:HttpGet(
		GameState.Script,
		true
	)
)()
