if not game:IsLoaded() then 
	game.Loaded:Wait()
end 

local LocalPlayer = game.Players.LocalPlayer
local TeleportService = game:GetService('TeleportService')
local HttpService = game:GetService('HttpService')

local Receive = game.ReplicatedStorage.Remotes.Pack.Receive;
local OpenHeld = game.ReplicatedStorage.Remotes.OpenHeldPack
local Rollback = game.ReplicatedStorage.Remotes.ExclamationMarkService.Acknowledge

local PlayerData = require(game:GetService("ReplicatedStorage").PlayerData);

local Data = PlayerData:GetReplicaAsync().Data;
local ShouldRollback = true;

local TARGET_PACK = getgenv().Options.TargetPack 
local WANTED_CARDS = getgenv().Options.WantedCards 

local function FindCardPack(Target: string): Tool
	for _, Child in LocalPlayer.Backpack:GetChildren() do
		if Child:GetAttribute('PackType') ~= Target then continue end 
		
		return Child 
	end 
end

local PackInstance;
while (not PackInstance) do
	PackInstance = FindCardPack(TARGET_PACK); task.wait(0.1)
end

PackInstance.Parent = LocalPlayer.Character
local OriginalOpened = PackInstance:GetAttribute('Uses');

task.spawn(function()
	while PackInstance:GetAttribute('Uses') == OriginalOpened do 
		OpenHeld:FireServer()
		task.wait(0.33)
	end 
end)

Receive.OnClientEvent:Once(function(PackType, Ids)
	for _, CardId in Ids do 
		local Target = Data.Cards.Inventory[CardId];
		if not Target then continue end 

		local Wanted = WANTED_CARDS[Target.Type];
		if not Wanted then continue end 

		if Wanted.Shiny and (not Target.Data.Shiny) then continue end 
		
		ShouldRollback = false; 
	end 

	if ShouldRollback then 
		Rollback:FireServer('\255'); task.wait(1)
	end 

	if ShouldRollback or (not getgenv().Options.StopWhenFound) then 
		queue_on_teleport(string.format([[
			getgenv().Options = game:GetService('HttpService'):JSONDecode([=[%s]=])

			loadstring(game:HttpGet('https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Standalone/PvBRollback.lua', true))()
		]], HttpService:JSONEncode(getgenv().Options)))
	end

	while true do 
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
		task.wait(0.5)
	end
end)

