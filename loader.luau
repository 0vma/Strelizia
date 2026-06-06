local a local b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u={function()local b,c,d=a(1
)return(function(...)if(not game:IsLoaded())then game.Loaded:Wait()end local e,f
=d(c.Library),getgenv()if f.Library then f.Library:Unload()end if(not pcall(e.
Get,e,'Shared'))then return end local g,h,i,j,k,l,m=e:Get'Shared/Modules/Places'
,e:Get'Shared/Modules/Interface'.GetInterface'Obsidian',e:Get
'Shared/Modules/Preference',e:Get'Shared/Constants',e:Get
'Shared/Functions/Strings',e:Get'Shared/Functions/Time',e:Get
'Shared/Functions/PromptDiscord'local n,o,p=j.Characters.BulletPoint,i.new(),g.
GetPlaceFromId(game.PlaceId)if not p then return h.Main:Notify{Title=
'strelizia.cc',Description=
[[this game is currently not supported by strelizia! if you think that this is a mistake then join our discord server and report this issue!]]
,Time=5}end if g.IsExecutorBlacklisted(p.BlacklistedExecutors)then local q={}for
r,s in g.RecommendedExecutors do table.insert(q,string.format('%s | %s%s',
tostring(s.Name),tostring((s.Paid and{(s.Price)}or{'FREE'})[1]),tostring((s.Note
and{string.format(' | %s',tostring(s.Note))}or{''})[1])))end return h.Main:
Notify{Title='strelizia.cc',Description=string.format(
[[script is not compatible with your executor! please check out some of the recommended options:

%s]]
,tostring(table.concat(q,'\n'))),Time=15}end local q=(p.Downtime.Status and p.
Downtime.Message)if q then return h.Main:Notify{Title='strelizia.cc',Description
=string.format(
[[unable to load %s script because it's currently experiencing a downtime! specificed downtime reason: %s]]
,tostring(p.Name),tostring(q))}end local r,s=e:Get'Modules/KeyFile',e:Get
'Modules/Luarmor':Init(p.Script)local t=f.script_key or r:Read()if t then local
u=s:Check(t)if u.code=='KEY_VALID'then h.Main:Notify{Title='strelizia.cc',
Description='saved key is valid! loading script!',Time=3}if f.script_key then r:
Write(t)end return s:LoadScript(t)end h.Main:Notify{Title='strelizia.cc',
Description='saved key is invalid! please enter a new key!',Time=4}r:Erase()end
if p.Keyless then h.Main:Notify{Title='strelizia.cc',Description=
[[script for this game is currently keyless, no key required! loading script...]]
,Time=3}return s:LoadScript()end local u=e:Get'Interface':Create()local v=u.
Library.Buttons local w,x=v.CheckKeyButton,v.GetKeyButton local y=function(y)if
y:len()~=32 then u.Library:Notify{Title='strelizia.cc',Description=
'invalid key length!',Time=2}return end w:SetDisabled(true)u.Library:Notify{
Title='strelizia.cc',Description='checking your key, please wait...',Time=2}
local z=s:Check(y)u.Library:Notify{Title='strelizia.cc',Description=z.message,
Time=2}if z.code=='KEY_VALID'then r:Write(y)u.Library:Unload()return s:
LoadScript(y)else w:SetDisabled(false)end end w.Func=function()return y(u.
Library.Options.ScriptKeyInput.Value)end x.Func=function()local z,A,B={},{}for C
,D in j.KeySystemAdProviders do z[D.Name]={Title=D.Name,Order=C,Variant=
'Primary',Callback=function()setclipboard(string.format(
'https://ads.luarmor.net/get_key?for=%s',tostring(D.Identifier)))u.Library:
Notify{Title='strelizia.cc',Description=string.format(
[[you have selected the following provider: %s
link to the ad provider has been copied to your clipboard!]]
,tostring(D.Name))}if B then o:Write('SELECTED_AD_PROVIDER',D.Name)end end}table
.insert(A,string.format('%s %s: \n%s%s Key Length: %s\n%s%s Completion Time: %s'
,tostring(n),tostring(D.Name),tostring(k.LeadingSpace(5)),tostring(n),tostring(l
.CompressTime(D.KeyLength)),tostring(k.LeadingSpace(5)),tostring(n),tostring(l.
CompressTime(D.CompletionTime))))end local C=o:Read'SELECTED_AD_PROVIDER'if C
then local D=z[C]if(D)then return D.Callback()end o:Write('SELECTED_AD_PROVIDER'
,nil)end local D=u.Window:AddDialog('AdProviderSelection',{Title=
'Ad Provider Selection',Description=
'select your ad provider based on the information below',Icon='key',
FooterButtons=z})D:AddLabel('AdProviderLabel',{Text=table.concat(A,'\n\n'),
DoesWrap=true})D:AddToggle('RememberMyChoiceProvider',{Text='remember my choice'
,Tooltip='wont ask you to pick providers again',Callback=function(E)B=E end})end
v.JoinDiscordButton.Func=function()m(j.DiscordInviteCode,true)u.Library:Notify{
Title='strelizia.cc',Description=
'successfully copied/prompted discord join code!'}end v.UnloadScript.Func=
function()return u.Library:Unload()end end)()end,function()local b,c,d=a(2)
return(function(...)local e=d(c.Parent.Vinca)return e.new():Extend(e.Extensions.
Children(c))end)()end,function()local b,c=a(3)return(function(...)return
function(d)return d.new(d):Extend(d.Extensions.Children(c))end end)()end,
function()a(4)return(function(...)return function(b)local c=b.Services local d,e
,f,g,h=c.EncodingService,b:Get'Shared/Modules/t',{},'strelizia/key.bin',typeof(
isfile)=='function'and typeof(writefile)=='function'and typeof(delfile)==
'function'f.Erase=function(i)if not h then return false end return pcall(delfile
,g)end f.Read=function(i)if(not h)then return nil end if(not isfile(g))then
return nil end local j,k=pcall(d.Base64Decode,d,buffer.fromstring(readfile(g)))
if(not j)then return f:Erase()end return buffer.tostring(k):reverse()end f.Write
=function(i,j)assert(e.string(j))if not h then return false end writefile(g,
buffer.tostring(d:Base64Encode(buffer.fromstring(j:reverse()))))return true end
return f end end)()end,function()a(5)return(function(...)return function(b)local
c,d,e,f=b:Get'Shared/Modules/t',
[[Cannot run any Luarmor module methods without calling :Init() first!]],
getgenv(),{}f.Init=function(g,h)assert(c.string(h))if(not g.Cached)then g.Cached
=loadstring(game:HttpGet'https://sdkapi-public.luarmor.net/library.lua')()g.
Cached.script_id=h end return g end f.Get=function(g)assert(c.table(g.Cached),d)
return g.Cached end f.Check=function(g,h)return g:Get().check_key(h)end f.
LoadScript=function(g,h)e.script_key=h return g:Get().load_script()end f.Purge=
function(g)g:Get().purge_cache()return g end return f end end)()end,function()a(
6)return(function(...)return function(b)local c,d,e,f,g,h=b:Get
'Shared/Constants',b:Get'Shared/Modules/Places',b:Get'Shared/Functions/Time',b:
Get'Shared/RBXUtil/TableUtil',b:Get'Shared/Modules/Interface',b:Get
'Shared/Modules/Color'local i,j,k,l=c.Characters,Color3.fromRGB(255,170,255),h.
Paint,{}l.Create=function(m)local n=g.GetInterface'Obsidian'local o=n.Main l.
Library=o local p,q=d.GetPlaceFromId(game.PlaceId),o:CreateWindow{Title=
'key system',Footer='strelizia.cc',Size=UDim2.fromOffset(600,540),Icon=
79981166576877,CornerRadius=6,SidebarCompacted=true}l.Window=q local r={Home=q:
AddTab{Name='Home',Icon='house',Description=
'everything related to the key system'},Settings=q:AddTab{Name='Settings',Icon=
'cog',Description='loader/ui configuration'}}local s=r.Home:AddGroupbox{Side=1,
Name='Key System',IconName='key'}s:AddInput('ScriptKeyInput',{Placeholder=
'key goes here!',ClearTextOnFocus=true,Text='Script Key',Tooltip=
[[paste your script key in here to access the script, press get key down below in order to get the key]]
})s:AddButton('CheckKeyButton',{Text='Check Key',Tooltip=
[[checks if the key in the input above is valid and loads the script]]}):
AddButton('GetKeyButton',{Text='Get Key',Tooltip=
'prompts ad provider links which lead to the script key'})local t,u,v=r.Home:
AddGroupbox{Side=1,Name='Information',IconName='info'},{string.format(
[[If you don't have a key yet, press %s, choose an %s and finish the ad flow after which you will receive %s.]]
,tostring(h.Paint('Get Key',j)),tostring(h.Paint('ad provider',j)),tostring(h.
Paint('your key',j))),string.format(
[[Paste your %s into the %s above and press validate in order to load the script.]]
,tostring(h.Paint('key',j)),tostring(h.Paint('input box',j))),string.format(
[[In case you run into issues or have questions make sure to join our %s by clicking the button below!]]
,tostring(h.Paint('discord server',j)))},''for w,x in u do v=v..string.format(
'%s %s \n \n',tostring(i.BulletPoint),tostring(x))end t:AddLabel('TutorialLabel'
,{Text=v:sub(1,-4),DoesWrap=true})t:AddDivider{Text='misc'}t:AddButton(
'JoinDiscordButton',{Text='Join Discord Server',Tooltip=
[[pressing this will either prompt our discord server directly in the app or copy the link to your clipboard]]
})t:AddButton('UnloadScript',{Text='Unload',Tooltip=
'pressing this will unload the script loader'})local w=r.Home:AddGroupbox{Side=2
,Name='Script Update Log',IconName='clipboard-clock'}w:AddLabel(
'ScriptUpdateDate',{Text=string.format('Last Updated at: %s',tostring(e.
FormatTime(p.Update.Time,'MM/DD/YYYY HH:mm'))),DoesWrap=true,Alignment=Enum.
TextXAlignment.Center})w:AddDivider{Text='update log'}w:AddLabel(
'ScriptUpdateLog',{Text=table.concat(p.Update.Log,'\n'),DoesWrap=true,Alignment=
Enum.TextXAlignment.Center})n.Tabs.Settings(r.Settings)return l end return l end
end)()end,function()a(7)return(function(...)return function(b)local c,d,e='0vma'
,'strelizia','shared.luau'print'\u{2139}\u{fe0f} | fetching shared lib from cdn'
local f,g=os.clock(),request{Url=string.format(
'https://raw.githubusercontent.com/%s/%s/refs/heads/main/%s',tostring(c),
tostring(d),tostring(e)),Method='GET'}if(g.StatusCode~=200)then print(string.
format('\u{274c} | failed to fetch shared lib from cdn: %s | %s',tostring(g.
StatusCode),tostring(g.StatusMessage)))return nil end local h=tonumber(g.Headers
.Age or 0)>0 and'hit'or'miss'print(string.format(
'\u{2705} | successfully fetched shared lib in %sms (cache %s)',tostring(math.
floor((os.clock()-f)*1000)),tostring(h)))local i,j=pcall(function()return
loadstring(g.Body)()end)if(not i)then print(string.format(
'\u{274c} | failed to exec shared lib: %s',tostring(j)))return nil end return j
end end)()end,function()local b,c,d=a(8)return(function(...)local e={}e.__index=
e e.Extensions={Children=function(f)local g={}for h,i in f:GetChildren()do g[i.
Name]=i end return g end}local f=cloneref or function(f)return f end e.Services=
setmetatable({},{__index=function(g,h)local i,j=pcall(game.GetService,game,h)if
i and j then j=f(j)rawset(g,h,j)return j end return nil end})e.new=function(g)
local h=setmetatable({__vinca=true,Loaded={},Loading={},Container={}},e)h.Root=g
or h return h end e.is=function(g)return g and typeof(g)=='table'and rawget(g,
'__vinca')end e.Add=function(g,h,i)assert(not g.Container[h],
'Index already exists')g.Container[h]=i return g end e.Load=function(g,h)if g.
Loaded[h]~=nil then return g.Loaded[h]end local i=g.Container[h]assert(i~=nil,
string.format('Unknown dependency "%s"',tostring(h)))assert(not g.Loading[h],
string.format('Circular dependency at "%s"',tostring(h)))g.Loading[h]=true if
typeof(i)=='table'and i.ClassName=='ModuleScript'then i=d(i)elseif typeof(i)==
'Instance'and i.ClassName=='ModuleScript'then i=d(i)end if typeof(i)=='function'
then i=i(g.Root)end g.Loading[h]=nil g.Loaded[h]=i return i end e.Extend=
function(g,h)for i,j in h do g:Add(i,j)end return g end e.Get=function(g,h)local
i=g for j in string.gmatch(h,'[^/]+')do if e.is(i)then i=i:Load(j)else i=i[j]end
assert(i~=nil,string.format('Invalid path "%s" at "%s"',tostring(h),tostring(j))
)end return i end return e end)()end},{{1,4,{'Loader'},{{2,2,{'Library'},{{7,2,{
'Shared'}},{6,2,{'Interface'}},{3,2,{'Modules'},{{5,2,{'Luarmor'}},{4,2,{
'KeyFile'}}}}}},{8,2,{'Vinca'}}}}},'0.4.2','strelizia.cc',string,task,
setmetatable,error,next,table,unpack,coroutine,script,type,require,pcall,
tostring,tonumber,_VERSION local v,w,x,y,z,A,B=k.insert,k.remove,k.freeze or
function(v)return v end,m.wrap,f.sub,f.match,f.gmatch if t and z(t,1,4)=='Lune'
then local C,D=q(p,'@lune/task')if C and D then g=D end end local C=g and g.
defer local D,E,F,G,H,I,J,K,L=C or function(D,...)y(D)(...)end,{[1]='Folder',[2]
='ModuleScript',[3]='Script',[4]='LocalScript',[5]='StringValue'},{},{},{},{},{}
,{},{}local M,N={GetFullName={{},function(M)local N,O=M.Name,M.Parent while O do
N=O.Name..'.'..N O=O.Parent end return N end},GetChildren={{},function(M)local N
={}for O in j,L[M]do v(N,O)end return N end},GetDescendants={{},function(M)local
N={}for O in j,L[M]do v(N,O)for P,Q in j,O:GetDescendants()do v(N,Q)end end
return N end},FindFirstChild={{'string','boolean?'},function(M,N,O)local P=L[M]
for Q in j,P do if Q.Name==N then return Q end end if O then for Q in j,P do
return Q:FindFirstChild(N,true)end end end},FindFirstAncestor={{'string'},
function(M,N)local O=M.Parent while O do if O.Name==N then return O end O=O.
Parent end end},WaitForChild={{'string','number?'},function(M,N)return M:
FindFirstChild(N)end}},{}for O,P in j,M do local Q,R,S=P[1],P[2],{}for T,U in j,
Q do local V,W=A(U,'^([^%?]+)(%??)')S[T]={V,W}end N[O]=function(T,...)if not L[T
]then i("Expected ':' not '.' calling member function "..O,2)end local U={...}
for V,W in j,S do local X=U[V]local Y,Z,_=o(X),W[1],W[2]if X==nil and not _ then
i('Argument '..X..' missing or nil',3)end if Z~='any'and Y~=Z and not(Y=='nil'
and _)then i('Argument '..V..' expects type "'..Z..'", got "'..Y..'"',2)end end
return R(T,...)end end local O=function(O,P,Q)local R,S,T,U,V,W=h({},{__mode='k'
}),function(R)i(R..' is not a valid (virtual) member of '..O..' "'..P..'"',3)end
,function(R)i('Unable to assign (virtual) property '..R..
'. Property is read only',3)end,{},{}V.__metatable=false V.__index=function(X,Y)
if Y=='ClassName'then return O elseif Y=='Name'then return P elseif Y=='Parent'
then return Q elseif O=='StringValue'and Y=='Value'then return W else local Z=N[
Y]if Z then return Z end end for Z in j,R do if Z.Name==Y then return Z end end
S(Y)end V.__newindex=function(X,Y,Z)if Y=='ClassName'then T(Y)elseif Y=='Name'
then P=Z elseif Y=='Parent'then if Z==U then return end if Q~=nil then L[Q][U]=
nil end Q=Z if Z~=nil then L[Z][U]=true end elseif O=='StringValue'and Y==
'Value'then W=Z else S(Y)end end V.__tostring=function()return P end h(U,V)L[U]=
R if Q~=nil then L[Q][U]=true end return U end local function
CreateRefFromObject(P,Q)local R,S,T,U=P[1],P[2],P[3],P[4]local V=E[S]local W=T
and w(T,1)or V local X=O(V,W,Q)F[R]=X if T then for Y,Z in j,T do X[Y]=Z end end
if U then for Y,Z in j,U do CreateRefFromObject(Z,X)end end return X end local P
=O('Folder','['..e..']')for Q,R in j,c do CreateRefFromObject(R,P)end for Q,R in
j,b do local S=F[Q]G[S]=R H[S]=Q local T=S.ClassName if T=='LocalScript'or T==
'Script'then v(J,S)end end local Q=function(Q)local R,S=Q.ClassName,I[Q]if S and
R=='ModuleScript'then return l(S)end local T,U=G[Q],function(T)T=r(T)local U,V,W
=Q:GetFullName(),A(T,'[^:]+:(%d+): (.+)')if not V or not u then return U..':*: '
..(W or T)end V=s(V)local X=H[Q]local Y=u[X]local Z=V-Y+1 if Z<0 then Z='?'end
return U..':'..Z..': '..W end if R=='LocalScript'or R=='Script'then local V,W=q(
T)if not V then i(U(W),0)end else local V={q(T)}local W=w(V,1)if not W then
local X=w(V,1)i(U(X),0)end I[Q]=V return l(V)end end a=function(R)local S,T,U=F[
R],function(S,...)local T={q(S,...)}local U=w(T,1)if not U then i(T[1],3)end
return l(T)end,x(h({},{__index=K,__newindex=function(S,T,U)K[T]=U end,__len=
function()return#K end,__iter=function()return j,K end}))local aa,ab,ac=x{
version=d,envname=e,shared=U,script=n,require=p},S,function(V,...)local W,X,Y=o(
V),'Attempted to call require with a non-ModuleScript',
'Attempted to call require with self'if W=='table'and L[V]then if V.ClassName~=
'ModuleScript'then i(X,2)elseif V==S then i(Y,2)end return Q(V)elseif W==
'string'and z(V,1,1)~='@'then if#V==0 then i(
'Attempted to call require with empty string',2)end local Z=S if z(V,1,1)=='/'
then Z=P elseif z(V,1,2)=='./'then V=z(V,3)end local _ for aa in B(V,'([^/]*)/?'
)do local ab=aa if aa=='..'then ab='Parent'end if ab~=''then local ac=Z:
FindFirstChild(ab)if not ac then local ad=Z.Parent if ad then ac=ad:
FindFirstChild(ab)end end if ac then Z=ac elseif aa~=_ and aa~='init'and aa~=
'init.server'and aa~='init.client'then i('Virtual script path "'..V..
'" not found',2)end end _=aa end if Z.ClassName~='ModuleScript'then i(X,2)elseif
Z==S then i(Y,2)end return Q(Z)end return T(p,V,...)end return aa,ab,ac end for
aa,ab in j,J do D(Q,ab)end
