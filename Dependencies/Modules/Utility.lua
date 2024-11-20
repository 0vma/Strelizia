local Utils = {}
local Marketplace = game:GetService("MarketplaceService")

Utils.TimeToFormat = function(Time: number, Format: string)
    return os.date(Format, Time)
end 

Utils.CommaNumber = function(number: number)
   number = tostring(number)
   return number:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

Utils.FormatHMS = function(Seconds: number)
	local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	return string.format("%02i", Hours)..":"..string.format("%02i", Minutes)..":"..string.format("%02i", Seconds)
end 

Utils.DecimalRound = function(number: number, decimals: number)
    return (tonumber(string.format("%."..decimals.."f", number)))
end

Utils.GetGameInfo = function(Game: number)
    local Success, Return = pcall(Marketplace.GetProductInfo, Marketplace, Game)
    if Success then 
        return Return 
    end 

    return nil 
end 

Utils.IsFunctionHooked = function(f, restore: boolean) -- // more secure way to do this
    assert(isfunctionhooked, "failed to find isfunctionhooked")
    assert(typeof(f) == 'function', "provided argument is not a function")

    restorefunction(isfunctionhooked)
    if isfunctionhooked(f) then 
        if restore then
            restorefunction(f)
        end 

        return true 
    end 

    return false 
end 



return Utils
