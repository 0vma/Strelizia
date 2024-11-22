local States = {}

States.data = {
    Creator = "0vma",
    Repo = "Strelizia",
    
    DefaultTreeFormat = "https://api.github.com/repos/%s/%s/git/trees/%s?recursive=1",
    GameTreeSha = "d3473da19ec2ae3444370551c683193a41c7b63b",
    Discord = "peFyg8gADB",

    Games = {
        ["16732694052"] = {
            Shutdown = {
                Status = false,
                Reason = "Shutdown reason here"
            },
            Version = "0.0.1",
            SupportedVersion = 536.25,
            UpdateLog = '<stroke color="#000000" thickness="2"><font color="rgb(0, 255, 0)">[+] Added new obstacle course levels for extra challenges</font>\n<font color="rgb(0, 255, 0)">[+] Introduced a new character customization feature</font>\n<font color="rgb(0, 255, 0)">[+] Added in-game achievements to track progress</font>\n<font color="rgb(255, 0, 0)">[-] Removed outdated in-game tutorial to make space for new one</font>\n<font color="rgb(255, 0, 0)">[-] Removed old Halloween-themed items</font>\n<font color="rgb(255, 255, 0)">[*] Fixed bug causing players to fall through the floor</font>\n<font color="rgb(255, 255, 0)">[*] Fixed issue with level progress not saving correctly</font>\n<font color="rgb(255, 255, 0)">[*] Fixed UI overlapping on smaller screen devices</font>\n<font color="rgb(255, 255, 0)">[*] Improved performance for smoother gameplay experience</font></stroke>',
        },
        ["18901165922"] = {
            Shutdown = {
                Status = false,
                Reason = "Shutdown reason here"
            },
            Modules = {
                ['Emojis'] = "https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Games/18901165922/Modules/Emojis.lua"
            },
            Version = "0.0.2 BETA",
            LastUpdated = 1731534966,
            Script = "https://api.luarmor.net/files/v3/loaders/df91992d2ad7b8dd3432b116e3ff2a31.lua",
            SupportedVersion = 536.25,
            UpdateLog = '<font color="rgb(255, 255, 0)">[/] Fixed Bugs</font>',
        },
    },

    Modules = {
        ['Threading'] = "https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Dependencies/Modules/Threading.lua",
        ['Requests'] = "https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Dependencies/Modules/Requests.lua",
        ['Utility'] = "https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Dependencies/Modules/Utility.lua"
    }
}


return States
