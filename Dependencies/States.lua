local States = {}

States.data = {
    Creator = "0vma",
    Repo = "Strelizia",
    
    DefaultTreeFormat = "https://api.github.com/repos/%s/%s/git/trees/%s?recursive=1",
    GameTreeSha = "d3473da19ec2ae3444370551c683193a41c7b63b",

    Games = {
        ["16732694052"] = {
            Shutdown = {
                Status = false,
                Reason = "Shutdown reason here"
            },
            Version = "0.0.1",
            SupportedVersion = 536.25,
            UpdateLog = "[+] Hi\n[-] Bye",
        }
    }
}


return States
