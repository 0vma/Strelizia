local LRM_IsUserPremium = (getgenv().key_system ~= nil and true or false) --// this variable will be auto set by luaarmor depending if the user has an valid key or not
do
  local KeySystem = getgenv().key_system
  if KeySystem then 
    KeySystem.result = LRM_IsUserPremium
  else 
      if LRM_IsUserPremium == false then 
          loadstring(game:HttpGet('https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Dependencies/KeySystem.lua', true))()
      end
  end

  if LRM_IsUserPremium == false then return end 
end

    
