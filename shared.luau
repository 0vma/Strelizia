local a local aa,ab,ac,ad,ae,af,ag,ah,ai,aj,ak,al,am,an,ao,ap,aq,ar,as,at={
function()local b,c,d=a(1)return(function(...)local e=d(c.Vinca)return e.new():
Extend(e.Extensions.Children(c))end)()end,function()local b,c=a(2)return(
function(...)return function(d)return d.new(d):Extend(d.Extensions.Children(c))
end end)()end,function()local b,c,d=a(3)return(function(...)return function(e)
local f=e.Services local g,h,i,j=f.RunService,d(c.Lock)(e),d(c.Task)(e),e:Get
'RBXUtil/Trove'local k={Running=false,Connection=nil,Trove=j.new(),Tasks={},
PendingTasks={}}k.Task=i k.Lock=h k.Begin=function()if k.Running then return end
k.Running=true k.Connection=g.Heartbeat:Connect(function(l)if(not k.Running)then
return end debug.profilebegin'TaskManager'for m,n in k.PendingTasks do k.
PendingTasks[m]=nil task.spawn(function()local o=n:Run()if(not o)or(not n.
Interval)then return k.RemoveTask(m)end task.wait(n.Interval)if(k.Tasks[m])then
k.PendingTasks[m]=n end end)end debug.profileend()end)end k.Stop=function()if
not k.Running then return end k.Running=false k.Connection:Disconnect()k.
Connection=nil for l in k.Tasks do k.RemoveTask(l)end k.Trove:Destroy()end k.
AddTask=function(l)assert(l and i.is(l),'Task must be a Task object!')local m=l.
Identifier k.Tasks[m]=l k.PendingTasks[m]=l return m end k.RemoveTask=function(l
)local m=k.Tasks[l]if(not m)then return end k.Tasks[l]=nil k.PendingTasks[l]=nil
m:Destroy()end k.GetTasksFromIndex=function(l)local m={}for n,o in k.Tasks do if
o.Index~=l then continue end m[n]=o end return m end k.RemoveTasksByIndex=
function(l)for m in k.GetTasksFromIndex(l)do k.RemoveTask(m)end end return k end
end)()end,function()a(4)return(function(...)return function(b)local c={}c.
__index=c local d,e,f,g,h,i,j,k=b:Get'Modules/t',b:Get'Functions/Time',b:Get
'Functions/OutputMessage',b:Get'Functions/CreateGUID',debug.setmemorycategory,
debug.resetmemorycategory,debug.profilebegin,debug.profileend local l,m=d.tuple(
d.string,d['function'],d.optional(d.number),d.optional(d.boolean)),d.optional(d.
string)c.new=function(n,o,p,q)assert(l(n,o,p,q))return setmetatable({__TASK=true
,Index=n,Identifier=g(),Callback=o,Running=false,Destroyed=false,Interval=p,
CurrentStep=nil,Profiling=false,Priority=1,Locks=q and{Groups={},Individual={}}
or nil},c)end c.is=function(n)return typeof(n)=='table'and rawget(n,'__TASK')end
c.SetPriority=function(n,o)assert(d.number(o))n.Priority=o return n end c.
GetPriority=function(n)return n.Priority end c.SetStep=function(n,o)assert(m(o))
local p=n.CurrentStep n.CurrentStep=o if p then k()end if o~=nil then j(o)end
return n end c.SetProfiling=function(n,o)assert(d.boolean(o))if n.Profiling==o
then return n end n.Profiling=o if o then j(n.Index)else if n.CurrentStep then n
:SetStep(nil)end k()end return n end c.Run=function(n)n.Running=true local o,p=
pcall(n.Callback,n)if(not o)then f('Error',string.format(
[[An error has occured during runtime of Thread '%s' on Step '%s': %s]],
tostring(n.Index),tostring(tostring(n.CurrentStep)),tostring(p)))end n.Running=
false if n.Profiling then n:SetProfiling(false)end return o,p end c.Destroy=
function(n)n.Destroyed=true local o=n.Locks if o then for p in o.Groups do p:
Release()end for p in o.Individual do p:Release()end table.clear(o.Groups)table.
clear(o.Individual)end return n end return{new=c.new,is=c.is}end end)()end,
function()a(5)return(function(...)return function(b)local c,d,e=b:Get'Modules/t'
,b:Get'RBXUtil/Signal',b:Get'RBXUtil/TableUtil'local f,g,h,i=e.Dictionary,e.
Filter,function(f,g)local h,i=f:GetPriority(),g:GetPriority()if h~=i then return
h>i end return f.Identifier>g.Identifier end,{Cache={}}i.__index=i i.new=
function(j)assert(c.string(j))if i.Cache[j]then return i.Cache[j]end local k=
setmetatable({__LOCK=true,Index=j,User=nil,UserChanged=d.new(),TakeoverRecipient
=nil,TakeoverInitiated=d.new(),Aborted=false,Destroyed=false},i)i.Cache[j]=k
return k end i.is=function(j)return typeof(j)=='table'and rawget(j,'__LOCK')end
i.CanTake=function(j,k)assert(k and typeof(k)=='table',
'Must provide a Task object for evaluation!')assert(k.Locks,
'Task must be Lock-utilizing!')local l=j.User if(not l)then return true end if(l
==k)then return true end local m=j.TakeoverRecipient if m then return h(k,m)end
return h(k,l)end i.TakeAsync=function(j,k)assert(k and typeof(k)=='table',
'Must provide a Task object for evaluation!')assert(k.Locks,
'Task must be Lock-utilizing!')if(not j.User)then j.User=k j.Aborted=false k.
Locks.Individual[j]=true j.UserChanged:Fire(k,nil)return true end if(j.User==k)
then return true end j.Aborted=true j.TakeoverRecipient=k j.TakeoverInitiated:
Fire(k,j.User)return j.UserChanged:Wait()==k end i.Release=function(j)if(not j.
User)then return j end local k,l=j.User,j.TakeoverRecipient j.User=l j.
TakeoverRecipient=nil j.Aborted=false k.Locks.Individual[j]=nil if l then l.
Locks.Individual[j]=true end j.UserChanged:Fire(l,k)return j end local j={}j.
__index=j j.new=function(k)assert(k and typeof(k)=='table',
'Must provide Locks for a Group')local l=setmetatable({User=nil,UserChanged=d.
new(),Locks=f(g(k,i.is)),TakeoverRecipient=nil,TakeoverInitiated=d.new(),Aborted
=false,Connections={},Destroyed=false},j)for m in l.Locks do table.insert(l.
Connections,m.TakeoverInitiated:Connect(function(n,o)if(not l.User)or(l.User~=o)
then return end l.Aborted=true end))end return l end j.CanTake=function(k,l)for
m in k.Locks do if m:CanTake(l)then continue end return false end return true
end j.TakeAsync=function(k,l)local m=k.User if(m==l)then return true end if m
then k.TakeoverRecipient=l k.TakeoverInitiated:Fire(l,m)return k.UserChanged:
Wait()==l end local n={}for o in k.Locks do if o:TakeAsync(l)then n[o]=true
continue end for p in n do p:Release()end return false end k.User=l k.Aborted=
false l.Locks.Groups[k]=true k.UserChanged:Fire(l,m)return true end j.Release=
function(k)if(not k.User)then return k end local l,m=k.User,k.TakeoverRecipient
for n in k.Locks do if(n.User~=l)then continue end if m then n.User=m n.Aborted=
false l.Locks.Individual[n]=nil m.Locks.Individual[n]=true else n:Release()end
end k.User=m k.TakeoverRecipient=nil k.Aborted=false l.Locks.Groups[k]=nil if m
then m.Locks.Groups[k]=true end k.UserChanged:Fire(m,l)return k end j.Destroy=
function(k)if(not k.Destroyed)then k.Destroyed=true for l,m in k.Connections do
m:Disconnect()end table.clear(k.Connections)end return k end return table.freeze
{new=i.new,Group=j}end end)()end,function()a(6)return(function(...)return
function(b)local c=b:Get'Modules/t'local d,e,f,g=c.tuple(c.ColorSequence,c.
numberConstrained(0,1)),c.tuple(c.string,c.union(c.Color3,c.ColorSequence)),c.
intersection(c.array(c.Color3),function(d)return#d>=2,
'Merge requires at least 2 colors'end),math.floor local h,i=function(h,i)return
string.format('<font color="rgb(%s,%s,%s)">%s</font>',tostring(g(i.R*255)),
tostring(g(i.G*255)),tostring(g(i.B*255)),tostring(h))end,{}i.
EvaluateColorSequence=function(j,k)assert(d(j,k))local l=j.Keypoints local m=l[1
]for n=2,#l do local o=l[n]if k<=o.Time then local p=(k-m.Time)/(o.Time-m.Time)
return m.Value:Lerp(o.Value,p)end m=o end return l[#l].Value end i.Paint=
function(j,k)assert(e(j,k))if typeof(k)=='Color3'then return h(j,k)elseif
typeof(k)=='ColorSequence'then local l,m={},#j for n=1,m do local o=(m==1)and 0
or((n-1)/(m-1))l[n]=i.Paint(j:sub(n,n),i.EvaluateColorSequence(k,o))end return
table.concat(l)end end i.Merge=function(...)local j={...}assert(f(j))local k,l={
},#j for m,n in j do table.insert(k,ColorSequenceKeypoint.new((m-1)/(l-1),n))end
return ColorSequence.new(k)end return i end end)()end,function()a(7)return(
function(...)return function(b)local c={}c.type=function(d)return function(e)
local f=type(e)if f==d then return true else return false,string.format(
'%s expected, got %s',d,f)end end end c.typeof=function(d)return function(e)
local f=typeof(e)if f==d then return true else return false,string.format(
'%s expected, got %s',d,f)end end end c.any=function(d)if d~=nil then return
true else return false,'any expected, got nil'end end c.boolean=c.typeof
'boolean'c.buffer=c.typeof'buffer'c.thread=c.typeof'thread'c.callback=c.typeof
'function'c['function']=c.callback c.none=c.typeof'nil'c['nil']=c.none c.string=
c.typeof'string'c.table=c.typeof'table'c.userdata=c.type'userdata'c.vector=c.
type'vector'c.number=function(d)local e=typeof(d)if e=='number'then if d==d then
return true else return false,'unexpected NaN value'end else return false,string
.format('number expected, got %s',e)end end c.nan=function(d)local e=typeof(d)if
e=='number'then if d~=d then return true else return false,
'unexpected non-NaN value'end else return false,string.format(
'number expected, got %s',e)end end c.Axes=c.typeof'Axes'c.BrickColor=c.typeof
'BrickColor'c.CatalogSearchParams=c.typeof'CatalogSearchParams'c.CFrame=c.typeof
'CFrame'c.Content=c.typeof'Content'c.Color3=c.typeof'Color3'c.ColorSequence=c.
typeof'ColorSequence'c.ColorSequenceKeypoint=c.typeof'ColorSequenceKeypoint'c.
DateTime=c.typeof'DateTime'c.DockWidgetPluginGuiInfo=c.typeof
'DockWidgetPluginGuiInfo'c.Enum=c.typeof'Enum'c.EnumItem=c.typeof'EnumItem'c.
Enums=c.typeof'Enums'c.Faces=c.typeof'Faces'c.FloatCurveKey=c.typeof
'FloatCurveKey'c.Font=c.typeof'Font'c.Instance=c.typeof'Instance'c.NumberRange=c
.typeof'NumberRange'c.NumberSequence=c.typeof'NumberSequence'c.
NumberSequenceKeypoint=c.typeof'NumberSequenceKeypoint'c.OverlapParams=c.typeof
'OverlapParams'c.PathWaypoint=c.typeof'PathWaypoint'c.PhysicalProperties=c.
typeof'PhysicalProperties'c.Random=c.typeof'Random'c.Ray=c.typeof'Ray'c.
RaycastParams=c.typeof'RaycastParams'c.RaycastResult=c.typeof'RaycastResult'c.
RBXScriptConnection=c.typeof'RBXScriptConnection'c.RBXScriptSignal=c.typeof
'RBXScriptSignal'c.Rect=c.typeof'Rect'c.Region3=c.typeof'Region3'c.Region3int16=
c.typeof'Region3int16'c.TweenInfo=c.typeof'TweenInfo'c.UDim=c.typeof'UDim'c.
UDim2=c.typeof'UDim2'c.Vector2=c.typeof'Vector2'c.Vector2int16=c.typeof
'Vector2int16'c.Vector3=c.typeof'Vector3'c.Vector3int16=c.typeof'Vector3int16'c.
literalList=function(d)local e={}for f,g in ipairs(d)do e[g]=true end return
function(f)if e[f]then return true end return false,'bad type for literal list'
end end c.literal=function(...)local d=select('#',...)if d==1 then local e=...
return function(f)if f~=e then return false,string.format('expected %s, got %s',
tostring(e),tostring(f))end return true end else local e={}for f=1,d do local g=
select(f,...)e[f]=c.literal(g)end return c.unionList(e)end end c.exactly=c.
literal c.keyOf=function(d)local e,f={},0 for g in pairs(d)do f=f+1 e[f]=g end
return c.literal(table.unpack(e,1,f))end c.valueOf=function(d)local e,f={},0 for
g,h in pairs(d)do f=f+1 e[f]=h end return c.literal(table.unpack(e,1,f))end c.
integer=function(d)local e,f=c.number(d)if not e then return false,f or''end if
d%1==0 then return true else return false,string.format(
'integer expected, got %s',d)end end c.numberMin=function(d)return function(e)
local f,g=c.number(e)if not f then return false,g or''end if e>=d then return
true else return false,string.format('number >= %s expected, got %s',d,e)end end
end c.numberMax=function(d)return function(e)local f,g=c.number(e)if not f then
return false,g end if e<=d then return true else return false,string.format(
'number <= %s expected, got %s',d,e)end end end c.numberMinExclusive=function(d)
return function(e)local f,g=c.number(e)if not f then return false,g or''end if d
<e then return true else return false,string.format(
'number > %s expected, got %s',d,e)end end end c.numberMaxExclusive=function(d)
return function(e)local f,g=c.number(e)if not f then return false,g or''end if e
<d then return true else return false,string.format(
'number < %s expected, got %s',d,e)end end end c.numberPositive=c.
numberMinExclusive(0)c.numberNegative=c.numberMaxExclusive(0)c.numberConstrained
=function(d,e)assert(c.number(d))assert(c.number(e))local f,g=c.numberMin(d),c.
numberMax(e)return function(h)local i,j=f(h)if not i then return false,j or''end
local k,l=g(h)if not k then return false,l or''end return true end end c.
numberConstrainedExclusive=function(d,e)assert(c.number(d))assert(c.number(e))
local f,g=c.numberMinExclusive(d),c.numberMaxExclusive(e)return function(h)local
i,j=f(h)if not i then return false,j or''end local k,l=g(h)if not k then return
false,l or''end return true end end c.match=function(d)assert(c.string(d))return
function(e)local f,g=c.string(e)if not f then return false,g end if string.
match(e,d)==nil then return false,string.format('%q failed to match pattern %q',
e,d)end return true end end c.optional=function(d)assert(c.callback(d))return
function(e)if e==nil then return true end local f,g=d(e)if f then return true
else return false,string.format('(optional) %s',g or'')end end end c.tuple=
function(...)local d={...}return function(...)local e={...}for f,g in ipairs(d)
do local h,i=g(e[f])if h==false then return false,string.format(
'Bad tuple index #%s:\n\t%s',f,i or'')end end return true end end c.keys=
function(d)assert(c.callback(d))return function(e)local f,g=c.table(e)if f==
false then return false,g or''end for h in pairs(e)do local i,j=d(h)if i==false
then return false,string.format('bad key %s:\n\t%s',tostring(h),j or'')end end
return true end end c.values=function(d)assert(c.callback(d))return function(e)
local f,g=c.table(e)if f==false then return false,g or''end for h,i in pairs(e)
do local j,k=d(i)if j==false then return false,string.format(
'bad value for key %s:\n\t%s',tostring(h),k or'')end end return true end end c.
map=function(d,e)assert(c.callback(d))assert(c.callback(e))local f,g=c.keys(d),c
.values(e)return function(h)local i,j=f(h)if not i then return false,j or''end
local k,l=g(h)if not k then return false,l or''end return true end end c.set=
function(d)return c.map(d,c.literal(true))end do local d=c.keys(c.integer)c.
array=function(e)assert(c.callback(e))local f=c.values(e)return function(g)local
h,i=d(g)if h==false then return false,string.format('[array] %s',i or'')end
local j=0 for k in ipairs(g)do j=j+1 end for k in pairs(g)do if k<1 or k>j then
return false,string.format('[array] key %s must be sequential',tostring(k))end
end local k,l=f(g)if not k then return false,string.format('[array] %s',l or'')
end return true end end c.strictArray=function(...)local e={...}assert(c.array(c
.callback)(e))return function(f)local g,h=d(f)if g==false then return false,
string.format('[strictArray] %s',h or'')end if#e<#f then return false,string.
format('[strictArray] Array size exceeds limit of %d',#e)end for i,j in pairs(e)
do local k,l=j(f[i])if not k then return false,string.format(
'[strictArray] Array index #%d - %s',i,l)end end return true end end end do
local d=c.array(c.callback)c.unionList=function(e)assert(d(e))return function(f)
for g,h in ipairs(e)do if h(f)then return true end end return false,
'bad type for union'end end c.union=function(...)return c.unionList{...}end c.
some=c.union c.intersectionList=function(e)assert(d(e))return function(f)for g,h
in ipairs(e)do local i,j=h(f)if not i then return false,j or''end end return
true end end c.intersection=function(...)return c.intersectionList{...}end c.
every=c.intersection end do local d=c.map(c.any,c.callback)c.interface=function(
e)assert(d(e))return function(f)local g,h=c.table(f)if g==false then return
false,h or''end for i,j in pairs(e)do local k,l=j(f[i])if k==false then return
false,string.format('[interface] bad value for %s:\n\t%s',tostring(i),l or'')end
end return true end end c.strictInterface=function(e)assert(d(e))return function
(f)local g,h=c.table(f)if g==false then return false,h or''end for i,j in pairs(
e)do local k,l=j(f[i])if k==false then return false,string.format(
'[interface] bad value for %s:\n\t%s',tostring(i),l or'')end end for i in pairs(
f)do if not e[i]then return false,string.format(
'[interface] unexpected field %q',tostring(i))end end return true end end end c.
instanceOf=function(d,e)assert(c.string(d))local f if e~=nil then f=c.children(e
)end return function(g)local h,i=c.Instance(g)if not h then return false,i or''
end if g.ClassName~=d then return false,string.format('%s expected, got %s',d,g.
ClassName)end if f then local j,k=f(g)if not j then return false,k end end
return true end end c.instance=c.instanceOf c.instanceIsA=function(d,e)assert(c.
string(d))local f if e~=nil then f=c.children(e)end return function(g)local h,i=
c.Instance(g)if not h then return false,i or''end if not g:IsA(d)then return
false,string.format('%s expected, got %s',d,g.ClassName)end if f then local j,k=
f(g)if not j then return false,k end end return true end end c.enum=function(d)
assert(c.Enum(d))return function(e)local f,g=c.EnumItem(e)if not f then return
false,g end if e.EnumType==d then return true else return false,string.format(
'enum of %s expected, got enum of %s',tostring(d),tostring(e.EnumType))end end
end do local d=c.tuple(c.callback,c.callback)c.wrap=function(e,f)assert(d(e,f))
return function(...)assert(f(...))return e(...)end end end c.strict=function(d)
return function(...)assert(d(...))end end do local d=c.map(c.string,c.callback)c
.children=function(e)assert(d(e))return function(f)local g,h=c.Instance(f)if not
g then return false,h or''end local i={}for j,k in ipairs(f:GetChildren())do
local l=k.Name if e[l]then if i[l]then return false,string.format(
'Cannot process multiple children with the same name %q',l)end i[l]=k end end
for j,k in pairs(e)do local l,m=k(i[j])if not l then return false,string.format(
'[%s.%s] %s',f:GetFullName(),j,m or'')end end return true end end end return c
end end)()end,function()local b,c,d=a(8)return(function(...)return function(e)
local f={Loaded={}}f.GetInterface=function(g)assert(typeof(g)=='string',
'Must provide Inteface Name')if f.Loaded[g]then return f.Loaded[g]end local h=c.
List:FindFirstChild(g)assert(h,string.format(
"Failed to find Interface Components for: '%s'",tostring(g)))local i={}for j,k
in h:GetChildren()do assert(k.ClassName=='ModuleScript',string.format(
[[Failed to load Interface Component '%s' of '%s': Instance is not a ModuleScript.]]
,tostring(k.Name),tostring(g)))i[k.Name]=d(k)(e)end f.Loaded[g]=i return i end
return f end end)()end,[11]=function()a(11)return(function(...)return function(b
)local c=(cloneref or clonereference or function(c)return c end)local d,e,f,g,h,
i,j,k,l,m,n=c(game:GetService'CoreGui'),c(game:GetService'Players'),c(game:
GetService'RunService'),c(game:GetService'SoundService'),c(game:GetService
'UserInputService'),c(game:GetService'TextService'),c(game:GetService'Teams'),c(
game:GetService'TweenService'),getgenv or function()return shared end,
setclipboard or nil,protectgui or(syn and syn.protect_gui)or function()end local
o,p=gethui or function()return d end,e.LocalPlayer or e.PlayerAdded:Wait()local
q,r,s,t,u,v,w,x=c(p:GetMouse()),{},{},{},{},{},
[[https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/]],{}
local y={TransparencyTexture={RobloxId=139785960036434,Path=
'Obsidian/assets/TransparencyTexture.png',URL=w..
'assets/TransparencyTexture.png',Id=nil},SaturationMap={RobloxId=4155801252,Path
='Obsidian/assets/SaturationMap.png',URL=w..'assets/SaturationMap.png',Id=nil},
LoadingIcon={RobloxId=97544096941083,Path='Obsidian/assets/LoadingIcon.png',URL=
w..'assets/LoadingIcon.png',Id=nil},CheckIcon={RobloxId=97682394690683,Path=
'Obsidian/assets/CheckIcon.png',URL=w..'assets/CheckIcon.png',Id=nil}}do local z
=function(z,A)if not isfolder or not makefolder then return end local B,C=z:
split'/',''if A then table.remove(B,#B)end for D,E in ipairs(B)do if not
isfolder(C..E)then makefolder(C..E)end C=C..E..'/'end return C end x.AddAsset=
function(A,B,C,D)if y[A]~=nil then error(string.format('Asset %q already exists'
,A))end assert(typeof(B)=='number','RobloxAssetId must be a number')y[A]={
RobloxId=B,Path=string.format('Obsidian/custom_assets/%s',A),URL=C,Id=nil}x.
DownloadAsset(A,D)end x.GetAsset=function(A)if not y[A]then return nil end local
B=y[A]if B.Id then return B.Id end local C=string.format('rbxassetid://%s',B.
RobloxId)if getcustomasset then local D,E=pcall(getcustomasset,B.Path)if D and E
then C=E end end B.Id=C return C end x.DownloadAsset=function(A,B)if not
getcustomasset or not writefile or not isfile then return false,
'missing functions'end local C=y[A]z(C.Path,true)if B~=true and isfile(C.Path)
then return true,nil end local D,E=pcall(function()writefile(C.Path,game:
HttpGet(C.URL))end)return D,E end for A,B in y do x.DownloadAsset(A)end end
local z={LocalPlayer=p,DevicePlatform=nil,IsMobile=false,IsRobloxFocused=true,
ScreenGui=nil,SearchText='',Searching=false,GlobalSearch=false,LastSearchTab=nil
,ActiveTab=nil,Tabs={},TabButtons={},DependencyBoxes={},KeybindFrame=nil,
KeybindContainer=nil,KeybindToggles={},Notifications={},Dialogues={},
ActiveLoading=nil,ActiveDialog=nil,Corners={},ToggleKeybind=Enum.KeyCode.
RightControl,TweenInfo=TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.
EasingDirection.Out),NotifyTweenInfo=TweenInfo.new(0.25,Enum.EasingStyle.Quad,
Enum.EasingDirection.Out),Toggled=false,Unloaded=false,Labels=r,Buttons=s,
Toggles=t,Options=u,NotifySide='Right',ShowCustomCursor=true,ForceCheckbox=false
,ShowToggleFrameInKeybinds=true,NotifyOnError=false,CantDragForced=false,Signals
={},UnloadSignals={},OriginalMinSize=Vector2.new(480,360),MinSize=Vector2.new(
480,360),DPIScale=1,CornerRadius=4,CornerRadiusDropdown=false,IsLightTheme=false
,Scheme={BackgroundColor=Color3.fromRGB(15,15,15),MainColor=Color3.fromRGB(25,25
,25),AccentColor=Color3.fromRGB(125,85,255),OutlineColor=Color3.fromRGB(40,40,40
),FontColor=Color3.new(1,1,1),Font=Font.fromEnum(Enum.Font.Code),RedColor=Color3
.fromRGB(255,50,50),DestructiveColor=Color3.fromRGB(220,38,38),DarkColor=Color3.
new(0,0,0),WhiteColor=Color3.new(1,1,1)},Registry={},Scales={},ScalesOffset={},
ImageManager=x,ShowCursorBinding=string.sub(tostring{},10)}if f:IsStudio()then
if h.TouchEnabled and not h.MouseEnabled then z.IsMobile=true z.OriginalMinSize=
Vector2.new(480,240)else z.IsMobile=false z.OriginalMinSize=Vector2.new(480,360)
end else pcall(function()z.DevicePlatform=h:GetPlatform()end)z.IsMobile=(z.
DevicePlatform==Enum.Platform.Android or z.DevicePlatform==Enum.Platform.IOS)z.
OriginalMinSize=z.IsMobile and Vector2.new(480,240)or Vector2.new(480,360)end
local A,B,C,D,E={Frame={BorderSizePixel=0},ImageLabel={BackgroundTransparency=1,
BorderSizePixel=0},ImageButton={AutoButtonColor=false,BorderSizePixel=0},
ScrollingFrame={BorderSizePixel=0},TextLabel={BorderSizePixel=0,FontFace='Font',
RichText=true,TextColor3='FontColor'},TextButton={AutoButtonColor=false,
BorderSizePixel=0,FontFace='Font',RichText=true,TextColor3='FontColor'},TextBox=
{BorderSizePixel=0,FontFace='Font',PlaceholderColor3=function()local A,B,C=z.
Scheme.FontColor:ToHSV()return Color3.fromHSV(A,B,C/2)end,Text='',TextColor3=
'FontColor'},UIListLayout={SortOrder=Enum.SortOrder.LayoutOrder},UIStroke={
ApplyStrokeMode=Enum.ApplyStrokeMode.Border},Window={Title='No Title',Footer=
'No Footer',Position=UDim2.fromOffset(6,6),Size=UDim2.fromOffset(720,600),
IconSize=UDim2.fromOffset(30,30),AutoShow=true,Center=true,Resizable=true,
SearchbarSize=UDim2.fromScale(1,1),GlobalSearch=false,CornerRadius=4,NotifySide=
'Right',ShowCustomCursor=true,Font=Enum.Font.Code,ToggleKeybind=Enum.KeyCode.
RightControl,ShowMobileButtons=true,MobileButtonsSide='Left',
UnlockMouseWhileOpen=true,EnableSidebarResize=false,EnableCompacting=true,
DisableCompactingSnap=false,SidebarCompacted=false,MinContainerWidth=256,
MinSidebarWidth=128,SidebarCompactWidth=48,SidebarCollapseThreshold=0.5,
CompactWidthActivation=128},Dialog={Title='Dialog',Description='Description',
AutoDismiss=true,OutsideClickDismiss=true,FooterButtons={}},Loading={Title=
'mspaint',Icon=95816097006870,IconSize=UDim2.fromOffset(30,30),LoadingIcon=x.
GetAsset'LoadingIcon',LoadingIconColor=nil,LoadingIconTweenTime=1,CurrentStep=0,
TotalSteps=10,ShowSidebar=false,AutoResizeHeight=false,WindowWidth=450,
WindowHeight=275,ContentWidth=450,SidebarWidth=250},Toggle={Text='Toggle',
Default=false,Callback=function()end,Changed=function()end,Risky=false,Disabled=
false,Visible=true},Input={Text='Input',Default='',Finished=false,Numeric=false,
ClearTextOnFocus=true,ClearTextOnBlur=false,Placeholder='',AllowEmpty=true,
EmptyReset='---',Callback=function()end,Changed=function()end,VerifyValue=nil,
Disabled=false,Visible=true},Slider={Text='Slider',Default=0,Min=0,Max=100,
Rounding=0,Prefix='',Suffix='',Callback=function()end,Changed=function()end,
Disabled=false,Visible=true},Dropdown={Values={},DisabledValues={},ValueImages={
},RichText=false,Multi=false,MaxVisibleDropdownItems=8,Callback=function()end,
Changed=function()end,Disabled=false,Visible=true},Viewport={Object=nil,Camera=
nil,Clone=true,AutoFocus=true,Interactive=false,Height=200,Visible=true},Image={
Image='',Transparency=0,BackgroundTransparency=0,Color=Color3.new(1,1,1),
RectOffset=Vector2.zero,RectSize=Vector2.zero,ScaleType=Enum.ScaleType.Fit,
Height=200,Outline=false,Visible=true},Video={Video='',Looped=false,Playing=
false,Volume=1,Height=200,Visible=true},UIPassthrough={Instance=nil,Height=24,
Visible=true},KeyPicker={Text='KeyPicker',Default='None',DefaultModifiers={},
Blacklisted={},BlacklistedModifiers={},Whitelisted={},WhitelistedModifiers={},
Mode='Toggle',Modes={'Always','Toggle','Hold'},SyncToggleState=false,Callback=
function()end,ChangedCallback=function()end,Changed=function()end,Clicked=
function()end},ColorPicker={Default=Color3.new(1,1,1),Callback=function()end,
Changed=function()end}},{Bottom={0,1},Right={1,0}},{Left={0.5,1},Right={0.5,1}},
{RedColor='Red',WhiteColor='White',DarkColor='Dark'},{Red='RedColor',White=
'WhiteColor',Dark='DarkColor'}local F,G,H=function(F)if not F then return nil
end local G=D[F]if G and z.Scheme[G]~=nil then z.Scheme[F]=z.Scheme[G]z.Scheme[G
]=nil return z.Scheme[F]end local H=E[F]if H and z.Scheme[H]~=nil then warn(
string.format('Scheme Value %q is deprecated, please use %q instead.',F,H))
return z.Scheme[H]end return z.Scheme[F]end,function(F,G,H)local I=Instance.new
'BindableEvent'local J=F:Once(function(...)if not H or typeof(H)=='function'and
H(...)then I:Fire(true)else I:Fire(false)end end)task.delay(G,function()J:
Disconnect()I:Fire(false)end)local K=I.Event:Wait()I:Destroy()return K end,
function(F,G)return F.UserInputType==Enum.UserInputType.MouseButton1 or(G==true
and F.UserInputType==Enum.UserInputType.MouseButton2)or F.UserInputType==Enum.
UserInputType.Touch end local I,J,L,M,N,O,P,Q,R,S=function(I,J)return H(I,J)and
I.UserInputState==Enum.UserInputState.Begin and z.IsRobloxFocused end,function(I
)return(I.UserInputType==Enum.UserInputType.MouseMovement or I.UserInputType==
Enum.UserInputType.Touch)and I.UserInputState==Enum.UserInputState.Change end,
function(I,J)return H(I,J)and(I.UserInputState==Enum.UserInputState.Begin or I.
UserInputState==Enum.UserInputState.Change)and z.IsRobloxFocused end,function(I)
local J=0 for K,L in I do J=J+1 end return J end,function(I)if not(I and I.
PlaybackState==Enum.PlaybackState.Playing)then return end I:Cancel()end,function
(I)return I:match'^%s*(.-)%s*$'end,function(I,J)assert(J>=0,
'Invalid rounding number.')if J==0 then return math.floor(I)end return tonumber(
string.format('%.'..J..'f',I))end,function(I)I=I:gsub('<br%s*/>','\n')return(I:
gsub('<[^<>]->',''))end,function(I)local J=e:GetPlayers()if I then local L=table
.find(J,p)if L then table.remove(J,L)end end table.sort(J,function(L,M)return L.
Name:lower()<M.Name:lower()end)return J end,function()local I=j:GetTeams()table.
sort(I,function(J,L)return J.Name:lower()<L.Name:lower()end)return I end z.
UpdateDependencyBoxes=function(T)for U,V in z.DependencyBoxes do V:Update(true)
end if z.Searching then z:UpdateSearch(z.SearchText)end end local function
CheckDepbox(T,U)local V=0 for W,X in T.Elements do if X.Type=='Divider'then X.
Holder.Visible=false continue elseif X.SubButton then local Y=false if X.Text:
lower():match(U)and X.Visible then Y=true else X.Base.Visible=false end if X.
SubButton.Text:lower():match(U)and X.SubButton.Visible then Y=true else X.
SubButton.Base.Visible=false end X.Holder.Visible=Y if Y then V=V+1 end continue
end if X.Text and X.Text:lower():match(U)and X.Visible then X.Holder.Visible=
true V=V+1 else X.Holder.Visible=false end end for W,X in T.DependencyBoxes do
if not X.Visible then continue end V=V+CheckDepbox(X,U)end T.Holder.Visible=V>0
return V end local function RestoreDepbox(T)for U,V in T.Elements do V.Holder.
Visible=typeof(V.Visible)=='boolean'and V.Visible or true if V.SubButton then V.
Base.Visible=V.Visible V.SubButton.Base.Visible=V.SubButton.Visible end end T:
Resize()T.Holder.Visible=true for U,V in T.DependencyBoxes do if not V.Visible
then continue end RestoreDepbox(V)end end local aa,ab=function(T,U)if not T then
return end local V=false for W,X in T.Groupboxes do local Y=0 for Z,_ in X.
Elements do if _.Type=='Divider'then _.Holder.Visible=false continue elseif _.
SubButton then local aa=false if _.Text:lower():match(U)and _.Visible then aa=
true else _.Base.Visible=false end if _.SubButton.Text:lower():match(U)and _.
SubButton.Visible then aa=true else _.SubButton.Base.Visible=false end _.Holder.
Visible=aa if aa then Y=Y+1 end continue end if _.Text and _.Text:lower():match(
U)and _.Visible then _.Holder.Visible=true Y=Y+1 else _.Holder.Visible=false end
end for aa,Z in X.DependencyBoxes do if not Z.Visible then continue end Y=Y+
CheckDepbox(Z,U)end if Y>0 then X:Resize()V=true end X.BoxHolder.Visible=Y>0 end
for aa,W in T.Tabboxes do local X,Y=0,{}for Z,_ in W.Tabs do Y[_]=0 for ab,ac in
_.Elements do if ac.Type=='Divider'then ac.Holder.Visible=false continue elseif
ac.SubButton then local ad=false if ac.Text:lower():match(U)and ac.Visible then
ad=true else ac.Base.Visible=false end if ac.SubButton.Text:lower():match(U)and
ac.SubButton.Visible then ad=true else ac.SubButton.Base.Visible=false end ac.
Holder.Visible=ad if ad then Y[_]=Y[_]+1 end continue end if ac.Text and ac.Text
:lower():match(U)and ac.Visible then ac.Holder.Visible=true Y[_]=Y[_]+1 else ac.
Holder.Visible=false end end for ab,ac in _.DependencyBoxes do if not ac.Visible
then continue end Y[_]=Y[_]+CheckDepbox(ac,U)end end for ab,ac in Y do ab.
ButtonHolder.Visible=ac>0 if ac>0 then X=X+1 V=true if W.ActiveTab==ab then ab:
Resize()elseif W.ActiveTab and Y[W.ActiveTab]==0 then ab:Show()end end end W.
BoxHolder.Visible=X>0 end return V end,function(aa)if not aa then return end for
ab,ac in aa.Groupboxes do for ad,T in ac.Elements do T.Holder.Visible=typeof(T.
Visible)=='boolean'and T.Visible or true if T.SubButton then T.Base.Visible=T.
Visible T.SubButton.Base.Visible=T.SubButton.Visible end end for ad,T in ac.
DependencyBoxes do if not T.Visible then continue end RestoreDepbox(T)end ac:
Resize()ac.BoxHolder.Visible=true end for ab,ac in aa.Tabboxes do for ad,T in ac
.Tabs do for U,V in T.Elements do V.Holder.Visible=typeof(V.Visible)=='boolean'
and V.Visible or true if V.SubButton then V.Base.Visible=V.Visible V.SubButton.
Base.Visible=V.SubButton.Visible end end for U,V in T.DependencyBoxes do if not
V.Visible then continue end RestoreDepbox(V)end T.ButtonHolder.Visible=true end
if ac.ActiveTab then ac.ActiveTab:Resize()end ac.BoxHolder.Visible=true end end
z.UpdateSearch=function(ac,ad)z.SearchText=ad local T={}if z.GlobalSearch then
for U,V in z.Tabs do if typeof(V)=='table'and not V.IsKeyTab then table.insert(T
,V)end end elseif z.LastSearchTab and typeof(z.LastSearchTab)=='table'then table
.insert(T,z.LastSearchTab)end for U,V in ipairs(T)do ab(V)end local U=ad:lower()
if O(U)==''then z.Searching=false z.LastSearchTab=nil return end if not z.
GlobalSearch and z.ActiveTab and z.ActiveTab.IsKeyTab then z.Searching=false z.
LastSearchTab=nil return end z.Searching=true local V={}if z.GlobalSearch then V
=T if#V==0 then for W,X in z.Tabs do if typeof(X)=='table'and not X.IsKeyTab
then table.insert(V,X)end end end elseif z.ActiveTab then table.insert(V,z.
ActiveTab)end local W,X=false for Y,Z in ipairs(V)do local _=aa(Z,U)if _ then if
not X then X=Z end if Z==z.ActiveTab then W=true end end end if z.GlobalSearch
then if W and z.ActiveTab then z.ActiveTab:RefreshSides()elseif X then local Y=
ad task.defer(function()if z.SearchText~=Y then return end if z.ActiveTab~=X
then X:Show()end end)end z.LastSearchTab=nil else z.LastSearchTab=z.ActiveTab
end end z.AddToRegistry=function(ac,ad,T)z.Registry[ad]=T end z.
RemoveFromRegistry=function(ac,ad)z.Registry[ad]=nil end z.
UpdateColorsUsingRegistry=function(ac)for ad,T in z.Registry do for U,V in T do
local W=F(V)if W or typeof(V)=='function'then ad[U]=W or V()end end end end z.
SetDPIScale=function(ac,ad)z.DPIScale=ad/100 z.MinSize=z.OriginalMinSize*z.
DPIScale for T,U in z.Scales do U.Scale=z.DPIScale-(tonumber(z.ScalesOffset[U])
or 0)end for T,U in u do if U.Type=='Dropdown'then U:RecalculateListSize()end
end for T,U in z.Notifications do U:Resize()end end z.GiveSignal=function(ac,ad)
local T=typeof(ad)if ad and(T=='RBXScriptConnection'or T=='RBXScriptSignal')then
table.insert(z.Signals,ad)end return ad end IsValidCustomIcon=function(ac)return
typeof(ac)=='string'and(ac:match'rbxasset'or ac:match'roblox%.com/asset/%?id='or
ac:match'rbxthumb://type=')end local ac,ad=pcall(function()return((loadstring(
game:HttpGet
[[https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua]]
)))()end)z.GetIcon=function(T,U)if not ac then return end local V,W=pcall(ad.
GetAsset,U)if not V then return end return W end z.GetCustomIcon=function(T,U)if
not U then return nil end if tonumber(U)then U=string.format('rbxassetid://%s',
tostring(U))end local V=IsValidCustomIcon(U)if V then return{Url=U,
ImageRectOffset=Vector2.zero,ImageRectSize=Vector2.zero,Custom=true}end local W=
z:GetIcon(U)if W then return W end return nil end z.Validate=function(T,U,V)if
typeof(U)~='table'then return V end for W,X in V do if typeof(W)=='number'then
continue end if typeof(X)=='table'then U[W]=z:Validate(U[W],X)elseif U[W]==nil
then U[W]=X end end return U end local T=function(T,U)local V=z.Registry[U]or{}
for W,X in T do if W~='Text'then local Y=F(X)if Y or typeof(X)=='function'then V
[W]=X X=Y or X()else V[W]=nil end end U[W]=X end if M(V)>0 then z.Registry[U]=V
end end local U,V=function(U,V)local W=Instance.new(U)if A[U]then T(A[U],W)end
T(V,W)if V.Parent and not V.ZIndex then pcall(function()W.ZIndex=V.Parent.ZIndex
end)end return W end,function(U,V)local W=pcall(function()if not V then V=d end
local W if typeof(V)=='function'then W=V()else W=V end U.Parent=W end)if not(W
and U.Parent)then U.Parent=z.LocalPlayer:WaitForChild('PlayerGui',math.huge)end
end local W,X=function(W,X)if X then V(W,d)return end pcall(n,W)V(W,o)end,U(
'ScreenGui',{Name='Obsidian',DisplayOrder=998,ResetOnSpawn=false})W(X)z.
ScreenGui=X X.DescendantRemoving:Connect(function(Y)z:RemoveFromRegistry(Y)end)
local Y,Z,_=(U('TextButton',{BackgroundTransparency=1,Modal=false,Size=UDim2.
fromScale(0,0),AnchorPoint=Vector2.zero,Text='',ZIndex=-999,Parent=X}))do Z=U(
'Frame',{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3='WhiteColor',Size=
UDim2.fromOffset(9,1),Visible=false,ZIndex=11000,Parent=X})U('Frame',{
AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3='DarkColor',Position=UDim2.
fromScale(0.5,0.5),Size=UDim2.new(1,2,1,2),ZIndex=10999,Parent=Z})local ae=U(
'Frame',{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3='WhiteColor',Position
=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(1,9),ZIndex=11000,Parent=Z})U(
'Frame',{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3='DarkColor',Position=
UDim2.fromScale(0.5,0.5),Size=UDim2.new(1,2,1,2),ZIndex=10999,Parent=ae})_=U(
'ImageLabel',{AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Position
=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(20,20),ZIndex=11000,Visible=
false,Parent=Z})end local ae,af do ae=U('Frame',{AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,Position=UDim2.new(1,-6,0,6),Size=UDim2.new(0,300,1,-6)
,Parent=X})table.insert(z.Scales,U('UIScale',{Parent=ae}))af=U('UIListLayout',{
HorizontalAlignment=Enum.HorizontalAlignment.Right,Padding=UDim.new(0,8),Parent=
ae})end z.ResetCursorIcon=function(ag)_.Visible=false _.Size=UDim2.fromOffset(20
,20)end z.ChangeCursorIcon=function(ag,ah)if not ah or ah==''then z:
ResetCursorIcon()return end local ai=z:GetCustomIcon(ah)assert(ai,
[[Image must be a valid Roblox asset or a valid URL or a valid lucide icon.]])_.
Visible=true _.Image=ai.Url _.ImageRectOffset=ai.ImageRectOffset _.ImageRectSize
=ai.ImageRectSize end z.ChangeCursorIconSize=function(ag,ah)assert(typeof(ah)==
'UDim2','UDim2 expected.')_.Size=ah end z.GetBetterColor=function(ag,ah,ai)ai=ai
*(z.IsLightTheme and-4 or 2)return Color3.fromRGB(math.clamp(ah.R*255+ai,0,255),
math.clamp(ah.G*255+ai,0,255),math.clamp(ah.B*255+ai,0,255))end z.
GetLighterColor=function(ag,ah)local ai,aj,ak=ah:ToHSV()return Color3.fromHSV(ai
,math.max(0,aj-0.1),math.min(1,ak+0.1))end z.GetDarkerColor=function(ag,ah)local
ai,aj,ak=ah:ToHSV()return Color3.fromHSV(ai,aj,ak/2)end z.GetKeyString=function(
ag,ah)if ah.EnumType==Enum.KeyCode and ah.Value>33 and ah.Value<127 then return
string.char(ah.Value)end return ah.Name end z.GetTextBounds=function(ag,ah,ai,aj
,ak)local al=Instance.new'GetTextBoundsParams'al.Text=ah al.RichText=true al.
Font=ai al.Size=aj al.Width=ak or workspace.CurrentCamera.ViewportSize.X-32
local am=i:GetTextBoundsAsync(al)return am.X,am.Y end z.MouseIsOverFrame=
function(ag,ah,ai)local aj,ak=ah.AbsolutePosition,ah.AbsoluteSize return ai.X>=
aj.X and ai.X<=aj.X+ak.X and ai.Y>=aj.Y and ai.Y<=aj.Y+ak.Y end z.SafeCallback=
function(ag,ah,...)if not(ah and typeof(ah)=='function')then return end local ai
=table.pack(xpcall(ah,function(ai)task.defer(error,debug.traceback(ai,2))if z.
NotifyOnError then z:Notify(ai)end return ai end,...))if not ai[1]then return
nil end return table.unpack(ai,2,ai.n)end z.MakeDraggable=function(ag,ah,ai,aj,
ak)local al,am,an,ao=false ai.InputBegan:Connect(function(ap)if not I(ap)or ak
and z.CantDragForced then return end am=ap.Position an=ah.Position al=true ao=ap
.Changed:Connect(function()if ap.UserInputState~=Enum.UserInputState.End then
return end al=false if ao and ao.Connected then ao:Disconnect()ao=nil end end)
end)z:GiveSignal(h.InputChanged:Connect(function(ap)if(not aj and not z.Toggled)
or(ak and z.CantDragForced)or not(X and X.Parent)then al=false if ao and ao.
Connected then ao:Disconnect()ao=nil end return end if al and J(ap)then local aq
=ap.Position-am ah.Position=UDim2.new(an.X.Scale,an.X.Offset+aq.X,an.Y.Scale,an.
Y.Offset+aq.Y)end end))end z.MakeResizable=function(ag,ah,ai,aj)local ak,al,am,
an=false ai.InputBegan:Connect(function(ao)if not I(ao)then return end al=ao.
Position am=ah.Size ak=true an=ao.Changed:Connect(function()if ao.UserInputState
~=Enum.UserInputState.End then return end ak=false if an and an.Connected then
an:Disconnect()an=nil end end)end)z:GiveSignal(h.InputChanged:Connect(function(
ao)if not ah.Visible or not(X and X.Parent)then ak=false if an and an.Connected
then an:Disconnect()an=nil end return end if ak and J(ao)then local ap=ao.
Position-al ah.Size=UDim2.new(am.X.Scale,math.clamp(am.X.Offset+ap.X,z.MinSize.X
,math.huge),am.Y.Scale,math.clamp(am.Y.Offset+ap.Y,z.MinSize.Y,math.huge))if aj
then z:SafeCallback(aj)end end end))end z.MakeCover=function(ag,ah,ai)local aj,
ak=B[ai]or{0,0},C[ai]or{1,0.5}local al=U('Frame',{AnchorPoint=Vector2.new(aj[1],
aj[2]),BackgroundColor3=ah.BackgroundColor3,Position=UDim2.fromScale(aj[1],aj[2]
),Size=UDim2.fromScale(ak[1],ak[2]),Parent=ah})return al end z.MakeLine=function
(ag,ah,ai)local aj=U('Frame',{AnchorPoint=ai.AnchorPoint or Vector2.zero,
BackgroundColor3='OutlineColor',Position=ai.Position,Size=ai.Size,ZIndex=ai.
ZIndex or ah.ZIndex,Parent=ah})return aj end z.AddOutline=function(ag,ah)local
ai,aj=U('UIStroke',{Color='OutlineColor',Thickness=1,ZIndex=2,Parent=ah}),U(
'UIStroke',{Color='DarkColor',Thickness=1.5,ZIndex=1,Parent=ah})return ai,aj end
z.AddBlank=function(ag,ah,ai)return U('Frame',{BackgroundTransparency=1,Size=ai
or UDim2.fromScale(0,0),Parent=ah})end z.MakeOutline=function(ag,ah,ai,aj)warn
[[Obsidian:MakeOutline is deprecated, please use Obsidian:AddOutline instead.]]
local ak=U('Frame',{BackgroundColor3='DarkColor',Position=UDim2.fromOffset(-2,-2
),Size=UDim2.new(1,4,1,4),ZIndex=aj,Parent=ah})local al=U('Frame',{
BackgroundColor3='OutlineColor',Position=UDim2.fromOffset(1,1),Size=UDim2.new(1,
-2,1,-2),ZIndex=aj,Parent=ak})if ai and ai>0 then U('UICorner',{CornerRadius=
UDim.new(0,ai+1),Parent=ak})U('UICorner',{CornerRadius=UDim.new(0,ai),Parent=al}
)end return ak,al end z.AddDraggableLabel=function(ag,ah)local ai,aj={},U(
'TextLabel',{AutomaticSize=Enum.AutomaticSize.XY,TextXAlignment=Enum.
TextXAlignment.Left,BackgroundColor3='BackgroundColor',Size=UDim2.fromOffset(0,0
),Position=UDim2.fromOffset(6,6),Text=ah,TextSize=15,ZIndex=10,Parent=X})table.
insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius),Parent=aj
}))U('UIPadding',{PaddingBottom=UDim.new(0,6),PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),PaddingTop=UDim.new(0,6),Parent=aj})table.insert(z.
Scales,U('UIScale',{Parent=aj}))z:AddOutline(aj)z:MakeDraggable(aj,aj,true)ai.
Label=aj ai.SetText=function(ak,al)aj.Text=al end ai.SetVisible=function(ak,al)
aj.Visible=al end return ai end z.AddDraggableButton=function(ag,ah,ai,aj)local
ak,al={},U('TextButton',{BackgroundColor3='BackgroundColor',Position=UDim2.
fromOffset(6,6),TextSize=16,ZIndex=10,Parent=X})table.insert(z.Corners,U(
'UICorner',{CornerRadius=UDim.new(0,z.CornerRadius),Parent=al}))if not aj then
table.insert(z.Scales,U('UIScale',{Parent=al}))end z:AddOutline(al)al.
MouseButton1Click:Connect(function()z:SafeCallback(ai,ak)end)z:MakeDraggable(al,
al,true)ak.Button=al ak.SetText=function(am,an)local ao,ap=z:GetTextBounds(an,z.
Scheme.Font,16)al.Text=an al.Size=UDim2.fromOffset(ao*2,ap*2)end ak:SetText(ah)
return ak end z.AddDraggableMenu=function(ag,ah)local ai=U('Frame',{
AutomaticSize=Enum.AutomaticSize.XY,BackgroundColor3='BackgroundColor',Position=
UDim2.fromOffset(6,6),Size=UDim2.fromOffset(0,0),ZIndex=10,Parent=X})table.
insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius),Parent=ai
}))table.insert(z.Scales,U('UIScale',{Parent=ai}))z:AddOutline(ai)z:MakeLine(ai,
{Position=UDim2.fromOffset(0,34),Size=UDim2.new(1,0,0,1)})local aj=U('TextLabel'
,{BackgroundTransparency=1,Size=UDim2.new(1,0,0,34),Text=ah,TextSize=15,
TextXAlignment=Enum.TextXAlignment.Left,Parent=ai})U('UIPadding',{PaddingLeft=
UDim.new(0,12),PaddingRight=UDim.new(0,12),Parent=aj})local ak=U('Frame',{
BackgroundTransparency=1,Position=UDim2.fromOffset(0,35),Size=UDim2.new(1,0,1,-
35),Parent=ai})U('UIListLayout',{Padding=UDim.new(0,7),Parent=ak})U('UIPadding',
{PaddingBottom=UDim.new(0,7),PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7
),PaddingTop=UDim.new(0,7),Parent=ak})z:MakeDraggable(ai,aj,true)return ai,ak
end do local ag=z:AddDraggableLabel''ag:SetVisible(false)z.SetWatermark=function
(ah,ai)warn
[[Watermark is deprecated, please use Library:AddDraggableLabel instead.]]ag:
SetText(ai)end z.SetWatermarkVisibility=function(ah,ai)warn
[[Watermark is deprecated, please use Library:AddDraggableLabel instead.]]ag:
SetVisible(ai)end end local ag z.AddContextMenu=function(ah,ai,aj,ak,al,am,an)
local ao,ap=(ai:FindFirstAncestorOfClass'ScreenGui')if ao~=X and(z.ActiveLoading
and ao~=z.ActiveLoading.ScreenGui)then ao=X end if al then ap=U('ScrollingFrame'
,{AutomaticCanvasSize=al==2 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
AutomaticSize=al==1 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
BackgroundColor3='BackgroundColor',BottomImage=
'rbxasset://textures/ui/Scroll/scroll-middle.png',CanvasSize=UDim2.fromOffset(0,
0),ScrollBarImageColor3='OutlineColor',ScrollBarThickness=al==2 and 2 or 0,Size=
typeof(aj)=='function'and aj()or aj,TopImage=
'rbxasset://textures/ui/Scroll/scroll-middle.png',Visible=false,ZIndex=10,Parent
=ao})else ap=U('Frame',{BackgroundColor3='BackgroundColor',Size=typeof(aj)==
'function'and aj()or aj,Visible=false,ZIndex=10,Parent=ao})end table.insert(z.
Scales,U('UIScale',{Parent=ap}))U('UIStroke',{Color='OutlineColor',Parent=ap})if
an~=true then table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.
CornerRadius/2),Parent=ap}))end local aq={Active=false,Holder=ai,Menu=ap,List=
nil,Signal=nil,Size=aj}if al then aq.List=U('UIListLayout',{Parent=ap})end aq.
Open=function(ar)if ag==aq then return elseif ag then ag:Close()end ag=aq aq.
Active=true if typeof(ak)=='function'then ap.Position=UDim2.fromOffset(math.
floor(ai.AbsolutePosition.X+ak()[1]),math.floor(ai.AbsolutePosition.Y+ak()[2]))
else ap.Position=UDim2.fromOffset(math.floor(ai.AbsolutePosition.X+ak[1]),math.
floor(ai.AbsolutePosition.Y+ak[2]))end ap.Size=typeof(aq.Size)=='function'and aq
.Size()or aq.Size if typeof(am)=='function'then z:SafeCallback(am,true)end ap.
Visible=true aq.Signal=ai:GetPropertyChangedSignal'AbsolutePosition':Connect(
function()if typeof(ak)=='function'then ap.Position=UDim2.fromOffset(math.floor(
ai.AbsolutePosition.X+ak()[1]),math.floor(ai.AbsolutePosition.Y+ak()[2]))else ap
.Position=UDim2.fromOffset(math.floor(ai.AbsolutePosition.X+ak[1]),math.floor(ai
.AbsolutePosition.Y+ak[2]))end end)end aq.Close=function(ar)if ag~=aq then
return end ap.Visible=false if aq.Signal then aq.Signal:Disconnect()aq.Signal=
nil end aq.Active=false ag=nil if typeof(am)=='function'then z:SafeCallback(am,
false)end end aq.Toggle=function(ar)if aq.Active then aq:Close()else aq:Open()
end end aq.SetSize=function(ar,as)aq.Size=as ap.Size=typeof(as)=='function'and
as()or as end return aq end z:GiveSignal(h.InputBegan:Connect(function(ah)if z.
Unloaded then return end if I(ah,true)then local ai=ah.Position if ag and not(z:
MouseIsOverFrame(ag.Menu,ai)or z:MouseIsOverFrame(ag.Holder,ai))then ag:Close()
end end end))local ah=U('TextLabel',{AutomaticSize=Enum.AutomaticSize.Y,
BackgroundColor3='BackgroundColor',TextSize=14,TextWrapped=true,Visible=false,
ZIndex=20,Parent=X})U('UIPadding',{PaddingBottom=UDim.new(0,2),PaddingLeft=UDim.
new(0,4),PaddingRight=UDim.new(0,4),PaddingTop=UDim.new(0,2),Parent=ah})table.
insert(z.Scales,U('UIScale',{Parent=ah}))U('UIStroke',{Color='OutlineColor',
Parent=ah})table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.
CornerRadius/2),Parent=ah}))ah:GetPropertyChangedSignal'AbsolutePosition':
Connect(function()if z.Unloaded then return end local ai=z:GetTextBounds(ah.Text
,ah.FontFace,ah.TextSize,(workspace.CurrentCamera.ViewportSize.X-ah.
AbsolutePosition.X-8)/z.DPIScale)ah.Size=UDim2.fromOffset(ai+8)end)local ai z.
AddTooltip=function(aj,ak,al,am)local an={Disabled=false,Hovering=false,Signals=
{}}local ao,ap=function()if ai==am or z.ActiveDialog or(ag and z:
MouseIsOverFrame(ag.Menu,q))or(an.Disabled and typeof(al)~='string')or(not an.
Disabled and typeof(ak)~='string')then return end ai=am local ao=am:
FindFirstAncestorOfClass'ScreenGui'if ao~=X and(z.ActiveLoading and ao~=z.
ActiveLoading.ScreenGui)then ao=X end ah.Parent=ao ah.Text=an.Disabled and al or
ak ah.Visible=true while(z.Toggled or z.ActiveLoading)and not z.ActiveDialog and
z:MouseIsOverFrame(am,q)and not(ag and z:MouseIsOverFrame(ag.Menu,q))do ah.
Position=UDim2.fromOffset(q.X+(z.ShowCustomCursor and 8 or 14),q.Y+(z.
ShowCustomCursor and 8 or 12))f.RenderStepped:Wait()end ah.Visible=false ai=nil
end,function(ao)local ap=typeof(ao)if ao and(ap=='RBXScriptConnection'or ap==
'RBXScriptSignal')then table.insert(an.Signals,ao)end return ao end ap(am.
MouseEnter:Connect(ao))ap(am.MouseMoved:Connect(ao))ap(am.MouseLeave:Connect(
function()if ai~=am then return end ah.Visible=false ai=nil end))an.Destroy=
function(aq)for ar=#an.Signals,1,-1 do local as=table.remove(an.Signals,ar)if as
and as.Connected then as:Disconnect()end end if ai==am then if ah then ah.
Visible=false end ai=nil end end table.insert(v,ah)return an end z.OnUnload=
function(aj,ak)table.insert(z.UnloadSignals,ak)end z.Unload=function(aj)for ak=#
z.Signals,1,-1 do local al=table.remove(z.Signals,ak)if al and al.Connected then
al:Disconnect()end end for ak,al in z.UnloadSignals do z:SafeCallback(al)end for
ak,al in v do z:SafeCallback(al.Destroy,al)end z.Unloaded=true if z.
ActiveLoading then z.ActiveLoading:Destroy()end if X then X:Destroy()end l().
Library=nil end local aj,ak,al,am,an=z:GetIcon'check',z:GetIcon'chevron-up',z:
GetIcon'move-diagonal-2',z:GetIcon'key',z:GetIcon'move'z.SetIconModule=function(
ao,ap)ac=true ad=ap aj=z:GetIcon'check'ak=z:GetIcon'chevron-up'al=z:GetIcon
'move-diagonal-2'am=z:GetIcon'key'an=z:GetIcon'move'end local ao={}do local ap={
}ap.AddKeyPicker=function(aq,ar,as)as=z:Validate(as,A.KeyPicker)local at=aq
local au,av=at.TextLabel,{Text=as.Text,Value=as.Default,Modifiers=as.
DefaultModifiers,DisplayValue=as.Default,Blacklisted=as.Blacklisted,
BlacklistedModifiers=as.BlacklistedModifiers,Whitelisted=as.Whitelisted,
WhitelistedModifiers=as.WhitelistedModifiers,Toggled=false,Mode=as.Mode,
SyncToggleState=as.SyncToggleState,Callback=as.Callback,ChangedCallback=as.
ChangedCallback,Changed=as.Changed,Clicked=as.Clicked,Type='KeyPicker'}if av.
Mode=='Press'then assert(at.Type=='Label',
[[KeyPicker with the mode 'Press' can be only applied on Labels.]])av.
SyncToggleState=false as.Modes={'Press'}as.Mode='Press'end if av.SyncToggleState
then as.Modes={'Toggle','Hold'}if not table.find(as.Modes,as.Mode)then as.Mode=
'Toggle'end end local aw,ax,ay,az,aA=false,{MB1=Enum.UserInputType.MouseButton1,
MB2=Enum.UserInputType.MouseButton2,MB3=Enum.UserInputType.MouseButton3},{[Enum.
UserInputType.MouseButton1]='MB1',[Enum.UserInputType.MouseButton2]='MB2',[Enum.
UserInputType.MouseButton3]='MB3'},{LAlt=Enum.KeyCode.LeftAlt,RAlt=Enum.KeyCode.
RightAlt,LCtrl=Enum.KeyCode.LeftControl,RCtrl=Enum.KeyCode.RightControl,LShift=
Enum.KeyCode.LeftShift,RShift=Enum.KeyCode.RightShift,Tab=Enum.KeyCode.Tab,
CapsLock=Enum.KeyCode.CapsLock},{[Enum.KeyCode.LeftAlt]='LAlt',[Enum.KeyCode.
RightAlt]='RAlt',[Enum.KeyCode.LeftControl]='LCtrl',[Enum.KeyCode.RightControl]=
'RCtrl',[Enum.KeyCode.LeftShift]='LShift',[Enum.KeyCode.RightShift]='RShift',[
Enum.KeyCode.Tab]='Tab',[Enum.KeyCode.CapsLock]='CapsLock'}local aB,aC=function(
aB)return aB.UserInputType==Enum.UserInputType.Keyboard and aA[aB.KeyCode]~=nil
end,function()local aB={}for aC,aD in az do if table.find(aB,aC)then continue
end if not h:IsKeyDown(aD)then continue end table.insert(aB,aC)end return aB end
local aD,aE,aF,aG=function(aD)if not(typeof(aD)=='table'and M(aD)>0)then return
true end local aE,aF=aC(),true for aG,aH in aD do if table.find(aE,aH)then
continue end aF=false break end return aF end,function(aD)if not aD then return
false end if ay[aD.UserInputType]~=nil then return h:IsMouseButtonPressed(aD.
UserInputType)and not h:GetFocusedTextBox()elseif aD.UserInputType==Enum.
UserInputType.Keyboard then return h:IsKeyDown(aD.KeyCode)and not h:
GetFocusedTextBox()else return false end end,function(aD)local aE={}for aF,aG in
aD do table.insert(aE,az[aG])end return aE end,function(aD)if typeof(aD)~=
'table'then return{}end local aE={}for aF,aG in aD do if not az[aG]then continue
end table.insert(aE,aG)end return aE end av.Modifiers=aG(av.Modifiers)local aH=
U('TextButton',{BackgroundColor3='MainColor',Size=UDim2.fromOffset(18,18),Text=
av.Value,TextSize=14,Parent=au})U('UIStroke',{Color='OutlineColor',Parent=aH})
table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius/2),
Parent=aH}))local aI={Normal=av.Mode~='Toggle'}do local aJ=U('TextButton',{
BackgroundTransparency=1,Size=UDim2.new(1,0,0,16),Text='',Visible=not as.NoUI,
Parent=z.KeybindContainer})local aK,aL=U('TextLabel',{AutomaticSize=Enum.
AutomaticSize.X,BackgroundTransparency=1,Size=UDim2.fromScale(0,1),Text='',
TextSize=14,TextTransparency=0.5,Parent=aJ}),U('Frame',{AnchorPoint=Vector2.new(
0,0.5),BackgroundColor3='MainColor',Position=UDim2.fromScale(0,0.5),Size=UDim2.
fromOffset(14,14),SizeConstraint=Enum.SizeConstraint.RelativeYY,Parent=aJ})table
.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius/2),Parent
=aL}))U('UIStroke',{Color='OutlineColor',Parent=aL})local aM=U('ImageLabel',{
Image=aj and aj.Url or'',ImageColor3='FontColor',ImageRectOffset=aj and aj.
ImageRectOffset or Vector2.zero,ImageRectSize=aj and aj.ImageRectSize or Vector2
.zero,ImageTransparency=1,Position=UDim2.fromOffset(2,2),Size=UDim2.new(1,-4,1,-
4),Parent=aL})aI.Display=function(aN,aO)aK.TextTransparency=aO and 0 or 0.5 aM.
ImageTransparency=aO and 0 or 1 end aI.SetText=function(aN,aO)aK.Text=aO end aI.
SetVisibility=function(aN,aO)aJ.Visible=aO end aI.SetNormal=function(aN,aO)aI.
Normal=aO aJ.Active=not aO aK.Position=aO and UDim2.fromOffset(0,0)or UDim2.
fromOffset(22,0)aL.Visible=not aO end av.DoClick=function(...)end aJ.
MouseButton1Click:Connect(function()if aI.Normal then return end av.Toggled=not
av.Toggled av:DoClick()end)aI.Holder=aJ aI.Label=aK aI.Checkbox=aL aI.Loaded=
true table.insert(z.KeybindToggles,aI)end local aJ=z:AddContextMenu(aH,UDim2.
fromOffset(62,0),function()return{aH.AbsoluteSize.X+1.5,0.5}end,1,nil,true)av.
Menu=aJ local aK={}for aL,aM in as.Modes do local aN,aO={},U('TextButton',{
BackgroundColor3='MainColor',BackgroundTransparency=1,Size=UDim2.new(1,0,0,21),
Text=aM,TextSize=14,TextTransparency=0.5,Parent=aJ.Menu})aN.Select=function(aP)
for aQ,aR in aK do aR:Deselect()end av.Mode=aM aO.BackgroundTransparency=0 aO.
TextTransparency=0 aJ:Close()end aN.Deselect=function(aP)av.Mode=nil aO.
BackgroundTransparency=1 aO.TextTransparency=0.5 end aO.MouseButton1Click:
Connect(function()aN:Select()end)if av.Mode==aM then aN:Select()end aK[aM]=aN
end av.Display=function(aL,aM)if z.Unloaded then return end local aN,aO=z:
GetTextBounds(aM or av.DisplayValue,aH.FontFace,aH.TextSize,au.AbsoluteSize.X)aH
.Text=aM or av.DisplayValue aH.Size=UDim2.fromOffset((aN+9),(aO+4))end av.Update
=function(aL)av:Display()if as.NoUI then return end if av.Mode=='Toggle'and at.
Type=='Toggle'and at.Disabled then aI:SetVisibility(false)return end local aM,aN
=av:GetState(),z.ShowToggleFrameInKeybinds and av.Mode=='Toggle'if av.
SyncToggleState and at.Value~=aM then at:SetValue(aM)end if aI.Loaded then if aN
then aI:SetNormal(false)else aI:SetNormal(true)end aI:SetText(('[%s] %s (%s)'):
format(av.DisplayValue,av.Text,av.Mode))aI:SetVisibility(true)aI:Display(aM)end
end av.GetState=function(aL)if av.Mode=='Always'then return true elseif av.Mode
=='Hold'then local aM=av.Value if aM=='None'then return false end if not aD(av.
Modifiers)then return false end if ax[aM]~=nil then return h:
IsMouseButtonPressed(ax[aM])and not h:GetFocusedTextBox()else return h:
IsKeyDown(Enum.KeyCode[aM])and not h:GetFocusedTextBox()end else return av.
Toggled end end av.OnChanged=function(aL,aM)av.Changed=aM end av.OnClick=
function(aL,aM)av.Clicked=aM end av.DoClick=function(aL)if av.Mode=='Press'then
if av.Toggled and as.WaitForCallback==true then return end av.Toggled=true end z
:SafeCallback(av.Callback,av.Toggled)z:SafeCallback(av.Clicked,av.Toggled)if av.
Mode=='Press'then av.Toggled=false end end av.SetValue=function(aL,aM)local aN,
aO,aP=aM[1],aM[2],aM[3]local aQ,aR=pcall(function()if aN=='None'then aN=nil
return nil end if ax[aN]==nil then return Enum.KeyCode[aN]end return ax[aN]end)
if aN==nil then av.Value='None'elseif aQ then av.Value=aN else av.Value=
'Unknown'end av.Modifiers=aG((typeof(aP)=='table'and{aP}or{(av.Modifiers)})[1])
av.DisplayValue=(M(av.Modifiers)>0 and{(table.concat(av.Modifiers,' + ')..' + '
..av.Value)}or{(av.Value)})[1]if aK[aO]then aK[aO]:Select()end local aS=aF(av.
Modifiers)z:SafeCallback(av.ChangedCallback,aR,aS)z:SafeCallback(av.Changed,aR,
aS)av:Update()end av.SetText=function(aL,aM)aI:SetText(aM)av:Update()end aH.
MouseButton1Click:Connect(function()if aw then return end aw=true aH.Text='...'
aH.Size=UDim2.fromOffset(29,18)local aL,aM,aN={}aN=function()aM=h.InputBegan:
Wait()if h:GetFocusedTextBox()~=nil then return true end if aM.KeyCode==Enum.
KeyCode.Escape then return false end local aO,aP=(aB(aM))if ay[aM.UserInputType]
~=nil then aP=ay[aM.UserInputType]elseif aM.UserInputType==Enum.UserInputType.
Keyboard then if aO then aP=aA[aM.KeyCode]else aP=aM.KeyCode.Name end end if aP
then if aO then if av.WhitelistedModifiers and#av.WhitelistedModifiers>0 and not
table.find(av.WhitelistedModifiers,aP)then return aN()end if av.
BlacklistedModifiers and table.find(av.BlacklistedModifiers,aP)then return aN()
end else if av.Whitelisted and#av.Whitelisted>0 and not table.find(av.
Whitelisted,aP)then return aN()end if av.Blacklisted and table.find(av.
Blacklisted,aP)then return aN()end end end return false end repeat task.wait()aH
.Text='...'aH.Size=UDim2.fromOffset(29,18)if aN()then aw=false av:Update()return
end if aM.KeyCode==Enum.KeyCode.Escape then break end if aB(aM)then local aO=
false repeat task.wait()if h:IsKeyDown(aM.KeyCode)then task.wait(0.075)if h:
IsKeyDown(aM.KeyCode)then if not table.find(aL,aA[aM.KeyCode])then aL[#aL+1]=aA[
aM.KeyCode]av:Display(table.concat(aL,' + ')..' + ...')end if aN()then aO=true
break end if aM.KeyCode==Enum.KeyCode.Escape then break end if not aB(aM)then
break end else if not table.find(aL,aA[aM.KeyCode])then break end end end until
false if aO then aw=false av:Update()return end end break until false local aO=
'Unknown'if ay[aM.UserInputType]~=nil then aO=ay[aM.UserInputType]elseif aM.
UserInputType==Enum.UserInputType.Keyboard then aO=aM.KeyCode==Enum.KeyCode.
Escape and'None'or aM.KeyCode.Name end aL=(aM.KeyCode==Enum.KeyCode.Escape or aO
=='Unknown')and{}or aL av.Toggled=false av:SetValue{aO,av.Mode,aL}repeat task.
wait()until not aE(aM)or h:GetFocusedTextBox()aw=false end)aH.MouseButton2Click:
Connect(aJ.Toggle)z:GiveSignal(h.InputBegan:Connect(function(aL)if z.Unloaded
then return end if av.Mode=='Always'or av.Value=='Unknown'or av.Value=='None'or
aw or h:GetFocusedTextBox()then return end local aM,aN,aO=av.Value,aD(av.
Modifiers),false if aM and aN==true and(ay[aL.UserInputType]==aM or(aL.
UserInputType==Enum.UserInputType.Keyboard and aL.KeyCode.Name==aM))then aO=true
end if av.Mode=='Toggle'then if aO then av.Toggled=not av.Toggled av:DoClick()
end elseif av.Mode=='Press'then if aO then av:DoClick()end end av:Update()end))z
:GiveSignal(h.InputEnded:Connect(function()if z.Unloaded then return end if av.
Value=='Unknown'or av.Value=='None'or aw or h:GetFocusedTextBox()then return end
av:Update()end))av:Update()if at.Addons then table.insert(at.Addons,av)end av.
Default=av.Value av.DefaultModifiers=table.clone(av.Modifiers or{})u[ar]=av
return aq end local aq={}for ar=0,1,0.1 do table.insert(aq,ColorSequenceKeypoint
.new(ar,Color3.fromHSV(ar,1,1)))end ap.AddColorPicker=function(ar,as,at)at=z:
Validate(at,A.ColorPicker)local au=ar local av,aw=au.TextLabel,{Value=at.Default
,Transparency=at.Transparency or 0,Title=at.Title,Callback=at.Callback,Changed=
at.Changed,Type='ColorPicker'}aw.Hue,aw.Sat,aw.Vib=aw.Value:ToHSV()local ax=U(
'TextButton',{BackgroundColor3=aw.Value,Size=UDim2.fromOffset(18,18),Text='',
Parent=av})local ay=U('UIStroke',{Color=z:GetDarkerColor(aw.Value),Parent=ax})
table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius/2),
Parent=ax}))local az=U('ImageLabel',{Image=x.GetAsset'TransparencyTexture',
ImageTransparency=(1-aw.Transparency),ScaleType=Enum.ScaleType.Tile,Position=
UDim2.new(0,-1,0,-1),Size=UDim2.new(1,2,1,2),TileSize=UDim2.fromOffset(9,9),
Parent=ax})table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.
CornerRadius/2),Parent=az}))local aA=z:AddContextMenu(ax,UDim2.fromOffset(at.
Transparency and 256 or 234,0),function()return{0.5,ax.AbsoluteSize.Y+1.5}end,1)
aA.List.Padding=UDim.new(0,8)aw.ColorMenu=aA U('UIPadding',{PaddingBottom=UDim.
new(0,6),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingTop=UDim.
new(0,6),Parent=aA.Menu})if typeof(aw.Title)=='string'then U('TextLabel',{
BackgroundTransparency=1,Size=UDim2.new(1,0,0,8),Text=aw.Title,TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,Parent=aA.Menu})end local aB=U('Frame',{
BackgroundTransparency=1,Size=UDim2.new(1,0,0,200),Parent=aA.Menu})U(
'UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6
),Parent=aB})local aC=U('ImageButton',{BackgroundColor3=aw.Value,Image=x.
GetAsset'SaturationMap',Size=UDim2.fromOffset(200,200),Parent=aB})local aD=U(
'Frame',{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3='WhiteColor',Size=
UDim2.fromOffset(6,6),Parent=aC})U('UICorner',{CornerRadius=UDim.new(1,0),Parent
=aD})U('UIStroke',{Color='DarkColor',Parent=aD})local aE=U('TextButton',{Size=
UDim2.fromOffset(16,200),Text='',Parent=aB})U('UIGradient',{Color=ColorSequence.
new(aq),Rotation=90,Parent=aE})local aF,aG,aH,aI=(U('Frame',{AnchorPoint=Vector2
.new(0.5,0.5),BackgroundColor3='WhiteColor',BorderColor3='DarkColor',
BorderSizePixel=1,Position=UDim2.fromScale(0.5,aw.Hue),Size=UDim2.new(1,2,0,1),
Parent=aE}))if at.Transparency then aG=U('ImageButton',{Image=x.GetAsset
'TransparencyTexture',ScaleType=Enum.ScaleType.Tile,Size=UDim2.fromOffset(16,200
),TileSize=UDim2.fromOffset(8,8),Parent=aB})aH=U('Frame',{BackgroundColor3=aw.
Value,Size=UDim2.fromScale(1,1),Parent=aG})U('UIGradient',{Rotation=90,
Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1)},Parent=aH})aI=U('Frame',{AnchorPoint=Vector2.
new(0.5,0.5),BackgroundColor3='WhiteColor',BorderColor3='DarkColor',
BorderSizePixel=1,Position=UDim2.fromScale(0.5,aw.Transparency),Size=UDim2.new(1
,2,0,1),Parent=aG})end local aJ=U('Frame',{BackgroundTransparency=1,Size=UDim2.
new(1,0,0,20),Parent=aA.Menu})U('UIListLayout',{FillDirection=Enum.FillDirection
.Horizontal,HorizontalFlex=Enum.UIFlexAlignment.Fill,Padding=UDim.new(0,8),
Parent=aJ})local aK=U('TextBox',{BackgroundColor3='MainColor',ClearTextOnFocus=
false,Size=UDim2.fromScale(1,1),Text='#??????',TextSize=14,Parent=aJ})U(
'UIStroke',{Color='OutlineColor',Parent=aK})table.insert(z.Corners,U('UICorner',
{CornerRadius=UDim.new(0,z.CornerRadius/2),Parent=aK}))local aL=U('TextBox',{
BackgroundColor3='MainColor',ClearTextOnFocus=false,Size=UDim2.fromScale(1,1),
Text='?, ?, ?',TextSize=14,Parent=aJ})U('UIStroke',{Color='OutlineColor',Parent=
aL})table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius/
2),Parent=aL}))local aM=z:AddContextMenu(ax,UDim2.fromOffset(93,0),function()
return{ax.AbsoluteSize.X+1.5,0.5}end,1)aw.ContextMenu=aM aM.List.Padding=UDim.
new(0,6)do local aN=function(aN,aO)local aP=U('TextButton',{
BackgroundTransparency=1,Size=UDim2.new(1,0,0,21),Text=aN,TextSize=14,Parent=aM.
Menu})aP.MouseButton1Click:Connect(function()z:SafeCallback(aO)aM:Close()end)end
aN('Copy color',function()z.CopiedColor={aw.Value,aw.Transparency}end)aw.
SetValueRGB=function(...)end aN('Paste color',function()aw:SetValueRGB(z.
CopiedColor[1],z.CopiedColor[2])end)if m then aN('Copy Hex',function()m(
tostring(aw.Value:ToHex()))end)aN('Copy RGB',function()m(table.concat({math.
floor(aw.Value.R*255),math.floor(aw.Value.G*255),math.floor(aw.Value.B*255)},
', '))end)end end aw.SetHSVFromRGB=function(aN,aO)aw.Hue,aw.Sat,aw.Vib=aO:ToHSV(
)end aw.Display=function(aN)if z.Unloaded then return end aw.Value=Color3.
fromHSV(aw.Hue,aw.Sat,aw.Vib)ax.BackgroundColor3=aw.Value ay.Color=z:
GetDarkerColor(aw.Value)az.ImageTransparency=(1-aw.Transparency)aC.
BackgroundColor3=Color3.fromHSV(aw.Hue,1,1)if aH then aH.BackgroundColor3=aw.
Value end aD.Position=UDim2.fromScale(aw.Sat,1-aw.Vib)aF.Position=UDim2.
fromScale(0.5,aw.Hue)if aI then aI.Position=UDim2.fromScale(0.5,aw.Transparency)
end aK.Text='#'..aw.Value:ToHex()aL.Text=table.concat({math.floor(aw.Value.R*255
),math.floor(aw.Value.G*255),math.floor(aw.Value.B*255)},', ')end aw.Update=
function(aN)aw:Display()z:SafeCallback(aw.Callback,aw.Value)z:SafeCallback(aw.
Changed,aw.Value)end aw.OnChanged=function(aN,aO)aw.Changed=aO end aw.SetValue=
function(aN,aO,aP)if typeof(aO)=='Color3'then aw:SetValueRGB(aO,aP)return end
local aQ=Color3.fromHSV(aO[1],aO[2],aO[3])aw.Transparency=at.Transparency and aP
or 0 aw:SetHSVFromRGB(aQ)aw:Update()end aw.SetValueRGB=function(aN,aO,aP)aw.
Transparency=at.Transparency and aP or 0 aw:SetHSVFromRGB(aO)aw:Update()end ax.
MouseButton1Click:Connect(aA.Toggle)ax.MouseButton2Click:Connect(aM.Toggle)aC.
InputBegan:Connect(function(aN)while L(aN)do local aO=aC.AbsolutePosition.X
local aP=aO+aC.AbsoluteSize.X local aQ,aR=math.clamp(q.X,aO,aP),aC.
AbsolutePosition.Y local aS=aR+aC.AbsoluteSize.Y local aT,aU,aV=math.clamp(q.Y,
aR,aS),aw.Sat,aw.Vib aw.Sat=(aQ-aO)/(aP-aO)aw.Vib=1-((aT-aR)/(aS-aR))if aw.Sat~=
aU or aw.Vib~=aV then aw:Update()end f.RenderStepped:Wait()end end)aE.InputBegan
:Connect(function(aN)while L(aN)do local aO=aE.AbsolutePosition.Y local aP=aO+aE
.AbsoluteSize.Y local aQ,aR=math.clamp(q.Y,aO,aP),aw.Hue aw.Hue=(aQ-aO)/(aP-aO)
if aw.Hue~=aR then aw:Update()end f.RenderStepped:Wait()end end)if aG then aG.
InputBegan:Connect(function(aN)while L(aN)do local aO,aP=aG.AbsolutePosition.Y,
aG.AbsolutePosition.Y+aG.AbsoluteSize.Y local aQ,aR=math.clamp(q.Y,aO,aP),aw.
Transparency aw.Transparency=(aQ-aO)/(aP-aO)if aw.Transparency~=aR then aw:
Update()end f.RenderStepped:Wait()end end)end aK.FocusLost:Connect(function(aN)
if not aN then return end local aO,aP=pcall(Color3.fromHex,aK.Text)if aO and
typeof(aP)=='Color3'then aw.Hue,aw.Sat,aw.Vib=aP:ToHSV()end aw:Update()end)aL.
FocusLost:Connect(function(aN)if not aN then return end local aO,aP,aQ=aL.Text:
match'(%d+),%s*(%d+),%s*(%d+)'if aO and aP and aQ then aw:SetHSVFromRGB(Color3.
fromRGB(aO,aP,aQ))end aw:Update()end)aw:Display()if au.Addons then table.insert(
au.Addons,aw)end aw.Default=aw.Value u[as]=aw return ar end ao.__index=ap ao.
__namecall=function(ar,as,...)return ap[as](...)end end local ap={}do local aq={
}aq.AddDivider=function(ar,...)local as,at,au,av=select(1,...),0,0 if typeof(as)
=='table'then av=as.Text at=as.MarginTop or as.Margin or 0 au=as.MarginBottom or
as.Margin or 0 elseif typeof(as)=='string'then av=as end local aw=ar local ax=aw
.Container local ay=U('Frame',{BackgroundTransparency=1,Size=UDim2.new(1,0,0,6+
at+au),Parent=ax})local az=U('Frame',{BackgroundTransparency=1,Size=UDim2.new(1,
0,1,0),Parent=ay})U('UIPadding',{PaddingTop=UDim.new(0,at),PaddingBottom=UDim.
new(0,au),Parent=ay})if av then local aA=U('TextLabel',{AutomaticSize=Enum.
AutomaticSize.X,BackgroundTransparency=1,Size=UDim2.fromScale(1,0),Text=av,
TextSize=14,TextTransparency=0.5,TextXAlignment=Enum.TextXAlignment.Center,
Parent=az})local aB=z:GetTextBounds(av,aA.FontFace,aA.TextSize,aA.AbsoluteSize.X
)local aC=math.floor(aB/2)+10 U('Frame',{AnchorPoint=Vector2.new(0,0.5),
BackgroundColor3='MainColor',BorderColor3='OutlineColor',BorderSizePixel=1,
Position=UDim2.fromScale(0,0.5),Size=UDim2.new(0.5,-aC,0,2),Parent=az})U('Frame'
,{AnchorPoint=Vector2.new(1,0.5),BackgroundColor3='MainColor',BorderColor3=
'OutlineColor',BorderSizePixel=1,Position=UDim2.fromScale(1,0.5),Size=UDim2.new(
0.5,-aC,0,2),Parent=az})else U('Frame',{AnchorPoint=Vector2.new(0,0.5),
BackgroundColor3='MainColor',BorderColor3='OutlineColor',BorderSizePixel=1,
Position=UDim2.fromScale(0,0.5),Size=UDim2.new(1,0,0,2),Parent=az})end aw:
Resize()local aA={Holder=ay,Text=av,MarginTop=at,MarginBottom=au,Type='Divider'}
table.insert(aw.Elements,aA)return aA end aq.AddLabel=function(ar,...)local as,
at,au,av={},{},select(1,...),select(2,...)if typeof(au)=='table'or typeof(av)==
'table'then local aw=typeof(au)=='table'and au or av as.Text=aw.Text or''as.
DoesWrap=aw.DoesWrap or false as.Size=aw.Size or 14 as.Visible=aw.Visible or
true as.Idx=typeof(av)=='table'and au or nil as.Alignment=aw.Alignment or Enum.
TextXAlignment.Left else as.Text=au or''as.DoesWrap=av or false as.Size=14 as.
Visible=true as.Idx=select(3,...)or nil end local aw=ar local ax,ay=aw.Container
,{Text=as.Text,DoesWrap=as.DoesWrap,Alignment=as.Alignment or Enum.
TextXAlignment.Left,Addons=at,Visible=as.Visible,Type='Label'}local az=U(
'TextLabel',{BackgroundTransparency=1,Size=UDim2.new(1,0,0,18),Text=ay.Text,
TextSize=as.Size,TextWrapped=ay.DoesWrap,TextXAlignment=aw.IsKeyTab and Enum.
TextXAlignment.Center or ay.Alignment,Parent=ax})ay.SetVisible=function(aA,aB)ay
.Visible=aB az.Visible=ay.Visible aw:Resize()end ay.SetText=function(aA,aB)ay.
Text=aB az.Text=aB if ay.DoesWrap then local aC,aD=z:GetTextBounds(ay.Text,az.
FontFace,az.TextSize,az.AbsoluteSize.X)az.Size=UDim2.new(1,0,0,aD+4)end aw:
Resize()end if ay.DoesWrap then local aA,aB=z:GetTextBounds(ay.Text,az.FontFace,
az.TextSize,az.AbsoluteSize.X)az.Size=UDim2.new(1,0,0,aB+4)local aC=az.
AbsoluteSize az:GetPropertyChangedSignal'AbsoluteSize':Connect(function()if az.
AbsoluteSize==aC then return end local aD,aE=z:GetTextBounds(ay.Text,az.FontFace
,az.TextSize,az.AbsoluteSize.X)az.Size=UDim2.new(1,0,0,aE+4)aC=az.AbsoluteSize
aw:Resize()end)else U('UIListLayout',{FillDirection=Enum.FillDirection.
Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,Padding=UDim.new(0
,6),Parent=az})end aw:Resize()ay.TextLabel=az ay.Container=ax if not as.DoesWrap
then setmetatable(ay,ao)end ay.Holder=az table.insert(aw.Elements,ay)if as.Idx
then r[as.Idx]=ay else table.insert(r,ay)end return ay end aq.AddButton=function
(ar,...)local as=function(...)local as,at,au={},select(1,...),select(2,...)if
typeof(at)=='table'or typeof(au)=='table'then local av=typeof(at)=='table'and at
or au as.Text=av.Text or''as.Func=av.Func or av.Callback or function()end as.
DoubleClick=av.DoubleClick as.Tooltip=av.Tooltip as.DisabledTooltip=av.
DisabledTooltip as.Risky=av.Risky or false as.Disabled=av.Disabled or false as.
Visible=av.Visible or true as.Idx=typeof(au)=='table'and at or nil else as.Text=
at or''as.Func=au or function()end as.DoubleClick=false as.Tooltip=nil as.
DisabledTooltip=nil as.Risky=false as.Disabled=false as.Visible=true as.Idx=
select(3,...)or nil end return as end local at,au=as(...),ar local av,aw=au.
Container,{Text=at.Text,Func=at.Func,DoubleClick=at.DoubleClick,Tooltip=at.
Tooltip,DisabledTooltip=at.DisabledTooltip,TooltipTable=nil,Risky=at.Risky,
Disabled=at.Disabled,Visible=at.Visible,Tween=nil,Type='Button'}local ax=U(
'Frame',{BackgroundTransparency=1,Size=UDim2.new(1,0,0,21),Parent=av})U(
'UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,HorizontalFlex=Enum.
UIFlexAlignment.Fill,Padding=UDim.new(0,9),Parent=ax})local ay,az=function(ay)
local az=U('TextButton',{Active=not ay.Disabled,BackgroundColor3=ay.Disabled and
'BackgroundColor'or'MainColor',Size=UDim2.fromScale(1,1),Text=ay.Text,TextSize=
14,TextTransparency=0.4,Visible=ay.Visible,Parent=ax})local aA=U('UIStroke',{
Color='OutlineColor',Transparency=ay.Disabled and 0.5 or 0,Parent=az})table.
insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius/2),Parent=
az}))return az,aA end,function(ay)ay.Base.MouseEnter:Connect(function()if ay.
Disabled then return end ay.Tween=k:Create(ay.Base,z.TweenInfo,{TextTransparency
=0})ay.Tween:Play()end)ay.Base.MouseLeave:Connect(function()if ay.Disabled then
return end ay.Tween=k:Create(ay.Base,z.TweenInfo,{TextTransparency=0.4})ay.Tween
:Play()end)ay.Base.MouseButton1Click:Connect(function()if ay.Disabled or ay.
Locked then return end if ay.DoubleClick then ay.Locked=true ay.Base.Text=
'Are you sure?'ay.Base.TextColor3=z.Scheme.AccentColor z.Registry[ay.Base].
TextColor3='AccentColor'local az=G(ay.Base.MouseButton1Click,0.5)ay.Base.Text=ay
.Text ay.Base.TextColor3=ay.Risky and z.Scheme.RedColor or z.Scheme.FontColor z.
Registry[ay.Base].TextColor3=ay.Risky and'RedColor'or'FontColor'if az then z:
SafeCallback(ay.Func)end f.RenderStepped:Wait()ay.Locked=false return end z:
SafeCallback(ay.Func)end)end aw.Base,aw.Stroke=ay(aw)az(aw)aw.AddButton=function
(aA,...)local aB=as(...)local aC={Text=aB.Text,Func=aB.Func,DoubleClick=aB.
DoubleClick,Tooltip=aB.Tooltip,DisabledTooltip=aB.DisabledTooltip,TooltipTable=
nil,Risky=aB.Risky,Disabled=aB.Disabled,Visible=aB.Visible,Tween=nil,Type=
'SubButton'}aw.SubButton=aC aC.Base,aC.Stroke=ay(aC)az(aC)aC.UpdateColors=
function(aD)if z.Unloaded then return end N(aC.Tween)aC.Base.BackgroundColor3=aC
.Disabled and z.Scheme.BackgroundColor or z.Scheme.MainColor aC.Base.
TextTransparency=aC.Disabled and 0.8 or 0.4 aC.Stroke.Transparency=aC.Disabled
and 0.5 or 0 z.Registry[aC.Base].BackgroundColor3=aC.Disabled and
'BackgroundColor'or'MainColor'end aC.SetDisabled=function(aD,aE)aC.Disabled=aE
if aC.TooltipTable then aC.TooltipTable.Disabled=aC.Disabled end aC.Base.Active=
not aC.Disabled aC:UpdateColors()end aC.SetVisible=function(aD,aE)aC.Visible=aE
aC.Base.Visible=aC.Visible au:Resize()end aC.SetText=function(aD,aE)aC.Text=aE
aC.Base.Text=aE end if typeof(aC.Tooltip)=='string'or typeof(aC.DisabledTooltip)
=='string'then aC.TooltipTable=z:AddTooltip(aC.Tooltip,aC.DisabledTooltip,aC.
Base)aC.TooltipTable.Disabled=aC.Disabled end if aC.Risky then aC.Base.
TextColor3=z.Scheme.RedColor z.Registry[aC.Base].TextColor3='RedColor'end aC:
UpdateColors()if aB.Idx then s[aB.Idx]=aC else table.insert(s,aC)end return aC
end aw.UpdateColors=function(aA)if z.Unloaded then return end N(aw.Tween)aw.Base
.BackgroundColor3=aw.Disabled and z.Scheme.BackgroundColor or z.Scheme.MainColor
aw.Base.TextTransparency=aw.Disabled and 0.8 or 0.4 aw.Stroke.Transparency=aw.
Disabled and 0.5 or 0 z.Registry[aw.Base].BackgroundColor3=aw.Disabled and
'BackgroundColor'or'MainColor'end aw.SetDisabled=function(aA,aB)aw.Disabled=aB
if aw.TooltipTable then aw.TooltipTable.Disabled=aw.Disabled end aw.Base.Active=
not aw.Disabled aw:UpdateColors()end aw.SetVisible=function(aA,aB)aw.Visible=aB
ax.Visible=aw.Visible au:Resize()end aw.SetText=function(aA,aB)aw.Text=aB aw.
Base.Text=aB end if typeof(aw.Tooltip)=='string'or typeof(aw.DisabledTooltip)==
'string'then aw.TooltipTable=z:AddTooltip(aw.Tooltip,aw.DisabledTooltip,aw.Base)
aw.TooltipTable.Disabled=aw.Disabled end if aw.Risky then aw.Base.TextColor3=z.
Scheme.RedColor z.Registry[aw.Base].TextColor3='RedColor'end aw:UpdateColors()au
:Resize()aw.Holder=ax table.insert(au.Elements,aw)if at.Idx then s[at.Idx]=aw
else table.insert(s,aw)end return aw end aq.AddCheckbox=function(ar,as,at)at=z:
Validate(at,A.Toggle)local au=ar local av,aw=au.Container,{Text=at.Text,Value=at
.Default,Tooltip=at.Tooltip,DisabledTooltip=at.DisabledTooltip,TooltipTable=nil,
Callback=at.Callback,Changed=at.Changed,Risky=at.Risky,Disabled=at.Disabled,
Visible=at.Visible,Addons={},Variant='Checkbox',Type='Toggle'}local ax=U(
'TextButton',{Active=not aw.Disabled,BackgroundTransparency=1,Size=UDim2.new(1,0
,0,18),Text='',Visible=aw.Visible,Parent=av})local ay=U('TextLabel',{
BackgroundTransparency=1,Position=UDim2.fromOffset(26,0),Size=UDim2.new(1,-26,1,
0),Text=aw.Text,TextSize=14,TextTransparency=0.4,TextXAlignment=Enum.
TextXAlignment.Left,Parent=ax})U('UIListLayout',{FillDirection=Enum.
FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,
Padding=UDim.new(0,6),Parent=ay})local az=U('Frame',{BackgroundColor3=
'MainColor',Size=UDim2.fromScale(1,1),SizeConstraint=Enum.SizeConstraint.
RelativeYY,Parent=ax})table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.
new(0,z.CornerRadius/2),Parent=az}))local aA,aB=U('UIStroke',{Color=
'OutlineColor',Parent=az}),U('ImageLabel',{Image=aj and aj.Url or'',ImageColor3=
'FontColor',ImageRectOffset=aj and aj.ImageRectOffset or Vector2.zero,
ImageRectSize=aj and aj.ImageRectSize or Vector2.zero,ImageTransparency=1,
Position=UDim2.fromOffset(2,2),Size=UDim2.new(1,-4,1,-4),Parent=az})aw.
UpdateColors=function(aC)aw:Display()end aw.Display=function(aC)if z.Unloaded
then return end aA.Transparency=aw.Disabled and 0.5 or 0 if aw.Disabled then ay.
TextTransparency=0.8 aB.ImageTransparency=aw.Value and 0.8 or 1 az.
BackgroundColor3=z.Scheme.BackgroundColor z.Registry[az].BackgroundColor3=
'BackgroundColor'return end k:Create(ay,z.TweenInfo,{TextTransparency=aw.Value
and 0 or 0.4}):Play()k:Create(aB,z.TweenInfo,{ImageTransparency=aw.Value and 0
or 1}):Play()az.BackgroundColor3=z.Scheme.MainColor z.Registry[az].
BackgroundColor3='MainColor'end aw.OnChanged=function(aC,aD)aw.Changed=aD end aw
.SetValue=function(aC,aD)if aw.Disabled then return end aw.Value=aD aw:Display()
for aE,aF in aw.Addons do if aF.Type=='KeyPicker'and aF.SyncToggleState then aF.
Toggled=aw.Value aF:Update()end end z:UpdateDependencyBoxes()z:SafeCallback(aw.
Callback,aw.Value)z:SafeCallback(aw.Changed,aw.Value)end aw.SetDisabled=function
(aC,aD)aw.Disabled=aD if aw.TooltipTable then aw.TooltipTable.Disabled=aw.
Disabled end for aE,aF in aw.Addons do if aF.Type=='KeyPicker'and aF.
SyncToggleState then aF:Update()end end ax.Active=not aw.Disabled aw:Display()
end aw.SetVisible=function(aC,aD)aw.Visible=aD ax.Visible=aw.Visible au:Resize()
end aw.SetText=function(aC,aD)aw.Text=aD ay.Text=aD end ax.MouseButton1Click:
Connect(function()if aw.Disabled then return end aw:SetValue(not aw.Value)end)if
typeof(aw.Tooltip)=='string'or typeof(aw.DisabledTooltip)=='string'then aw.
TooltipTable=z:AddTooltip(aw.Tooltip,aw.DisabledTooltip,ax)aw.TooltipTable.
Disabled=aw.Disabled end if aw.Risky then ay.TextColor3=z.Scheme.RedColor z.
Registry[ay].TextColor3='RedColor'end aw:Display()au:Resize()aw.TextLabel=ay aw.
Container=av setmetatable(aw,ao)aw.Holder=ax table.insert(au.Elements,aw)aw.
Default=aw.Value t[as]=aw return aw end aq.AddToggle=function(ar,as,at)if z.
ForceCheckbox then return aq.AddCheckbox(ar,as,at)end at=z:Validate(at,A.Toggle)
local au=ar local av,aw=au.Container,{Text=at.Text,Value=at.Default,Tooltip=at.
Tooltip,DisabledTooltip=at.DisabledTooltip,TooltipTable=nil,Callback=at.Callback
,Changed=at.Changed,Risky=at.Risky,Disabled=at.Disabled,Visible=at.Visible,
Addons={},Variant='Switch',Type='Toggle'}local ax=U('TextButton',{Active=not aw.
Disabled,BackgroundTransparency=1,Size=UDim2.new(1,0,0,18),Text='',Visible=aw.
Visible,Parent=av})local ay=U('TextLabel',{BackgroundTransparency=1,Size=UDim2.
new(1,-40,1,0),Text=aw.Text,TextSize=14,TextTransparency=0.4,TextXAlignment=Enum
.TextXAlignment.Left,Parent=ax})U('UIListLayout',{FillDirection=Enum.
FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,
Padding=UDim.new(0,6),Parent=ay})local az=U('Frame',{AnchorPoint=Vector2.new(1,0
),BackgroundColor3='MainColor',Position=UDim2.fromScale(1,0),Size=UDim2.
fromOffset(32,18),Parent=ax})U('UICorner',{CornerRadius=UDim.new(1,0),Parent=az}
)U('UIPadding',{PaddingBottom=UDim.new(0,2),PaddingLeft=UDim.new(0,2),
PaddingRight=UDim.new(0,2),PaddingTop=UDim.new(0,2),Parent=az})local aA,aB=U(
'UIStroke',{Color='OutlineColor',Parent=az}),U('Frame',{BackgroundColor3=
'FontColor',Size=UDim2.fromScale(1,1),SizeConstraint=Enum.SizeConstraint.
RelativeYY,Parent=az})U('UICorner',{CornerRadius=UDim.new(1,0),Parent=aB})aw.
UpdateColors=function(aC)aw:Display()end aw.Display=function(aC)if z.Unloaded
then return end local aD=aw.Value and 1 or 0 az.BackgroundTransparency=aw.
Disabled and 0.75 or 0 aA.Transparency=aw.Disabled and 0.75 or 0 az.
BackgroundColor3=aw.Value and z.Scheme.AccentColor or z.Scheme.MainColor aA.
Color=aw.Value and z.Scheme.AccentColor or z.Scheme.OutlineColor z.Registry[az].
BackgroundColor3=aw.Value and'AccentColor'or'MainColor'z.Registry[aA].Color=aw.
Value and'AccentColor'or'OutlineColor'if aw.Disabled then ay.TextTransparency=
0.8 aB.AnchorPoint=Vector2.new(aD,0)aB.Position=UDim2.fromScale(aD,0)aB.
BackgroundColor3=z:GetDarkerColor(z.Scheme.FontColor)z.Registry[aB].
BackgroundColor3=function()return z:GetDarkerColor(z.Scheme.FontColor)end return
end k:Create(ay,z.TweenInfo,{TextTransparency=aw.Value and 0 or 0.4}):Play()k:
Create(aB,z.TweenInfo,{AnchorPoint=Vector2.new(aD,0),Position=UDim2.fromScale(aD
,0)}):Play()aB.BackgroundColor3=z.Scheme.FontColor z.Registry[aB].
BackgroundColor3='FontColor'end aw.OnChanged=function(aC,aD)aw.Changed=aD end aw
.SetValue=function(aC,aD)if aw.Disabled then return end aw.Value=aD aw:Display()
for aE,aF in aw.Addons do if aF.Type=='KeyPicker'and aF.SyncToggleState then aF.
Toggled=aw.Value aF:Update()end end z:UpdateDependencyBoxes()z:SafeCallback(aw.
Callback,aw.Value)z:SafeCallback(aw.Changed,aw.Value)end aw.SetDisabled=function
(aC,aD)aw.Disabled=aD if aw.TooltipTable then aw.TooltipTable.Disabled=aw.
Disabled end for aE,aF in aw.Addons do if aF.Type=='KeyPicker'and aF.
SyncToggleState then aF:Update()end end ax.Active=not aw.Disabled aw:Display()
end aw.SetVisible=function(aC,aD)aw.Visible=aD ax.Visible=aw.Visible au:Resize()
end aw.SetText=function(aC,aD)aw.Text=aD ay.Text=aD end ax.MouseButton1Click:
Connect(function()if aw.Disabled then return end aw:SetValue(not aw.Value)end)if
typeof(aw.Tooltip)=='string'or typeof(aw.DisabledTooltip)=='string'then aw.
TooltipTable=z:AddTooltip(aw.Tooltip,aw.DisabledTooltip,ax)aw.TooltipTable.
Disabled=aw.Disabled end if aw.Risky then ay.TextColor3=z.Scheme.RedColor z.
Registry[ay].TextColor3='RedColor'end aw:Display()au:Resize()aw.TextLabel=ay aw.
Container=av setmetatable(aw,ao)aw.Holder=ax table.insert(au.Elements,aw)aw.
Default=aw.Value t[as]=aw return aw end aq.AddInput=function(ar,as,at)if typeof(
at)=='table'and(typeof(at.VerifyValue)=='function'and at.Finished~=true)then at.
Finished=true end at=z:Validate(at,A.Input)local au=ar local av,aw=au.Container,
{Text=at.Text,Value=at.Default,Finished=at.Finished,Numeric=at.Numeric,
ClearTextOnFocus=at.ClearTextOnFocus,ClearTextOnBlur=at.ClearTextOnBlur,
Placeholder=at.Placeholder,AllowEmpty=at.AllowEmpty,EmptyReset=at.EmptyReset,
Tooltip=at.Tooltip,DisabledTooltip=at.DisabledTooltip,TooltipTable=nil,Callback=
at.Callback,Changed=at.Changed,VerifyValue=at.VerifyValue,Disabled=at.Disabled,
Visible=at.Visible,Type='Input'}local ax=U('Frame',{BackgroundTransparency=1,
Size=UDim2.new(1,0,0,39),Visible=aw.Visible,Parent=av})local ay,az=U('TextLabel'
,{BackgroundTransparency=1,Size=UDim2.new(1,0,0,14),Text=aw.Text,TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,Parent=ax}),U('TextBox',{AnchorPoint=
Vector2.new(0,1),BackgroundColor3='MainColor',ClearTextOnFocus=not aw.Disabled
and aw.ClearTextOnFocus,PlaceholderText=aw.Placeholder,Position=UDim2.fromScale(
0,1),Size=UDim2.new(1,0,0,21),Text=aw.Value,TextEditable=not aw.Disabled,
TextScaled=true,TextXAlignment=Enum.TextXAlignment.Left,Parent=ax})U('UIPadding'
,{PaddingBottom=UDim.new(0,3),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,
8),PaddingTop=UDim.new(0,4),Parent=az})U('UIStroke',{Color='OutlineColor',Parent
=az})table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius
/2),Parent=az}))aw.UpdateColors=function(aA)if z.Unloaded then return end ay.
TextTransparency=aw.Disabled and 0.8 or 0 az.TextTransparency=aw.Disabled and
0.8 or 0 end aw.OnChanged=function(aA,aB)aw.Changed=aB end aw.SetValue=function(
aA,aB)if not aw.AllowEmpty and O(aB)==''then aB=aw.EmptyReset end if at.
MaxLength and#aB>at.MaxLength then aB=aB:sub(1,at.MaxLength)end if aw.Numeric
then if#tostring(aB)>0 and not tonumber(aB)then aB=aw.Value end end if typeof(at
.VerifyValue)=='function'and(aB~=aw.EmptyReset and at.VerifyValue(aB)~=true)then
aB=aw.EmptyReset end aw.Value=aB az.Text=aB if not aw.Disabled then z:
SafeCallback(aw.Callback,aw.Value)z:SafeCallback(aw.Changed,aw.Value)end end aw.
SetDisabled=function(aA,aB)aw.Disabled=aB if aw.TooltipTable then aw.
TooltipTable.Disabled=aw.Disabled end az.ClearTextOnFocus=not aw.Disabled and aw
.ClearTextOnFocus az.TextEditable=not aw.Disabled aw:UpdateColors()end aw.
SetVisible=function(aA,aB)aw.Visible=aB ax.Visible=aw.Visible au:Resize()end aw.
SetText=function(aA,aB)aw.Text=aB ay.Text=aB end if aw.Finished then az.
FocusLost:Connect(function(aA)if not aA then if aw.ClearTextOnBlur then az.Text=
aw.Value end return end aw:SetValue(az.Text)end)else az:GetPropertyChangedSignal
'Text':Connect(function()if az.Text==aw.Value then return end aw:SetValue(az.
Text)end)end if typeof(aw.Tooltip)=='string'or typeof(aw.DisabledTooltip)==
'string'then aw.TooltipTable=z:AddTooltip(aw.Tooltip,aw.DisabledTooltip,az)aw.
TooltipTable.Disabled=aw.Disabled end au:Resize()aw.Holder=ax table.insert(au.
Elements,aw)aw.Default=aw.Value if typeof(at.VerifyValue)=='function'and(aw.
Default~=aw.EmptyReset and at.VerifyValue(aw.Default)~=true)then aw:SetValue(aw.
EmptyReset)aw.Default=aw.EmptyReset end u[as]=aw return aw end aq.AddSlider=
function(ar,as,at)at=z:Validate(at,A.Slider)local au=ar local av,aw=au.Container
,{Text=at.Text,Value=at.Default,Min=at.Min,Max=at.Max,Prefix=at.Prefix,Suffix=at
.Suffix,Compact=at.Compact,Rounding=at.Rounding,HideMax=at.HideMax,Tooltip=at.
Tooltip,DisabledTooltip=at.DisabledTooltip,TooltipTable=nil,Callback=at.Callback
,Changed=at.Changed,Disabled=at.Disabled,Visible=at.Visible,Type='Slider'}local
ax,ay=(U('Frame',{BackgroundTransparency=1,Size=UDim2.new(1,0,0,at.Compact and
15 or 33),Visible=aw.Visible,Parent=av}))if not at.Compact then ay=U('TextLabel'
,{BackgroundTransparency=1,Size=UDim2.new(1,0,0,14),Text=aw.Text,TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,Parent=ax})end local az=U('TextButton',{
Active=not aw.Disabled,AnchorPoint=Vector2.new(0,1),BackgroundColor3='MainColor'
,Position=UDim2.fromScale(0,1),Size=UDim2.new(1,0,0,15),Text='',Parent=ax})U(
'UIStroke',{Color='OutlineColor',Parent=az})local aA=U('TextLabel',{
BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text='',TextSize=14,ZIndex=2,
Parent=az})U('UIStroke',{ApplyStrokeMode=Enum.ApplyStrokeMode.Contextual,Color=
'DarkColor',LineJoinMode=Enum.LineJoinMode.Miter,Parent=aA})local aB=U('Frame',{
BackgroundColor3='AccentColor',Size=UDim2.fromScale(0.5,1),Parent=az})table.
insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius/2),Parent=
az}))table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius
/2),Parent=aB}))aw.UpdateColors=function(aC)if z.Unloaded then return end if ay
then ay.TextTransparency=aw.Disabled and 0.8 or 0 end aA.TextTransparency=aw.
Disabled and 0.8 or 0 aB.BackgroundColor3=aw.Disabled and z.Scheme.OutlineColor
or z.Scheme.AccentColor z.Registry[aB].BackgroundColor3=aw.Disabled and
'OutlineColor'or'AccentColor'end aw.Display=function(aC)if z.Unloaded then
return end local aD if at.FormatDisplayValue then aD=at.FormatDisplayValue(aw,aw
.Value)end if aD then aA.Text=tostring(aD)else if at.Compact then aA.Text=string
.format('%s: %s%s%s',aw.Text,aw.Prefix,aw.Value,aw.Suffix)elseif at.HideMax then
aA.Text=string.format('%s%s%s',aw.Prefix,aw.Value,aw.Suffix)else aA.Text=string.
format('%s%s%s/%s%s%s',aw.Prefix,aw.Value,aw.Suffix,aw.Prefix,aw.Max,aw.Suffix)
end end local aE=(aw.Value-aw.Min)/(aw.Max-aw.Min)aB.Size=UDim2.fromScale(aE,1)
end aw.OnChanged=function(aC,aD)aw.Changed=aD end aw.SetMax=function(aC,aD)
assert(aD>aw.Min,'Max value cannot be less than the current min value.')aw:
SetValue(math.clamp(aw.Value,aw.Min,aD))aw.Max=aD aw:Display()end aw.SetMin=
function(aC,aD)assert(aD<aw.Max,
'Min value cannot be greater than the current max value.')aw:SetValue(math.
clamp(aw.Value,aD,aw.Max))aw.Min=aD aw:Display()end aw.SetValue=function(aC,aD)
if aw.Disabled then return end local aE=tonumber(aD)if not aE or aE==aw.Value
then return end aE=math.clamp(aE,aw.Min,aw.Max)aw.Value=aE aw:Display()z:
SafeCallback(aw.Callback,aw.Value)z:SafeCallback(aw.Changed,aw.Value)end aw.
SetDisabled=function(aC,aD)aw.Disabled=aD if aw.TooltipTable then aw.
TooltipTable.Disabled=aw.Disabled end az.Active=not aw.Disabled aw:UpdateColors(
)end aw.SetVisible=function(aC,aD)aw.Visible=aD ax.Visible=aw.Visible au:Resize(
)end aw.SetText=function(aC,aD)aw.Text=aD if ay then ay.Text=aD return end aw:
Display()end aw.SetPrefix=function(aC,aD)aw.Prefix=aD aw:Display()end aw.
SetSuffix=function(aC,aD)aw.Suffix=aD aw:Display()end az.InputBegan:Connect(
function(aC)if not I(aC)or aw.Disabled then return end if z.ActiveTab then for
aD,aE in z.ActiveTab.Sides do aE.ScrollingEnabled=false end end if z.
ActiveLoading and z.ActiveLoading.Sidebar then z.ActiveLoading.Sidebar.Container
.ScrollingEnabled=false end while L(aC)do local aD=q.X local aE,aF=math.clamp((
aD-az.AbsolutePosition.X)/az.AbsoluteSize.X,0,1),aw.Value aw.Value=P(aw.Min+((aw
.Max-aw.Min)*aE),aw.Rounding)aw:Display()if aw.Value~=aF then z:SafeCallback(aw.
Callback,aw.Value)z:SafeCallback(aw.Changed,aw.Value)end f.RenderStepped:Wait()
end if z.ActiveTab then for aD,aE in z.ActiveTab.Sides do aE.ScrollingEnabled=
true end end if z.ActiveLoading and z.ActiveLoading.Sidebar then z.ActiveLoading
.Sidebar.Container.ScrollingEnabled=true end end)if typeof(aw.Tooltip)=='string'
or typeof(aw.DisabledTooltip)=='string'then aw.TooltipTable=z:AddTooltip(aw.
Tooltip,aw.DisabledTooltip,az)aw.TooltipTable.Disabled=aw.Disabled end aw:
UpdateColors()aw:Display()au:Resize()aw.Holder=ax table.insert(au.Elements,aw)aw
.Default=aw.Value u[as]=aw return aw end aq.AddDropdown=function(ar,as,at)at=z:
Validate(at,A.Dropdown)local au=ar local av=au.Container if at.SpecialType==
'Player'then at.Values=R(at.ExcludeLocalPlayer)at.AllowNull=true elseif at.
SpecialType=='Team'then at.Values=S()at.AllowNull=true end local aw={Text=
typeof(at.Text)=='string'and at.Text or nil,Value=at.Multi and{}or nil,Values=at
.Values,DisabledValues=at.DisabledValues,ValueImages=at.ValueImages,Multi=at.
Multi,SpecialType=at.SpecialType,ExcludeLocalPlayer=at.ExcludeLocalPlayer,
EnablePlayerImages=at.EnablePlayerImages,Tooltip=at.Tooltip,RichText=at.RichText
,DisabledTooltip=at.DisabledTooltip,TooltipTable=nil,Callback=at.Callback,
Changed=at.Changed,Disabled=at.Disabled,Visible=at.Visible,Type='Dropdown'}local
ax=U('Frame',{BackgroundTransparency=1,Size=UDim2.new(1,0,0,aw.Text and 39 or 21
),Visible=aw.Visible,Parent=av})local ay,az=U('TextLabel',{
BackgroundTransparency=1,Size=UDim2.new(1,0,0,14),Text=aw.Text,TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,Visible=not not at.Text,ZIndex=3,Parent=
ax}),U('TextButton',{AnchorPoint=Vector2.new(0,1),BackgroundColor3='MainColor',
Position=UDim2.fromScale(0,1),Size=UDim2.new(1,0,0,21),Text='',TextTransparency=
1,ZIndex=2,Parent=ax})U('UIPadding',{PaddingLeft=UDim.new(0,8),PaddingRight=UDim
.new(0,4),Parent=az})U('UIStroke',{Color='OutlineColor',Parent=az})if z.
CornerRadiusDropdown==true then table.insert(z.Corners,U('UICorner',{
CornerRadius=UDim.new(0,z.CornerRadius/2),Parent=az}))end local aA,aB,aC,aD=U(
'ImageLabel',{BackgroundTransparency=1,Position=UDim2.fromOffset(-4,3),Size=
UDim2.fromOffset(16,16),Image='',ImageTransparency=1,ZIndex=2,Parent=az}),U(
'TextButton',{Active=not aw.Disabled,BackgroundTransparency=1,Size=UDim2.new(1,0
,0,21),Text='---',TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,RichText=at.RichText,ZIndex=2,Parent=az}),(
U('ImageLabel',{AnchorPoint=Vector2.new(1,0.5),Image=ak and ak.Url or'',
ImageColor3='FontColor',ImageRectOffset=ak and ak.ImageRectOffset or Vector2.
zero,ImageRectSize=ak and ak.ImageRectSize or Vector2.zero,ImageTransparency=0.5
,Position=UDim2.fromScale(1,0.5),Size=UDim2.fromOffset(16,16),Parent=az}))if at.
Searchable then aD=U('TextBox',{BackgroundTransparency=1,PlaceholderText=
'Search...',Position=UDim2.fromOffset(-8,0),Size=UDim2.new(1,-12,1,0),TextSize=
14,TextXAlignment=Enum.TextXAlignment.Left,Visible=false,Parent=aB})U(
'UIPadding',{PaddingLeft=UDim.new(0,8),Parent=aD})end local aE,aF=function(aE)if
not aE then return nil end local aF if aw.SpecialType=='Player'and aw.
EnablePlayerImages==true then if typeof(aE)=='Instance'and aE:IsA'Player'then aF
={Url=string.format('rbxthumb://type=AvatarHeadShot&id=%s&w=48&h=48',tostring(aE
.UserId))}end else if at.ValueImages and at.ValueImages[aE]then aF=z:
GetCustomIcon(at.ValueImages[aE])end end return aF end,z:AddContextMenu(az,
function()return UDim2.fromOffset((az.AbsoluteSize.X/z.DPIScale)+1,0)end,
function()return{0.5,az.AbsoluteSize.Y+1.5}end,2,function(aE)aB.TextTransparency
=(aE and aD)and 1 or 0 aC.ImageTransparency=aE and 0 or 0.5 aC.Rotation=aE and
180 or 0 if aD then aD.Text=''aD.Visible=aE end end,true)aw.Menu=aF local aG={}
aw.RecalculateListSize=function(aH,aI)local aJ,aK=math.clamp((aI or M(aw.Values)
)*21,0,at.MaxVisibleDropdownItems*21),(az.AbsoluteSize.X/z.DPIScale)+1 for aL in
aG do local aM=at.RichText and Q(aL.Text)or aL.Text local aN=z:GetTextBounds(aM,
aL.FontFace,aL.TextSize,math.huge)if aN>aK then aK=aN end end aF:SetSize(
function()return UDim2.fromOffset(aK,aJ)end)end aw.UpdateColors=function(aH)if z
.Unloaded then return end ay.TextTransparency=aw.Disabled and 0.8 or 0 aB.
TextTransparency=aw.Disabled and 0.8 or 0 aA.ImageTransparency=aw.Disabled and
0.8 or 0 aC.ImageTransparency=aw.Disabled and 0.8 or aF.Active and 0 or 0.5 end
aw.Display=function(aH)if z.Unloaded then return end local aI,aJ=''if at.Multi
then for aK,aL in aw.Values do if aw.Value[aL]then if not aJ then aJ=aE(aL)end
aI=aI..(at.FormatDisplayValue and tostring(at.FormatDisplayValue(aL))or
tostring(aL))..', 'end end aI=aI:sub(1,#aI-2)else aJ=aE(aw.Value)aI=aw.Value and
tostring(aw.Value)or''if aI~=''and at.FormatDisplayValue then aI=tostring(at.
FormatDisplayValue(aI))end end aB.Text=(aI==''and'---'or aI)if aJ then aA.Image=
aJ.Url aA.ImageRectOffset=aJ.ImageRectOffset or Vector2.zero aA.ImageRectSize=aJ
.ImageRectSize or Vector2.zero aA.ImageTransparency=0 else aA.Image=''aA.
ImageTransparency=1 end aB.Size=aJ and UDim2.new(1,-8,0,21)or UDim2.new(1,0,0,21
)aB.Position=aJ and UDim2.fromOffset(14,0)or UDim2.fromOffset(0,0)end aw.
OnChanged=function(aH,aI)aw.Changed=aI end aw.GetActiveValues=function(aH)if at.
Multi then local aI={}for aJ,aK in aw.Value do table.insert(aI,aJ)end return aI
end return aw.Value and 1 or 0 end aw.BuildDropdownList=function(aH)local aI,aJ=
aw.Values,aw.DisabledValues if aw.UtilityButtonsHolder then aw.
UtilityButtonsHolder:Destroy()aw.UtilityButtonsHolder=nil end for aK,aL in aG do
aK.Parent:Destroy()end table.clear(aG)local aK=0 if aw.Multi and next(aw.Values)
and(not aD or aD.Text:len()==0)then aK=1 local aL=U('Frame',{
BackgroundTransparency=1,Size=UDim2.new(1,0,0,21),Parent=aF.Menu})aw.
UtilityButtonsHolder=aL U('UIListLayout',{Parent=aL,Padding=UDim.new(0,8),
FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.
HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Center})
local aM=function(aM,aN)local aO=U('TextButton',{BackgroundColor3='MainColor',
Size=UDim2.fromScale(0.45,0.8),Text=aM,TextSize=13,TextTransparency=0.4,Parent=
aL})U('UIStroke',{Color='OutlineColor',Parent=aO})table.insert(z.Corners,U(
'UICorner',{CornerRadius=UDim.new(0,z.CornerRadius/2),Parent=aO}))aO.
MouseButton1Click:Connect(aN)end aM('Select All',function()local aN={}for aO,aP
in aw.Values do aN[aP]=true end aw:SetValue(aN)end)aM('Deselect All',function()
aw:SetValue{}end)end for aL,aM in aI do local aN=tostring(at.FormatListValue and
at.FormatListValue(aM)or(at.FormatDisplayValue and at.FormatDisplayValue(aM)or
aM))local aO=at.RichText and Q(aN)or aN if aD and not aO:lower():match(aD.Text:
lower())then continue end aK=aK+1 local aP,aQ,aR=table.find(aJ,aM),{},aE(aM)
local aS=U('Frame',{BackgroundColor3='MainColor',BackgroundTransparency=1,
LayoutOrder=aP and 1 or 0,Size=UDim2.new(1,0,0,21),Parent=aF.Menu})local aT,aU=
aR and U('ImageLabel',{BackgroundTransparency=1,Image=aR.Url,ImageRectOffset=aR.
ImageRectOffset,ImageRectSize=aR.ImageRectSize,ImageTransparency=0.5,Size=UDim2.
fromOffset(16,16),Position=UDim2.fromOffset(4,3),Parent=aS}),U('TextButton',{
BackgroundTransparency=1,RichText=at.RichText,Size=aR and UDim2.new(1,-18,0,21)
or UDim2.new(1,0,0,21),Position=aR and UDim2.fromOffset(18,0)or UDim2.
fromOffset(0,0),Text=aN,TextSize=14,TextTransparency=0.5,TextXAlignment=Enum.
TextXAlignment.Left,Parent=aS})U('UIPadding',{PaddingLeft=UDim.new(0,7),
PaddingRight=UDim.new(0,7),Parent=aU})local aV if at.Multi then aV=aw.Value[aM]
else aV=aw.Value==aM end aQ.UpdateButton=function(aW)if at.Multi then aV=aw.
Value[aM]else aV=aw.Value==aM end aS.BackgroundTransparency=aV and 0 or 1 aU.
TextTransparency=aP and 0.8 or aV and 0 or 0.5 if aT then aT.ImageTransparency=
aP and 0.8 or aV and 0 or 0.5 end end if not aP then aU.MouseButton1Click:
Connect(function()local aW=not aV if not(aw:GetActiveValues()==1 and not aW and
not at.AllowNull)then aV=aW if at.Multi then aw.Value[aM]=aV and true or nil
else aw.Value=aV and aM or nil end for aX,aY in aG do aY:UpdateButton()end end
aQ:UpdateButton()aw:Display()z:UpdateDependencyBoxes()z:SafeCallback(aw.Callback
,aw.Value)z:SafeCallback(aw.Changed,aw.Value)end)end aQ:UpdateButton()aw:
Display()aG[aU]=aQ end aw:RecalculateListSize(aK)end aw.SetValue=function(aH,aI)
if at.Multi then local aJ={}for aK,aL in aI or{}do if typeof(aL)~='boolean'then
aJ[aL]=true elseif aL and table.find(aw.Values,aK)then aJ[aK]=true end end aw.
Value=aJ else if table.find(aw.Values,aI)then aw.Value=aI elseif not aI then aw.
Value=nil end end aw:Display()for aJ,aK in aG do aK:UpdateButton()end if not aw.
Disabled then z:UpdateDependencyBoxes()z:SafeCallback(aw.Callback,aw.Value)z:
SafeCallback(aw.Changed,aw.Value)end end aw.SetValues=function(aH,aI)aw.Values=
aI aw:BuildDropdownList()end aw.AddValues=function(aH,aI)if typeof(aI)=='table'
then for aJ,aK in aI do table.insert(aw.Values,aK)end elseif typeof(aI)==
'string'then table.insert(aw.Values,aI)else return end aw:BuildDropdownList()end
aw.SetDisabledValues=function(aH,aI)aw.DisabledValues=aI aw:BuildDropdownList()
end aw.AddDisabledValues=function(aH,aI)if typeof(aI)=='table'then for aJ,aK in
aI do table.insert(aw.DisabledValues,aK)end elseif typeof(aI)=='string'then
table.insert(aw.DisabledValues,aI)else return end aw:BuildDropdownList()end aw.
SetValueImages=function(aH,aI)if typeof(aI)~='table'then return end aw.
ValueImages=aI aw:BuildDropdownList()end aw.AddValueImages=function(aH,aI)if
typeof(aI)~='table'then return end for aJ,aK in aI do aw.ValueImages[aJ]=aK end
aw:BuildDropdownList()end aw.SetDisabled=function(aH,aI)aw.Disabled=aI if aw.
TooltipTable then aw.TooltipTable.Disabled=aw.Disabled end aF:Close()aB.Active=
not aw.Disabled aw:UpdateColors()end aw.SetVisible=function(aH,aI)aw.Visible=aI
ax.Visible=aw.Visible au:Resize()end aw.SetText=function(aH,aI)aw.Text=aI ax.
Size=UDim2.new(1,0,0,aI and 39 or 21)ay.Text=aI and aI or''ay.Visible=not not aI
end local aH=function()if aw.Disabled then return end aF:Toggle()end az.
MouseButton1Click:Connect(aH)aB.MouseButton1Click:Connect(aH)if aD then aD:
GetPropertyChangedSignal'Text':Connect(aw.BuildDropdownList)end local aI={}if
typeof(at.Default)=='string'then local aJ=table.find(aw.Values,at.Default)if aJ
then table.insert(aI,aJ)end elseif typeof(at.Default)=='table'then for aJ,aK in
next,at.Default do local aL=table.find(aw.Values,aK)if aL then table.insert(aI,
aL)end end elseif aw.Values[at.Default]~=nil then table.insert(aI,at.Default)end
if next(aI)then for aJ=1,#aI do local aK=aI[aJ]if at.Multi then aw.Value[aw.
Values[aK] ]=true else aw.Value=aw.Values[aK]end if not at.Multi then break end
end end if typeof(aw.Tooltip)=='string'or typeof(aw.DisabledTooltip)=='string'
then aw.TooltipTable=z:AddTooltip(aw.Tooltip,aw.DisabledTooltip,az)aw.
TooltipTable.Disabled=aw.Disabled end aw:UpdateColors()aw:Display()aw:
BuildDropdownList()au:Resize()aw.Holder=ax table.insert(au.Elements,aw)aw.
Default=aI aw.DefaultValues=aw.Values u[as]=aw return aw end aq.AddViewport=
function(ar,as,at)at=z:Validate(at,A.Viewport)local au=ar local av,aw,ax,ay,az,
aA=au.Container,false,false,0,(at.Object)if at.Clone and typeof(at.Object)==
'Instance'then if at.Object.Archivable then az=az:Clone()else at.Object.
Archivable=true az=az:Clone()at.Object.Archivable=false end end local aB={Object
=az,Camera=(not at.Camera and{(Instance.new'Camera')}or{(at.Camera)})[1],
Interactive=at.Interactive,AutoFocus=at.AutoFocus,Visible=at.Visible,Type=
'Viewport'}assert(typeof(aB.Object)=='Instance'and(aB.Object:IsA'BasePart'or aB.
Object:IsA'Model'),'Instance must be a BasePart or Model.')assert(typeof(aB.
Camera)=='Instance'and aB.Camera:IsA'Camera',
'Camera must be a valid Camera instance.')local aC=function(aC)if aC:IsA
'BasePart'then return aC.Size end return select(2,aC:GetBoundingBox())end local
aD,aE=function()local aD=aC(aB.Object)local aE=math.max(aD.X,aD.Y,aD.Z)local aF,
aG=aE*2,aB.Object:GetPivot().Position aB.Camera.CFrame=CFrame.new(aG+Vector3.
new(0,aE/2,aF),aG)end,U('Frame',{BackgroundTransparency=1,Size=UDim2.new(1,0,0,
at.Height),Visible=aB.Visible,Parent=av})local aF=U('Frame',{AnchorPoint=Vector2
.new(0,1),BackgroundColor3='MainColor',BorderColor3='OutlineColor',
BorderSizePixel=1,Position=UDim2.fromScale(0,1),Size=UDim2.fromScale(1,1),Parent
=aE})U('UIPadding',{PaddingBottom=UDim.new(0,3),PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,4),Parent=aF})local aG=U(
'ViewportFrame',{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Parent=aF,
CurrentCamera=aB.Camera,Active=aB.Interactive})aG.MouseEnter:Connect(function()
if not aB.Interactive then return end for aH,aI in au.Tab.Sides do aI.
ScrollingEnabled=false end end)aG.MouseLeave:Connect(function()if not aB.
Interactive then return end for aH,aI in au.Tab.Sides do aI.ScrollingEnabled=
true end end)aG.InputBegan:Connect(function(aH)if not aB.Interactive then return
end if aH.UserInputType==Enum.UserInputType.MouseButton2 then aw=true aA=aH.
Position elseif aH.UserInputType==Enum.UserInputType.Touch and not ax then aw=
true aA=aH.Position end end)z:GiveSignal(h.InputEnded:Connect(function(aH)if z.
Unloaded then return end if not aB.Interactive then return end if aH.
UserInputType==Enum.UserInputType.MouseButton2 then aw=false elseif aH.
UserInputType==Enum.UserInputType.Touch then aw=false end end))z:GiveSignal(h.
InputChanged:Connect(function(aH)if z.Unloaded then return end if not aB.
Interactive or not aw or ax then return end if aH.UserInputType==Enum.
UserInputType.MouseMovement or aH.UserInputType==Enum.UserInputType.Touch then
local aI=aH.Position-aA aA=aH.Position local aJ,aK,aL=aB.Object:GetPivot().
Position,aB.Camera,CFrame.fromAxisAngle(Vector3.new(0,1,0),-aI.X*0.01)aK.CFrame=
CFrame.new(aJ)*aL*CFrame.new(-aJ)*aK.CFrame local aM=CFrame.fromAxisAngle(aK.
CFrame.RightVector,-aI.Y*0.01)local aN=CFrame.new(aJ)*aM*CFrame.new(-aJ)*aK.
CFrame if aN.UpVector.Y>0.1 then aK.CFrame=aN end end end))aG.InputChanged:
Connect(function(aH)if not aB.Interactive then return end if aH.UserInputType==
Enum.UserInputType.MouseWheel then local aI=aH.Position.Z*2 do local
__DARKLUA_VAR=aB.Camera __DARKLUA_VAR.CFrame=__DARKLUA_VAR.CFrame+aB.Camera.
CFrame.LookVector*aI end end end)z:GiveSignal(h.TouchPinch:Connect(function(aH,
aI,aJ,aK)if z.Unloaded then return end if not aB.Interactive or not z:
MouseIsOverFrame(aG,aH[1])then return end if aK==Enum.UserInputState.Begin then
ax=true aw=false ay=(aH[1]-aH[2]).Magnitude elseif aK==Enum.UserInputState.
Change then local aL=(aH[1]-aH[2]).Magnitude local aM=(aL-ay)*0.1 ay=aL do local
__DARKLUA_VAR=aB.Camera __DARKLUA_VAR.CFrame=__DARKLUA_VAR.CFrame+aB.Camera.
CFrame.LookVector*aM end elseif aK==Enum.UserInputState.End or aK==Enum.
UserInputState.Cancel then ax=false end end))aB.Object.Parent=aG if aB.AutoFocus
then aD()end aB.SetObject=function(aH,aI,aJ)assert(aI,'Object cannot be nil.')if
aJ then aI=aI:Clone()end if aB.Object then aB.Object:Destroy()end aB.Object=aI
aB.Object.Parent=aG au:Resize()end aB.SetHeight=function(aH,aI)assert(aI>0,
'Height must be greater than 0.')aE.Size=UDim2.new(1,0,0,aI)au:Resize()end aB.
Focus=function(aH)if not aB.Object then return end aD()end aB.SetCamera=function
(aH,aI)assert(aI and typeof(aI)=='Instance'and aI:IsA'Camera',
'Camera must be a valid Camera instance.')aB.Camera=aI aG.CurrentCamera=aI end
aB.SetInteractive=function(aH,aI)aB.Interactive=aI aG.Active=aI end aB.
SetVisible=function(aH,aI)aB.Visible=aI aE.Visible=aB.Visible au:Resize()end au:
Resize()aB.Holder=aE table.insert(au.Elements,aB)u[as]=aB return aB end aq.
AddImage=function(ar,as,at)at=z:Validate(at,A.Image)local au=ar local av,aw=au.
Container,{Image=at.Image,Color=at.Color,RectOffset=at.RectOffset,RectSize=at.
RectSize,Outline=at.Outline,Height=at.Height,ScaleType=at.ScaleType,Transparency
=at.Transparency,BackgroundTransparency=at.BackgroundTransparency,Visible=at.
Visible,Type='Image'}local ax=U('Frame',{BackgroundTransparency=1,Size=UDim2.
new(1,0,0,at.Height),Visible=aw.Visible,Parent=av})local ay=U('Frame',{
AnchorPoint=Vector2.new(0,1),BackgroundColor3='MainColor',BorderColor3=
'OutlineColor',BorderSizePixel=1,BackgroundTransparency=aw.
BackgroundTransparency,Position=UDim2.fromScale(0,1),Size=UDim2.fromScale(1,1),
Parent=ax})if aw.Outline then z:AddOutline(ay)end U('UIPadding',{PaddingBottom=
UDim.new(0,3),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=
UDim.new(0,4),Parent=ay})local az={BackgroundTransparency=1,Size=UDim2.
fromScale(1,1),Image=aw.Image,ImageTransparency=aw.Transparency,ImageColor3=aw.
Color,ImageRectOffset=aw.RectOffset,ImageRectSize=aw.RectSize,ScaleType=aw.
ScaleType,Parent=ay}local aA=z:GetCustomIcon(az.Image)assert(aA,
[[Image must be a valid Roblox asset or a valid URL or a valid lucide icon.]])az
.Image=aA.Url az.ImageRectOffset=aA.ImageRectOffset az.ImageRectSize=aA.
ImageRectSize local aB=U('ImageLabel',az)aw.SetHeight=function(aC,aD)assert(aD>0
,'Height must be greater than 0.')aw.Height=aD ax.Size=UDim2.new(1,0,0,aD)au:
Resize()end aw.SetImage=function(aC,aD)assert(typeof(aD)=='string',
'Image must be a string.')local aE=z:GetCustomIcon(aD)assert(aE,
[[Image must be a valid Roblox asset or a valid URL or a valid lucide icon.]])aD
=aE.Url aw.RectOffset=aE.ImageRectOffset aw.RectSize=aE.ImageRectSize aB.Image=
aD aw.Image=aD end aw.SetColor=function(aC,aD)assert(typeof(aD)=='Color3',
'Color must be a Color3 value.')aB.ImageColor3=aD aw.Color=aD end aw.
SetRectOffset=function(aC,aD)assert(typeof(aD)=='Vector2',
'RectOffset must be a Vector2 value.')aB.ImageRectOffset=aD aw.RectOffset=aD end
aw.SetRectSize=function(aC,aD)assert(typeof(aD)=='Vector2',
'RectSize must be a Vector2 value.')aB.ImageRectSize=aD aw.RectSize=aD end aw.
SetScaleType=function(aC,aD)assert(typeof(aD)=='EnumItem'and aD:IsA'ScaleType',
'ScaleType must be a valid Enum.ScaleType.')aB.ScaleType=aD aw.ScaleType=aD end
aw.SetTransparency=function(aC,aD)assert(typeof(aD)=='number',
'Transparency must be a number between 0 and 1.')assert(aD>=0 and aD<=1,
'Transparency must be between 0 and 1.')aB.ImageTransparency=aD aw.Transparency=
aD end aw.SetVisible=function(aC,aD)aw.Visible=aD ax.Visible=aw.Visible au:
Resize()end au:Resize()aw.Holder=ax table.insert(au.Elements,aw)u[as]=aw return
aw end aq.AddVideo=function(ar,as,at)at=z:Validate(at,A.Video)local au=ar local
av,aw=au.Container,{Video=at.Video,Looped=at.Looped,Playing=at.Playing,Volume=at
.Volume,Height=at.Height,Visible=at.Visible,Type='Video'}local ax=U('Frame',{
BackgroundTransparency=1,Size=UDim2.new(1,0,0,at.Height),Visible=aw.Visible,
Parent=av})local ay=U('Frame',{AnchorPoint=Vector2.new(0,1),BackgroundColor3=
'MainColor',BorderColor3='OutlineColor',BorderSizePixel=1,Position=UDim2.
fromScale(0,1),Size=UDim2.fromScale(1,1),Parent=ax})U('UIPadding',{PaddingBottom
=UDim.new(0,3),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=
UDim.new(0,4),Parent=ay})local az=U('VideoFrame',{BackgroundTransparency=1,Size=
UDim2.fromScale(1,1),Video=aw.Video,Looped=aw.Looped,Volume=aw.Volume,Parent=ay}
)az.Playing=aw.Playing aw.SetHeight=function(aA,aB)assert(aB>0,
'Height must be greater than 0.')aw.Height=aB ax.Size=UDim2.new(1,0,0,aB)au:
Resize()end aw.SetVideo=function(aA,aB)assert(typeof(aB)=='string',
'Video must be a string.')az.Video=aB aw.Video=aB end aw.SetLooped=function(aA,
aB)assert(typeof(aB)=='boolean','Looped must be a boolean.')az.Looped=aB aw.
Looped=aB end aw.SetVolume=function(aA,aB)assert(typeof(aB)=='number',
'Volume must be a number between 0 and 10.')az.Volume=aB aw.Volume=aB end aw.
SetPlaying=function(aA,aB)assert(typeof(aB)=='boolean',
'Playing must be a boolean.')az.Playing=aB aw.Playing=aB end aw.Play=function(aA
)az.Playing=true aw.Playing=true end aw.Pause=function(aA)az.Playing=false aw.
Playing=false end aw.SetVisible=function(aA,aB)aw.Visible=aB ax.Visible=aw.
Visible au:Resize()end au:Resize()aw.Holder=ax aw.VideoFrame=az table.insert(au.
Elements,aw)u[as]=aw return aw end aq.AddUIPassthrough=function(ar,as,at)at=z:
Validate(at,A.UIPassthrough)local au=ar local av=au.Container assert(at.Instance
,'Instance must be provided.')assert(typeof(at.Instance)=='Instance'and at.
Instance:IsA'GuiBase2d','Instance must inherit from GuiBase2d.')assert(typeof(at
.Height)=='number'and at.Height>0,'Height must be a number greater than 0.')
local aw={Instance=at.Instance,Height=at.Height,Visible=at.Visible,Type=
'UIPassthrough'}local ax=U('Frame',{BackgroundTransparency=1,Size=UDim2.new(1,0,
0,at.Height),Visible=aw.Visible,Parent=av})aw.Instance.Parent=ax au:Resize()aw.
SetHeight=function(ay,az)assert(typeof(az)=='number'and az>0,
'Height must be a number greater than 0.')aw.Height=az ax.Size=UDim2.new(1,0,0,
az)au:Resize()end aw.SetInstance=function(ay,az)assert(az,
'Instance must be provided.')assert(typeof(az)=='Instance'and az:IsA'GuiBase2d',
'Instance must inherit from GuiBase2d.')if aw.Instance then aw.Instance.Parent=
nil end aw.Instance=az aw.Instance.Parent=ax end aw.SetVisible=function(ay,az)aw
.Visible=az ax.Visible=aw.Visible au:Resize()end aw.Holder=ax table.insert(au.
Elements,aw)u[as]=aw return aw end aq.AddDependencyBox=function(ar)local as=ar
local at,au,av=(as.Container)do au=U('Frame',{BackgroundTransparency=1,Size=
UDim2.fromScale(1,1),Visible=false,Parent=at})av=U('UIListLayout',{Padding=UDim.
new(0,8),Parent=au})end local aw={Visible=false,Dependencies={},Holder=au,
Container=au,Elements={},DependencyBoxes={}}aw.Resize=function(ax)au.Size=UDim2.
new(1,0,0,av.AbsoluteContentSize.Y/z.DPIScale)as:Resize()end aw.Update=function(
ax,ay)for az,aA in aw.Dependencies do local aB,aC=aA[1],aA[2]if aB.Type==
'Toggle'and aB.Value~=aC then au.Visible=false aw.Visible=false return elseif aB
.Type=='Dropdown'then if typeof(aB.Value)=='table'then if not aB.Value[aC]then
au.Visible=false aw.Visible=false return end else if aB.Value~=aC then au.
Visible=false aw.Visible=false return end end end end aw.Visible=true au.Visible
=true if not z.Searching then task.defer(function()aw:Resize()end)elseif not ay
then z:UpdateSearch(z.SearchText)end end av:GetPropertyChangedSignal
'AbsoluteContentSize':Connect(function()if not aw.Visible then return end aw:
Resize()end)aw.SetupDependencies=function(ax,ay)for az,aA in ay do assert(
typeof(aA)=='table','Dependency should be a table.')assert(aA[1]~=nil,
'Dependency is missing element.')assert(aA[2]~=nil,
'Dependency is missing expected value.')end aw.Dependencies=ay aw:Update()end au
:GetPropertyChangedSignal'Visible':Connect(function()aw:Resize()end)
setmetatable(aw,ap)table.insert(as.DependencyBoxes,aw)table.insert(z.
DependencyBoxes,aw)return aw end aq.AddDependencyGroupbox=function(ar)local as=
ar local at,au,av,aw=as.Tab,(as.BoxHolder)do av=U('Frame',{BackgroundColor3=
'BackgroundColor',Size=UDim2.fromScale(1,0),Visible=false,Parent=au})table.
insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius),Parent=av
}))z:AddOutline(av)aw=U('UIListLayout',{Padding=UDim.new(0,8),Parent=av})U(
'UIPadding',{PaddingBottom=UDim.new(0,7),PaddingLeft=UDim.new(0,7),PaddingRight=
UDim.new(0,7),PaddingTop=UDim.new(0,7),Parent=av})end local ax={Visible=false,
Dependencies={},BoxHolder=au,Holder=av,Container=av,Tab=at,Elements={},
DependencyBoxes={}}ax.Resize=function(ay)av.Size=UDim2.new(1,0,0,(aw.
AbsoluteContentSize.Y/z.DPIScale)+18)end ax.Update=function(ay,az)for aA,aB in
ax.Dependencies do local aC,aD=aB[1],aB[2]if aC.Type=='Toggle'and aC.Value~=aD
then av.Visible=false ax.Visible=false return elseif aC.Type=='Dropdown'then if
typeof(aC.Value)=='table'then if not aC.Value[aD]then av.Visible=false ax.
Visible=false return end else if aC.Value~=aD then av.Visible=false ax.Visible=
false return end end end end ax.Visible=true if not z.Searching then av.Visible=
true ax:Resize()elseif not az then z:UpdateSearch(z.SearchText)end end ax.
SetupDependencies=function(ay,az)for aA,aB in az do assert(typeof(aB)=='table',
'Dependency should be a table.')assert(aB[1]~=nil,
'Dependency is missing element.')assert(aB[2]~=nil,
'Dependency is missing expected value.')end ax.Dependencies=az ax:Update()end
setmetatable(ax,ap)table.insert(at.DependencyGroupboxes,ax)table.insert(z.
DependencyBoxes,ax)return ax end ap.__index=aq ap.__namecall=function(ar,as,...)
return aq[as](...)end end z.SetFont=function(aq,ar)if typeof(ar)=='EnumItem'then
ar=Font.fromEnum(ar)end z.Scheme.Font=ar z:UpdateColorsUsingRegistry()end z.
SetNotifySide=function(aq,ar)z.NotifySide=ar if ar:lower()=='left'then ae.
AnchorPoint=Vector2.new(0,0)ae.Position=UDim2.fromOffset(6,6)af.
HorizontalAlignment=Enum.HorizontalAlignment.Left else ae.AnchorPoint=Vector2.
new(1,0)ae.Position=UDim2.new(1,-6,0,6)af.HorizontalAlignment=Enum.
HorizontalAlignment.Right end end z.Notify=function(aq,...)local ar,as={},
select(1,...)if typeof(as)=='table'then ar.Title=tostring(as.Title)ar.
Description=tostring(as.Description)ar.Time=as.Time or 5 ar.SoundId=as.SoundId
ar.Steps=as.Steps ar.Persist=as.Persist ar.Icon=as.Icon ar.BigIcon=as.BigIcon ar
.IconColor=as.IconColor else ar.Description=tostring(as)ar.Time=select(2,...)or
5 ar.SoundId=select(3,...)end ar.Destroyed=false local at,au=false if typeof(ar.
Time)=='Instance'then au=ar.Time.Destroying:Connect(function()at=true au:
Disconnect()au=nil end)end local av=U('Frame',{AutomaticSize=Enum.AutomaticSize.
Y,BackgroundTransparency=1,Size=UDim2.fromScale(1,0),Visible=false,Parent=ae})
local aw=U('Frame',{AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=
'MainColor',Position=z.NotifySide:lower()=='left'and UDim2.new(-1,-8,0,-2)or
UDim2.new(1,8,0,-2),Size=UDim2.fromScale(1,1),ZIndex=5,Parent=av})table.insert(z
.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius),Parent=aw}))U(
'UIListLayout',{Padding=UDim.new(0,4),Parent=aw})U('UIPadding',{PaddingBottom=
UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=
UDim.new(0,8),Parent=aw})z:AddOutline(aw)local ax=U('Frame',{
BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.XY,Size=UDim2.
fromScale(1,0),Parent=aw})if ar.BigIcon then U('UIListLayout',{Padding=UDim.new(
0,8),FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.
VerticalAlignment.Center,Parent=ax})end local ay if ar.BigIcon then local az=z:
GetCustomIcon(ar.BigIcon)if az then ay=U('ImageLabel',{BackgroundTransparency=1,
Size=UDim2.fromOffset(24,24),Image=az.Url,ImageColor3=ar.IconColor or
'AccentColor',ImageRectOffset=az.ImageRectOffset,ImageRectSize=az.ImageRectSize,
Parent=ax})end end local az=U('Frame',{BackgroundTransparency=1,AutomaticSize=
Enum.AutomaticSize.XY,Size=UDim2.fromScale(0,0),Parent=ax})U('UIListLayout',{
Padding=UDim.new(0,4),Parent=az})local aA if ar.Title then aA=U('Frame',{
BackgroundTransparency=1,Size=UDim2.fromScale(0,0),Parent=az})end local aB if ar
.Icon and aA then local aC=z:GetCustomIcon(ar.Icon)if aC then aB=U('ImageLabel',
{BackgroundTransparency=1,AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,
0.5,1),Size=UDim2.fromOffset(15,15),Image=aC.Url,ImageColor3=ar.IconColor or
'FontColor',ImageRectOffset=aC.ImageRectOffset,ImageRectSize=aC.ImageRectSize,
Parent=aA})end end local aC,aD,aE,aF,aG=0,0 if ar.Title then aE=U('TextLabel',{
AutomaticSize=Enum.AutomaticSize.None,BackgroundTransparency=1,AnchorPoint=
Vector2.new(0,0.5),Position=UDim2.new(0,(ar.Icon and 21 or 0),0.5,0),Size=UDim2.
fromScale(0,0),Text=ar.Title,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left
,TextYAlignment=Enum.TextYAlignment.Center,TextWrapped=true,Parent=aA})end if ar
.Description then aF=U('TextLabel',{AutomaticSize=Enum.AutomaticSize.None,
BackgroundTransparency=1,Size=UDim2.fromScale(0,0),Text=ar.Description,TextSize=
14,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Parent=az})end ar.
Resize=function(aH)local aI,aJ=ay and 32 or 0,aB and 21 or 0 if aE then local aK
,aL=z:GetTextBounds(aE.Text,aE.FontFace,aE.TextSize,(ae.AbsoluteSize.X/z.
DPIScale)-24-aI-aJ)aE.Size=UDim2.fromOffset(aK,aL)aC=aK+aJ aA.Size=UDim2.
fromOffset(aC,math.max(aL,aB and 16 or 0))end if aF then local aK,aL=z:
GetTextBounds(aF.Text,aF.FontFace,aF.TextSize,(ae.AbsoluteSize.X/z.DPIScale)-24-
aI)aF.Size=UDim2.fromOffset(aK,aL)aD=aK end av.Size=UDim2.fromOffset(math.max(aC
,aD)+24+aI,0)end ar.ChangeTitle=function(aH,aI)if aE then ar.Title=tostring(aI)
aE.Text=ar.Title ar:Resize()end end ar.ChangeDescription=function(aH,aI)if aF
then ar.Description=tostring(aI)aF.Text=ar.Description ar:Resize()end end ar.
ChangeStep=function(aH,aI)if aG and ar.Steps then aI=math.clamp(aI or 0,0,ar.
Steps)aG.Size=UDim2.fromScale(aI/ar.Steps,1)end end ar.Destroy=function(aH)ar.
Destroyed=true if typeof(ar.Time)=='Instance'then pcall(ar.Time.Destroy,ar.Time)
end if au then au:Disconnect()end k:Create(aw,z.NotifyTweenInfo,{Position=z.
NotifySide:lower()=='left'and UDim2.new(-1,-8,0,-2)or UDim2.new(1,8,0,-2)}):
Play()task.delay(z.NotifyTweenInfo.Time,function()z.Notifications[av]=nil av:
Destroy()end)end ar:Resize()local aH=U('Frame',{BackgroundTransparency=1,Size=
UDim2.new(1,0,0,7),Visible=(ar.Persist~=true and typeof(ar.Time)~='Instance')or
typeof(ar.Steps)=='number',Parent=aw})local aI=U('Frame',{BackgroundColor3=
'BackgroundColor',BorderColor3='OutlineColor',BorderSizePixel=1,Position=UDim2.
fromOffset(0,3),Size=UDim2.new(1,0,0,2),Parent=aH})aG=U('Frame',{
BackgroundColor3='AccentColor',Size=UDim2.fromScale(1,1),Parent=aI})if typeof(ar
.Time)=='Instance'then aG.Size=UDim2.fromScale(0,1)end if ar.SoundId then local
aJ=ar.SoundId if typeof(aJ)=='number'then aJ=string.format('rbxassetid://%d',aJ)
end U('Sound',{SoundId=aJ,Volume=3,PlayOnRemove=true,Parent=g}):Destroy()end z.
Notifications[av]=ar av.Visible=true k:Create(aw,z.NotifyTweenInfo,{Position=
UDim2.fromOffset(0,0)}):Play()task.delay(z.NotifyTweenInfo.Time,function()if ar.
Persist then return elseif typeof(ar.Time)=='Instance'then repeat task.wait()
until at or ar.Destroyed else k:Create(aG,TweenInfo.new(ar.Time,Enum.EasingStyle
.Linear,Enum.EasingDirection.InOut),{Size=UDim2.fromScale(0,1)}):Play()task.
wait(ar.Time)end if not ar.Destroyed then ar:Destroy()end end)return ar end z.
CreateWindow=function(aq,ar)ar=z:Validate(ar,A.Window)local as=workspace.
CurrentCamera.ViewportSize if f:IsStudio()and as.X<=5 and as.Y<=5 then repeat as
=workspace.CurrentCamera.ViewportSize task.wait()until as.X>5 and as.Y>5 end
local at,au=as.X-64,as.Y-64 z.OriginalMinSize=Vector2.new(math.min(z.
OriginalMinSize.X,at),math.min(z.OriginalMinSize.Y,au))z.MinSize=z.
OriginalMinSize ar.Size=UDim2.fromOffset(math.clamp(ar.Size.X.Offset,z.MinSize.X
,at),math.clamp(ar.Size.Y.Offset,z.MinSize.Y,au))if typeof(ar.Font)=='EnumItem'
then ar.Font=Font.fromEnum(ar.Font)end ar.CornerRadius=math.min(ar.CornerRadius,
20)if ar.Compact~=nil then ar.SidebarCompacted=ar.Compact end if ar.
SidebarMinWidth~=nil then ar.MinSidebarWidth=ar.SidebarMinWidth end ar.
MinSidebarWidth=math.max(64,ar.MinSidebarWidth)ar.SidebarCompactWidth=math.max(
48,ar.SidebarCompactWidth)ar.SidebarCollapseThreshold=math.clamp(ar.
SidebarCollapseThreshold,0.1,0.9)ar.CompactWidthActivation=math.max(48,ar.
CompactWidthActivation)z.CornerRadius=ar.CornerRadius z:SetNotifySide(ar.
NotifySide)z.ShowCustomCursor=ar.ShowCustomCursor z.Scheme.Font=ar.Font z.
ToggleKeybind=ar.ToggleKeybind z.GlobalSearch=ar.GlobalSearch local av,aw,ax,ay,
az,aA,aB,aC,aD,aE,aF,aG,aH,aI,aJ,aK,aL,aM,aN=ar.SearchbarSize==UDim2.fromScale(1
,1),math.ceil(ar.Size.X.Offset*0.3),(ar.SidebarCompacted)local aO=aw do z.
KeybindFrame,z.KeybindContainer=z:AddDraggableMenu'Keybinds'z.KeybindFrame.
AnchorPoint=Vector2.new(0,0.5)z.KeybindFrame.Position=UDim2.new(0,6,0.5,0)z.
KeybindFrame.Visible=false ay=U('TextButton',{BackgroundColor3=function()return
z:GetBetterColor(z.Scheme.BackgroundColor,-1)end,Name='Main',Text='',Position=ar
.Position,Size=ar.Size,Visible=false,Parent=X})table.insert(z.Corners,U(
'UICorner',{CornerRadius=UDim.new(0,ar.CornerRadius),Parent=ay}))table.insert(z.
Scales,U('UIScale',{Parent=ay}))z:AddOutline(ay)z:MakeLine(ay,{Position=UDim2.
fromOffset(0,48),Size=UDim2.new(1,0,0,1)})az=U('Frame',{BackgroundColor3=
'OutlineColor',Position=UDim2.fromOffset(aw,0),Size=UDim2.new(0,1,1,-21),Parent=
ay})if ar.BackgroundImage then aL=U('ImageLabel',{Image=ar.BackgroundImage,
Position=UDim2.fromScale(0,0),Size=UDim2.fromScale(1,1),ScaleType=Enum.ScaleType
.Stretch,ZIndex=999,BackgroundTransparency=1,ImageTransparency=0.75,Parent=ay})
table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,ar.CornerRadius),
Parent=aL}))end if ar.Center then ay.Position=UDim2.new(0.5,-ay.Size.X.Offset/2,
0.5,-ay.Size.Y.Offset/2)end local aP=U('Frame',{BackgroundTransparency=1,Size=
UDim2.new(1,0,0,48),Parent=ay})z:MakeDraggable(ay,aP,false,true)aA=U('Frame',{
BackgroundTransparency=1,Size=UDim2.new(0,aw,1,0),Parent=aP})U('UIListLayout',{
FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.
HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Center,
Padding=UDim.new(0,6),Parent=aA})if ar.Icon then local aQ=z:GetCustomIcon(ar.
Icon)aC=U('ImageLabel',{Image=aQ.Url,ImageRectOffset=aQ.ImageRectOffset,
ImageRectSize=aQ.ImageRectSize,Size=ar.IconSize,Parent=aA})else aC=U('TextLabel'
,{BackgroundTransparency=1,Size=ar.IconSize,Text=ar.Title:sub(1,1),TextScaled=
true,Visible=false,Parent=aA})end local aQ=z:GetTextBounds(ar.Title,z.Scheme.
Font,20,aA.AbsoluteSize.X-(ar.Icon and ar.IconSize.X.Offset+6 or 0)-12)aB=U(
'TextLabel',{BackgroundTransparency=1,Size=UDim2.new(0,aQ,1,0),Text=ar.Title,
TextSize=20,Parent=aA})aD=U('Frame',{AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,Position=UDim2.new(1,-49,0.5,0),Size=UDim2.new(1,-aw-57
-1,1,-16),Parent=aP})U('UIListLayout',{FillDirection=Enum.FillDirection.
Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Left,VerticalAlignment=
Enum.VerticalAlignment.Center,Padding=UDim.new(0,8),Parent=aD})aF=U('Frame',{
Size=UDim2.fromScale(ar.DisableSearch and 1 or 0.5,1),Visible=false,
BackgroundTransparency=1,Parent=aD})U('UIFlexItem',{FlexMode=Enum.UIFlexMode.
Grow,Parent=aF})U('UIListLayout',{FillDirection=Enum.FillDirection.Vertical,
HorizontalAlignment=Enum.HorizontalAlignment.Left,VerticalAlignment=Enum.
VerticalAlignment.Center,Parent=aF})U('UIPadding',{PaddingBottom=UDim.new(0,8),
PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,8),
Parent=aF})aG=U('TextLabel',{BackgroundTransparency=1,Size=UDim2.fromScale(1,0),
AutomaticSize=Enum.AutomaticSize.Y,Text='',TextSize=14,TextXAlignment=Enum.
TextXAlignment.Left,Parent=aF})aH=U('TextLabel',{BackgroundTransparency=1,Size=
UDim2.fromScale(1,0),AutomaticSize=Enum.AutomaticSize.Y,Text='',TextWrapped=true
,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,TextTransparency=0.5,Parent
=aF})aE=U('TextBox',{BackgroundColor3='MainColor',PlaceholderText='Search',Size=
ar.SearchbarSize,TextScaled=true,Visible=not(ar.DisableSearch or false),Parent=
aD})U('UIFlexItem',{FlexMode=Enum.UIFlexMode.Shrink,Parent=aE})table.insert(z.
Corners,U('UICorner',{CornerRadius=UDim.new(0,ar.CornerRadius),Parent=aE}))U(
'UIPadding',{PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=
UDim.new(0,8),PaddingTop=UDim.new(0,8),Parent=aE})U('UIStroke',{Color=
'OutlineColor',Parent=aE})local aR=z:GetIcon'search'if aR then U('ImageLabel',{
Image=aR.Url,ImageColor3='FontColor',ImageRectOffset=aR.ImageRectOffset,
ImageRectSize=aR.ImageRectSize,ImageTransparency=0.5,Size=UDim2.fromScale(1,1),
SizeConstraint=Enum.SizeConstraint.RelativeYY,Parent=aE})end if an then U(
'ImageLabel',{AnchorPoint=Vector2.new(1,0.5),Image=an.Url,ImageColor3=
'OutlineColor',ImageRectOffset=an.ImageRectOffset,ImageRectSize=an.ImageRectSize
,Position=UDim2.new(1,-10,0.5,0),Size=UDim2.fromOffset(28,28),SizeConstraint=
Enum.SizeConstraint.RelativeYY,Parent=aP})end aM=U('Frame',{AnchorPoint=Vector2.
new(0,1),BackgroundColor3=function()return z:GetBetterColor(z.Scheme.
BackgroundColor,4)end,Position=UDim2.fromScale(0,1),Size=UDim2.new(1,0,0,20+ar.
CornerRadius),Parent=ay})z:MakeLine(ay,{AnchorPoint=Vector2.new(0,1),Position=
UDim2.new(0,0,1,-20),Size=UDim2.new(1,0,0,1)})local aS=U('Frame',{AnchorPoint=
Vector2.new(0,1),BackgroundTransparency=1,Position=UDim2.fromScale(0,1),Size=
UDim2.new(1,0,0,20),Parent=ay})table.insert(z.Corners,U('UICorner',{CornerRadius
=UDim.new(0,ar.CornerRadius),Parent=aM}))aN=U('TextLabel',{
BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text=ar.Footer,TextSize=14,
TextTransparency=0.5,Parent=aS})if ar.Resizable then aI=U('TextButton',{
AnchorPoint=Vector2.new(1,0),BackgroundTransparency=1,Position=UDim2.new(1,-ar.
CornerRadius/4,0,0),Size=UDim2.fromScale(1,1),SizeConstraint=Enum.SizeConstraint
.RelativeYY,Text='',Parent=aS})z:MakeResizable(ay,aI,function()for aT,aU in z.
Tabs do aU:Resize(true)end end)end U('ImageLabel',{Image=al and al.Url or'',
ImageColor3='FontColor',ImageRectOffset=al and al.ImageRectOffset or Vector2.
zero,ImageRectSize=al and al.ImageRectSize or Vector2.zero,ImageTransparency=0.5
,Position=UDim2.fromOffset(2,2),Size=UDim2.new(1,-4,1,-4),Parent=aI})aJ=U(
'ScrollingFrame',{AutomaticCanvasSize=Enum.AutomaticSize.Y,BackgroundColor3=
'BackgroundColor',CanvasSize=UDim2.fromScale(0,0),Position=UDim2.fromOffset(0,49
),ScrollBarThickness=0,Size=UDim2.new(0,aw,1,-70),Parent=ay})U('UIListLayout',{
Parent=aJ})aK=U('Frame',{AnchorPoint=Vector2.new(1,0),BackgroundColor3=function(
)return z:GetBetterColor(z.Scheme.BackgroundColor,1)end,Name='Container',
Position=UDim2.new(1,0,0,49),Size=UDim2.new(1,-aw-1,1,-70),Parent=ay})U(
'UIPadding',{PaddingBottom=UDim.new(0,0),PaddingLeft=UDim.new(0,6),PaddingRight=
UDim.new(0,6),PaddingTop=UDim.new(0,0),Parent=aK})end local aP={}aP.ChangeTitle=
function(aQ,aR)assert(typeof(aR)=='string','Expected string for title got: '..
typeof(aR))aB.Text=aR ar.Title=aR end if ar.BackgroundImage then aP.
SetBackgroundImage=function(aQ,aR)assert(typeof(aR)=='string',
'Expected string for Image got: '..typeof(aR))aL.Image=aR ar.BackgroundImage=aR
end end aP.SetFooter=function(aQ,aR)assert(typeof(aR)=='string',
'Expected string for footer got: '..typeof(aR))aN.Text=aR ar.Footer=aR end aP.
SetCornerRadius=function(aQ,aR)assert(typeof(aR)=='number',
'Expected number for Radius got: '..typeof(aR))aR=math.min(aR,20)for aS,aT in z.
Corners do if aT.CornerRadius.Offset==z.CornerRadius/2 then aT.CornerRadius=UDim
.new(0,aR/2)else aT.CornerRadius=UDim.new(0,aR)end end z.CornerRadius=aR ar.
CornerRadius=aR aI.Position=UDim2.new(1,-aR/4,0,0)aM.Size=UDim2.new(1,0,0,20+aR)
for aS,aT in z.Tabs do if aT.IsKeyTab then continue end for aU,aV in aT.Tabboxes
do aV:UpdateCorners()end end end local aQ=function()ax=aP:GetSidebarWidth()==ar.
SidebarCompactWidth if ar.DisableCompactingSnap then ax=aP:GetSidebarWidth()<=ar
.CompactWidthActivation end aB.Visible=not ax if not ar.Icon then aC.Visible=ax
end for aQ,aR in z.TabButtons do if not aR.Icon then continue end aR.Label.
Visible=not ax aR.Padding.PaddingBottom=UDim.new(0,ax and 6 or 11)aR.Padding.
PaddingLeft=UDim.new(0,ax and 6 or 12)aR.Padding.PaddingRight=UDim.new(0,ax and
6 or 12)aR.Padding.PaddingTop=UDim.new(0,ax and 6 or 11)aR.Icon.SizeConstraint=
ax and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY end end
aP.IsSidebarCompacted=function(aR)return ax end aP.SetCompact=function(aR,aS)aP:
SetSidebarWidth(aS and ar.SidebarCompactWidth or aO)end aP.GetSidebarWidth=
function(aR)return aJ.Size.X.Offset end aP.SetSidebarWidth=function(aR,aS)aS=
math.clamp(aS,48,ay.Size.X.Offset-ar.MinContainerWidth-1)az.Position=UDim2.
fromOffset(aS,0)aA.Size=UDim2.new(0,aS,1,0)aD.Size=UDim2.new(1,-aS-57-1,1,-16)aJ
.Size=UDim2.new(0,aS,1,-70)aK.Size=UDim2.new(1,-aS-1,1,-70)if ar.
EnableCompacting then aQ()end if not ax then aO=aS end end aP.ShowTabInfo=
function(aR,aS,aT)aG.Text=aS aH.Text=aT if av then aE.Size=UDim2.fromScale(0.5,1
)end aF.Visible=true end aP.HideTabInfo=function(aR)aF.Visible=false if av then
aE.Size=UDim2.fromScale(1,1)end end aP.AddTab=function(aR,...)local aS,aT,aU if
select('#',...)==1 and typeof(...)=='table'then local aV=select(1,...)aS=aV.Name
or'Tab'aT=aV.Icon aU=aV.Description else aS=select(1,...)aT=select(2,...)aU=
select(3,...)end local aV,aW,aX,aY,aZ,a_ aT=z:GetCustomIcon(aT)do aV=U(
'TextButton',{BackgroundColor3='MainColor',BackgroundTransparency=1,Size=UDim2.
new(1,0,0,40),Text='',Parent=aJ})local a0=U('UIPadding',{PaddingBottom=UDim.new(
0,ax and 6 or 11),PaddingLeft=UDim.new(0,ax and 6 or 12),PaddingRight=UDim.new(0
,ax and 6 or 12),PaddingTop=UDim.new(0,ax and 6 or 11),Parent=aV})aW=U(
'TextLabel',{BackgroundTransparency=1,Position=UDim2.fromOffset(30,0),Size=UDim2
.new(1,-30,1,0),Text=aS,TextSize=16,TextTransparency=0.5,TextXAlignment=Enum.
TextXAlignment.Left,Visible=not ax,Parent=aV})if aT then aX=U('ImageLabel',{
Image=aT.Url,ImageColor3=aT.Custom and'WhiteColor'or'AccentColor',
ImageRectOffset=aT.ImageRectOffset,ImageRectSize=aT.ImageRectSize,
ImageTransparency=0.5,ScaleType=Enum.ScaleType.Fit,Size=UDim2.fromScale(1,1),
SizeConstraint=ax and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.
RelativeYY,Parent=aV})end table.insert(z.TabButtons,{Label=aW,Padding=a0,Icon=aX
})aY=U('Frame',{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Visible=false
,Parent=aK})aZ=U('ScrollingFrame',{AutomaticCanvasSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,CanvasSize=UDim2.fromScale(0,0),
ScrollBarImageTransparency=1,ScrollBarThickness=0,Size=UDim2.new(0.5,-3,1,0),
Parent=aY})U('UIListLayout',{Padding=UDim.new(0,2),Parent=aZ})U('UIPadding',{
PaddingBottom=UDim.new(0,2),PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,2)
,PaddingTop=UDim.new(0,2),Parent=aZ})do U('Frame',{BackgroundTransparency=1,
LayoutOrder=-1,Parent=aZ})U('Frame',{BackgroundTransparency=1,LayoutOrder=1,
Parent=aZ})end a_=U('ScrollingFrame',{AnchorPoint=Vector2.new(1,0),
AutomaticCanvasSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,CanvasSize=
UDim2.fromScale(0,0),Position=UDim2.fromScale(1,0),ScrollBarImageTransparency=1,
ScrollBarThickness=0,Size=UDim2.new(0.5,-3,1,0),Parent=aY})U('UIListLayout',{
Padding=UDim.new(0,2),Parent=a_})U('UIPadding',{PaddingBottom=UDim.new(0,2),
PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,2),PaddingTop=UDim.new(0,2),
Parent=a_})do U('Frame',{BackgroundTransparency=1,LayoutOrder=-1,Parent=a_})U(
'Frame',{BackgroundTransparency=1,LayoutOrder=1,Parent=a_})end end local a0,a1,
a2,a3,a4,a5,a6,a7=(U('Frame',{AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,Position=UDim2.fromOffset(0,7),Size=UDim2.fromScale(1,0
),Visible=false,Parent=aY}))do a1=U('Frame',{BackgroundColor3='BackgroundColor',
Position=UDim2.fromOffset(2,0),Size=UDim2.new(1,-5,0,0),Parent=a0})table.insert(
z.Corners,U('UICorner',{CornerRadius=UDim.new(0,ar.CornerRadius),Parent=a1}))a2,
a3=z:AddOutline(a1)a4=U('ScrollingFrame',{BackgroundTransparency=1,
BorderSizePixel=0,Size=UDim2.fromScale(1,1),CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=3,ScrollingDirection=Enum.ScrollingDirection.Y,Parent=a1})U(
'UIPadding',{PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,6),PaddingRight=
UDim.new(0,6),PaddingTop=UDim.new(0,4),Parent=a4})a5=U('TextLabel',{
BackgroundTransparency=1,Size=UDim2.new(1,-4,0,14),Text='',TextColor3=Color3.
fromRGB(255,50,50),TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,Parent=a4
})a6=U('UIStroke',{ApplyStrokeMode=Enum.ApplyStrokeMode.Contextual,Color=Color3.
fromRGB(169,0,0),LineJoinMode=Enum.LineJoinMode.Miter,Parent=a5})a7=U(
'TextLabel',{BackgroundTransparency=1,Position=UDim2.fromOffset(0,16),Size=UDim2
.new(1,-4,0,0),Text='',TextSize=14,TextWrapped=true,Parent=a4,TextXAlignment=
Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top})U('UIStroke',{
ApplyStrokeMode=Enum.ApplyStrokeMode.Contextual,Color='DarkColor',LineJoinMode=
Enum.LineJoinMode.Miter,Parent=a7})end local a8={Groupboxes={},Tabboxes={},
DependencyGroupboxes={},Description=aU,Sides={aZ,a_},WarningBox={IsNormal=false,
LockSize=false,Visible=false,Title='WARNING',Text=''}}a8.UpdateWarningBox=
function(a9,ba)if typeof(ba.IsNormal)=='boolean'then a8.WarningBox.IsNormal=ba.
IsNormal end if typeof(ba.LockSize)=='boolean'then a8.WarningBox.LockSize=ba.
LockSize end if typeof(ba.Visible)=='boolean'then a8.WarningBox.Visible=ba.
Visible end if typeof(ba.Title)=='string'then a8.WarningBox.Title=ba.Title end
if typeof(ba.Text)=='string'then a8.WarningBox.Text=ba.Text end a0.Visible=a8.
WarningBox.Visible a5.Text=a8.WarningBox.Title a7.Text=a8.WarningBox.Text a8:
Resize(true)a1.BackgroundColor3=a8.WarningBox.IsNormal==true and z.Scheme.
BackgroundColor or Color3.fromRGB(127,0,0)a3.Color=a8.WarningBox.IsNormal==true
and z.Scheme.DarkColor or Color3.fromRGB(85,0,0)a2.Color=a8.WarningBox.IsNormal
==true and z.Scheme.OutlineColor or Color3.fromRGB(255,50,50)a5.TextColor3=a8.
WarningBox.IsNormal==true and z.Scheme.FontColor or Color3.fromRGB(255,50,50)a6.
Color=a8.WarningBox.IsNormal==true and z.Scheme.OutlineColor or Color3.fromRGB(
169,0,0)if not z.Registry[a1]then z:AddToRegistry(a1,{})end if not z.Registry[a3
]then z:AddToRegistry(a3,{})end if not z.Registry[a2]then z:AddToRegistry(a2,{})
end if not z.Registry[a5]then z:AddToRegistry(a5,{})end if not z.Registry[a6]
then z:AddToRegistry(a6,{})end z.Registry[a1].BackgroundColor3=function()return
a8.WarningBox.IsNormal==true and z.Scheme.BackgroundColor or Color3.fromRGB(127,
0,0)end z.Registry[a3].Color=function()return a8.WarningBox.IsNormal==true and z
.Scheme.DarkColor or Color3.fromRGB(85,0,0)end z.Registry[a2].Color=function()
return a8.WarningBox.IsNormal==true and z.Scheme.OutlineColor or Color3.fromRGB(
255,50,50)end z.Registry[a5].TextColor3=function()return a8.WarningBox.IsNormal
==true and z.Scheme.FontColor or Color3.fromRGB(255,50,50)end z.Registry[a6].
Color=function()return a8.WarningBox.IsNormal==true and z.Scheme.OutlineColor or
Color3.fromRGB(169,0,0)end end a8.RefreshSides=function(a9)local ba=a0.Visible
and a1.Size.Y.Offset+8 or 0 for bb,bc in a8.Sides do bc.Position=UDim2.new(bc.
Position.X.Scale,0,0,ba)bc.Size=UDim2.new(0.5,-3,1,-ba)end end a8.Resize=
function(a9,ba)if ba then local bb,bc,bd=math.floor(aY.AbsoluteSize.Y/3.25),z:
GetTextBounds(a7.Text,z.Scheme.Font,a7.TextSize,a7.AbsoluteSize.X)local be=24+bd
if a8.WarningBox.LockSize==true and be>=bb then a4.CanvasSize=UDim2.fromOffset(0
,be)be=bb else a4.CanvasSize=UDim2.fromOffset(0,0)end a7.Size=UDim2.new(1,-4,0,
bd)a1.Size=UDim2.new(1,-5,0,be+4)end a8:RefreshSides()end a8.AddGroupbox=
function(a9,ba)local bb=U('Frame',{AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,Size=UDim2.fromScale(1,0),Parent=ba.Side==1 and aZ or
a_})U('UIListLayout',{Padding=UDim.new(0,6),Parent=bb})U('UIPadding',{
PaddingBottom=UDim.new(0,4),PaddingTop=UDim.new(0,4),Parent=bb})local bc,bd,be,
bf do bc=U('Frame',{BackgroundColor3='BackgroundColor',Size=UDim2.fromScale(1,0)
,Parent=bb})table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,ar.
CornerRadius),Parent=bc}))z:AddOutline(bc)z:MakeLine(bc,{Position=UDim2.
fromOffset(0,34),Size=UDim2.new(1,0,0,1)})local bg=z:GetCustomIcon(ba.IconName)
if bg then U('ImageLabel',{Image=bg.Url,ImageColor3=bg.Custom and'WhiteColor'or
'AccentColor',ImageRectOffset=bg.ImageRectOffset,ImageRectSize=bg.ImageRectSize,
Position=UDim2.fromOffset(6,6),Size=UDim2.fromOffset(22,22),Parent=bc})end bd=U(
'TextLabel',{BackgroundTransparency=1,Position=UDim2.fromOffset(bg and 24 or 0,0
),Size=UDim2.new(1,0,0,34),Text=ba.Name,TextSize=15,TextXAlignment=Enum.
TextXAlignment.Left,Parent=bc})U('UIPadding',{PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),Parent=bd})be=U('Frame',{BackgroundTransparency=1,
Position=UDim2.fromOffset(0,35),Size=UDim2.new(1,0,1,-35),Parent=bc})bf=U(
'UIListLayout',{Padding=UDim.new(0,8),Parent=be})U('UIPadding',{PaddingBottom=
UDim.new(0,7),PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7),PaddingTop=
UDim.new(0,7),Parent=be})end local bg={BoxHolder=bb,Holder=bc,Container=be,Tab=
a8,DependencyBoxes={},Elements={}}bg.Resize=function(bh)bc.Size=UDim2.new(1,0,0,
(bf.AbsoluteContentSize.Y/z.DPIScale)+49)end setmetatable(bg,ap)bg:Resize()a8.
Groupboxes[ba.Name]=bg return bg end a8.AddLeftGroupbox=function(a9,ba,bb)return
a8:AddGroupbox{Side=1,Name=ba,IconName=bb}end a8.AddRightGroupbox=function(a9,ba
,bb)return a8:AddGroupbox{Side=2,Name=ba,IconName=bb}end a8.AddTabbox=function(
a9,ba)local bb=U('Frame',{AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,Size=UDim2.fromScale(1,0),Parent=ba.Side==1 and aZ or
a_})U('UIListLayout',{Padding=UDim.new(0,6),Parent=bb})U('UIPadding',{
PaddingBottom=UDim.new(0,4),PaddingTop=UDim.new(0,4),Parent=bb})local bc,bd do
bc=U('Frame',{BackgroundColor3='BackgroundColor',Size=UDim2.fromScale(1,0),
Parent=bb})table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,ar.
CornerRadius),Parent=bc}))z:AddOutline(bc)bd=U('Frame',{BackgroundTransparency=1
,Size=UDim2.new(1,0,0,34),Parent=bc})U('UIListLayout',{FillDirection=Enum.
FillDirection.Horizontal,HorizontalFlex=Enum.UIFlexAlignment.Fill,Parent=bd})end
local be,bf,bg=0,1,{ActiveTab=nil,BoxHolder=bb,Holder=bc,Tabs={}}bg.
UpdateCorners=function(bh)for bi,bj in bg.Tabs do bj:UpdateCorners()end end bg.
AddTab=function(bh,bi,bj)local bk=bf be=be+1 bf=bf+1 local bl,bm=z:
GetCustomIcon(bj),U('TextButton',{BackgroundColor3='MainColor',
BackgroundTransparency=0,Size=UDim2.fromOffset(0,34),Text='',Parent=bd})table.
insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,ar.CornerRadius),Parent=
bm}))local bn,bo,bp,bq=U('Frame',{Name='BottomCover',BackgroundColor3=
'MainColor',BorderSizePixel=0,Position=UDim2.new(0,0,1,-ar.CornerRadius),Size=
UDim2.new(1,0,0,ar.CornerRadius),Parent=bm}),U('Frame',{Name='LeftCover',
BackgroundColor3='MainColor',BorderSizePixel=0,Position=UDim2.new(0,0,0,0),Size=
UDim2.new(0,ar.CornerRadius,1,0),Visible=false,Parent=bm}),U('Frame',{Name=
'RightCover',AnchorPoint=Vector2.new(1,0),BackgroundColor3='MainColor',
BorderSizePixel=0,Position=UDim2.new(1,0,0,0),Size=UDim2.new(0,ar.CornerRadius,1
,0),Visible=false,Parent=bm}),U('Frame',{AnchorPoint=Vector2.new(0.5,0.5),
AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Position=UDim2.
fromScale(0.5,0.5),Size=UDim2.fromOffset(0,16),Parent=bm})U('UIListLayout',{
FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.
HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Center,
Padding=UDim.new(0,8),Parent=bq})local br if bl then br=U('ImageLabel',{Image=bl
.Url,ImageColor3=bl.Custom and'WhiteColor'or'AccentColor',ImageRectOffset=bl.
ImageRectOffset,ImageRectSize=bl.ImageRectSize,ImageTransparency=0.5,Size=UDim2.
fromOffset(16,16),Parent=bq})end local bs,bt,bu=U('TextLabel',{AutomaticSize=
Enum.AutomaticSize.X,BackgroundTransparency=1,Size=UDim2.fromOffset(0,16),Text=
bi,TextSize=15,TextTransparency=0.5,Parent=bq}),z:MakeLine(bm,{AnchorPoint=
Vector2.new(0,1),Position=UDim2.new(0,0,1,1),Size=UDim2.new(1,0,0,1)}),U('Frame'
,{BackgroundTransparency=1,Position=UDim2.fromOffset(0,35),Size=UDim2.new(1,0,1,
-35),Visible=false,Parent=bc})local bv=U('UIListLayout',{Padding=UDim.new(0,8),
Parent=bu})U('UIPadding',{PaddingBottom=UDim.new(0,7),PaddingLeft=UDim.new(0,7),
PaddingRight=UDim.new(0,7),PaddingTop=UDim.new(0,7),Parent=bu})local bw={
ButtonHolder=bm,Container=bu,ButtonCovers={BottomCover=bn,LeftCover=bo,
RightCover=bp},Tab=a8,Elements={},DependencyBoxes={}}bw.Show=function(bx)if bg.
ActiveTab then bg.ActiveTab:Hide()end bm.BackgroundTransparency=1 bn.
BackgroundTransparency=1 bo.BackgroundTransparency=1 bp.BackgroundTransparency=1
bs.TextTransparency=0 if br then br.ImageTransparency=0 end bt.Visible=false bu.
Visible=true bg.ActiveTab=bw bw:Resize()end bw.Hide=function(bx)bm.
BackgroundTransparency=0 bn.BackgroundTransparency=0 bo.BackgroundTransparency=0
bp.BackgroundTransparency=0 bs.TextTransparency=0.5 if br then br.
ImageTransparency=0.5 end bt.Visible=true bu.Visible=false bg.ActiveTab=nil end
bw.Resize=function(bx)if bg.ActiveTab~=bw then return end bc.Size=UDim2.new(1,0,
0,(bv.AbsoluteContentSize.Y/z.DPIScale)+49)end bw.UpdateCorners=function(bx)bo.
Visible=bk~=1 bp.Visible=bk~=be bn.Position=UDim2.new(0,0,1,-ar.CornerRadius)bn.
Size=UDim2.new(1,0,0,ar.CornerRadius)bo.Size=UDim2.new(0,ar.CornerRadius,1,0)bp.
Size=UDim2.new(0,ar.CornerRadius,1,0)end if not bg.ActiveTab then bw:Show()end
bm.MouseButton1Click:Connect(bw.Show)setmetatable(bw,ap)bg.Tabs[bi]=bw bg:
UpdateCorners()return bw end if ba.Name then a8.Tabboxes[ba.Name]=bg else table.
insert(a8.Tabboxes,bg)end return bg end a8.AddLeftTabbox=function(a9,ba)return
a8:AddTabbox{Side=1,Name=ba}end a8.AddRightTabbox=function(a9,ba)return a8:
AddTabbox{Side=2,Name=ba}end a8.Hover=function(a9,ba)if z.ActiveTab==a8 then
return end k:Create(aW,z.TweenInfo,{TextTransparency=ba and 0.25 or 0.5}):Play()
if aX then k:Create(aX,z.TweenInfo,{ImageTransparency=ba and 0.25 or 0.5}):Play(
)end end a8.Show=function(a9)if z.ActiveTab then z.ActiveTab:Hide()end k:Create(
aV,z.TweenInfo,{BackgroundTransparency=0}):Play()k:Create(aW,z.TweenInfo,{
TextTransparency=0}):Play()if aX then k:Create(aX,z.TweenInfo,{ImageTransparency
=0}):Play()end if aU then aP:ShowTabInfo(aS,aU)end aY.Visible=true a8:
RefreshSides()z.ActiveTab=a8 if z.Searching then z:UpdateSearch(z.SearchText)end
end a8.Hide=function(a9)k:Create(aV,z.TweenInfo,{BackgroundTransparency=1}):
Play()k:Create(aW,z.TweenInfo,{TextTransparency=0.5}):Play()if aX then k:Create(
aX,z.TweenInfo,{ImageTransparency=0.5}):Play()end aY.Visible=false aP:
HideTabInfo()z.ActiveTab=nil end a8.SetVisible=function(a9,ba)aV.Visible=ba if
not ba and z.ActiveTab==a8 then a8:Hide()end end if not z.ActiveTab then a8:
Show()end aV.MouseEnter:Connect(function()a8:Hover(true)end)aV.MouseLeave:
Connect(function()a8:Hover(false)end)aV.MouseButton1Click:Connect(a8.Show)z.Tabs
[aS]=a8 return a8 end aP.AddKeyTab=function(aR,...)local aS,aT,aU if select('#',
...)==1 and typeof(...)=='table'then local aV=select(1,...)aS=aV.Name or'Tab'aT=
aV.Icon aU=aV.Description else aS=select(1,...)or'Tab'aT=select(2,...)aU=select(
3,...)end aT=aT or'key'local aV,aW,aX,aY aT=(aT=='key'and{am}or{(z:
GetCustomIcon(aT))})[1]do aV=U('TextButton',{BackgroundColor3='MainColor',
BackgroundTransparency=1,Size=UDim2.new(1,0,0,40),Text='',Parent=aJ})local aZ=U(
'UIPadding',{PaddingBottom=UDim.new(0,ax and 6 or 11),PaddingLeft=UDim.new(0,ax
and 6 or 12),PaddingRight=UDim.new(0,ax and 6 or 12),PaddingTop=UDim.new(0,ax
and 6 or 11),Parent=aV})aW=U('TextLabel',{BackgroundTransparency=1,Position=
UDim2.fromOffset(30,0),Size=UDim2.new(1,-30,1,0),Text=aS,TextSize=16,
TextTransparency=0.5,TextXAlignment=Enum.TextXAlignment.Left,Visible=not ax,
Parent=aV})if aT then aX=U('ImageLabel',{Image=aT.Url,ImageColor3=aT.Custom and
'WhiteColor'or'AccentColor',ImageRectOffset=aT.ImageRectOffset,ImageRectSize=aT.
ImageRectSize,ImageTransparency=0.5,Size=UDim2.fromScale(1,1),SizeConstraint=ax
and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,Parent=aV})
end table.insert(z.TabButtons,{Label=aW,Padding=aZ,Icon=aX})aY=U(
'ScrollingFrame',{AutomaticCanvasSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,CanvasSize=UDim2.fromScale(0,0),ScrollBarThickness=0,
Size=UDim2.fromScale(1,1),Visible=false,Parent=aK})U('UIListLayout',{
HorizontalAlignment=Enum.HorizontalAlignment.Center,Padding=UDim.new(0,8),
VerticalAlignment=Enum.VerticalAlignment.Center,Parent=aY})U('UIPadding',{
PaddingLeft=UDim.new(0,1),PaddingRight=UDim.new(0,1),Parent=aY})end local aZ={
Elements={},Description=aU,IsKeyTab=true}aZ.AddKeyBox=function(a_,a0)assert(
typeof(a0)=='function','Callback must be a function')local a1=U('Frame',{
BackgroundTransparency=1,Size=UDim2.new(0.75,0,0,21),Parent=aY})local a2=U(
'TextBox',{BackgroundColor3='MainColor',PlaceholderText='Key',Size=UDim2.new(1,-
71,1,0),TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,Parent=a1})U(
'UIPadding',{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),Parent=a2})U(
'UIStroke',{Color='OutlineColor',Parent=a2})table.insert(z.Corners,U('UICorner',
{CornerRadius=UDim.new(0,z.CornerRadius/2),Parent=a2}))local a3=U('TextButton',{
AnchorPoint=Vector2.new(1,0),BackgroundColor3='MainColor',Position=UDim2.
fromScale(1,0),Size=UDim2.new(0,63,1,0),Text='Execute',TextSize=14,Parent=a1})U(
'UIStroke',{Color='OutlineColor',Parent=a3})table.insert(z.Corners,U('UICorner',
{CornerRadius=UDim.new(0,z.CornerRadius/2),Parent=a3}))a3.InputBegan:Connect(
function(a4)if not I(a4)then return end if not z:MouseIsOverFrame(a3,a4.Position
)then return end a0(a2.Text)end)end aZ.RefreshSides=function(a_)end aZ.Resize=
function(a_)end aZ.UpdateCorners=function(a_)end aZ.Hover=function(a_,a0)if z.
ActiveTab==aZ then return end k:Create(aW,z.TweenInfo,{TextTransparency=a0 and
0.25 or 0.5}):Play()if aX then k:Create(aX,z.TweenInfo,{ImageTransparency=a0 and
0.25 or 0.5}):Play()end end aZ.Show=function(a_)if z.ActiveTab then z.ActiveTab:
Hide()end k:Create(aV,z.TweenInfo,{BackgroundTransparency=0}):Play()k:Create(aW,
z.TweenInfo,{TextTransparency=0}):Play()if aX then k:Create(aX,z.TweenInfo,{
ImageTransparency=0}):Play()end aY.Visible=true if aU then aP:ShowTabInfo(aS,aU)
end aZ:RefreshSides()z.ActiveTab=aZ if z.Searching then z:UpdateSearch(z.
SearchText)end end aZ.Hide=function(a_)k:Create(aV,z.TweenInfo,{
BackgroundTransparency=1}):Play()k:Create(aW,z.TweenInfo,{TextTransparency=0.5})
:Play()if aX then k:Create(aX,z.TweenInfo,{ImageTransparency=0.5}):Play()end aY.
Visible=false aP:HideTabInfo()z.ActiveTab=nil end aZ.SetVisible=function(a_,a0)
aV.Visible=a0 if not a0 and z.ActiveTab==aZ then aZ:Hide()end end if not z.
ActiveTab then aZ:Show()end aV.MouseEnter:Connect(function()aZ:Hover(true)end)aV
.MouseLeave:Connect(function()aZ:Hover(false)end)aV.MouseButton1Click:Connect(aZ
.Show)aZ.Container=aY setmetatable(aZ,ap)z.Tabs[aS]=aZ return aZ end aP.
AddDialog=function(aR,aS,aT)aT=z:Validate(aT,A.Dialog)local aU,aV,aW,aX,aY={}aW=
U('TextButton',{AutoButtonColor=false,BackgroundColor3='DarkColor',
BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text='',Active=false,ZIndex=
9000,Visible=true,Parent=ay})k:Create(aW,z.TweenInfo,{BackgroundTransparency=0.5
}):Play()aV=U('TextButton',{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=
'BackgroundColor',Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(300,0)
,AutomaticSize=Enum.AutomaticSize.Y,Text='',AutoButtonColor=false,ZIndex=9001,
Parent=aW})table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,ar.
CornerRadius),Parent=aV}))z:AddOutline(aV)local aZ,a_=U('Frame',{
BackgroundTransparency=1,Size=UDim2.fromScale(1,0),AutomaticSize=Enum.
AutomaticSize.Y,ZIndex=9002,Parent=aV}),U('UIScale',{Scale=0.95,Parent=aV})k:
Create(a_,z.TweenInfo,{Scale=1}):Play()local a0,a1,a2=U('UIPadding',{
PaddingBottom=UDim.new(0,15),PaddingLeft=UDim.new(0,15),PaddingRight=UDim.new(0,
15),PaddingTop=UDim.new(0,15),Parent=aZ}),U('UIListLayout',{Padding=UDim.new(0,
10),SortOrder=Enum.SortOrder.LayoutOrder,Parent=aZ}),U('Frame',{
BackgroundTransparency=1,Size=UDim2.fromScale(1,0),AutomaticSize=Enum.
AutomaticSize.Y,LayoutOrder=1,ZIndex=9002,Parent=aZ})U('UIListLayout',{Padding=
UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,Parent=a2})U('UIPadding',{
PaddingBottom=UDim.new(0,5),Parent=a2})local a3=U('Frame',{
BackgroundTransparency=1,Size=UDim2.new(1,0,0,20),AutomaticSize=Enum.
AutomaticSize.Y,LayoutOrder=1,ZIndex=9002,Parent=a2})U('UIListLayout',{Padding=
UDim.new(0,6),FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum
.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,Parent=a3})if aT.
Icon then local a4=z:GetCustomIcon(aT.Icon)if a4 then local a5=U('ImageLabel',{
BackgroundTransparency=1,Size=UDim2.fromOffset(16,16),Image=a4.Url,ImageColor3=
'FontColor',ImageRectOffset=a4.ImageRectOffset,ImageRectSize=a4.ImageRectSize,
LayoutOrder=1,ZIndex=9002,Parent=a3})if aT.TitleColor then a5.ImageColor3=aT.
TitleColor end end end local a4=U('TextLabel',{BackgroundTransparency=1,Size=
UDim2.new(1,0,0,18),AutomaticSize=Enum.AutomaticSize.Y,Text=aT.Title,TextSize=18
,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=2,ZIndex=9002,Parent=a3})if
aT.TitleColor then a4.TextColor3=aT.TitleColor end local a5=U('TextLabel',{
BackgroundTransparency=1,Size=UDim2.new(1,0,0,14),AutomaticSize=Enum.
AutomaticSize.Y,Text=aT.Description,TextSize=14,TextTransparency=aT.
DescriptionColor and 0 or 0.2,TextXAlignment=Enum.TextXAlignment.Left,
TextWrapped=true,LayoutOrder=2,ZIndex=9002,Parent=a2})if aT.DescriptionColor
then a5.TextColor3=aT.DescriptionColor end aX=U('Frame',{BackgroundTransparency=
1,Size=UDim2.fromScale(1,0),AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=4,
ZIndex=9002,Parent=aZ})U('UIListLayout',{Padding=UDim.new(0,8),SortOrder=Enum.
SortOrder.LayoutOrder,Parent=aX})U('UIPadding',{PaddingBottom=UDim.new(0,5),
Parent=aX})local a6=U('Frame',{BackgroundColor3='OutlineColor',
BackgroundTransparency=0,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),LayoutOrder=5
,ZIndex=9002,Parent=aZ})aY=U('Frame',{BackgroundTransparency=1,Size=UDim2.new(1,
0,0,0),AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=6,ZIndex=9002,Parent=aZ})
U('UIListLayout',{Padding=UDim.new(0,8),FillDirection=Enum.FillDirection.
Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,Wraps=true,
SortOrder=Enum.SortOrder.LayoutOrder,Parent=aY})U('UIPadding',{PaddingTop=UDim.
new(0,5),Parent=aY})local a7={Elements={},Container=aX}a7.Resize=function(a8)
local a9,ba,bb,bc,bd=ay.AbsoluteSize.X*0.75,400,0,0,false for be,bf in aU do bd=
true bc=bc+1 bb=bb+bf.Container.Size.X.Offset end local be=ba if bd then local
bf=bb+((bc-1)*8)+30 be=math.max(ba,math.min(bf,a9))end aV.Size=UDim2.fromOffset(
be,0)local bf,bg=z:GetTextBounds(a5.Text,z.Scheme.Font,14,be-30)a5.Size=UDim2.
new(1,0,0,bg)local bh=false for bi,bj in aX:GetChildren()do if not bj:IsA
'UIListLayout'and not bj:IsA'UIPadding'then bh=true break end end aX.Visible=bh
aY.Visible=bd a6.Visible=bd end a7.SetTitle=function(a8,a9)a4.Text=a9 a7:Resize(
)end a7.SetDescription=function(a8,a9)a5.Text=a9 a7:Resize()end a7.Dismiss=
function(a8)z.ActiveDialog=nil local a9=k:Create(a_,z.TweenInfo,{Scale=0.95})k:
Create(aW,z.TweenInfo,{BackgroundTransparency=1}):Play()a9:Play()task.delay(z.
TweenInfo.Time,function()aW:Destroy()end)z.Dialogues[aS]=nil end aW.
MouseButton1Click:Connect(function()if aT.OutsideClickDismiss then a7:Dismiss()
end end)a7.RemoveFooterButton=function(a8,a9)if aU[a9]then aU[a9].Container:
Destroy()aU[a9]=nil end end a7.SetButtonDisabled=function(a8,a9,ba)if aU[a9]and
type(aU[a9].SetDisabled)=='function'then aU[a9]:SetDisabled(ba)end end a7.
SetButtonOrder=function(a8,a9,ba)if aU[a9]and aU[a9].Container then aU[a9].
Container.LayoutOrder=ba end end a7.AddFooterButton=function(a8,a9,ba)a7:
RemoveFooterButton(a9)local bb,bc,bd,be,bf=ba.WaitTime or 0,U('Frame',{
BackgroundTransparency=1,Size=UDim2.fromOffset(0,26),LayoutOrder=ba.Order or 0,
ZIndex=9002,Parent=aY}),'MainColor','OutlineColor',ba.Variant or'Primary'if bf==
'Primary'then bd='FontColor'be='FontColor'elseif bf=='Secondary'then bd=
'MainColor'be='OutlineColor'elseif bf=='Destructive'then bd='DestructiveColor'be
='DestructiveColor'elseif bf=='Ghost'then bd='BackgroundColor'be=
'BackgroundColor'end local bg=U('TextButton',{BackgroundColor3=bd,BorderColor3=
be,BackgroundTransparency=bb>0 and 0.5 or 0,Size=UDim2.fromOffset(0,26),Text='',
AutoButtonColor=false,ZIndex=9002,Parent=bc})z:AddOutline(bg)table.insert(z.
Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius),Parent=bg}))local
bh,bi=U('UIPadding',{PaddingLeft=UDim.new(0,15),PaddingRight=UDim.new(0,15),
Parent=bg}),z.Scheme.FontColor if bf=='Primary'then bi=z.Scheme.BackgroundColor
elseif bf=='Destructive'then bi=Color3.new(1,1,1)end local bj=U('TextLabel',{
BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text=ba.Title or a9,
TextColor3=bi,TextTransparency=bb>0 and 0.5 or 0,TextSize=14,ZIndex=9002,Parent=
bg})local bk=z:GetTextBounds(bj.Text,z.Scheme.Font,14,250)bc.Size=UDim2.
fromOffset(bk+30,26)bg.Size=UDim2.fromOffset(bk+30,26)local bl if bb>0 then bl=
U('Frame',{BackgroundColor3='AccentColor',BorderSizePixel=0,Position=UDim2.new(0
,0,1,-2),Size=UDim2.new(0,0,0,2),ZIndex=2,Parent=bg})table.insert(z.Corners,U(
'UICorner',{CornerRadius=UDim.new(0,z.CornerRadius),Parent=bl}))end local bm=bb
<=0 local bn,bo={Container=bc,SetDisabled=function(bn,bo)bm=not bo if bo then k:
Create(bg,z.TweenInfo,{BackgroundTransparency=0.5}):Play()k:Create(bj,z.
TweenInfo,{TextTransparency=0.5}):Play()else k:Create(bg,z.TweenInfo,{
BackgroundTransparency=0}):Play()k:Create(bj,z.TweenInfo,{TextTransparency=0}):
Play()end end},typeof(bd)=='Color3'and bd or z.Scheme[bd]local bp=bf=='Ghost'and
z.Scheme.MainColor or z:GetBetterColor(bo,10)bg.MouseEnter:Connect(function()if
not bm then return end k:Create(bg,z.TweenInfo,{BackgroundColor3=bp}):Play()end)
bg.MouseLeave:Connect(function()if not bm then return end k:Create(bg,z.
TweenInfo,{BackgroundColor3=bo}):Play()end)bg.MouseButton1Click:Connect(function
()if not bm then return end if ba.Callback then ba.Callback(a7)end if aT.
AutoDismiss then a7:Dismiss()end end)if bb>0 then k:Create(bl,TweenInfo.new(bb,
Enum.EasingStyle.Linear),{Size=UDim2.new(1,0,0,2)}):Play()task.delay(bb,function
()bn:SetDisabled(false)if bl then k:Create(bl,z.TweenInfo,{
BackgroundTransparency=1}):Play()end end)end aU[a9]=bn end for a8,a9 in aT.
FooterButtons do if type(a8)=='number'and a9.Id then a8=a9.Id end a7:
AddFooterButton(a8,a9)end setmetatable(a7,ap)z.Dialogues[aS]=a7 a7:Resize()z.
ActiveDialog=a7 return a7 end aP.Toggle=function(aR,aS)if z.ActiveLoading then
if aS==true then return end if not z.Toggled then return end end if typeof(aS)==
'boolean'then z.Toggled=aS else z.Toggled=not z.Toggled end ay.Visible=z.Toggled
if ar.UnlockMouseWhileOpen then Y.Modal=z.Toggled end if z.Toggled and not z.
IsMobile then local aT,aU=h.MouseIconEnabled,z.ShowCursorBinding pcall(function(
)f:UnbindFromRenderStep(aU)end)f:BindToRenderStep(aU,Enum.RenderPriority.Last.
Value,function()h.MouseIconEnabled=not z.ShowCustomCursor Z.Position=UDim2.
fromOffset(q.X,q.Y)Z.Visible=z.ShowCustomCursor if not(z.Toggled and X and X.
Parent)then h.MouseIconEnabled=aT Z.Visible=false f:UnbindFromRenderStep(aU)end
end)elseif not z.Toggled then ah.Visible=false for aT,aU in z.Options do if aU.
Type=='ColorPicker'then aU.ColorMenu:Close()aU.ContextMenu:Close()elseif aU.Type
=='Dropdown'or aU.Type=='KeyPicker'then aU.Menu:Close()end end end end z.Toggle=
function(aR,aS)return aP:Toggle(aS)end if ar.EnableSidebarResize then local aR,
aS,aT,aU,aV,aW=(ar.MinSidebarWidth+ar.SidebarCompactWidth)*ar.
SidebarCollapseThreshold,false,(U('TextButton',{AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=1,Position=UDim2.fromScale(0.5,0),Size=UDim2.new(0,8,1,0)
,Text='',Parent=az}))aT.MouseEnter:Connect(function()k:Create(az,z.TweenInfo,{
BackgroundColor3=z:GetLighterColor(z.Scheme.OutlineColor)}):Play()end)aT.
MouseLeave:Connect(function()if aS then return end k:Create(az,z.TweenInfo,{
BackgroundColor3=z.Scheme.OutlineColor}):Play()end)aT.InputBegan:Connect(
function(aX)if not I(aX)then return end z.CantDragForced=true aU=aX.Position aV=
aP:GetSidebarWidth()aS=true aW=aX.Changed:Connect(function()if aX.UserInputState
~=Enum.UserInputState.End then return end z.CantDragForced=false k:Create(az,z.
TweenInfo,{BackgroundColor3=z.Scheme.OutlineColor}):Play()aS=false if aW and aW.
Connected then aW:Disconnect()aW=nil end end)end)z:GiveSignal(h.InputChanged:
Connect(function(aX)if not z.Toggled or not(X and X.Parent)then aS=false if aW
and aW.Connected then aW:Disconnect()aW=nil end return end if aS and J(aX)then
local aY=aX.Position-aU local aZ=aV+aY.X if ar.DisableCompactingSnap then aP:
SetSidebarWidth(aZ)return end if aZ>aR then aP:SetSidebarWidth(math.max(aZ,ar.
MinSidebarWidth))else aP:SetSidebarWidth(ar.SidebarCompactWidth)end end end))end
if ar.EnableCompacting and ar.SidebarCompacted then aP:SetSidebarWidth(ar.
SidebarCompactWidth)end if ar.AutoShow and not z.ActiveLoading then task.spawn(z
.Toggle)end if z.IsMobile then local aR,aS=z:AddDraggableButton('Toggle',
function()z:Toggle()end,true),z:AddDraggableButton('Lock',function(aR)z.
CantDragForced=not z.CantDragForced aR:SetText(z.CantDragForced and'Unlock'or
'Lock')end,true)if ar.MobileButtonsSide=='Right'then aR.Button.Position=UDim2.
new(1,-6,0,6)aR.Button.AnchorPoint=Vector2.new(1,0)aS.Button.Position=UDim2.new(
1,-6,0,46)aS.Button.AnchorPoint=Vector2.new(1,0)else aS.Button.Position=UDim2.
fromOffset(6,46)end if ar.ShowMobileButtons==false then aR.Button.Visible=false
aS.Button.Visible=false end end aE:GetPropertyChangedSignal'Text':Connect(
function()z:UpdateSearch(aE.Text)end)z:GiveSignal(h.InputBegan:Connect(function(
aR)if z.Unloaded then return end if h:GetFocusedTextBox()then return end if(
typeof(z.ToggleKeybind)=='table'and z.ToggleKeybind.Type=='KeyPicker'and aR.
KeyCode.Name==z.ToggleKeybind.Value)or aR.KeyCode==z.ToggleKeybind then z.
Toggle()end end))z:GiveSignal(h.WindowFocused:Connect(function()z.
IsRobloxFocused=true end))z:GiveSignal(h.WindowFocusReleased:Connect(function()z
.IsRobloxFocused=false end))return aP end z.CreateLoading=function(aq,ar)if z.
ActiveLoading then warn
[[Loading GUI already exists, you cannot create multiple Loading GUIs.]]return z
.ActiveLoading end ar=z:Validate(ar,A.Loading)local as,at={CurrentStep=ar.
CurrentStep,TotalSteps=ar.TotalSteps,ShowSidebar=ar.ShowSidebar,AutoResizeHeight
=ar.AutoResizeHeight,IsError=false,Destroyed=false,WindowWidth=ar.WindowWidth,
WindowHeight=ar.WindowHeight,BaseWindowHeight=ar.WindowHeight,WindowErrorHeight=
ar.WindowHeight,ContentWidth=ar.ContentWidth,SidebarWidth=ar.SidebarWidth},U(
'ScreenGui',{Name='ObsidianLoading',DisplayOrder=999,ResetOnSpawn=false})W(at)as
.ScreenGui=at at.DescendantRemoving:Connect(function(au)z:RemoveFromRegistry(au)
end)local au=U('TextButton',{Name='Main',AnchorPoint=Vector2.new(0.5,0.5),
BackgroundColor3=function()return z:GetBetterColor(z.Scheme.BackgroundColor,-1)
end,Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(as.ShowSidebar and(
as.ContentWidth+as.SidebarWidth)or as.WindowWidth,as.WindowHeight),
ClipsDescendants=true,Text='',AutoButtonColor=false,Parent=at})z:AddOutline(au)
table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius),
Parent=au}))local av=U('UIScale',{Scale=z.IsMobile and 0.8 or 1,Parent=au})table
.insert(z.Scales,av)z.ScalesOffset[av]=z.IsMobile and 0.2 or 0 local aw,ax=U(
'Frame',{Name='Content',BackgroundTransparency=1,Position=UDim2.fromOffset(0,0),
Size=UDim2.new(0,as.ContentWidth,1,0),Parent=au}),U('Frame',{Name='SideBar',
BackgroundTransparency=1,Position=UDim2.fromOffset(as.ContentWidth,0),Size=UDim2
.new(0,as.ShowSidebar and as.SidebarWidth or 0,1,0),ClipsDescendants=true,
Visible=as.ShowSidebar,Parent=au})local ay=U('UICorner',{CornerRadius=UDim.new(0
,z.CornerRadius),Parent=ax})table.insert(z.Corners,ay)z:AddOutline(ax)local az,
aA=U('Frame',{BackgroundColor3='OutlineColor',BorderSizePixel=0,Position=UDim2.
fromOffset(0,0),Size=UDim2.new(0,1,1,0),Visible=as.ShowSidebar,Parent=ax}),U(
'Frame',{Name='TopBar',BackgroundTransparency=1,Size=UDim2.new(1,0,0,48),ZIndex=
2,Parent=aw})z:MakeDraggable(au,aA,true,true)local aB=U('Frame',{
BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Parent=aA})U('UIListLayout',{
FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.
HorizontalAlignment.Left,VerticalAlignment=Enum.VerticalAlignment.Center,Padding
=UDim.new(0,6),Parent=aB})U('UIPadding',{PaddingLeft=UDim.new(0,12),Parent=aB})
if ar.Icon then local aC=z:GetCustomIcon(ar.Icon)U('ImageLabel',{Image=aC.Url,
ImageRectOffset=aC.ImageRectOffset,ImageRectSize=aC.ImageRectSize,Size=ar.
IconSize,Parent=aB})else U('TextLabel',{BackgroundTransparency=1,Size=ar.
IconSize,Text=ar.Title:sub(1,1),TextScaled=true,Visible=false,Parent=aB})end
local aC=z:GetTextBounds(ar.Title,z.Scheme.Font,20,aB.AbsoluteSize.X-(ar.Icon
and(ar.IconSize.X.Offset+6)or 0)-12)U('TextLabel',{BackgroundTransparency=1,Size
=UDim2.new(0,aC,1,0),Text=ar.Title,TextSize=20,Parent=aB})z:MakeLine(aw,{
Position=UDim2.fromOffset(0,48),Size=UDim2.new(1,0,0,1)})local aD=U('Frame',{
Name='InnerContent',BackgroundTransparency=1,Position=UDim2.fromOffset(0,49),
Size=UDim2.new(1,0,1,-49),Parent=aw})U('UIListLayout',{FillDirection=Enum.
FillDirection.Vertical,HorizontalAlignment=Enum.HorizontalAlignment.Center,
VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,12),Parent=aD
})local aE,aF=U('Frame',{Name='IconHolder',BackgroundTransparency=1,Size=UDim2.
fromOffset(64,64),Parent=aD}),z:GetCustomIcon(ar.LoadingIcon)local aG,aH=(U(
'ImageLabel',{Name='LoaderIcon',AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(
1,1),Image=aF.Url,ImageRectOffset=aF.ImageRectOffset,ImageRectSize=aF.
ImageRectSize,ImageColor3=ar.LoadingIconColor or((ar.LoadingIcon==A.Loading.
LoadingIcon)and'AccentColor'or'WhiteColor'),Parent=aE}))if ar.
LoadingIconTweenTime>0 then aH=k:Create(aG,TweenInfo.new(ar.LoadingIconTweenTime
,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,-1),{Rotation=360})aH:Play()
end local aI,aJ,aK=U('TextLabel',{BackgroundTransparency=1,AutomaticSize=as.
AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,Size=as.
AutoResizeHeight and UDim2.new(1,-60,0,0)or UDim2.fromOffset(0,0),Text='',
TextSize=18,TextWrapped=as.AutoResizeHeight,Parent=aD}),U('TextLabel',{
BackgroundTransparency=1,AutomaticSize=as.AutoResizeHeight and Enum.
AutomaticSize.Y or Enum.AutomaticSize.XY,Size=as.AutoResizeHeight and UDim2.new(
1,-60,0,0)or UDim2.fromOffset(0,0),Text='',TextSize=14,TextTransparency=0.5,
TextWrapped=as.AutoResizeHeight,Parent=aD}),U('Frame',{BackgroundColor3=
'MainColor',Size=UDim2.new(0.7,0,0,15),Parent=aD})z:AddOutline(aK)table.insert(z
.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.CornerRadius/2),Parent=aK}))
local aL=U('Frame',{BackgroundColor3='AccentColor',BorderSizePixel=0,Size=UDim2.
fromScale(0,1),Parent=aK})table.insert(z.Corners,U('UICorner',{CornerRadius=UDim
.new(0,z.CornerRadius/2),Parent=aL}))local aM=U('TextLabel',{
BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text='',TextSize=14,ZIndex=2,
Parent=aK})U('UIStroke',{ApplyStrokeMode=Enum.ApplyStrokeMode.Contextual,Color=
'DarkColor',LineJoinMode=Enum.LineJoinMode.Miter,Parent=aM})local aN=U(
'ScrollingFrame',{BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.
new(0,0,0,0),Size=UDim2.fromScale(1,1),ScrollBarThickness=2,ScrollBarImageColor3
='OutlineColor',Parent=ax})local aO=U('UIListLayout',{Padding=UDim.new(0,8),
SortOrder=Enum.SortOrder.LayoutOrder,Parent=aN})U('UIPadding',{PaddingBottom=
UDim.new(0,12),PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12),PaddingTop
=UDim.new(0,12),Parent=aN})local aP={Elements={},DependencyBoxes={},Tabboxes={},
BoxHolder=aN,Container=aN,Resize=function(aP)aN.CanvasSize=UDim2.fromOffset(0,aO
.AbsoluteContentSize.Y+24)end,Tab={Elements={},DependencyBoxes={},
DependencyGroupboxes={},Tabboxes={}}}aO:GetPropertyChangedSignal
'AbsoluteContentSize':Connect(function()aP:Resize()end)setmetatable(aP,ap)as.
Sidebar=aP local aQ=U('Frame',{Name='Error',BackgroundTransparency=1,Position=
UDim2.fromOffset(0,49),Size=UDim2.new(1,0,1,-49),ClipsDescendants=true,Visible=
false,Parent=aw})local aR,aS,aT,aU=U('TextLabel',{BackgroundTransparency=1,
Position=UDim2.fromOffset(15,15),Size=UDim2.new(1,-30,0,18),Text='Error',
TextColor3='RedColor',TextSize=18,TextXAlignment=Enum.TextXAlignment.Left,Parent
=aQ}),U('TextLabel',{BackgroundTransparency=1,Position=UDim2.fromOffset(15,39),
Size=UDim2.new(1,-30,1,-90),Text='Error Message',TextSize=14,TextTransparency=
0.2,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum
.TextYAlignment.Top,Parent=aQ}),U('Frame',{BackgroundColor3='OutlineColor',
BackgroundTransparency=0,BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0),
Position=UDim2.new(0.5,0,1,-48),Size=UDim2.new(1,-30,0,1),Visible=false,Parent=
aQ}),U('Frame',{AnchorPoint=Vector2.new(0.5,1),BackgroundTransparency=1,Position
=UDim2.new(0.5,0,1,0),Size=UDim2.new(1,0,0,42),Visible=false,Parent=aQ})U(
'UIListLayout',{Padding=UDim.new(0,8),FillDirection=Enum.FillDirection.
Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=
Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,Parent=aU})U(
'UIPadding',{PaddingTop=UDim.new(0,5),PaddingBottom=UDim.new(0,15),PaddingRight=
UDim.new(0,15),Parent=aU})as.UpdateLayout=function(aV)if as.IsError then as:
RecalculateErrorHeight()end local aW=as.ShowSidebar local aX,aY=aW and(as.
ContentWidth+as.SidebarWidth)or as.WindowWidth,as.IsError and as.
WindowErrorHeight or as.WindowHeight if aW then ax.Visible=true az.Visible=true
end k:Create(au,z.TweenInfo,{Size=UDim2.fromOffset(aX,aY)}):Play()k:Create(ax,z.
TweenInfo,{Position=UDim2.fromOffset(as.ContentWidth,0),Size=UDim2.new(0,aW and
as.SidebarWidth or 0,1,0)}):Play()k:Create(aw,z.TweenInfo,{Size=UDim2.new(0,aW
and as.ContentWidth or as.WindowWidth,1,0)}):Play()if not aW then task.delay(z.
TweenInfo.Time,function()if not as.ShowSidebar then ax.Visible=false az.Visible=
false end end)end end as.RecalculateLoadingHeight=function(aV)if not as.
AutoResizeHeight then return end local aW=97+aD.UIListLayout.AbsoluteContentSize
.Y as.WindowHeight=math.max(as.BaseWindowHeight,aW)end as.SetMessage=function(aV
,aW)aI.Text=aW if as.AutoResizeHeight then as:RecalculateLoadingHeight()as:
UpdateLayout()end end as.SetDescription=function(aV,aW)aJ.Text=aW if as.
AutoResizeHeight then as:RecalculateLoadingHeight()as:UpdateLayout()end end as.
SetLoadingIcon=function(aV,aW)local aX=z:GetCustomIcon(aW)aG.Image=aX.Url aG.
ImageRectOffset=aX.ImageRectOffset aG.ImageRectSize=aX.ImageRectSize end as.
SetLoadingIconTweenTime=function(aV,aW)if aH then aH:Cancel()aH:Destroy()end if
aW>0 then aH=k:Create(aG,TweenInfo.new(aW,Enum.EasingStyle.Linear,Enum.
EasingDirection.Out,-1),{Rotation=360})aH:Play()else aG.Rotation=0 end end as.
SetLoadingIconColor=function(aV,aW)aG.ImageColor3=aW end as.SetCurrentStep=
function(aV,aW)as.CurrentStep=math.clamp(aW,0,as.TotalSteps)local aX=as.
CurrentStep/as.TotalSteps k:Create(aL,z.TweenInfo,{Size=UDim2.fromScale(aX,1)}):
Play()aM.Text=string.format('%d/%d',as.CurrentStep,as.TotalSteps)end as.
SetTotalSteps=function(aV,aW)as.TotalSteps=aW as:SetCurrentStep(as.CurrentStep)
end as.SetWindowHeight=function(aV,aW)as.WindowHeight=aW as:UpdateLayout()end as
.SetWindowWidth=function(aV,aW)as.WindowWidth=aW as:UpdateLayout()end as.
SetContentWidth=function(aV,aW)as.ContentWidth=aW as:UpdateLayout()end as.
SetSidebarWidth=function(aV,aW)as.SidebarWidth=aW as:UpdateLayout()end as.
ShowSidebarPage=function(aV,aW)as.ShowSidebar=aW as:UpdateLayout()end as.
ShowErrorPage=function(aV,aW)as.IsError=aW aD.Visible=not aW aQ.Visible=aW if as
.ShowSidebar then as:ShowSidebarPage(not aW)else as:UpdateLayout()end end as.
RecalculateErrorHeight=function(aV)local aW=(as.ShowSidebar and as.ContentWidth
or as.WindowWidth)-30 local aX,aY=z:GetTextBounds(aS.Text,z.Scheme.Font,14,aW)aS
.Size=UDim2.new(1,-30,0,aY)local aZ=aU.Visible local a_=88+aY+15+(aZ and 48 or 0
)as.WindowErrorHeight=a_ end as.SetErrorMessage=function(aV,aW)aS.Text=aW as:
UpdateLayout()end as.SetErrorButtons=function(aV,aW)assert(typeof(aW)=='table',
'Buttons must be a table')for aX,aY in aU:GetChildren()do if aY:IsA'Frame'then
aY:Destroy()end end local aX=M(aW)>0 aU.Visible=aX aT.Visible=aX for aY,aZ in aW
do local a_,a0,a1,a2=U('Frame',{BackgroundTransparency=1,Size=UDim2.fromOffset(0
,26),Parent=aU}),'MainColor','OutlineColor',aZ.Variant or'Primary'if a2==
'Primary'then a0='FontColor'a1='FontColor'elseif a2=='Secondary'then a0=
'MainColor'a1='OutlineColor'elseif a2=='Destructive'then a0='DestructiveColor'a1
='DestructiveColor'elseif a2=='Ghost'then a0='BackgroundColor'a1=
'BackgroundColor'end local a3=U('TextButton',{BackgroundColor3=a0,BorderColor3=
a1,Size=UDim2.fromOffset(0,26),Text='',AutoButtonColor=false,Parent=a_})z:
AddOutline(a3)table.insert(z.Corners,U('UICorner',{CornerRadius=UDim.new(0,z.
CornerRadius),Parent=a3}))U('UIPadding',{PaddingLeft=UDim.new(0,15),PaddingRight
=UDim.new(0,15),Parent=a3})local a4=z.Scheme.FontColor if a2=='Primary'then a4=z
.Scheme.BackgroundColor elseif a2=='Destructive'then a4=Color3.new(1,1,1)end
local a5=U('TextLabel',{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text=
aZ.Title or aY,TextColor3=a4,TextSize=14,Parent=a3})local a6=z:GetTextBounds(a5.
Text,z.Scheme.Font,14,250)a_.Size=UDim2.fromOffset(a6+30,26)a3.Size=UDim2.
fromOffset(a6+30,26)local a7=typeof(a0)=='Color3'and a0 or z.Scheme[a0]local a8=
a2=='Ghost'and z.Scheme.MainColor or z:GetBetterColor(a7,10)a3.MouseEnter:
Connect(function()k:Create(a3,z.TweenInfo,{BackgroundColor3=a8}):Play()end)a3.
MouseLeave:Connect(function()k:Create(a3,z.TweenInfo,{BackgroundColor3=a7}):
Play()end)a3.MouseButton1Click:Connect(function()if aZ.Callback then aZ.
Callback(as)end end)end as:UpdateLayout()end as.Destroy=function(aV)if aH then
aH:Cancel()end at:Destroy()as.Destroyed=true z.ActiveLoading=nil if z.Toggle and
z.Toggled==false and z.Unloaded~=true then z:Toggle(true)end end as.Continue=as.
Destroy if z.Toggle and z.Toggled and z.Unloaded~=true then z:Toggle(false)end
as:SetCurrentStep(as.CurrentStep)z.ActiveLoading=as return as end local aq,ar=
function()if z.Unloaded then return end local aq,ar=R(),R(true)for as,at in u do
if at.Type=='Dropdown'and at.SpecialType=='Player'then at:SetValues(at.
ExcludeLocalPlayer and ar or aq)end end end,function()if z.Unloaded then return
end local aq=S()for ar,as in u do if as.Type=='Dropdown'and as.SpecialType==
'Team'then as:SetValues(aq)end end end z:GiveSignal(e.PlayerAdded:Connect(aq))z:
GiveSignal(e.PlayerRemoving:Connect(aq))z:GiveSignal(j.ChildAdded:Connect(ar))z:
GiveSignal(j.ChildRemoved:Connect(ar))l().Library=z return z end end)()end,[12]=
function()a(12)return(function(...)return function(aa)local ab,ac=(cloneref or
clonereference or function(ab)return ab end),(clonefunction or copyfunction or
function(ab)return ab end)local ad,ae,af,ag=ab(game:GetService'HttpService'),
isfolder,isfile,listfiles if typeof(ac)=='function'then local ah,ai,aj=ac(ae),
ac(af),ac(ag)local ak,al=pcall(function()return ah('test'..tostring(math.random(
1000000,9999999)))end)if ak==false or typeof(al)~='boolean'then ae=function(am)
local an,ao=pcall(ah,am)return((an and{ao}or{false})[1])end af=function(am)local
an,ao=pcall(ai,am)return((an and{ao}or{false})[1])end ag=function(am)local an,ao
=pcall(aj,am)return((an and{ao}or{{}})[1])end end end local ah={}do ah.Folder=
'ObsidianLibSettings'ah.SubFolder=''ah.Ignore={}ah.Library=nil ah.
UseLoadingOrder=false ah.LoadingOrder={}ah.Parser={Toggle={Save=function(ai,aj)
return{type='Toggle',idx=ai,value=aj.Value}end,Load=function(ai,aj)local ak=ah.
Library.Toggles[ai]if ak and ak.Value~=aj.value then ak:SetValue(aj.value)end
end},Slider={Save=function(ai,aj)return{type='Slider',idx=ai,value=tostring(aj.
Value)}end,Load=function(ai,aj)local ak=ah.Library.Options[ai]if ak and ak.Value
~=aj.value then ak:SetValue(aj.value)end end},Dropdown={Save=function(ai,aj)
return{type='Dropdown',idx=ai,value=aj.Value,multi=aj.Multi}end,Load=function(ai
,aj)local ak=ah.Library.Options[ai]if ak and ak.Value~=aj.value then ak:
SetValue(aj.value)end end},ColorPicker={Save=function(ai,aj)return{type=
'ColorPicker',idx=ai,value=aj.Value:ToHex(),transparency=aj.Transparency}end,
Load=function(ai,aj)if ah.Library.Options[ai]then ah.Library.Options[ai]:
SetValueRGB(Color3.fromHex(aj.value),aj.transparency)end end},KeyPicker={Save=
function(ai,aj)return{type='KeyPicker',idx=ai,mode=aj.Mode,key=aj.Value,
modifiers=aj.Modifiers}end,Load=function(ai,aj)if ah.Library.Options[ai]then ah.
Library.Options[ai]:SetValue{aj.key,aj.mode,aj.modifiers}end end},Input={Save=
function(ai,aj)return{type='Input',idx=ai,text=aj.Value}end,Load=function(ai,aj)
local ak=ah.Library.Options[ai]if ak and ak.Value~=aj.text and type(aj.text)==
'string'then ah.Library.Options[ai]:SetValue(aj.text)end end}}ah.SetLibrary=
function(ai,aj)ai.Library=aj end ah.SetLoadingOrder=function(ai,aj,ak)ai.
UseLoadingOrder=aj if typeof(ak)=='table'then ai.LoadingOrder=ak end end ah.
IgnoreThemeSettings=function(ai)ai:SetIgnoreIndexes{'BackgroundColor',
'MainColor','AccentColor','OutlineColor','FontColor','FontFace',
'ThemeManager_ThemeList','ThemeManager_CustomThemeList',
'ThemeManager_CustomThemeName'}end ah.CheckSubFolder=function(ai,aj)if typeof(ai
.SubFolder)~='string'or ai.SubFolder==''then return false end if aj==true then
if not ae(ai.Folder..'/settings/'..ai.SubFolder)then makefolder(ai.Folder..
'/settings/'..ai.SubFolder)end end return true end ah.GetPaths=function(ai)local
aj,ak={},ai.Folder:split'/'for al=1,#ak do local am=table.concat(ak,'/',1,al)if
not table.find(aj,am)then aj[#aj+1]=am end end aj[#aj+1]=ai.Folder..'/themes'aj[
#aj+1]=ai.Folder..'/settings'if ai:CheckSubFolder(false)then local al=ai.Folder
..'/settings/'..ai.SubFolder ak=al:split'/'for am=1,#ak do local an=table.
concat(ak,'/',1,am)if not table.find(aj,an)then aj[#aj+1]=an end end end return
aj end ah.BuildFolderTree=function(ai)local aj=ai:GetPaths()for ak=1,#aj do
local al=aj[ak]if ae(al)then continue end makefolder(al)end end ah.
CheckFolderTree=function(ai)if ae(ai.Folder)then return end ah:BuildFolderTree()
task.wait(0.1)end ah.SetIgnoreIndexes=function(ai,aj)for ak,al in pairs(aj)do ai
.Ignore[al]=true end end ah.SetFolder=function(ai,aj)ai.Folder=aj ai:
BuildFolderTree()end ah.SetSubFolder=function(ai,aj)ai.SubFolder=aj ai:
BuildFolderTree()end ah.Save=function(ai,aj)if(not aj)then return false,
'no config file is selected'end ah:CheckFolderTree()local ak=ai.Folder..
'/settings/'..aj..'.json'if ah:CheckSubFolder(true)then ak=ai.Folder..
'/settings/'..ai.SubFolder..'/'..aj..'.json'end local al={objects={}}for am,an
in pairs(ai.Library.Toggles)do if not an.Type then continue end if not ai.Parser
[an.Type]then continue end if ai.Ignore[am]then continue end table.insert(al.
objects,ai.Parser[an.Type].Save(am,an))end for am,an in pairs(ai.Library.Options
)do if not an.Type then continue end if not ai.Parser[an.Type]then continue end
if ai.Ignore[am]then continue end table.insert(al.objects,ai.Parser[an.Type].
Save(am,an))end local am,an=pcall(ad.JSONEncode,ad,al)if not am then return
false,'failed to encode data'end writefile(ak,an)return true end ah.Load=
function(ai,aj)if(not aj)then return false,'no config file is selected'end ah:
CheckFolderTree()local ak=ai.Folder..'/settings/'..aj..'.json'if ah:
CheckSubFolder(true)then ak=ai.Folder..'/settings/'..ai.SubFolder..'/'..aj..
'.json'end if not af(ak)then return false,'invalid file'end local al,am=pcall(ad
.JSONDecode,ad,readfile(ak))if not al then return false,'decode error'end if ai.
UseLoadingOrder==true and typeof(ai.LoadingOrder)=='table'then table.sort(am.
objects,function(an,ao)local ap,aq=table.find(ai.LoadingOrder,an.type)or math.
huge,table.find(ai.LoadingOrder,ao.type)or math.huge return ap<aq end)end for an
,ao in am.objects do if not ao.type then continue end if not ai.Parser[ao.type]
then continue end if ai.Ignore[ao.idx]then continue end task.spawn(ai.Parser[ao.
type].Load,ao.idx,ao)end return true end ah.Delete=function(ai,aj)if(not aj)then
return false,'no config file is selected'end local ak=ai.Folder..'/settings/'..
aj..'.json'if ah:CheckSubFolder(true)then ak=ai.Folder..'/settings/'..ai.
SubFolder..'/'..aj..'.json'end if not af(ak)then return false,'invalid file'end
local al=pcall(delfile,ak)if not al then return false,'delete file error'end
return true end ah.RefreshConfigList=function(ai)local aj,ak=pcall(function()ah:
CheckFolderTree()local aj,ak={},{}if ah:CheckSubFolder(true)then aj=ag(ai.Folder
..'/settings/'..ai.SubFolder)else aj=ag(ai.Folder..'/settings')end if typeof(aj)
~='table'then aj={}end for al=1,#aj do local am=aj[al]if am:sub(-5)=='.json'then
local an=am:find('.json',1,true)local ao,ap=an,am:sub(an,an)while ap~='/'and ap
~='\\'and ap~=''do an=an-1 ap=am:sub(an,an)end if ap=='/'or ap=='\\'then table.
insert(ak,am:sub(an+1,ao-1))end end end return ak end)if(not aj)then if ai.
Library then ai.Library:Notify('Failed to load config list: '..tostring(ak))else
warn('Failed to load config list: '..tostring(ak))end return{}end return ak end
ah.GetAutoloadConfig=function(ai)ah:CheckFolderTree()local aj=ai.Folder..
'/settings/autoload.txt'if ah:CheckSubFolder(true)then aj=ai.Folder..
'/settings/'..ai.SubFolder..'/autoload.txt'end if af(aj)then local ak,al=pcall(
readfile,aj)if not ak then return'none'end al=tostring(al)return al==''and'none'
or al end return'none'end ah.LoadAutoloadConfig=function(ai)ah:CheckFolderTree()
local aj=ai.Folder..'/settings/autoload.txt'if ah:CheckSubFolder(true)then aj=ai
.Folder..'/settings/'..ai.SubFolder..'/autoload.txt'end if af(aj)then local ak,
al=pcall(readfile,aj)if not ak then ai.Library:Notify
'Failed to load autoload config: write file error'return end local am,an=ai:
Load(al)if not am then ai.Library:Notify('Failed to load autoload config: '..an)
return end ai.Library:Notify(string.format('Auto loaded config %q',al))end end
ah.SaveAutoloadConfig=function(ai,aj)ah:CheckFolderTree()local ak=ai.Folder..
'/settings/autoload.txt'if ah:CheckSubFolder(true)then ak=ai.Folder..
'/settings/'..ai.SubFolder..'/autoload.txt'end local al=pcall(writefile,ak,aj)if
not al then return false,'write file error'end return true,''end ah.
DeleteAutoLoadConfig=function(ai)ah:CheckFolderTree()local aj=ai.Folder..
'/settings/autoload.txt'if ah:CheckSubFolder(true)then aj=ai.Folder..
'/settings/'..ai.SubFolder..'/autoload.txt'end local ak=pcall(delfile,aj)if not
ak then return false,'delete file error'end return true,''end ah.
BuildConfigSection=function(ai,aj)assert(ai.Library,
'Must set SaveManager.Library')local ak=aj:AddRightGroupbox('Configuration',
'folder-cog')ak:AddInput('SaveManager_ConfigName',{Text='Config name'})ak:
AddButton{Text='Create config',Tooltip=
'creates a new config file with the name entered above',Func=function()local al=
ai.Library.Options.SaveManager_ConfigName.Value if al:gsub(' ','')==''then ai.
Library:Notify('Invalid config name (empty)',2)return end local am,an=ai:Save(al
)if not am then ai.Library:Notify('Failed to create config: '..an)return end ai.
Library:Notify(string.format('Created config %q',al))ai.Library.Options.
SaveManager_ConfigList:SetValues(ai:RefreshConfigList())ai.Library.Options.
SaveManager_ConfigList:SetValue(nil)end}ak:AddDivider{Text='config options'}ak:
AddDropdown('SaveManager_ConfigList',{Text='Config list',Values=ai:
RefreshConfigList(),AllowNull=true})ak:AddButton{Text='Load config',Tooltip=
'loads the selected config from the list',Func=function()local al=ai.Library.
Options.SaveManager_ConfigList.Value local am,an=ai:Load(al)if not am then ai.
Library:Notify('Failed to load config: '..an)return end ai.Library:Notify(string
.format('Loaded config %q',al))end}ak:AddButton{Text='Overwrite config',Tooltip=
'overwrites the selected config with current settings',Func=function()local al=
ai.Library.Options.SaveManager_ConfigList.Value local am,an=ai:Save(al)if not am
then ai.Library:Notify('Failed to overwrite config: '..an)return end ai.Library:
Notify(string.format('Overwrote config %q',al))end}ak:AddButton{Text=
'Delete config',Tooltip='permanently deletes the selected config file',Risky=
true,DoubleClick=true,Func=function()local al=ai.Library.Options.
SaveManager_ConfigList.Value local am,an=ai:Delete(al)if not am then ai.Library:
Notify('Failed to delete config: '..an)return end ai.Library:Notify(string.
format('Deleted config %q',al))ai.Library.Options.SaveManager_ConfigList:
SetValues(ai:RefreshConfigList())ai.Library.Options.SaveManager_ConfigList:
SetValue(nil)end}ak:AddButton{Text='Refresh list',Tooltip=
'refreshes the config list from disk',Func=function()ai.Library.Options.
SaveManager_ConfigList:SetValues(ai:RefreshConfigList())ai.Library.Options.
SaveManager_ConfigList:SetValue(nil)end}ak:AddButton{Text='Set as autoload',
Tooltip=[[sets the selected config to automatically load on next launch]],Func=
function()local al=ai.Library.Options.SaveManager_ConfigList.Value local am,an=
ai:SaveAutoloadConfig(al)if not am then ai.Library:Notify(
'Failed to set autoload config: '..an)return end ai.Library:Notify(string.
format('Set %q to auto load',al))ai.AutoloadConfigLabel:SetText(
'Current autoload config: '..al)end}ak:AddButton{Text='Reset autoload',Tooltip=
'clears the autoload config so nothing loads automatically',Func=function()local
al,am=ai:DeleteAutoLoadConfig()if not al then ai.Library:Notify(
'Failed to set autoload config: '..am)return end ai.Library:Notify
'Set autoload to none'ai.AutoloadConfigLabel:SetText
'Current autoload config: none'end}ai.AutoloadConfigLabel=ak:AddLabel(
'Current autoload config: '..ai:GetAutoloadConfig(),true)ai:SetIgnoreIndexes{
'SaveManager_ConfigList','SaveManager_ConfigName'}end ah:BuildFolderTree()end
return ah end end)()end,[13]=function()local aa,ab,ac=a(13)return(function(...)
return function(ad)return{Home=ac(ab.Home)(ad),Settings=ac(ab.Settings)(ad)}end
end)()end,[14]=function()a(14)return(function(...)return function(aa)local ab,ac
=aa.Services,getgenv()local ad,ae,af,ag=ab.Players,ab.RunService,ab.
TeleportService,aa:Get'Constants'local ah,ai,aj,ak,al,am,an,ao,ap,aq,ar=ag.
Characters,aa:Get'Modules/Places',aa:Get'Modules/Color',aa:Get
'Modules/TaskManager',aa:Get'Modules/Preference',aa:Get'Functions/Time',aa:Get
'Functions/Numbers',aa:Get'Functions/Strings',aa:Get'Functions/GetPing',aa:Get
'Functions/PromptDiscord',ad.LocalPlayer local as,at,au,av,aw,ax=am.now(),Color3
.fromRGB(255,170,255),Color3.fromRGB(0,170,255),ac.script_key or'abcdef',al.new(
),function()local as=os.date'*t'.hour if as>=0 and as<6 then return'Night'elseif
as>=6 and as<12 then return'Morning'elseif as>=12 and as<16 then return
'Afternoon'elseif as>=16 and as<20 then return'Evening'end return'Night'end
return function(ay,az)local aA,aB,aC,aD=aa:Get'Modules/Interface'.GetInterface
'Obsidian',ai.GetPlaceFromId(game.PlaceId),ag.LRM_Constants,ay:AddGroupbox{Side=
1,Name='Account',IconName='circle-user'}local aE=aD:AddImage('UserImage',{Image=
'http://www.roblox.com/asset/?id=131927632408540',Height=200,Outline=true,
ScaleType=Enum.ScaleType.Stretch,BackgroundTransparency=1})task.spawn(function()
local aF,aG=pcall(ad.GetUserThumbnailAsync,ad,ar.UserId,Enum.ThumbnailType.
HeadShot,Enum.ThumbnailSize.Size352x352)if aF then aE:SetImage(aG)end end)aD:
AddLabel{Text=string.format('Good %s, <b>%s</b>!',tostring(ax()),tostring(ar.
DisplayName)),DoesWrap=true}aD:AddLabel{Text=string.format(
'Welcome to <b>%s</b>!',tostring(aj.Paint('strelizia.cc',at))),DoesWrap=true}aD:
AddDivider{Text='account info'}aD:AddLabel{Text=string.format(
'%s User Id: <b>%s</b>',tostring(ah.BulletPoint),tostring(ar.UserId))}aD:
AddLabel{Text=string.format('%s Account Age: <b>%s Days</b>',tostring(ah.
BulletPoint),tostring(ar.AccountAge))}local aF=aD:AddLabel{Text=string.format(
'%s Friends Online: <b>?</b>',tostring(ah.BulletPoint))}task.spawn(function()
local aG,aH=pcall(ar.GetFriendsOnlineAsync,ar)if aG then aF:SetText(string.
format('%s Friends Online: <b>%s</b>',tostring(ah.BulletPoint),tostring(an.
Comma(#aH))))end end)local aG=ay:AddGroupbox{Side=1,Name='Session',IconName=
'server'}local aH,aI,aJ,aK=aG:AddLabel{Text=string.format(
'%s Session Time: <b>00:00:00</b>',tostring(ah.BulletPoint)),DoesWrap=true},aG:
AddLabel{Text=string.format('%s FPS: <b>?</b>',tostring(ah.BulletPoint)),
DoesWrap=true},(aG:AddLabel{Text=string.format('%s Ping: <b>? ms</b>',tostring(
ah.BulletPoint)),DoesWrap=true})do local aL,aM=0,am.now()ak.AddTask(ak.Task.new(
'FrameCounter',function(aN)aL=aL+1 local aO=am.now()if aO>=aM then aK=aL aL=0 aM
=aO+1 end end,0))end ak.AddTask(ak.Task.new('SessionGroupboxUpdater',function(aL
)aH:SetText(string.format('%s Session Time: <b>%s</b>',tostring(ah.BulletPoint),
tostring(am.FormatDuration(am.now()-as,'%h:%m:%s',true))))aI:SetText(string.
format('%s FPS: <b>%s</b>',tostring(ah.BulletPoint),tostring(aK or'N/A')))aJ:
SetText(string.format('%s Ping: <b>%s ms</b>',tostring(ah.BulletPoint),tostring(
math.floor(ap()*1000))))end,1))aG:AddDivider{Text='server info'}local aL=aG:
AddLabel{Text=string.format('%s Players Online: ? out of ?',tostring(ah.
BulletPoint)),DoesWrap=true}do local aM=function()aL:SetText(string.format(
'%s Players Online: <b>%s</b> out of <b>%s</b>',tostring(ah.BulletPoint),
tostring(#ad:GetPlayers()),tostring(ad.MaxPlayers)))end local aN,aO=ad.
PlayerAdded:Connect(aM),ad.PlayerRemoving:Connect(aM)aA.Main:OnUnload(function()
aN:Disconnect()aO:Disconnect()end)aM()end aG:AddLabel{Text=string.format(
'%s Place Version: <b>v%s</b>',tostring(ah.BulletPoint),tostring(game.
PlaceVersion)),DoesWrap=true}aG:AddDivider{Text='session sharing'}local aM=aG:
AddInput('SessionShareJobId',{Text='Server Job Id',Tooltip=
[[enter job id of the server you want to join, must be in the same game]],
Placeholder='click here',ClearTextOnFocus=true})aG:AddButton{Text='Join Server',
Tooltip='joins the server using the job id from above',DoubleClick=true,Func=
function()local aN=aM.Value or''if#aN~=36 then return aA.Main:Notify{Title=
'strelizia.cc',Description='invalid job id',Duration=2}end local aO,aP=pcall(af.
TeleportToPlaceInstance,af,game.PlaceId,aN,ar)if(not aO)then aA.Main:Notify{
Title='strelizia.cc',Description=string.format(
'failed to join server: %s; click to try again',tostring(tostring(aP))),Duration
=2}end end}aG:AddButton{Text='Copy Job Id',Tooltip=
'copies the job id from the current server to clipboard',Func=function()
setclipboard(game.JobId)aA.Main:Notify{Title='strelizia.cc',Description=
'copied job id to clipboard',Duration=2}end}if aC.Authenticated then local aN,aO
,aP=ay:AddGroupbox{Side=2,Name='Key Information',IconName='key'},(aC.SecondsLeft
==-1)or(aC.SecondsLeft==math.huge),am.now()+aC.SecondsLeft aN:AddLabel{Text=
string.format('%s Key Expiry: <b>%s</b>',tostring(ah.BulletPoint),tostring((aO
and{(aj.Paint('Never!',au))}or{(am.FormatTime(aP,'MM/DD/YYYY HH:mm'))})[1])),
DoesWrap=true}aN:AddLabel{Text=string.format('%s Total Executions: <b>%s</b>',
tostring(ah.BulletPoint),tostring(an.Comma(aC.TotalExecutions))),DoesWrap=true}
aN:AddLabel{Text=string.format('%s User Note: <b>%s</b>',tostring(ah.BulletPoint
),tostring(aC.UserNote)),DoesWrap=true}aN:AddDivider{Text='key stuff'}aN:
AddLabel{Text=string.format('%s Script Key: <b>...%s</b>',tostring(ah.
BulletPoint),tostring(string.sub(av,-5))),DoesWrap=true}aN:AddButton{Text=
'Copy Script Key',Tooltip='copies user key to clipboard',Func=function()
setclipboard(av)aA.Main:Notify{Title='strelizia.cc',Description=
'copied script key to clipboard',Duration=2}end}end local aN,aO=ay:AddGroupbox{
Side=2,Name='Credits',IconName='list'},{}for aP,aQ in(aB.Credits or{})do local
aR=ag.ProductionRoleInfo[aQ.Role]or ag.ProductionRoleInfo.generic table.insert(
aO,string.format('%s %s - <b>%s</b>',tostring(ah.BulletPoint),tostring(aQ.Name),
tostring(aj.Paint(aQ.Role,aR.Color))))end aN:AddLabel('CreditsLabel',{Text=table
.concat(aO,'\n'),DoesWrap=true})aN:AddDivider{Text='discord (pls join)'}local aP
=aN:AddButton{Text='Join Discord Server',Func=function()aq(ag.DiscordInviteCode,
true)aA.Main:Notify{Title='strelizia.cc',Description=
'successfully copied/prompted discord join code!'}end}if(not aw:Read
'PRESSED_JOIN_DISCORD')then print'mueheheh'task.spawn(function()task.wait(math.
random(5,10))local aQ=az:AddDialog('DiscordJoinDialog',{Title=
'sorry for disturbing you',Description=
[[would you please join our discord? it helps us grow and stay connected with our community. you also benefit from being able to make suggestions, bug reports and stay updated with latest features.]]
,FooterButtons={Confirm={Title='yes!',Variant='Primary',Callback=function()aw:
Write('PRESSED_JOIN_DISCORD',true)aP.Func()end},Decline={Title='no, thanks',
Variant='Secondary',WaitTime=3}}})aQ:AddToggle('DontAskDiscord',{Text=
"don't ask me again",Tooltip='okay :(',Callback=function(aR)aw:Write(
'PRESSED_JOIN_DISCORD',aR)end})end)end end end end)()end,[15]=function()a(15)
return(function(...)return function(aa)local ab=aa:Get'Modules/Places'return
function(ac)local ad,ae=aa:Get'Modules/Interface'.GetInterface'Obsidian',ab.
GetPlaceFromId(game.PlaceId)local af,ag,ah,ai=ad.Main,ad.SaveManager,ad.
ThemeManager,ac:AddGroupbox{Side=1,Name='Menu',IconName='wrench'}ai:AddButton{
Text='Clear User Key',Tooltip=
[[clears saved key from the loader allowing you to enter a new one]],Disabled=(
not isfile'strelizia/key.bin'),DoubleClick=true,Func=function()delfile
'strelizia/key.bin'af:Notify{Title='strelizia.cc',Description=
[[successfully deleted the saved key, re-execute the loader in order to enter a new one]]
,Time=2}end}ai:AddButton{Text='Erase Cache',Tooltip=
[[deletes cache files used for quality of life, only run if you experience issues]]
,DoubleClick=true,Func=function()if(not isfolder'strelizia/cache')then return
end for aj,ak in listfiles'strelizia/cache'do for al,am in listfiles(ak)do
delfile(am)end end for aj,ak in listfiles'strelizia/pref'do delfile(ak)end af:
Notify{Title='strelizia.cc',Description='successfully deleted all cached files!'
,Time=2}end}ai:AddDivider{Text='ui settings'}ai:AddToggle('KeybindMenuOpen',{
Default=af.KeybindFrame.Visible,Text='Open Keybind Menu',Tooltip=
'opens menu with keybinds',Callback=function(aj)af.KeybindFrame.Visible=aj end})
ai:AddToggle('ShowCustomCursor',{Text='Custom Cursor',Tooltip=
[[determines if roblox cursor will be replaced with a custom one]],Default=true,
Callback=function(aj)af.ShowCustomCursor=aj end})ai:AddDropdown(
'NotificationSide',{Values={'Left','Right'},Default='Right',Text=
'Notification Side',Tooltip=
'determines on which side will ui notifications pop up',Callback=function(aj)af:
SetNotifySide(aj)end})ai:AddDropdown('DPIDropdown',{Values={'50%','75%','100%',
'125%','150%','175%','200%'},Default='100%',Text='DPI Scale',Tooltip=
'determines the size of the ui',Callback=function(aj)aj=aj:gsub('%%','')local ak
=tonumber(aj)af:SetDPIScale(ak)end})ai:AddDivider{Text='misc'}ai:AddLabel
'Menu bind':AddKeyPicker('MenuKeybind',{Default='RightShift',NoUI=true,Text=
'Menu keybind'})ai:AddButton{Text='Unload',Tooltip='unloads the script',Risky=
true,DoubleClick=true,Func=function()af:Unload()end}af.ToggleKeybind=af.Options.
MenuKeybind ah:SetLibrary(af)ag:SetLibrary(af)ag:IgnoreThemeSettings()ag:
SetIgnoreIndexes{'MenuKeybind','DontAskDiscord','RememberMyChoiceProvider'}ah:
SetFolder'strelizia/ui'ag:SetFolder(string.format('strelizia/ui/configs/%s',
tostring(ae.Name)))ag:BuildConfigSection(ac)ah:ApplyToTab(ac)ag:
LoadAutoloadConfig()end end end)()end,[16]=function()a(16)return(function(...)
return function(aa)local ab,ac=(cloneref or clonereference or function(ab)return
ab end),(clonefunction or copyfunction or function(ab)return ab end)local ad,ae,
af,ag=ab(game:GetService'HttpService'),isfolder,isfile,listfiles if typeof(ac)==
'function'then local ah,ai,aj=ac(ae),ac(af),ac(ag)local ak,al=pcall(function()
return ah('test'..tostring(math.random(1000000,9999999)))end)if ak==false or
typeof(al)~='boolean'then ae=function(am)local an,ao=pcall(ah,am)return((an and{
ao}or{false})[1])end af=function(am)local an,ao=pcall(ai,am)return((an and{ao}or
{false})[1])end ag=function(am)local an,ao=pcall(aj,am)return((an and{ao}or{{}})
[1])end end end local ah={}do local ai={'FontColor','MainColor','AccentColor',
'BackgroundColor','OutlineColor'}ah.Folder='ObsidianLibSettings'ah.Library=nil
ah.AppliedToTab=false ah.BuiltInThemes={Default={1,{FontColor='ffffff',MainColor
='191919',AccentColor='7d55ff',BackgroundColor='0f0f0f',OutlineColor='282828'}},
BBot={2,{FontColor='ffffff',MainColor='1e1e1e',AccentColor='7e48a3',
BackgroundColor='232323',OutlineColor='141414'}},Fatality={3,{FontColor='ffffff'
,MainColor='1e1842',AccentColor='c50754',BackgroundColor='191335',OutlineColor=
'3c355d'}},Jester={4,{FontColor='ffffff',MainColor='242424',AccentColor='db4467'
,BackgroundColor='1c1c1c',OutlineColor='373737'}},Mint={5,{FontColor='ffffff',
MainColor='242424',AccentColor='3db488',BackgroundColor='1c1c1c',OutlineColor=
'373737'}},['Tokyo Night']={6,{FontColor='ffffff',MainColor='191925',AccentColor
='6759b3',BackgroundColor='16161f',OutlineColor='323232'}},Ubuntu={7,{FontColor=
'ffffff',MainColor='3e3e3e',AccentColor='e2581e',BackgroundColor='323232',
OutlineColor='191919'}},Quartz={8,{FontColor='ffffff',MainColor='232330',
AccentColor='426e87',BackgroundColor='1d1b26',OutlineColor='27232f'}},Nord={9,{
FontColor='eceff4',MainColor='3b4252',AccentColor='88c0d0',BackgroundColor=
'2e3440',OutlineColor='4c566a'}},Dracula={10,{FontColor='f8f8f2',MainColor=
'44475a',AccentColor='ff79c6',BackgroundColor='282a36',OutlineColor='6272a4'}},
Monokai={11,{FontColor='f8f8f2',MainColor='272822',AccentColor='f92672',
BackgroundColor='1e1f1c',OutlineColor='49483e'}},Gruvbox={12,{FontColor='ebdbb2'
,MainColor='3c3836',AccentColor='fb4934',BackgroundColor='282828',OutlineColor=
'504945'}},Solarized={13,{FontColor='839496',MainColor='073642',AccentColor=
'cb4b16',BackgroundColor='002b36',OutlineColor='586e75'}},Catppuccin={14,{
FontColor='d9e0ee',MainColor='302d41',AccentColor='f5c2e7',BackgroundColor=
'1e1e2e',OutlineColor='575268'}},['One Dark']={15,{FontColor='abb2bf',MainColor=
'282c34',AccentColor='c678dd',BackgroundColor='21252b',OutlineColor='5c6370'}},
Cyberpunk={16,{FontColor='f9f9f9',MainColor='262335',AccentColor='00ff9f',
BackgroundColor='1a1a2e',OutlineColor='413c5e'}},['Oceanic Next']={17,{FontColor
='d8dee9',MainColor='1b2b34',AccentColor='6699cc',BackgroundColor='16232a',
OutlineColor='343d46'}},Material={18,{FontColor='eeffff',MainColor='212121',
AccentColor='82aaff',BackgroundColor='151515',OutlineColor='424242'}}}ah.
SetLibrary=function(aj,ak)aj.Library=ak end ah.GetPaths=function(aj)local ak,al=
{},aj.Folder:split'/'for am=1,#al do ak[#ak+1]=table.concat(al,'/',1,am)end ak[#
ak+1]=aj.Folder..'/themes'return ak end ah.BuildFolderTree=function(aj)local ak=
aj:GetPaths()for al=1,#ak do local am=ak[al]if ae(am)then continue end
makefolder(am)end end ah.CheckFolderTree=function(aj)if ae(aj.Folder)then return
end aj:BuildFolderTree()task.wait(0.1)end ah.SetFolder=function(aj,ak)aj.Folder=
ak aj:BuildFolderTree()end ah.ApplyTheme=function(aj,ak)local al=aj:
GetCustomTheme(ak)local am=al or aj.BuiltInThemes[ak]if not am then return end
local an=am[2]for ao,ap in pairs(al or an)do if ao=='VideoLink'then continue
elseif ao=='FontFace'then aj.Library:SetFont(Enum.Font[ap])if aj.Library.Options
[ao]then aj.Library.Options[ao]:SetValue(ap)end else aj.Library.Scheme[ao]=
Color3.fromHex(ap)if aj.Library.Options[ao]then aj.Library.Options[ao]:
SetValueRGB(Color3.fromHex(ap))end end end aj:ThemeUpdate()end ah.ThemeUpdate=
function(aj)for ak,al in ai do if aj.Library.Options and aj.Library.Options[al]
then aj.Library.Scheme[al]=aj.Library.Options[al].Value end end aj.Library:
UpdateColorsUsingRegistry()end ah.GetCustomTheme=function(aj,ak)local al=aj.
Folder..'/themes/'..ak..'.json'if not af(al)then return nil end local am=
readfile(al)local an,ao=pcall(ad.JSONDecode,ad,am)if not an then return nil end
return ao end ah.LoadDefault=function(aj)local ak,al,am='Default',af(aj.Folder..
'/themes/default.txt')and readfile(aj.Folder..'/themes/default.txt'),true if al
then if aj.BuiltInThemes[al]then ak=al elseif aj:GetCustomTheme(al)then ak=al am
=false end elseif aj.BuiltInThemes[aj.DefaultTheme]then ak=aj.DefaultTheme end
if am then aj.Library.Options.ThemeManager_ThemeList:SetValue(ak)else aj:
ApplyTheme(ak)end end ah.SaveDefault=function(aj,ak)writefile(aj.Folder..
'/themes/default.txt',ak)end ah.SetDefaultTheme=function(aj,ak)assert(aj.Library
,'Must set ThemeManager.Library first!')assert(not aj.AppliedToTab,
[[Cannot set default theme after applying ThemeManager to a tab!]])local al,am={
},{}for an,ao in ai do if typeof(ak[ao])=='Color3'then al[ao]='#'..ak[ao]:ToHex(
)am[ao]=ak[ao]elseif typeof(ak[ao])=='string'then al[ao]=(ak[ao]:sub(1,1)=='#'
and{(ak[ao])}or{('#'..ak[ao])})[1]am[ao]=Color3.fromHex(ak[ao])else al[ao]=ah.
BuiltInThemes.Default[2][ao]am[ao]=Color3.fromHex(ah.BuiltInThemes.Default[2][ao
])end end if typeof(ak.FontFace)=='EnumItem'then al.FontFace=ak.FontFace.Name am
.Font=Font.fromEnum(ak.FontFace)elseif typeof(ak.FontFace)=='string'then al.
FontFace=ak.FontFace am.Font=Font.fromEnum(Enum.Font[ak.FontFace])else al.
FontFace='Code'am.Font=Font.fromEnum(Enum.Font.Code)end for an,ao in{'RedColor',
'DarkColor','WhiteColor'}do am[ao]=aj.Library.Scheme[ao]end aj.Library.Scheme=am
aj.BuiltInThemes.Default={1,al}aj.Library:UpdateColorsUsingRegistry()end ah.
SaveCustomTheme=function(aj,ak)if ak:gsub(' ','')==''then aj.Library:Notify(
'Invalid file name for theme (empty)',3)return end local al={}for am,an in ai do
al[an]=aj.Library.Options[an].Value:ToHex()end al.FontFace=aj.Library.Options.
FontFace.Value writefile(aj.Folder..'/themes/'..ak..'.json',ad:JSONEncode(al))
end ah.Delete=function(aj,ak)if not ak then return false,
'no config file is selected'end local al=aj.Folder..'/themes/'..ak..'.json'if
not af(al)then return false,'invalid file'end local am=pcall(delfile,al)if not
am then return false,'delete file error'end return true end ah.
ReloadCustomThemes=function(aj)local ak,al=ag(aj.Folder..'/themes'),{}for am=1,#
ak do local an=ak[am]if an:sub(-5)=='.json'then local ao=an:find('.json',1,true)
local ap,aq=ao,an:sub(ao,ao)while aq~='/'and aq~='\\'and aq~=''do ao=ao-1 aq=an:
sub(ao,ao)end if aq=='/'or aq=='\\'then table.insert(al,an:sub(ao+1,ap-1))end
end end return al end ah.CreateThemeManager=function(aj,ak)ak:AddLabel
'Background color':AddColorPicker('BackgroundColor',{Default=aj.Library.Scheme.
BackgroundColor})ak:AddLabel'Main color':AddColorPicker('MainColor',{Default=aj.
Library.Scheme.MainColor})ak:AddLabel'Accent color':AddColorPicker('AccentColor'
,{Default=aj.Library.Scheme.AccentColor})ak:AddLabel'Outline color':
AddColorPicker('OutlineColor',{Default=aj.Library.Scheme.OutlineColor})ak:
AddLabel'Font color':AddColorPicker('FontColor',{Default=aj.Library.Scheme.
FontColor})ak:AddDropdown('FontFace',{Text='Font Face',Default='Code',Values={
'BuilderSans','Code','Fantasy','Gotham','Jura','Roboto','RobotoMono',
'SourceSans'}})local al={}for am,an in pairs(aj.BuiltInThemes)do table.insert(al
,am)end table.sort(al,function(am,an)return aj.BuiltInThemes[am][1]<aj.
BuiltInThemes[an][1]end)ak:AddDivider{Text='built-in themes'}ak:AddDropdown(
'ThemeManager_ThemeList',{Text='Theme list',Values=al,Default=1})ak:AddButton{
Text='Set as default',Tooltip=
'sets the selected built-in theme as the default on load',Func=function()aj:
SaveDefault(aj.Library.Options.ThemeManager_ThemeList.Value)aj.Library:Notify(
string.format('Set default theme to %q',aj.Library.Options.
ThemeManager_ThemeList.Value))end}aj.Library.Options.ThemeManager_ThemeList:
OnChanged(function()aj:ApplyTheme(aj.Library.Options.ThemeManager_ThemeList.
Value)end)ak:AddDivider{Text='custom themes'}ak:AddInput(
'ThemeManager_CustomThemeName',{Text='Custom theme name'})ak:AddButton{Text=
'Create theme',Tooltip=
[[creates a new custom theme from current colors using the name entered above]],
Func=function()local am=aj.Library.Options.ThemeManager_CustomThemeName.Value if
am:gsub(' ','')==''then aj.Library:Notify('Invalid theme name (empty)',2)return
end aj:SaveCustomTheme(am)aj.Library:Notify(string.format('Created theme %q',am)
)aj.Library.Options.ThemeManager_CustomThemeList:SetValues(aj:
ReloadCustomThemes())aj.Library.Options.ThemeManager_CustomThemeList:SetValue(
nil)end}ak:AddDivider{Text='custom theme options'}ak:AddDropdown(
'ThemeManager_CustomThemeList',{Text='Custom themes',Values=aj:
ReloadCustomThemes(),AllowNull=true,Default=1})ak:AddButton{Text='Load theme',
Tooltip='loads the selected custom theme and applies it',Func=function()local am
=aj.Library.Options.ThemeManager_CustomThemeList.Value aj:ApplyTheme(am)aj.
Library:Notify(string.format('Loaded theme %q',am))end}ak:AddButton{Text=
'Overwrite theme',Tooltip=
'overwrites the selected custom theme with current colors',Func=function()local
am=aj.Library.Options.ThemeManager_CustomThemeList.Value aj:SaveCustomTheme(am)
aj.Library:Notify(string.format('Overwrote theme %q',am))end}ak:AddButton{Text=
'Delete theme',Tooltip='permanently deletes the selected custom theme file',
Risky=true,DoubleClick=true,Func=function()local am=aj.Library.Options.
ThemeManager_CustomThemeList.Value local an,ao=aj:Delete(am)if not an then aj.
Library:Notify('Failed to delete theme: '..ao)return end aj.Library:Notify(
string.format('Deleted theme %q',am))aj.Library.Options.
ThemeManager_CustomThemeList:SetValues(aj:ReloadCustomThemes())aj.Library.
Options.ThemeManager_CustomThemeList:SetValue(nil)end}ak:AddButton{Text=
'Refresh list',Tooltip='refreshes the custom theme list from disk',Func=function
()aj.Library.Options.ThemeManager_CustomThemeList:SetValues(aj:
ReloadCustomThemes())aj.Library.Options.ThemeManager_CustomThemeList:SetValue(
nil)end}ak:AddButton{Text='Set as default',Tooltip=
'sets the selected custom theme as the default on load',Func=function()if aj.
Library.Options.ThemeManager_CustomThemeList.Value~=nil and aj.Library.Options.
ThemeManager_CustomThemeList.Value~=''then aj:SaveDefault(aj.Library.Options.
ThemeManager_CustomThemeList.Value)aj.Library:Notify(string.format(
'Set default theme to %q',aj.Library.Options.ThemeManager_CustomThemeList.Value)
)end end}ak:AddButton{Text='Reset default',Tooltip=
[[clears the saved default theme so nothing is applied on load]],Func=function()
local am=pcall(delfile,aj.Folder..'/themes/default.txt')if not am then aj.
Library:Notify'Failed to reset default: delete file error'return end aj.Library:
Notify'Set default theme to nothing'aj.Library.Options.
ThemeManager_CustomThemeList:SetValues(aj:ReloadCustomThemes())aj.Library.
Options.ThemeManager_CustomThemeList:SetValue(nil)end}aj:LoadDefault()aj.
AppliedToTab=true local am=function()aj:ThemeUpdate()end aj.Library.Options.
BackgroundColor:OnChanged(am)aj.Library.Options.MainColor:OnChanged(am)aj.
Library.Options.AccentColor:OnChanged(am)aj.Library.Options.OutlineColor:
OnChanged(am)aj.Library.Options.FontColor:OnChanged(am)aj.Library.Options.
FontFace:OnChanged(function(an)aj.Library:SetFont(Enum.Font[an])aj.Library:
UpdateColorsUsingRegistry()end)end ah.CreateGroupBox=function(aj,ak)assert(aj.
Library,'Must set ThemeManager.Library first!')return ak:AddLeftGroupbox(
'Themes','paintbrush')end ah.ApplyToTab=function(aj,ak)assert(aj.Library,
'Must set ThemeManager.Library first!')local al=aj:CreateGroupBox(ak)aj:
CreateThemeManager(al)end ah.ApplyToGroupbox=function(aj,ak)assert(aj.Library,
'Must set ThemeManager.Library first!')aj:CreateThemeManager(ak)end ah:
BuildFolderTree()end getgenv().ObsidianThemeManager=ah return ah end end)()end,[
17]=function()local aa,ab,ac=a(17)return(function(...)return function(ad)local
ae={List={}}ae.RecommendedExecutors={{Name='Volt',Paid=true,Price='$20 monthly',
Note='dev tested'},{Name='Potassium',Paid=true,Price='20$ lifetime',Note=
'dev tested'},{Name='Velocity',Paid=false},{Name='Delta',Paid=false,Note=
'emulator only'}}for af,ag in ab:GetChildren()do table.insert(ae.List,ac(ag)(ad)
)end ae.GetPlaceFromId=function(af)for ag,ah in ae.List do if not ah.Ids[
tostring(af)]then continue end return ah end return nil end ae.
IsExecutorBlacklisted=function(af)local ag=(identifyexecutor or getexecutorname)
if not ag then return true end local ah=ag()if not ah then return true end for
ai,aj in af or{}do if ah:find(aj,1,true)~=nil then return true end end return
false end return ae end end)()end,[18]=function()a(18)return(function(...)return
function(aa)local ab,ac,ad,ae=aa:Get'Modules/Color',Color3.new(0,1,0),Color3.
new(1,0,0),Color3.new(0,0,1)return{Name='Slime RNG',Ids={['92416421522960']=true
},Keyless=false,Downtime={Status=false,Message='Placeholder'},
BlacklistedExecutors={'Solara','Xeno'},Credits={{Name='vma',Role='developer'},{
Name='felik',Role='contributor'}},Script='d0595bedc8bfc40178f522fe49b5285f',
Update={Time=1780179066,Log={ab.Paint('[+] Added auto use special dices',ac),ab.
Paint('[+] Added auto craft slimes',ac),ab.Paint(
'[+] Added auto find crafting recipe',ac),ab.Paint('[+] Added auto follow UFO',
ac),ab.Paint('[+] Added auto apply power fruits',ac),ab.Paint(
'[+] Added auto upgrade power fruits',ac),ab.Paint(
'[+] Added auto extract power fruits',ac),ab.Paint('[+] Added auto claim codes',
ac),ab.Paint('[+] Added auto equip best pets',ac),ab.Paint(
'[+] Added goop gun target priority',ac),ab.Paint(
'[+] Added manual enemy farming zone',ac),ab.Paint('[+] Added FPS cap',ac),ab.
Paint('[+] Added disable rendering',ac),ab.Paint(
'[+] Added rejoin on disconnect',ac),ab.Paint('[+] Added execute on teleport',ac
),ab.Paint('[+] Added auto load config on teleport',ac),'\n',ab.Paint(
[[[*] Decoupled enemy farming (auto teleport to zone, auto goop gun)]],ae),ab.
Paint('[*] Mitigated unexpected auto equip behavior',ae),ab.Paint(
'[*] Mitigated unexpected XP transfer behavior',ae)}}}end end)()end,[19]=
function()a(19)return(function(...)return function(aa)local ab,ac,ad,ae=aa:Get
'Modules/Color',Color3.new(0,1,0),Color3.new(1,0,0),Color3.new(0,0,1)return{Name
='Kick a Lucky Block',Ids={['89469502395769']=true},Keyless=false,Downtime={
Status=false,Message='Placeholder'},BlacklistedExecutors={'Solara','Xeno'},
Credits={{Name='felix',Role='developer'}},Script=
'dbf4452a0cf919c7bad6aef8117e789f',Update={Time=1763296128,Log={ab.Paint(
'[+] Released',ac)}}}end end)()end,[20]=function()a(20)return(function(...)
return function(aa)local ab=aa.Services local ac,ad,ae,af=ab.HttpService,aa:Get
'Modules/t','strelizia/pref','generic'local ag,ah,ai=ad.union(ad.string,ad.
number,ad.table,ad.boolean,ad['nil']),ad.optional(ad.string),{}ai.__index=ai ai.
new=function(aj)aj=aj or af return setmetatable({Path=string.format('%s/%s.json'
,tostring(ae),tostring(aj))},ai)end ai.Read=function(aj,ak)assert(ah(ak))local
al=(ak and{nil}or{{}})[1]if(not isfile(aj.Path))then return al end local am,an=
pcall(ac.JSONDecode,ac,readfile(aj.Path))if(not am)then aj:Erase()return al end
return(ak and{(an[ak])}or{an})[1]end ai.Write=function(aj,ak,al)assert(ad.
string(ak))assert(ag(al))local am=aj:Read()am[ak]=al local an,ao=pcall(ac.
JSONEncode,ac,am)if an then writefile(aj.Path,ao)end return aj end ai.Update=
function(aj,ak,al)assert(ad.string(ak))assert(ad['function'](al))return aj:
Write(ak,al(aj:Read(ak)))end ai.Erase=function(aj)writefile(aj.Path,'{}')return
aj end return ai end end)()end,[21]=function()local aa,ab=a(21)return(function(
...)return function(ac)return ac.new(ac):Extend(ac.Extensions.Children(ab))end
end)()end,[22]=function()a(22)return(function(...)return function(aa)local ab={}
ab.IsDict=function(ac)return ac[1]==nil end ab.Dictionary=function(ac)local ad={
}for ae,af in ac do ad[af]=true end return ad end ab.Filter=function(ac,ad)local
ae,af={},ab.IsDict(ac)for ag,ah in ac do local ai=ad(ah,ag)if(not ai)then
continue end if af then ae[ag]=ah else table.insert(ae,ah)end end return ae end
ab.Reconcile=function(ac,ad)for ae,af in ad do local ag,ah=ac[ae],typeof(af)if
ag==nil or typeof(ag)~=ah then ac[ae]=af elseif ah=='table'then ab.Reconcile(ag,
af)end end return ac end ab.FullMap=function(ac,ad)local ae,af={},ab.IsDict(ac)
for ag,ah in ac do local ai,aj=ad(ah,ag)if not(ai)then continue end if af then
ae[aj]=ai else table.insert(ae,ai)end end return ae end ab.JoinArrays=function(
...)local ac={}for ad=1,select('#',...)do for ae,af in select(ad,...)do ac[#ac+1
]=af end end return ac end return ab end end)()end,[23]=function()a(23)return(
function(...)return function(aa)local ab local ac=function(ac,...)local ad=ab ab
=nil ac(...)ab=ad end local ad,ae=function()while true do ac(coroutine.yield())
end end,{}ae.__index=ae ae.new=function(af,ag)return setmetatable({_connected=
true,_signal=af,_fn=ag,_next=false},ae)end ae.Disconnect=function(af)af.
_connected=false if af._signal._handlerListHead==af then af._signal.
_handlerListHead=af._next else local ag=af._signal._handlerListHead while ag and
ag._next~=af do ag=ag._next end if ag then ag._next=af._next end end end
setmetatable(ae,{__index=function(af,ag)error((
'Attempt to get Connection::%s (not a valid member)'):format(tostring(ag)),2)end
,__newindex=function(af,ag,ah)error((
'Attempt to set Connection::%s (not a valid member)'):format(tostring(ag)),2)end
})local af={}af.__index=af af.new=function()return setmetatable({
_handlerListHead=false},af)end af.Connect=function(ag,ah)local ai=ae.new(ag,ah)
if ag._handlerListHead then ai._next=ag._handlerListHead ag._handlerListHead=ai
else ag._handlerListHead=ai end return ai end af.DisconnectAll=function(ag)ag.
_handlerListHead=false end af.Fire=function(ag,...)local ah=ag._handlerListHead
while ah do if ah._connected then if not ab then ab=coroutine.create(ad)
coroutine.resume(ab)end task.spawn(ab,ah._fn,...)end ah=ah._next end end af.Wait
=function(ag)local ah,ai=(coroutine.running())ai=ag:Connect(function(...)ai:
Disconnect()task.spawn(ah,...)end)return coroutine.yield()end af.Once=function(
ag,ah)local ai ai=ag:Connect(function(...)if ai._connected then ai:Disconnect()
end ah(...)end)return ai end setmetatable(af,{__index=function(ag,ah)error((
'Attempt to get Signal::%s (not a valid member)'):format(tostring(ah)),2)end,
__newindex=function(ag,ah,ai)error((
'Attempt to set Signal::%s (not a valid member)'):format(tostring(ah)),2)end})
return af end end)()end,[24]=function()a(24)return(function(...)return function(
aa)local ab,ac,ad,ae,af,ag,ah='Non-promise value passed into %s at index %s',
'Please pass a list of promises to %s','Please pass a handler function to %s!',{
__mode='k'},function(ab)if type(ab)=='function'then return true end if type(ab)
=='table'then local ac=getmetatable(ab)if ac and type(rawget(ac,'__call'))==
'function'then return true end end return false end,function(ab,ac)local ad={}
for ae,af in ipairs(ac)do ad[af]=af end return setmetatable(ad,{__index=function
(ae,af)error(string.format('%s is not in %s!',af,ab),2)end,__newindex=function()
error(string.format('Creating new members in %s is not allowed!',ab),2)end})end
do ah={Kind=ag('Promise.Error.Kind',{'ExecutionError','AlreadyCancelled',
'NotResolvedInTime','TimedOut'})}ah.__index=ah ah.new=function(ai,aj)ai=ai or{}
return setmetatable({error=tostring(ai.error)or'[This error has no error text.]'
,trace=ai.trace,context=ai.context,kind=ai.kind,parent=aj,createdTick=os.clock()
,createdTrace=debug.traceback()},ah)end ah.is=function(ai)if type(ai)=='table'
then local aj=getmetatable(ai)if type(aj)=='table'then return rawget(ai,'error')
~=nil and type(rawget(aj,'extend'))=='function'end end return false end ah.
isKind=function(ai,aj)assert(aj~=nil,
'Argument #2 to Promise.Error.isKind must not be nil')return ah.is(ai)and ai.
kind==aj end ah.extend=function(ai,aj)aj=aj or{}aj.kind=aj.kind or ai.kind
return ah.new(aj,ai)end ah.getErrorChain=function(ai)local aj={ai}while aj[#aj].
parent do table.insert(aj,aj[#aj].parent)end return aj end ah.__tostring=
function(ai)local aj={string.format('-- Promise.Error(%s) --',ai.kind or'?')}for
ak,al in ipairs(ai:getErrorChain())do table.insert(aj,table.concat({al.trace or
al.error,al.context},'\n'))end return table.concat(aj,'\n')end end local ai,aj,
ak=function(...)return select('#',...),{...}end,function(ai,...)return ai,
select('#',...),{...}end,function(ai)assert(ai~=nil,'traceback is nil')return
function(aj)if type(aj)=='table'then return aj end return ah.new{error=aj,kind=
ah.Kind.ExecutionError,trace=debug.traceback(tostring(aj),2),context=
'Promise created at:\n\n'..ai}end end local al=function(al,am,...)return aj(
xpcall(am,ak(al),...))end local am,an,ao=function(am,an,ao,ap)return function(
...)local aq,ar,as=al(am,an,...)if aq then ao(unpack(as,1,ar))else ap(as[1])end
end end,function(am)return next(am)==nil end,{Error=ah,Status=ag(
'Promise.Status',{'Started','Resolved','Rejected','Cancelled'}),_getTime=os.
clock,_timeEvent=game:GetService'RunService'.Heartbeat,
_unhandledRejectionCallbacks={}}ao.prototype={}ao.__index=ao.prototype ao._new=
function(ap,aq,ar)if ar~=nil and not ao.is(ar)then error(
'Argument #2 to Promise.new must be a promise or nil',2)end local as={_thread=
nil,_source=ap,_status=ao.Status.Started,_values=nil,_valuesLength=-1,
_unhandledRejection=true,_queuedResolve={},_queuedReject={},_queuedFinally={},
_cancellationHook=nil,_parent=ar,_consumers=setmetatable({},ae)}if ar and ar.
_status==ao.Status.Started then ar._consumers[as]=true end setmetatable(as,ao)
local at,au,av=function(...)as:_resolve(...)end,function(...)as:_reject(...)end,
function(at)if at then if as._status==ao.Status.Cancelled then at()else as.
_cancellationHook=at end end return as._status==ao.Status.Cancelled end as.
_thread=coroutine.create(function()local aw,ax,ay=al(as._source,aq,at,au,av)if
not aw then au(ay[1])end end)task.spawn(as._thread)return as end ao.new=function
(ap)return ao._new(debug.traceback(nil,2),ap)end ao.__tostring=function(ap)
return string.format('Promise(%s)',ap._status)end ao.defer=function(ap)local aq,
ar=(debug.traceback(nil,2))ar=ao._new(aq,function(as,at,au)local av av=ao.
_timeEvent:Connect(function()av:Disconnect()local aw,ax,ay=al(aq,ap,as,at,au)if
not aw then at(ay[1])end end)end)return ar end ao.async=ao.defer ao.resolve=
function(...)local ap,aq=ai(...)return ao._new(debug.traceback(nil,2),function(
ar)ar(unpack(aq,1,ap))end)end ao.reject=function(...)local ap,aq=ai(...)return
ao._new(debug.traceback(nil,2),function(ar,as)as(unpack(aq,1,ap))end)end ao._try
=function(ap,aq,...)local ar,as=ai(...)return ao._new(ap,function(at)at(aq(
unpack(as,1,ar)))end)end ao.try=function(ap,...)return ao._try(debug.traceback(
nil,2),ap,...)end ao._all=function(ap,aq,ar)if type(aq)~='table'then error(
string.format(ac,'Promise.all'),3)end for as,at in pairs(aq)do if not ao.is(at)
then error(string.format(ab,'Promise.all',tostring(as)),3)end end if#aq==0 or ar
==0 then return ao.resolve{}end return ao._new(ap,function(as,at,au)local av,aw,
ax,ay,az={},{},0,0,false local aA=function()for aA,aB in ipairs(aw)do aB:cancel(
)end end local aB=function(aB,...)if az then return end ax=ax+1 if ar==nil then
av[aB]=...else av[ax]=...end if ax>=(ar or#aq)then az=true as(av)aA()end end au(
aA)for aC,aD in ipairs(aq)do aw[aC]=aD:andThen(function(...)aB(aC,...)end,
function(...)ay=ay+1 if ar==nil or#aq-ay<ar then aA()az=true at(...)end end)end
if az then aA()end end)end ao.all=function(ap)return ao._all(debug.traceback(nil
,2),ap)end ao.fold=function(ap,aq,ar)assert(type(ap)=='table',
'Bad argument #1 to Promise.fold: must be a table')assert(af(aq),
'Bad argument #2 to Promise.fold: must be a function')local as=ao.resolve(ar)
return ao.each(ap,function(at,au)as=as:andThen(function(av)return aq(av,at,au)
end)end):andThen(function()return as end)end ao.some=function(ap,aq)assert(type(
aq)=='number','Bad argument #2 to Promise.some: must be a number')return ao.
_all(debug.traceback(nil,2),ap,aq)end ao.any=function(ap)return ao._all(debug.
traceback(nil,2),ap,1):andThen(function(aq)return aq[1]end)end ao.allSettled=
function(ap)if type(ap)~='table'then error(string.format(ac,'Promise.allSettled'
),2)end for aq,ar in pairs(ap)do if not ao.is(ar)then error(string.format(ab,
'Promise.allSettled',tostring(aq)),2)end end if#ap==0 then return ao.resolve{}
end return ao._new(debug.traceback(nil,2),function(aq,ar,as)local at,au,av={},{}
,0 local aw=function(aw,...)av=av+1 at[aw]=...if av>=#ap then aq(at)end end as(
function()for ax,ay in ipairs(au)do ay:cancel()end end)for ax,ay in ipairs(ap)do
au[ax]=ay:finally(function(...)aw(ax,...)end)end end)end ao.race=function(ap)
assert(type(ap)=='table',string.format(ac,'Promise.race'))for aq,ar in pairs(ap)
do assert(ao.is(ar),string.format(ab,'Promise.race',tostring(aq)))end return ao.
_new(debug.traceback(nil,2),function(aq,ar,as)local at,au={},false local av=
function()for av,aw in ipairs(at)do aw:cancel()end end local aw=function(aw)
return function(...)av()au=true return aw(...)end end if as(aw(ar))then return
end for ax,ay in ipairs(ap)do at[ax]=ay:andThen(aw(aq),aw(ar))end if au then av(
)end end)end ao.each=function(ap,aq)assert(type(ap)=='table',string.format(ac,
'Promise.each'))assert(af(aq),string.format(ad,'Promise.each'))return ao._new(
debug.traceback(nil,2),function(ar,as,at)local au,av,aw={},{},false local ax=
function()for ax,ay in ipairs(av)do ay:cancel()end end at(function()aw=true ax()
end)local ay={}for az,aA in ipairs(ap)do if ao.is(aA)then if aA:getStatus()==ao.
Status.Cancelled then ax()return as(ah.new{error='Promise is cancelled',kind=ah.
Kind.AlreadyCancelled,context=string.format(
[[The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.

That Promise was created at:

%s]]
,az,aA._source)})elseif aA:getStatus()==ao.Status.Rejected then ax()return as(
select(2,aA:await()))end local aB=aA:andThen(function(...)return...end)table.
insert(av,aB)ay[az]=aB else ay[az]=aA end end for az,aA in ipairs(ay)do if ao.
is(aA)then local aB aB,aA=aA:await()if not aB then ax()return as(aA)end end if
aw then return end local aB=ao.resolve(aq(aA,az))table.insert(av,aB)local aC,aD=
aB:await()if not aC then ax()return as(aD)end au[az]=aD end ar(au)end)end ao.is=
function(ap)if type(ap)~='table'then return false end local aq=getmetatable(ap)
if aq==ao then return true elseif aq==nil then return af(ap.andThen)elseif type(
aq)=='table'and type(rawget(aq,'__index'))=='table'and af(rawget(rawget(aq,
'__index'),'andThen'))then return true end return false end ao.promisify=
function(ap)return function(...)return ao._try(debug.traceback(nil,2),ap,...)end
end do local ap,aq ao.delay=function(ar)assert(type(ar)=='number',
'Bad argument #1 to Promise.delay, must be a number.')if not(ar>=
1.6666666666666665E-2)or ar==math.huge then ar=1.6666666666666665E-2 end return
ao._new(debug.traceback(nil,2),function(as,at,au)local av=ao._getTime()local aw=
av+ar local ax={resolve=as,startTime=av,endTime=aw}if aq==nil then ap=ax aq=ao.
_timeEvent:Connect(function()local ay=ao._getTime()while ap~=nil and ap.endTime<
ay do local az=ap ap=az.next if ap==nil then aq:Disconnect()aq=nil else ap.
previous=nil end az.resolve(ao._getTime()-az.startTime)end end)else if ap.
endTime<aw then local ay=ap local az=ay.next while az~=nil and az.endTime<aw do
ay=az az=ay.next end ay.next=ax ax.previous=ay if az~=nil then ax.next=az az.
previous=ax end else ax.next=ap ap.previous=ax ap=ax end end au(function()local
ay=ax.next if ap==ax then if ay==nil then aq:Disconnect()aq=nil else ay.previous
=nil end ap=ay else local az=ax.previous az.next=ay if ay~=nil then ay.previous=
az end end end)end)end end ao.prototype.timeout=function(ap,aq,ar)local as=debug
.traceback(nil,2)return ao.race{ao.delay(aq):andThen(function()return ao.reject(
ar==nil and ah.new{kind=ah.Kind.TimedOut,error='Timed out',context=string.
format('Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s',aq,as)}or
ar)end),ap}end ao.prototype.getStatus=function(ap)return ap._status end ao.
prototype._andThen=function(ap,aq,ar,as)ap._unhandledRejection=false if ap.
_status==ao.Status.Cancelled then local at=ao.new(function()end)at:cancel()
return at end return ao._new(aq,function(at,au,av)local aw=at if ar then aw=am(
aq,ar,at,au)end local ax=au if as then ax=am(aq,as,at,au)end if ap._status==ao.
Status.Started then table.insert(ap._queuedResolve,aw)table.insert(ap.
_queuedReject,ax)av(function()if ap._status==ao.Status.Started then table.
remove(ap._queuedResolve,table.find(ap._queuedResolve,aw))table.remove(ap.
_queuedReject,table.find(ap._queuedReject,ax))end end)elseif ap._status==ao.
Status.Resolved then aw(unpack(ap._values,1,ap._valuesLength))elseif ap._status
==ao.Status.Rejected then ax(unpack(ap._values,1,ap._valuesLength))end end,ap)
end ao.prototype.andThen=function(ap,aq,ar)assert(aq==nil or af(aq),string.
format(ad,'Promise:andThen'))assert(ar==nil or af(ar),string.format(ad,
'Promise:andThen'))return ap:_andThen(debug.traceback(nil,2),aq,ar)end ao.
prototype.catch=function(ap,aq)assert(aq==nil or af(aq),string.format(ad,
'Promise:catch'))return ap:_andThen(debug.traceback(nil,2),nil,aq)end ao.
prototype.tap=function(ap,aq)assert(af(aq),string.format(ad,'Promise:tap'))
return ap:_andThen(debug.traceback(nil,2),function(...)local ar=aq(...)if ao.is(
ar)then local as,at=ai(...)return ar:andThen(function()return unpack(at,1,as)end
)end return...end)end ao.prototype.andThenCall=function(ap,aq,...)assert(af(aq),
string.format(ad,'Promise:andThenCall'))local ar,as=ai(...)return ap:_andThen(
debug.traceback(nil,2),function()return aq(unpack(as,1,ar))end)end ao.prototype.
andThenReturn=function(ap,...)local aq,ar=ai(...)return ap:_andThen(debug.
traceback(nil,2),function()return unpack(ar,1,aq)end)end ao.prototype.cancel=
function(ap)if ap._status~=ao.Status.Started then return end ap._status=ao.
Status.Cancelled if ap._cancellationHook then ap._cancellationHook()end
coroutine.close(ap._thread)if ap._parent then ap._parent:_consumerCancelled(ap)
end for aq in pairs(ap._consumers)do aq:cancel()end ap:_finalize()end ao.
prototype._consumerCancelled=function(ap,aq)if ap._status~=ao.Status.Started
then return end ap._consumers[aq]=nil if next(ap._consumers)==nil then ap:
cancel()end end ao.prototype._finally=function(ap,aq,ar)ap._unhandledRejection=
false local as=ao._new(aq,function(as,at,au)local av au(function()ap:
_consumerCancelled(ap)if av then av:cancel()end end)local aw=as if ar then aw=
function(...)local ax=ar(...)if ao.is(ax)then av=ax ax:finally(function(ay)if ay
~=ao.Status.Rejected then as(ap)end end):catch(function(...)at(...)end)else as(
ap)end end end if ap._status==ao.Status.Started then table.insert(ap.
_queuedFinally,aw)else aw(ap._status)end end)return as end ao.prototype.finally=
function(ap,aq)assert(aq==nil or af(aq),string.format(ad,'Promise:finally'))
return ap:_finally(debug.traceback(nil,2),aq)end ao.prototype.finallyCall=
function(ap,aq,...)assert(af(aq),string.format(ad,'Promise:finallyCall'))local
ar,as=ai(...)return ap:_finally(debug.traceback(nil,2),function()return aq(
unpack(as,1,ar))end)end ao.prototype.finallyReturn=function(ap,...)local aq,ar=
ai(...)return ap:_finally(debug.traceback(nil,2),function()return unpack(ar,1,aq
)end)end ao.prototype.awaitStatus=function(ap)ap._unhandledRejection=false if ap
._status==ao.Status.Started then local aq=coroutine.running()ap:finally(function
()task.spawn(aq)end):catch(function()end)coroutine.yield()end if ap._status==ao.
Status.Resolved then return ap._status,unpack(ap._values,1,ap._valuesLength)
elseif ap._status==ao.Status.Rejected then return ap._status,unpack(ap._values,1
,ap._valuesLength)end return ap._status end local ap=function(ap,...)return ap==
ao.Status.Resolved,...end ao.prototype.await=function(aq)return ap(aq:
awaitStatus())end local aq=function(aq,...)if aq~=ao.Status.Resolved then error(
(...)==nil and'Expected Promise rejected with no value.'or(...),3)end return...
end ao.prototype.expect=function(ar)return aq(ar:awaitStatus())end ao.prototype.
awaitValue=ao.prototype.expect ao.prototype._unwrap=function(ar)if ar._status==
ao.Status.Started then error('Promise has not resolved or rejected.',2)end local
as=ar._status==ao.Status.Resolved return as,unpack(ar._values,1,ar._valuesLength
)end ao.prototype._resolve=function(ar,...)if ar._status~=ao.Status.Started then
if ao.is((...))then(...):_consumerCancelled(ar)end return end if ao.is((...))
then if select('#',...)>1 then local as=string.format(
[[When returning a Promise from andThen, extra arguments are discarded! See:

%s]]
,ar._source)warn(as)end local as=...local at=as:andThen(function(...)ar:
_resolve(...)end,function(...)local at=as._values[1]if as._error then at=ah.new{
error=as._error,kind=ah.Kind.ExecutionError,context=
[=[[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]]=]
}end if ah.isKind(at,ah.Kind.ExecutionError)then return ar:_reject(at:extend{
error='This Promise was chained to a Promise that errored.',trace='',context=
string.format(
[[The Promise at:

%s
...Rejected because it was chained to the following Promise, which encountered an error:
]]
,ar._source)})end ar:_reject(...)end)if at._status==ao.Status.Cancelled then ar:
cancel()elseif at._status==ao.Status.Started then ar._parent=at at._consumers[ar
]=true end return end ar._status=ao.Status.Resolved ar._valuesLength,ar._values=
ai(...)for as,at in ipairs(ar._queuedResolve)do coroutine.wrap(at)(...)end ar:
_finalize()end ao.prototype._reject=function(ar,...)if ar._status~=ao.Status.
Started then return end ar._status=ao.Status.Rejected ar._valuesLength,ar.
_values=ai(...)if not an(ar._queuedReject)then for as,at in ipairs(ar.
_queuedReject)do coroutine.wrap(at)(...)end else local as=tostring((...))
coroutine.wrap(function()ao._timeEvent:Wait()if not ar._unhandledRejection then
return end local at=string.format('Unhandled Promise rejection:\n\n%s\n\n%s',as,
ar._source)for au,av in ipairs(ao._unhandledRejectionCallbacks)do task.spawn(av,
ar,unpack(ar._values,1,ar._valuesLength))end if ao.TEST then return end warn(at)
end)()end ar:_finalize()end ao.prototype._finalize=function(ar)for as,at in
ipairs(ar._queuedFinally)do coroutine.wrap(at)(ar._status)end ar._queuedFinally=
nil ar._queuedReject=nil ar._queuedResolve=nil if not ao.TEST then ar._parent=
nil ar._consumers=nil end task.defer(coroutine.close,ar._thread)end ao.prototype
.now=function(ar,as)local at=debug.traceback(nil,2)if ar._status==ao.Status.
Resolved then return ar:_andThen(at,function(...)return...end)else return ao.
reject(as==nil and ah.new{kind=ah.Kind.NotResolvedInTime,error=
'This Promise was not resolved in time for :now()',context=
':now() was called at:\n\n'..at}or as)end end ao.retry=function(ar,as,...)
assert(af(ar),'Parameter #1 to Promise.retry must be a function')assert(type(as)
=='number','Parameter #2 to Promise.retry must be a number')local at,au={...},
select('#',...)return ao.resolve(ar(...)):catch(function(...)if as>0 then return
ao.retry(ar,as-1,unpack(at,1,au))else return ao.reject(...)end end)end ao.
retryWithDelay=function(ar,as,at,...)assert(af(ar),
'Parameter #1 to Promise.retry must be a function')assert(type(as)=='number',
'Parameter #2 (times) to Promise.retry must be a number')assert(type(at)==
'number','Parameter #3 (seconds) to Promise.retry must be a number')local au,av=
{...},select('#',...)return ao.resolve(ar(...)):catch(function(...)if as>0 then
ao.delay(at):await()return ao.retryWithDelay(ar,as-1,at,unpack(au,1,av))else
return ao.reject(...)end end)end ao.fromEvent=function(ar,as)as=as or function()
return true end return ao._new(debug.traceback(nil,2),function(at,au,av)local aw
,ax=false local ay=function()ax:Disconnect()ax=nil end ax=ar:Connect(function(
...)local az=as(...)if az==true then at(...)if ax then ay()else aw=true end
elseif type(az)~='boolean'then error
'Promise.fromEvent predicate should always return a boolean'end end)if aw and ax
then return ay()end av(ay)end)end ao.onUnhandledRejection=function(ar)table.
insert(ao._unhandledRejectionCallbacks,ar)return function()local as=table.find(
ao._unhandledRejectionCallbacks,ar)if as then table.remove(ao.
_unhandledRejectionCallbacks,as)end end end return ao end end)()end,[25]=
function()a(25)return(function(...)return function(aa)local ab={}ab.Paths=
setmetatable({},{__mode='k'})local ac,ad,ae,af,ag={Delimiter='/'},game.
WaitForChild,game.FindFirstChild,function(ac,ad)local ae=ab.Paths[ac]if not ae
then return nil end local af=ae[ad]return((af~=nil and af.Parent==ac)and{af}or{
nil})[1]end,function(ac,ad,ae)local af=ab.Paths[ac]if not af then ab.Paths[ac]={
}af=ab.Paths[ac]end af[ad]=ae end local ah=function(ah,ai,aj)local ak=af(ai,ah)
if ak then return ak end local al,am=string.split(ah,ac.Delimiter),ai for an,ao
in al do am=ae(am,ao)or(aj and ad(am,ao,aj))or nil if not am then return nil end
end ag(ai,ah,am)return am end ac.Find=function(ai,aj)return ah(aj,ai)end ac.
Await=function(ai,aj,ak)return ah(aj,ai,ak)end return ac end end)()end,[26]=
function()a(26)return(function(...)local aa=game:GetService'RunService'local ab,
ac,ad=newproxy(),newproxy(),table.freeze{'Destroy','Disconnect','destroy',
'disconnect'}local ae,af,ag,ah=function(ae,af)local ag=typeof(ae)if ag==
'function'then return ab elseif ag=='thread'then return ac end if af then return
af end if ag=='Instance'then return'Destroy'elseif ag=='RBXScriptConnection'then
return'Disconnect'elseif ag=='table'then for ah,ai in ad do if typeof(ae[ai])==
'function'then return ai end end end error(string.format(
'failed to get cleanup function for object %s: %s',tostring(ag),tostring(ae)),3)
end,function(ae)if typeof(ae)~='table'or typeof(ae.getStatus)~='function'or
typeof(ae.finally)~='function'or typeof(ae.cancel)~='function'then error(
'did not receive a promise as an argument',3)end end,function(ae)if typeof(ae)~=
'RBXScriptSignal'and(typeof(ae)~='table'or typeof(ae.Connect)~='function'or
typeof(ae.Once)~='function')then error('did not receive a signal as an argument'
,3)end end,{}ah.__index=ah ah.new=function()local ai=setmetatable({},ah)ai.
_objects={}ai._cleaning=false return(ai)end ah.Add=function(ai,aj,ak)if ai.
_cleaning then error('cannot call trove:Add() while cleaning',2)end local al=ae(
aj,ak)table.insert(ai._objects,{aj,al})return aj end ah.Clone=function(ai,aj)if
ai._cleaning then error('cannot call trove:Clone() while cleaning',2)end return
ai:Add(aj:Clone())end ah.Construct=function(ai,aj,...)if ai._cleaning then
error('Cannot call trove:Construct() while cleaning',2)end local ak,al=(type(aj)
)if ak=='table'then al=(aj).new(...)elseif ak=='function'then al=(aj)(...)end
return ai:Add(al)end ah.Connect=function(ai,aj,ak)if ai._cleaning then error(
'Cannot call trove:Connect() while cleaning',2)end ag(aj)local al=aj return ai:
Add(al:Connect(ak))end ah.Once=function(ai,aj,ak)if ai._cleaning then error(
'Cannot call trove:Connect() while cleaning',2)end ag(aj)local al,am=aj am=al:
Once(function(...)ak(...)ai:Pop(am)end)return ai:Add(am)end ah.BindToRenderStep=
function(ai,aj,ak,al)if ai._cleaning then error(
'cannot call trove:BindToRenderStep() while cleaning',2)end aa:BindToRenderStep(
aj,ak,al)ai:Add(function()aa:UnbindFromRenderStep(aj)end)end ah.AddPromise=
function(ai,aj)if ai._cleaning then error(
'cannot call trove:AddPromise() while cleaning',2)end af(aj)local ak=aj if ak:
getStatus()=='Started'then ak:finally(function()if ai._cleaning then return end
ai:_findAndRemoveFromObjects(ak,false)end)ai:Add(ak,'cancel')end return ak end
ah.Remove=function(ai,aj)if ai._cleaning then error(
'cannot call trove:Remove() while cleaning',2)end return ai:
_findAndRemoveFromObjects(aj,true)end ah.Pop=function(ai,aj)if ai._cleaning then
error('cannot call trove:Pop() while cleaning',2)end return ai:
_findAndRemoveFromObjects(aj,false)end ah.Extend=function(ai)if ai._cleaning
then error('cannot call trove:Extend() while cleaning',2)end return ai:
Construct(ah)end ah.Clean=function(ai)if ai._cleaning then return end ai.
_cleaning=true for aj,ak in ai._objects do ai:_cleanupObject(ak[1],ak[2])end
table.clear(ai._objects)ai._cleaning=false end ah.WrapClean=function(ai)return
function()ai:Clean()end end ah._findAndRemoveFromObjects=function(ai,aj,ak)local
al=ai._objects for am,an in al do if an[1]==aj then local ao=#al al[am]=al[ao]al
[ao]=nil if ak then ai:_cleanupObject(an[1],an[2])end return true end end return
false end ah._cleanupObject=function(ai,aj,ak)if ak==ab then task.spawn(aj)
elseif ak==ac then pcall(task.cancel,aj)else aj[ak](aj)end end ah.
AttachToInstance=function(ai,aj)if ai._cleaning then error(
'cannot call trove:AttachToInstance() while cleaning',2)elseif not aj:
IsDescendantOf(game)then error(
'instance is not a descendant of the game hierarchy',2)end return ai:Connect(aj.
Destroying,function()ai:Destroy()end)end ah.Destroy=function(ai)ai:Clean()end
return{new=ah.new}end)()end,[27]=function()local aa,ab=a(27)return(function(...)
return function(ac)return ac.new(ac):Extend(ac.Extensions.Children(ab))end end)(
)end,[28]=function()a(28)return(function(...)return function(aa)local ab=aa.
Services local ac=ab.HttpService return function()return(ac:GenerateGUID(false):
gsub('-','')):lower()end end end)()end,[29]=function()a(29)return(function(...)
return function(aa)local ab=aa.Services local ac,ad,ae,af=ab.Workspace,aa:Get
'Modules/t',aa:Get'RBXUtil/TableUtil',aa:Get'Functions/Numbers'local ag,ah,ai,aj
=ad.numberMin(0),ad.tuple(ad.numberMin(0),ad.string),math.floor,{}aj.Constants={
Second=1,Minute=60,Hour=3600,Day=86400,Month=2592000,Year=31536000}local ak={}
for al,am in pairs(aj.Constants)do table.insert(ak,{Name=al,Value=am})end table.
sort(ak,function(al,am)return al.Value>am.Value end)aj.now=function()return ac:
GetServerTimeNow()end aj.FormatTime=function(al,am)assert(ah(al,am))return
DateTime.fromUnixTimestamp(al):FormatLocalTime(am,'en-us')end aj.FormatDuration=
function(al,am,an)assert(ah(al,am))local ao,ap,aq,ar,as=ai(al/86400),ai(al%86400
/3600),ai(al%3600/60),ai(al%60),an and'%02d'or'%d'return(am:gsub('%%d',string.
format(as,ao)):gsub('%%h',string.format(as,ap)):gsub('%%m',string.format(as,aq))
:gsub('%%s',string.format(as,ar)))end aj.CompressTime=function(al)assert(ag(al))
al=ai(al)for am,an in ak do local ao,ap=an.Name,an.Value local aq=ai(al/ap)if aq
==0 then continue end return string.format('%s %s',tostring(af.Comma(aq)),
tostring(ao..(aq>1 and's'or'')))end return'0 Seconds'end return aj end end)()end
,[30]=function()a(30)return(function(...)return function(aa)local ab=aa:Get
'Modules/t'local ac,ad=ab.tuple(ab.number,ab.numberConstrained(0,8)),{}ad.Comma=
function(ae)assert(ab.integer(ae))local af=tostring(ae)local ag,ah,ai=af:match
'^([^%d]*%d)(%d*)(.-)$'return ag..ah:reverse():gsub('(%d%d%d)','%1,'):reverse()
..ai end ad.DecimalRound=function(ae,af)assert(ac(ae,af))if ae%1==0 then return
ae end return string.format(string.format('%%.%sf',tostring(af)),ae)end return
ad end end)()end,[31]=function()a(31)return(function(...)return function(aa)
local ab=aa:Get'Modules/t'local ac,ad,ae=ab.tuple(ab.string,ab.numberMin(0),ab.
optional(ab.string)),string.rep,{}ae.Truncate=function(af,ag,ah)assert(ac(af,ag,
ah))return af:sub(1,ag)..(ah or'')end ae.LeadingSpace=function(af)assert(ab.
numberPositive(af))return ad(' ',af)end return ae end end)()end,[32]=function()
a(32)return(function(...)return function(aa)local ab,ac=(request or(http and
http.request)or httprequest),aa.Services local ad=ac.HttpService return function
(ae,af)if af then setclipboard('https://www.discord.gg/'..ae)end if(not ab)then
return false end ab{Url='http://127.0.0.1:6463/rpc?v=1',Method='POST',Headers={[
'Content-Type']='application/json',Origin='https://discord.com'},Body=ad:
JSONEncode{cmd='INVITE_BROWSER',args={code=ae},nonce=ad:GenerateGUID(false)}}
return true end end end)()end,[33]=function()a(33)return(function(...)return
function(aa)local ab={Info='\u{1f535}',Warn='\u{1f7e0}',Success='\u{1f7e2}',
Error='\u{1f534}'}local ac=function(ac,ad)local ae=os.date'*t'string.format(
'%s:%s:%s',ae.hour,ae.min,ae.sec)print(string.format('%s | [Library]: %s',ab[ac]
,ad))end return ac end end)()end,[34]=function()a(34)return(function(...)return
function(aa)local ab=aa.Services.Stats local ac=ab.Network.ServerStatsItem[
'Data Ping']return function()return ac:GetValue()/1000 end end end)()end,[35]=
function()a(35)return(function(...)return function(aa)local ab=aa:Get'Modules/t'
local ac,ad=ab.tuple(ab.string,ab['function'],ab['function']),{List={}}ad.Add=
function(ae,af,ag)assert(ac(ae,af,ag))if ad.List[ae]then ad.Release(ae)end local
ah=hookfunction(af,newcclosure(ag))ad.List[ae]={af,ah}return ah end ad.Release=
function(ae)assert(ab.string(ae))local af=ad.List[ae]if(not af)then return false
end hookfunction(af[1],af[2])ad.List[ae]=nil return true end ad.Cleanup=function
()for ae in ad.List do ad.Release(ae)end end return ad end end)()end,[36]=
function()a(36)return(function(...)return function(aa)local ab=aa.Services local
ac,ad,ae=ab.VirtualUser,ab.Players,ab.Workspace local af,ag,ah,ai=ad.LocalPlayer
,Random.new(),Vector2.zero,{Connection=nil}ai.IsEnabled=function()return ai.
Connection~=nil end ai.Enable=function()if ai.IsEnabled()then return true end ai
.Connection=af.Idled:Connect(function(aj)local ak=ae.CurrentCamera ac:
Button2Down(ah,ak.CFrame)task.wait(ag:NextNumber(0,1))ac:Button2Up(ah,ak.CFrame)
end)return true end ai.Disable=function()if(not ai.IsEnabled())then return true
end ai.Connection:Disconnect()ai.Connection=nil return true end return ai end
end)()end,[37]=function()a(37)return(function(...)return function(aa)local ab={}
ab.Find=function(ac,ad,ae)local af,ag=1,#ac while af<=ag do local ah=math.floor(
(af+ag)/2)local ai=(ae and{(ae(ac[ah]))}or{(ac[ah])})[1]if ai==ad then return ah
,ac[ah]elseif ai<ad then af=ah+1 else ag=ah-1 end end return nil end ab.Nearest=
function(ac,ad,ae)local af,ag,ah,ai=1,#ac,(math.huge)while af<=ag do local aj=
math.floor((af+ag)/2)local ak=(ae and{(ae(ac[aj]))}or{(ac[aj])})[1]local al=math
.abs(ak-ad)if al<ah then ai=aj ah=al end if ak==ad then break elseif ak<ad then
af=aj+1 else ag=aj-1 end end if ai then return ai,ac[ai]end return nil end
return ab end end)()end,[38]=function()a(38)return(function(...)return function(
aa)local ab=aa.Services local ac,ad,ae=ab.Players,ab.Workspace,ab.RunService
local af,ag=(ac.LocalPlayer)local ah,ai=function(ah)local ai=af.Character if(not
ai)then return end for aj,ak in ai:QueryDescendants'BasePart'do ak.CanCollide=ah
end end,{}ai.Noclip=function()if ag then return end ag=ae.Stepped:Connect(
function()ah(false)end)end ai.Clip=function()if ag then ag:Disconnect()ag=nil
end ah(true)end return ai end end)()end,[39]=function()a(39)return(function(...)
return function(aa)local ab,ac,ad,ae=aa:Get'RBXUtil/TableUtil',aa:Get
'Functions/Time',aa:Get'Modules/t',utf8.char local af=ac.Constants local ag={
DiscordInviteCode='mkPHtrSyWy',Characters={Invisible=10240,BulletPoint=8226},
Emojis={Unknown='<:letter_x:1305284794044776622>',Person=
'<:person:1305298114265219094>'},LRM_Constants={Premium=LRM_IsUserPremium or
false,DiscordUserId=LRM_LinkedDiscordID or 0,ScriptName=LRM_ScriptName or
'generic',TotalExecutions=LRM_TotalExecutions or 1337,SecondsLeft=
LRM_SecondsLeft or 60,UserNote=LRM_UserNote or'user note',ScriptVersion=
LRM_ScriptVersion or'0001'},KeySystemAdProviders={{Name='Linkvertise',KeyLength=
af.Hour*24,CompletionTime=af.Minute*3,Identifier='Linkvertise-EsllfgSWtQqg'},{
Name='Another Provider',KeyLength=af.Hour*12,CompletionTime=af.Minute*2,
Identifier='Something-ABCD'}},ProductionRoleInfo={developer={Color=Color3.
fromRGB(2,116,255)},contributor={Color=Color3.fromRGB(255,255,127)},generic={
Color=Color3.new(1,1,1)}}}for ah,ai in ag.Characters do if typeof(ai)~='number'
then continue end ag.Characters[ah]=ae(ai)end setmetatable(ag.Emojis,{__index=
function(ah,ai)local aj=rawget(ah,'Unknown')rawset(ah,ai,aj)return aj end})
return ag end end)()end,[40]=function()local aa,ab,ac=a(40)return(function(...)
local ad={}ad.__index=ad ad.Extensions={Children=function(ae)local af={}for ag,
ah in ae:GetChildren()do af[ah.Name]=ah end return af end}local ae=cloneref or
function(ae)return ae end ad.Services=setmetatable({},{__index=function(af,ag)
local ah,ai=pcall(game.GetService,game,ag)if ah and ai then ai=ae(ai)rawset(af,
ag,ai)return ai end return nil end})ad.new=function(af)local ag=setmetatable({
__vinca=true,Loaded={},Loading={},Container={}},ad)ag.Root=af or ag return ag
end ad.is=function(af)return af and typeof(af)=='table'and rawget(af,'__vinca')
end ad.Add=function(af,ag,ah)assert(not af.Container[ag],'Index already exists')
af.Container[ag]=ah return af end ad.Load=function(af,ag)if af.Loaded[ag]~=nil
then return af.Loaded[ag]end local ah=af.Container[ag]assert(ah~=nil,string.
format('Unknown dependency "%s"',tostring(ag)))assert(not af.Loading[ag],string.
format('Circular dependency at "%s"',tostring(ag)))af.Loading[ag]=true if
typeof(ah)=='table'and ah.ClassName=='ModuleScript'then ah=ac(ah)elseif typeof(
ah)=='Instance'and ah.ClassName=='ModuleScript'then ah=ac(ah)end if typeof(ah)==
'function'then ah=ah(af.Root)end af.Loading[ag]=nil af.Loaded[ag]=ah return ah
end ad.Extend=function(af,ag)for ah,ai in ag do af:Add(ah,ai)end return af end
ad.Get=function(af,ag)local ah=af for ai in string.gmatch(ag,'[^/]+')do if ad.
is(ah)then ah=ah:Load(ai)else ah=ah[ai]end assert(ah~=nil,string.format(
'Invalid path "%s" at "%s"',tostring(ag),tostring(ai)))end return ah end return
ad end)()end},{{1,2,{'Shared'},{{39,2,{'Constants'}},{2,2,{'Modules'},{{8,2,{
'Interface'},{{9,1,{'List'},{{10,1,{'Obsidian'},{{11,2,{'Main'}},{16,2,{
'ThemeManager'}},{12,2,{'SaveManager'}},{13,2,{'Tabs'},{{15,2,{'Settings'}},{14,
2,{'Home'}}}}}}}}}},{7,2,{'t'}},{6,2,{'Color'}},{20,2,{'Preference'}},{3,2,{
'TaskManager'},{{4,2,{'Task'}},{5,2,{'Lock'}}}},{17,2,{'Places'},{{19,2,{
'Kick a Lucky Block'}},{18,2,{'Slime RNG'}}}}}},{40,2,{'Vinca'}},{21,2,{
'RBXUtil'},{{24,2,{'Promise'}},{22,2,{'TableUtil'}},{23,2,{'Signal'}},{25,2,{
'Tree'}},{26,2,{'Trove'}}}},{27,2,{'Functions'},{{33,2,{'OutputMessage'}},{30,2,
{'Numbers'}},{37,2,{'BinarySearch'}},{36,2,{'AntiAFK'}},{29,2,{'Time'}},{38,2,{
'Noclip'}},{32,2,{'PromptDiscord'}},{35,2,{'Hooks'}},{28,2,{'CreateGUID'}},{31,2
,{'Strings'}},{34,2,{'GetPing'}}}}}}},'0.4.2','strelizia.cc',string,task,
setmetatable,error,next,table,unpack,coroutine,script,type,require,pcall,
tostring,tonumber,_VERSION local au,av,aw,ax,ay,az,aA=aj.insert,aj.remove,aj.
freeze or function(au)return au end,al.wrap,ae.sub,ae.match,ae.gmatch if as and
ay(as,1,4)=='Lune'then local aB,aC=ap(ao,'@lune/task')if aB and aC then af=aC
end end local aB=af and af.defer local aC,aD,aE,aF,aG,aH,aI,aJ,aK=aB or function
(aC,...)ax(aC)(...)end,{[1]='Folder',[2]='ModuleScript',[3]='Script',[4]=
'LocalScript',[5]='StringValue'},{},{},{},{},{},{},{}local aL,aM={GetFullName={{
},function(aL)local aM,aN=aL.Name,aL.Parent while aN do aM=aN.Name..'.'..aM aN=
aN.Parent end return aM end},GetChildren={{},function(aL)local aM={}for aN in ai
,aK[aL]do au(aM,aN)end return aM end},GetDescendants={{},function(aL)local aM={}
for aN in ai,aK[aL]do au(aM,aN)for aO,aP in ai,aN:GetDescendants()do au(aM,aP)
end end return aM end},FindFirstChild={{'string','boolean?'},function(aL,aM,aN)
local aO=aK[aL]for aP in ai,aO do if aP.Name==aM then return aP end end if aN
then for aP in ai,aO do return aP:FindFirstChild(aM,true)end end end},
FindFirstAncestor={{'string'},function(aL,aM)local aN=aL.Parent while aN do if
aN.Name==aM then return aN end aN=aN.Parent end end},WaitForChild={{'string',
'number?'},function(aL,aM)return aL:FindFirstChild(aM)end}},{}for aN,aO in ai,aL
do local aP,aQ,aR=aO[1],aO[2],{}for aS,aT in ai,aP do local aU,aV=az(aT,
'^([^%?]+)(%??)')aR[aS]={aU,aV}end aM[aN]=function(aS,...)if not aK[aS]then ah(
"Expected ':' not '.' calling member function "..aN,2)end local aT={...}for aU,
aV in ai,aR do local aW=aT[aU]local aX,aY,aZ=an(aW),aV[1],aV[2]if aW==nil and
not aZ then ah('Argument '..aW..' missing or nil',3)end if aY~='any'and aX~=aY
and not(aX=='nil'and aZ)then ah('Argument '..aU..' expects type "'..aY..
'", got "'..aX..'"',2)end end return aQ(aS,...)end end local aN=function(aN,aO,
aP)local aQ,aR,aS,aT,aU,aV=ag({},{__mode='k'}),function(aQ)ah(aQ..
' is not a valid (virtual) member of '..aN..' "'..aO..'"',3)end,function(aQ)ah(
'Unable to assign (virtual) property '..aQ..'. Property is read only',3)end,{},{
}aU.__metatable=false aU.__index=function(aW,aX)if aX=='ClassName'then return aN
elseif aX=='Name'then return aO elseif aX=='Parent'then return aP elseif aN==
'StringValue'and aX=='Value'then return aV else local aY=aM[aX]if aY then return
aY end end for aY in ai,aQ do if aY.Name==aX then return aY end end aR(aX)end aU
.__newindex=function(aW,aX,aY)if aX=='ClassName'then aS(aX)elseif aX=='Name'then
aO=aY elseif aX=='Parent'then if aY==aT then return end if aP~=nil then aK[aP][
aT]=nil end aP=aY if aY~=nil then aK[aY][aT]=true end elseif aN=='StringValue'
and aX=='Value'then aV=aY else aR(aX)end end aU.__tostring=function()return aO
end ag(aT,aU)aK[aT]=aQ if aP~=nil then aK[aP][aT]=true end return aT end
local function CreateRefFromObject(aO,aP)local aQ,aR,aS,aT=aO[1],aO[2],aO[3],aO[
4]local aU=aD[aR]local aV=aS and av(aS,1)or aU local aW=aN(aU,aV,aP)aE[aQ]=aW if
aS then for aX,aY in ai,aS do aW[aX]=aY end end if aT then for aX,aY in ai,aT do
CreateRefFromObject(aY,aW)end end return aW end local aO=aN('Folder','['..ad..
']')for aP,aQ in ai,ab do CreateRefFromObject(aQ,aO)end for aP,aQ in ai,aa do
local aR=aE[aP]aF[aR]=aQ aG[aR]=aP local aS=aR.ClassName if aS=='LocalScript'or
aS=='Script'then au(aI,aR)end end local aP=function(aP)local aQ,aR=aP.ClassName,
aH[aP]if aR and aQ=='ModuleScript'then return ak(aR)end local aS,aT=aF[aP],
function(aS)aS=aq(aS)local aT,aU,aV=aP:GetFullName(),az(aS,'[^:]+:(%d+): (.+)')
if not aU or not at then return aT..':*: '..(aV or aS)end aU=ar(aU)local aW=aG[
aP]local aX=at[aW]local aY=aU-aX+1 if aY<0 then aY='?'end return aT..':'..aY..
': '..aV end if aQ=='LocalScript'or aQ=='Script'then local aU,aV=ap(aS)if not aU
then ah(aT(aV),0)end else local aU={ap(aS)}local aV=av(aU,1)if not aV then local
aW=av(aU,1)ah(aT(aW),0)end aH[aP]=aU return ak(aU)end end a=function(aQ)local aR
,aS,aT=aE[aQ],function(aR,...)local aS={ap(aR,...)}local aT=av(aS,1)if not aT
then ah(aS[1],3)end return ak(aS)end,aw(ag({},{__index=aJ,__newindex=function(aR
,aS,aT)aJ[aS]=aT end,__len=function()return#aJ end,__iter=function()return ai,aJ
end}))local aU,aV,aW=aw{version=ac,envname=ad,shared=aT,script=am,require=ao},aR
,function(aU,...)local aV,aW,aX=an(aU),
'Attempted to call require with a non-ModuleScript',
'Attempted to call require with self'if aV=='table'and aK[aU]then if aU.
ClassName~='ModuleScript'then ah(aW,2)elseif aU==aR then ah(aX,2)end return aP(
aU)elseif aV=='string'and ay(aU,1,1)~='@'then if#aU==0 then ah(
'Attempted to call require with empty string',2)end local aY=aR if ay(aU,1,1)==
'/'then aY=aO elseif ay(aU,1,2)=='./'then aU=ay(aU,3)end local aZ for a_ in aA(
aU,'([^/]*)/?')do local a0=a_ if a_=='..'then a0='Parent'end if a0~=''then local
a1=aY:FindFirstChild(a0)if not a1 then local a2=aY.Parent if a2 then a1=a2:
FindFirstChild(a0)end end if a1 then aY=a1 elseif a_~=aZ and a_~='init'and a_~=
'init.server'and a_~='init.client'then ah('Virtual script path "'..aU..
'" not found',2)end end aZ=a_ end if aY.ClassName~='ModuleScript'then ah(aW,2)
elseif aY==aR then ah(aX,2)end return aP(aY)end return aS(ao,aU,...)end return
aU,aV,aW end for aQ,aR in ai,aI do aC(aP,aR)end return aP(aO:GetChildren()[1])
