local Utils = {}
local Marketplace = game:GetService("MarketplaceService")

Utils.TimeToFormat = function(Time: number, Format: string)
    return os.date(Format, Time)
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