local Functions = {}
Functions.OptimiseGame = function()
      -- MADE BY RIP#6666
      -- send issues or suggestions to my discord: discord.gg/rips
      
      if not _G.Ignore then
          _G.Ignore = {}
      end
      if not _G.WaitPerAmount then
          _G.WaitPerAmount = 500
      end
      
      
      
      if not game:IsLoaded() then
          repeat
              task.wait()
          until game:IsLoaded()
      end
      if not _G.Settings then
          _G.Settings = {
              Players = {
                  ["Ignore Me"] = false,
                  ["Ignore Others"] = false,
                  ["Ignore Tools"] = true
              },
              Meshes = {
                  NoMesh = true,
                  NoTexture = true,
                  Destroy = false
              },
              Images = {
                  Invisible = true,
                  Destroy = false
              },
              Explosions = {
                  Smaller = true,
                  Invisible = false, -- Not recommended for PVP games
                  Destroy = true -- Not recommended for PVP games
              },
              Particles = {
                  Invisible = true,
                  Destroy = false
              },
              TextLabels = {
                  LowerQuality = true,
                  Invisible = false,
                  Destroy = false
              },
              MeshParts = {
                  LowerQuality = true,
                  Invisible = true,
                  NoTexture = true,
                  NoMesh = true,
                  Destroy = false
              },
              Other = {
                  ["No Camera Effects"] = true,
                  ["No Clothes"] = true,
                  ["Low Water Graphics"] = true,
                  ["No Shadows"] = true,
                  ["Low Rendering"] = true,
                  ["Low Quality Parts"] = true,
                  ["Low Quality Models"] = true,
                  ["Reset Materials"] = true,
                  ["Lower Quality MeshParts"] = true
              }
          }
      end
      local Players, Lighting, StarterGui, MaterialService = game:GetService("Players"), game:GetService("Lighting"), game:GetService("StarterGui"), game:GetService("MaterialService")
      local ME, CanBeEnabled = Players.LocalPlayer, {"ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles"}
      local function PartOfCharacter(Instance)
          for i, v in pairs(Players:GetPlayers()) do
              if v ~= ME and v.Character and Instance:IsDescendantOf(v.Character) then
                  return true
              end
          end
          return false
      end
      local function DescendantOfIgnore(Instance)
          for i, v in pairs(_G.Ignore) do
              if Instance:IsDescendantOf(v) then
                  return true
              end
          end
          return false
      end
      local function CheckIfBad(Instance)
          if not Instance:IsDescendantOf(Players) and (_G.Settings.Players["Ignore Others"] and not PartOfCharacter(Instance) or not _G.Settings.Players["Ignore Others"]) and (_G.Settings.Players["Ignore Me"] and ME.Character and not Instance:IsDescendantOf(ME.Character) or not _G.Settings.Players["Ignore Me"]) and (_G.Settings.Players["Ignore Tools"] and not Instance:IsA("BackpackItem") and not Instance:FindFirstAncestorWhichIsA("BackpackItem") or not _G.Settings.Players["Ignore Tools"])--[[not PartOfCharacter(Instance)]] and (_G.Ignore and not table.find(_G.Ignore, Instance) and not DescendantOfIgnore(Instance) or (not _G.Ignore or type(_G.Ignore) ~= "table" or #_G.Ignore <= 0)) then
              if Instance:IsA("DataModelMesh") then
                  if _G.Settings.Meshes.NoMesh and Instance:IsA("SpecialMesh") then
                      Instance.MeshId = ""
                  end
                  if _G.Settings.Meshes.NoTexture and Instance:IsA("SpecialMesh") then
                      Instance.TextureId = ""
                  end
                  if _G.Settings.Meshes.Destroy or _G.Settings["No Meshes"] then
                      Instance:Destroy()
                  end
              elseif Instance:IsA("FaceInstance") then
                  if _G.Settings.Images.Invisible then
                      Instance.Transparency = 1
                      Instance.Shiny = 1
                  end
                  if _G.Settings.Images.LowDetail then
                      Instance.Shiny = 1
                  end
                  if _G.Settings.Images.Destroy then
                      Instance:Destroy()
                  end
              elseif Instance:IsA("ShirtGraphic") then
                  if _G.Settings.Images.Invisible then
                      Instance.Graphic = ""
                  end
                  if _G.Settings.Images.Destroy then
                      Instance:Destroy()
                  end
              elseif table.find(CanBeEnabled, Instance.ClassName) then
                  if _G.Settings["Invisible Particles"] or _G.Settings["No Particles"] or (_G.Settings.Other and _G.Settings.Other["Invisible Particles"]) or (_G.Settings.Particles and _G.Settings.Particles.Invisible) then
                      Instance.Enabled = false
                  end
                  if (_G.Settings.Other and _G.Settings.Other["No Particles"]) or (_G.Settings.Particles and _G.Settings.Particles.Destroy) then
                      Instance:Destroy()
                  end
              elseif Instance:IsA("PostEffect") and (_G.Settings["No Camera Effects"] or (_G.Settings.Other and _G.Settings.Other["No Camera Effects"])) then
                  Instance.Enabled = false
              elseif Instance:IsA("Explosion") then
                  if _G.Settings["Smaller Explosions"] or (_G.Settings.Other and _G.Settings.Other["Smaller Explosions"]) or (_G.Settings.Explosions and _G.Settings.Explosions.Smaller) then
                      Instance.BlastPressure = 1
                      Instance.BlastRadius = 1
                  end
                  if _G.Settings["Invisible Explosions"] or (_G.Settings.Other and _G.Settings.Other["Invisible Explosions"]) or (_G.Settings.Explosions and _G.Settings.Explosions.Invisible) then
                      Instance.BlastPressure = 1
                      Instance.BlastRadius = 1
                      Instance.Visible = false
                  end
                  if _G.Settings["No Explosions"] or (_G.Settings.Other and _G.Settings.Other["No Explosions"]) or (_G.Settings.Explosions and _G.Settings.Explosions.Destroy) then
                      Instance:Destroy()
                  end
              elseif Instance:IsA("Clothing") or Instance:IsA("SurfaceAppearance") or Instance:IsA("BaseWrap") then
                  if _G.Settings["No Clothes"] or (_G.Settings.Other and _G.Settings.Other["No Clothes"]) then
                      Instance:Destroy()
                  end
              elseif Instance:IsA("BasePart") and not Instance:IsA("MeshPart") then
                  if _G.Settings["Low Quality Parts"] or (_G.Settings.Other and _G.Settings.Other["Low Quality Parts"]) then
                      Instance.Material = Enum.Material.Plastic
                      Instance.Reflectance = 0
                  end
              elseif Instance:IsA("TextLabel") and Instance:IsDescendantOf(workspace) then
                  if _G.Settings["Lower Quality TextLabels"] or (_G.Settings.Other and _G.Settings.Other["Lower Quality TextLabels"]) or (_G.Settings.TextLabels and _G.Settings.TextLabels.LowerQuality) then
                      Instance.Font = Enum.Font.SourceSans
                      Instance.TextScaled = false
                      Instance.RichText = false
                      Instance.TextSize = 14
                  end
                  if _G.Settings["Invisible TextLabels"] or (_G.Settings.Other and _G.Settings.Other["Invisible TextLabels"]) or (_G.Settings.TextLabels and _G.Settings.TextLabels.Invisible) then
                      Instance.Visible = false
                  end
                  if _G.Settings["No TextLabels"] or (_G.Settings.Other and _G.Settings.Other["No TextLabels"]) or (_G.Settings.TextLabels and _G.Settings.TextLabels.Destroy) then
                      Instance:Destroy()
                  end
              elseif Instance:IsA("Model") then
                  if _G.Settings["Low Quality Models"] or (_G.Settings.Other and _G.Settings.Other["Low Quality Models"]) then
                      Instance.LevelOfDetail = 1
                  end
              elseif Instance:IsA("MeshPart") then
                  if _G.Settings["Low Quality MeshParts"] or (_G.Settings.Other and _G.Settings.Other["Low Quality MeshParts"]) or (_G.Settings.MeshParts and _G.Settings.MeshParts.LowerQuality) then
                      Instance.RenderFidelity = 2
                      Instance.Reflectance = 0
                      Instance.Material = Enum.Material.Plastic
                  end
                  if _G.Settings["Invisible MeshParts"] or (_G.Settings.Other and _G.Settings.Other["Invisible MeshParts"]) or (_G.Settings.MeshParts and _G.Settings.MeshParts.Invisible) then
                      Instance.Transparency = 1
                      Instance.RenderFidelity = 2
                      Instance.Reflectance = 0
                      Instance.Material = Enum.Material.Plastic
                  end
                  if _G.Settings.MeshParts and _G.Settings.MeshParts.NoTexture then
                      Instance.TextureID = ""
                  end
                  if _G.Settings.MeshParts and _G.Settings.MeshParts.NoMesh then
                      Instance.MeshId = ""
                  end
                  if _G.Settings["No MeshParts"] or (_G.Settings.Other and _G.Settings.Other["No MeshParts"]) or (_G.Settings.MeshParts and _G.Settings.MeshParts.Destroy) then
                      Instance:Destroy()
                  end
              end
          end
      end
      
      coroutine.wrap(pcall)(function()
          if (_G.Settings["Low Water Graphics"] or (_G.Settings.Other and _G.Settings.Other["Low Water Graphics"])) then
              if not workspace:FindFirstChildOfClass("Terrain") then
                  repeat
                      task.wait()
                  until workspace:FindFirstChildOfClass("Terrain")
              end
              workspace:FindFirstChildOfClass("Terrain").WaterWaveSize = 0
              workspace:FindFirstChildOfClass("Terrain").WaterWaveSpeed = 0
              workspace:FindFirstChildOfClass("Terrain").WaterReflectance = 0
              workspace:FindFirstChildOfClass("Terrain").WaterTransparency = 0
              if sethiddenproperty then
                  sethiddenproperty(workspace:FindFirstChildOfClass("Terrain"), "Decoration", false)
              end
          end
      end)
      coroutine.wrap(pcall)(function()
          if _G.Settings["No Shadows"] or (_G.Settings.Other and _G.Settings.Other["No Shadows"]) then
              Lighting.GlobalShadows = false
              Lighting.FogEnd = 9e9
              Lighting.ShadowSoftness = 0
              if sethiddenproperty then
                  sethiddenproperty(Lighting, "Technology", 2)
              end
          end
      end)
      coroutine.wrap(pcall)(function()
          if _G.Settings["Low Rendering"] or (_G.Settings.Other and _G.Settings.Other["Low Rendering"]) then
              settings().Rendering.QualityLevel = 1
              settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
          end
      end)
      coroutine.wrap(pcall)(function()
          if _G.Settings["Reset Materials"] or (_G.Settings.Other and _G.Settings.Other["Reset Materials"]) then
              for i, v in pairs(MaterialService:GetChildren()) do
                  v:Destroy()
              end
              MaterialService.Use2022Materials = false
          end
      end)
      
      game.DescendantAdded:Connect(function(value)
          task.wait(1)
          CheckIfBad(value)
      end)
      
      local Descendants = game:GetDescendants()
      local StartNumber = _G.WaitPerAmount or 500
      local WaitNumber = _G.WaitPerAmount or 500
      
      for i, v in pairs(Descendants) do
          CheckIfBad(v)
          if i == WaitNumber then
              task.wait()
              WaitNumber = WaitNumber + StartNumber
          end
      end

end
return Functions
