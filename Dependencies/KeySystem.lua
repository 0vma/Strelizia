getgenv().key_system={initiated=true,result=nil}local a=Instance.new("ScreenGui")a.IgnoreGuiInset=true;a.ScreenInsets=Enum.ScreenInsets.DeviceSafeInsets;a.ResetOnSpawn=true;a.ZIndexBehavior=Enum.ZIndexBehavior.Global;a.Name="Loader"a.Parent=game.CoreGui;local b=Instance.new("Frame")b.AnchorPoint=Vector2.new(0.5,0.5)b.BackgroundColor3=Color3.new(0.231373,0.231373,0.231373)b.BorderColor3=Color3.new(0,0,0)b.BorderSizePixel=0;b.Position=UDim2.new(0.5,0,0.5,0)b.Size=UDim2.new(0.261115044,0,0.246006384,0)b.Visible=false;b.Name="Main"b.Parent=a;local c=Instance.new("UIStroke")c.Color=Color3.new(0.172549,0.172549,0.172549)c.Thickness=2;c.Parent=b;local d=Instance.new("UICorner")d.Parent=b;local e=Instance.new("Frame")e.AnchorPoint=Vector2.new(0.5,0.5)e.BackgroundColor3=Color3.new(0.156863,0.156863,0.156863)e.BorderColor3=Color3.new(0,0,0)e.BorderSizePixel=0;e.Position=UDim2.new(0.5,0,0.150000006,0)e.Size=UDim2.new(0.450000018,0,0.230000019,0)e.Visible=true;e.Name="ScriptBg"e.Parent=b;local f=Instance.new("TextLabel")f.Font=Enum.Font.FredokaOne;f.Text="Strelizia"f.TextColor3=Color3.new(1,1,1)f.TextScaled=true;f.TextSize=14;f.TextWrapped=true;f.AnchorPoint=Vector2.new(0.5,0.5)f.BackgroundColor3=Color3.new(1,1,1)f.BackgroundTransparency=1;f.BorderColor3=Color3.new(0,0,0)f.BorderSizePixel=0;f.Position=UDim2.new(0.5,0,0.5,0)f.Size=UDim2.new(0.899999976,0,0.899999976,0)f.Visible=true;f.Name="Script"f.Parent=e;local g=Instance.new("UIStroke")g.Thickness=2;g.Parent=f;local h=Instance.new("UITextSizeConstraint")h.MaxTextSize=31;h.Parent=f;local i=Instance.new("UIStroke")i.Color=Color3.new(0.129412,0.129412,0.129412)i.Thickness=2;i.Parent=e;local j=Instance.new("UICorner")j.Parent=e;local k=Instance.new("Frame")k.AnchorPoint=Vector2.new(0.5,0.5)k.BackgroundColor3=Color3.new(0.156863,0.156863,0.156863)k.BorderColor3=Color3.new(0,0,0)k.BorderSizePixel=0;k.Position=UDim2.new(0.501351297,0,0.533116996,0)k.Size=UDim2.new(0.917567492,0,0.385844201,0)k.Visible=true;k.Name="TextBoxBg"k.Parent=b;local l=Instance.new("UIStroke")l.Color=Color3.new(0.129412,0.129412,0.129412)l.Thickness=2;l.Parent=k;local m=Instance.new("UICorner")m.Parent=k;local n=Instance.new("TextBox")n.Font=Enum.Font.FredokaOne;n.Text=""n.PlaceholderText="put ur key here"n.PlaceholderColor3=Color3.fromRGB(255,255,255)n.TextColor3=Color3.new(1,1,1)n.TextScaled=true;n.TextSize=14;n.TextWrapped=true;n.AnchorPoint=Vector2.new(0.5,0.5)n.BackgroundColor3=Color3.new(1,1,1)n.BackgroundTransparency=1;n.BorderColor3=Color3.new(0,0,0)n.BorderSizePixel=0;n.Position=UDim2.new(0.5,0,0.5,0)n.Size=UDim2.new(0.899999976,0,0.899999976,0)n.Visible=true;n.Parent=k;local o=Instance.new("UIStroke")o.Thickness=2;o.Parent=n;local p=Instance.new("UITextSizeConstraint")p.MaxTextSize=50;p.Parent=n;local q=Instance.new("TextButton")q.Font=Enum.Font.FredokaOne;q.Text="Check Key"q.TextColor3=Color3.new(1,1,1)q.TextScaled=true;q.TextSize=14;q.TextWrapped=true;q.AnchorPoint=Vector2.new(0.5,0.5)q.BackgroundColor3=Color3.new(0.156863,0.156863,0.156863)q.BorderColor3=Color3.new(0,0,0)q.BorderSizePixel=0;q.Position=UDim2.new(0.259864986,0,0.871740162,0)q.Size=UDim2.new(0.435000002,0,0.169,0)q.Visible=true;q.Name="Check"q.Parent=b;local r=Instance.new("UIStroke")r.Thickness=2;r.Parent=q;local s=Instance.new("UICorner")s.Parent=q;local t=Instance.new("UIStroke")t.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;t.Color=Color3.new(0.129412,0.129412,0.129412)t.Thickness=2;t.Parent=q;local u=Instance.new("UITextSizeConstraint")u.MaxTextSize=26;u.Parent=q;local v=Instance.new("TextButton")v.Font=Enum.Font.FredokaOne;v.Text="Get Key"v.TextColor3=Color3.new(1,1,1)v.TextScaled=true;v.TextSize=14;v.TextWrapped=true;v.AnchorPoint=Vector2.new(0.5,0.5)v.BackgroundColor3=Color3.new(0.156863,0.156863,0.156863)v.BorderColor3=Color3.new(0,0,0)v.BorderSizePixel=0;v.Position=UDim2.new(0.740945935,0,0.871740162,0)v.Size=UDim2.new(0.435135096,0,0.16883117,0)v.Visible=true;v.Name="Get"v.Parent=b;local w=Instance.new("UIStroke")w.Thickness=2;w.Parent=v;local x=Instance.new("UICorner")x.Parent=v;local y=Instance.new("UIStroke")y.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;y.Color=Color3.new(0.129412,0.129412,0.129412)y.Thickness=2;y.Parent=v;local z=Instance.new("UITextSizeConstraint")z.MaxTextSize=26;z.Parent=v;local A=Instance.new("TextButton")A.Font=Enum.Font.SourceSans;A.Text=""A.TextColor3=Color3.new(0,0,0)A.TextScaled=true;A.TextSize=14;A.TextWrapped=true;A.AnchorPoint=Vector2.new(0.5,0.5)A.BackgroundColor3=Color3.new(1,1,1)A.BackgroundTransparency=0.8999999761581421;A.BorderColor3=Color3.new(0,0,0)A.BorderSizePixel=0;A.Position=UDim2.new(0.0922973529,0,0.152785614,0)A.Size=UDim2.new(0.100000001,0,0.240999997,0)A.Visible=true;A.Name="Discord"A.Parent=b;local B=Instance.new("UIStroke")B.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;B.Color=Color3.new(0.129412,0.129412,0.129412)B.Thickness=2;B.Parent=A;local C=Instance.new("UICorner")C.Parent=A;local D=Instance.new("ImageLabel")D.Image="http://www.roblox.com/asset/?id=18505728201"D.ResampleMode=Enum.ResamplerMode.Pixelated;D.AnchorPoint=Vector2.new(0.5,0.5)D.BackgroundColor3=Color3.new(1,1,1)D.BackgroundTransparency=1;D.BorderColor3=Color3.new(0,0,0)D.BorderSizePixel=0;D.Position=UDim2.new(0.5,0,0.5,0)D.Size=UDim2.new(0.800000012,0,0.800000012,0)D.Visible=true;D.Name="Icon"D.Parent=A;local E=Instance.new("UITextSizeConstraint")E.MaxTextSize=14;E.Parent=A;local F=Instance.new("TextButton")F.Font=Enum.Font.SourceSans;F.Text=""F.TextColor3=Color3.new(0,0,0)F.TextScaled=true;F.TextSize=14;F.TextWrapped=true;F.AnchorPoint=Vector2.new(0.5,0.5)F.BackgroundColor3=Color3.new(1,1,1)F.BackgroundTransparency=0.8999999761581421;F.BorderColor3=Color3.new(0,0,0)F.BorderSizePixel=0;F.Position=UDim2.new(0.908513486,0,0.152785614,0)F.Size=UDim2.new(0.100000001,0,0.240999997,0)F.Visible=true;F.Name="Close"F.Parent=b;local G=Instance.new("UIStroke")G.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;G.Color=Color3.new(0.129412,0.129412,0.129412)G.Thickness=2;G.Parent=F;local H=Instance.new("UICorner")H.Parent=F;local I=Instance.new("ImageLabel")I.Image="rbxassetid://3926305904"I.ImageRectOffset=Vector2.new(284,4)I.ImageRectSize=Vector2.new(24,24)I.ResampleMode=Enum.ResamplerMode.Pixelated;I.AnchorPoint=Vector2.new(0.5,0.5)I.BackgroundColor3=Color3.new(1,1,1)I.BackgroundTransparency=1;I.BorderColor3=Color3.new(0,0,0)I.BorderSizePixel=0;I.Position=UDim2.new(0.5,0,0.5,0)I.Size=UDim2.new(0.800000012,0,0.800000012,0)I.Visible=true;I.Name="Icon"I.Parent=F;local J=Instance.new("UITextSizeConstraint")J.MaxTextSize=14;J.Parent=F;local K=Instance.new("UIAspectRatioConstraint")K.AspectRatio=2.402597665786743;K.Parent=b;local L=Instance.new("Frame")L.AnchorPoint=Vector2.new(0.5,0.5)L.BackgroundColor3=Color3.new(1,1,1)L.BackgroundTransparency=1;L.BorderColor3=Color3.new(0,0,0)L.BorderSizePixel=0;L.Position=UDim2.new(0.5,0,1.39999998,0)L.Size=UDim2.new(1.42702687,0,0.681818187,0)L.Visible=true;L.Name="Prompts"L.Parent=b;local M=Instance.new("Frame")M.AnchorPoint=Vector2.new(0.5,0.5)M.BackgroundColor3=Color3.new(0.231373,0.231373,0.231373)M.BorderColor3=Color3.new(0,0,0)M.BorderSizePixel=0;M.Position=UDim2.new(0.5,0,0.166666672,0)M.Size=UDim2.new(0.389,0,0.5,0)M.Visible=false;M.Name="Template"M.Parent=L;local N=Instance.new("TextLabel")N.Font=Enum.Font.FredokaOne;N.TextColor3=Color3.new(1,1,1)N.TextSize=14;N.AnchorPoint=Vector2.new(0.5,0.5)N.BackgroundColor3=Color3.new(1,1,1)N.BackgroundTransparency=1;N.BorderColor3=Color3.new(0,0,0)N.BorderSizePixel=0;N.Position=UDim2.new(0.5,0,-0.0500000007,0)N.Size=UDim2.new(0.899999976,0,0.200000003,0)N.Visible=true;N.ZIndex=2;N.Name="Title"N.Parent=M;local O=Instance.new("UIStroke")O.Thickness=2;O.Parent=N;local P=Instance.new("UIStroke")P.Color=Color3.new(0.172549,0.172549,0.172549)P.Thickness=2;P.Parent=M;local Q=Instance.new("UICorner")Q.Parent=M;local R=Instance.new("Frame")R.AnchorPoint=Vector2.new(0.5,0.5)R.BackgroundColor3=Color3.new(1,1,1)R.BackgroundTransparency=1;R.BorderColor3=Color3.new(0,0,0)R.BorderSizePixel=0;R.Position=UDim2.new(0.5,0,0.5,0)R.Size=UDim2.new(0.899999976,0,0.899999976,0)R.Visible=true;R.Name="Buttons"R.Parent=M;local S=Instance.new("UIListLayout")S.Padding=UDim.new(0,5)S.FillDirection=Enum.FillDirection.Horizontal;S.HorizontalAlignment=Enum.HorizontalAlignment.Center;S.SortOrder=Enum.SortOrder.LayoutOrder;S.VerticalAlignment=Enum.VerticalAlignment.Center;S.Parent=R;local T=Instance.new("TextButton")T.Font=Enum.Font.FredokaOne;T.Text="Get Key"T.TextColor3=Color3.new(1,1,1)T.TextScaled=true;T.TextSize=14;T.TextWrapped=true;T.AnchorPoint=Vector2.new(0.5,0.5)T.BackgroundColor3=Color3.new(0.156863,0.156863,0.156863)T.BorderColor3=Color3.new(0,0,0)T.BorderSizePixel=0;T.Position=UDim2.new(0.740945935,0,0.871740162,0)T.Size=UDim2.new(1,0,1,0)T.Visible=false;T.Name="Example"T.Parent=R;local U=Instance.new("UIStroke")U.Thickness=2;U.Parent=T;local V=Instance.new("UICorner")V.Parent=T;local W=Instance.new("UIStroke")W.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;W.Color=Color3.new(0.129412,0.129412,0.129412)W.Thickness=2;W.Parent=T;local X=Instance.new("UITextSizeConstraint")X.MaxTextSize=26;X.Parent=T;local Y=Instance.new("UIListLayout")Y.Padding=UDim.new(0,10)Y.HorizontalAlignment=Enum.HorizontalAlignment.Center;Y.SortOrder=Enum.SortOrder.LayoutOrder;Y.Parent=L;local Z=function(_)_.AutoButtonColor=false;local a0=_.Size;_.MouseEnter:Connect(function()_:TweenSize(UDim2.fromScale(a0.X.Scale*1.08,a0.Y.Scale*1.08),Enum.EasingDirection.Out,Enum.EasingStyle.Sine,0.25,true)end)_.MouseLeave:Connect(function()_:TweenSize(a0,Enum.EasingDirection.Out,Enum.EasingStyle.Sine,0.25,true)end)_.MouseButton1Down:Connect(function()_:TweenSize(UDim2.fromScale(a0.X.Scale/1.08,a0.Y.Scale/1.08),Enum.EasingDirection.Out,Enum.EasingStyle.Sine,0.25,true)end)_.MouseButton1Up:Connect(function()_:TweenSize(UDim2.fromScale(a0.X.Scale*1.08,a0.Y.Scale*1.08),Enum.EasingDirection.Out,Enum.EasingStyle.Sine,0.25,true)end)end;do Z(q)Z(F)Z(A)Z(v)end;local a1=function(a2)a2:TweenSize(UDim2.fromScale(0,0),Enum.EasingDirection.In,Enum.EasingStyle.Linear,0.35)task.wait(0.35)a2:Destroy()end;local a3=function(a4,a5,a6)local a7=M:Clone()local a8=a7.Size;a7.Parent=L;local a9=a7.Buttons.Example;for aa,ab in pairs(a5)do local ac=a9:Clone()ac.Parent=a7.Buttons;ac.Name=tostring(aa)ac.Size=UDim2.fromScale(1/#a5,0.78)ac.Text=ab.Text;ac.MouseButton1Click:Connect(function()if a7:GetAttribute("done")then return end;a7:SetAttribute("done",true)coroutine.wrap(ab.Callback)()n.Text=""n.PlaceholderText="keysystem link has been copied to ur clipboard. paste the key here after you are done with all the steps"task.delay(4,function()if n and n.Parent and n.Text==""and n.PlaceholderText=="keysystem link has been copied to ur clipboard. paste the key here after you are done with all the steps"then n.PlaceholderText="put ur key here"end end)a1(a7)end)Z(ac)ac.Visible=true end;local ad=a7.Buttons.UIListLayout.AbsoluteContentSize;a7.Size=UDim2.fromOffset(0,0)a7.Visible=true;a7:TweenSize(UDim2.fromOffset(ad.X+10,ad.Y),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.35,true)task.delay(a6,function()if a7 and a7.Parent then a1(a7)end end)end;return{new=function(self,ae)e:FindFirstChild("Script").Text=ae.Title;if ae.Discord_Invite then A.MouseButton1Click:Connect(function()local af=syn and syn.request or http and http.request or request;if af then af({Url="http://127.0.0.1:6463/rpc?v=1",Method="POST",Headers={["Content-Type"]="application/json",["Origin"]="https://discord.com"},Body=game.HttpService:JSONEncode({cmd="INVITE_BROWSER",args={code=ae.Discord_Invite},nonce=game.HttpService:GenerateGUID(false)})})setclipboard(string.format("https://discord.gg/%s",ae.Discord_Invite))end end)end;v.MouseButton1Click:Connect(function()n.Text=""n.PlaceholderText="select one of the ad providers"a3("Ad Provider",ae.Ad_Providers,10)end)q.MouseButton1Click:Connect(function()if n.Text:len()~=32 then n.Text=""n.PlaceholderText="invalid key format!"task.delay(1.5,function()if n and n.Parent and n.PlaceholderText=="invalid key format!"and n.Text==""then n.PlaceholderText="put ur key here"end end)return end;loadstring(game:HttpGet(ae.Script,true))()if getgenv().key_system.result~=nil then if getgenv().key_system.result==false then n.Text=""n.PlaceholderText="invalid key!"task.delay(1.5,function()if n and n.Parent and n.PlaceholderText=="invalid key!"and n.Text==""then n.PlaceholderText="put ur key here"end end)return end;b:TweenSize(UDim2.fromScale(0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.35)task.wait(0.35)a:Destroy()else n.Text=""n.PlaceholderText="something went wrong, please try again later"task.delay(4,function()b:TweenSize(UDim2.fromScale(0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.35)task.wait(0.35)a:Destroy()end)end end)F.MouseButton1Click:Connect(function()b:TweenSize(UDim2.fromScale(0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.35)task.wait(0.35)a:Destroy()end)local ag=b.Size;b.Size=UDim2.fromScale(0,0)b.Visible=true;b:TweenSize(ag,Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.35)end}
