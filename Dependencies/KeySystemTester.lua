local LRM_IsUserPremium = (getgenv().key_system ~= nil and true or false) --// this variable will be auto set by luaarmor depending if the user has an valid key or not
do
  local KeySystem = getgenv().key_system
  if KeySystem then 
    KeySystem.result = LRM_IsUserPremium
  else 
      if LRM_IsUserPremium == false then 
          local Result = loadstring(game:HttpGet('https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Dependencies/KeySystem.lua', true))()
          if typeof(Result) == 'table' then 
              Result:new({
                  Title = "Strelizia",
                  Ad_Providers = {
                      {
                          Text = "Linkvertise\n(12 Hours)",
                          Callback = function()
                              setclipboard('i set linkvertise clipboard')
                          end
                      },
                      {
                          Text = "Lootlabs\n(8 hours)",
                          Callback = function()
                              setclipboard("i set lootlabs clipboard")
                          end
                      }
                  },
                  Discord_Invite = "PAeXtBkh",
                  Script = "https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Dependencies/KeySystemTester.lua"
              })
          end
      end
  end

  if LRM_IsUserPremium == false then return end 
end

    
