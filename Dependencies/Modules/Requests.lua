local Module = {}
function Module.get(args)
    assert(args.url, "no url provided")

    local headers = args.headers or {["Content-Type"] = "application/json"}

    local fnc = (syn and syn.request) or (http and http.request) or (request)
    assert(fnc, "no request function found")
    
    local Success, Result = pcall(fnc, {
        Url = args.url,
        Method = "GET",
        Headers = headers
    })

    if (Success == true and Result.Success) then 
        return Result
    end

    return nil
end

function Module.post(args)
    assert(args.url, "no url provided")
    assert(args.body, "no body provided")

    local headers = args.headers or {["Content-Type"] = "application/json"}

    local fnc = (syn and syn.request) or (http and http.request) or (request)
    assert(fnc, "no request function found")
    
    local Success, Result = pcall(fnc, {
        Url = args.url,
        Body = args.body,
        Method = "POST",
        Headers = headers
    })

    if (Success == true and Result.Success) then 
        return Result
    end

    return nil
end

return Module
