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

    return Success, Result
end

function Module.post(args)
    assert(args.url, "no url provided")
    assert(args.body, "no body provided")

    local headers = args.headers or {["Content-Type"] = "application/json"}

    local fnc = (syn ~= nil and syn.request) or (http ~= nil and http.request) or (request)
    assert(fnc, "no request function found")
    
    local Success, Result = pcall(fnc, {
        Url = args.url,
        Body = args.body,
        Method = "POST",
        Headers = headers
    })

    return Success, Result
end

return Module
