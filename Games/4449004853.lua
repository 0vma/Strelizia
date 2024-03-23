
if not game:IsLoaded() then
    game.Loaded:Wait()
end

getgenv().Strelizia = {
    Dependencies = {
        States = {
            ["16510724413"] = { --https://www.roblox.com/games/16510724413/Pet-Catchers-ARCADE
                Version = "0.0.0 unreleased",
                UpdateLog = "[+] Placeholder\n[-] Placeholder\n[*] Placeholder",
                Status = {
                    Downtime = false,
                    DowntimeReason = "..."
                },
            }
        }
    }
} -- remove this upon release

local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxereas/UI-Libraries/main/notification_gui_library.lua", true))() -- note; port the code over to strelizia GetCountryRegionForPlayerAsync
local Strelizia = getgenv().Strelizia
if not Strelizia or not Strelizia.Dependencies then
    Notification.new("errror", "Strelizia | Failed to load", "Global variables are missing. Make sure to use the official loadstring"):deleteTimeout(3)
    return
end

if not Strelizia.Dependencies.States[tostring(game.PlaceId)] then
    Notification.new("errror", "Strelizia | Failed to load", "Failed to find script states"):deleteTimeout(3)
    return
end

if Strelizia.Dependencies.States[tostring(game.PlaceId)].Status["Downtime"] == true then
    Notification.new("warning", "Strelizia | Script is Down!", string.format("Reason: %s", Strelizia.Dependencies.States[tostring(game.PlaceId)].Status["DowntimeReason"])):deleteTimeout(3)
    return
end

local States = Strelizia.Dependencies.States[tostring(game.PlaceId)]


local Remotes = {
    Event = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"),
    Function = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Function")
}

local Modules = {
    Constants = require(game:GetService("ReplicatedStorage").Shared.Constants),
    PetRender = require(game:GetService("ReplicatedStorage").Client.Pets.PetRender),
    Pets = require(game:GetService("ReplicatedStorage").Shared.Data.Pets),
    CatchChance = require(game:GetService("ReplicatedStorage").Shared.Utilities.GetCatchChance),
    CaptureCubes = require(game:GetService("ReplicatedStorage").Shared.Data.CaptureCubes),
    Regions = require(game:GetService("ReplicatedStorage").Shared.Data.Regions),
    Minigames = require(game:GetService("ReplicatedStorage").Shared.Data.Minigames),
    Bosses = require(game:GetService("ReplicatedStorage").Shared.Data.Bosses),
    Index = require(game:GetService("ReplicatedStorage").Shared.Utilities.IndexUtil),
    Save = getupvalue(require(game:GetService("ReplicatedStorage").Client.Framework.Services.LocalData).Get, 1)
}

-- // Functions 
local Functions = {} 
Functions.GetTabWidth = function() -- this is something i use to scale fluent ui because it works with offset for some reason, bruh
    local GuiService = game:GetService("GuiService")
    local screenWidth, screenHeight = GuiService:GetScreenResolution().X, GuiService:GetScreenResolution().Y
    local baseWidth, baseHeight = 1440, 1022
    local scaleWidth = screenWidth / baseWidth
    local scaleHeight = screenHeight / baseHeight
    local scaleFactor = math.min(scaleWidth, scaleHeight)

    local baseSize = 120
    local scaledSize = baseSize * scaleFactor

    return scaledSize
end

Functions.SetRenderDistance = function(n)
    local PreferedSetting = "Medium";

    Modules.Constants.RenderDistance[PreferedSetting] = n;

    Remotes.Event:FireServer("SetOption", "Render Distance", PreferedSetting)
end

Functions.ConvertToHMS = function(Seconds)
    local Minutes = (Seconds - Seconds % 60) / 60
    Seconds = Seconds - Minutes * 60
    local Hours = (Minutes - Minutes % 60) / 60
    Minutes = Minutes - Hours * 60
    return string.format("%02i", Hours) .. ":" .. string.format("%02i", Minutes) .. ":" ..string.format("%02i", Seconds)
end

Functions.NumberSuffix = function(oldNum)
    local List = {"K", "M", "B", "T", "Qd", "Qn", "Sx", "Sp", "O", "N"}
    local Num = math.abs(oldNum)
    local ListCount = 0
    while Num / 1000 >= 1 do
        ListCount = ListCount + 1
        Num = Num / 1000
    end

    if ListCount == 0 then
        return oldNum
    end

    return (oldNum < 0 and "-" or "") .. math.floor(Num * 10) / 10 .. List[ListCount] .. "+"
end

Functions.DeepCopy = function(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            v = Functions.DeepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

Functions.GetTableSize = function(_table)
    local n = 0; 
    for _, v in pairs(_table) do 
        n += 1
    end

    return n
end

Functions.IsPetIndexed = function(PetName, Shiny)
    if not Modules.Save.Index[PetName] then
        return false
    end

    if Modules.Save.Index[PetName][Shiny == true and "Shiny" or "Normal"].Caught == 0 then
        return false
    end

    return true
end

-- // Ui Library 

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/0vma/Twilight/main/Dependencies/UILibrary/Main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "<b>Strelizia</b> | Pet Catchers",
    SubTitle = "by vma & Pryxo",
    TabWidth = Functions.GetTabWidth(),
    Size = UDim2.fromScale(0.35, 0.5),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    Home = Window:AddTab({
        Title = "Home",
        Icon = "home"
    }),
    Farming = Window:AddTab({
        Title = "Farming",
        Icon = "coins"
    }),
    Hatching = Window:AddTab({
        Title = "Hatching",
        Icon = "egg"
    }),
    Minigames = Window:AddTab({
        Title = "Minigames",
        Icon = "gamepad"
    }),
    Misc = Window:AddTab({
        Title = "Extra",
        Icon = "circle-ellipsis"
    }),
    Settings = Window:AddTab({
        Title = "Settings",
        Icon = "settings"
    }),
}

Tabs.Home:AddParagraph({
    Title = "> Information <",
    Content = "general information about the script/user",
    Section = true
})

Tabs.Home:AddParagraph({
    Title = string.format("Script Version: %s", States.Version),
    Content = "",
})

Tabs.Home:AddParagraph({
    Title = "Update Log: ",
    Content = States.UpdateLog,
})

