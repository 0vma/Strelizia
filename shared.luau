----!native
-- ++++++++ WAX BUNDLED DATA BELOW ++++++++ --

-- Will be used later for getting flattened globals
local ImportGlobals

-- Holds direct closure data (defining this before the DOM tree for line debugging etc)
local ClosureBindings ,
















































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































ObjectTree ,





WaxVersion ,
EnvName ,




string,task,setmetatable,error,next,table,unpack,coroutine,script,type,require,pcall,tostring,tonumber,_VERSION ,LineOffsets = {function()local wax, script, require=ImportGlobals(1)return (function(...)local Vinca = require(script.Vinca)
return Vinca.new():Extend(Vinca.Extensions.Children(script))
end)() end,function()local wax, script=ImportGlobals(2)return (function(...)return function(Root)
	return Root.new(Root):Extend(Root.Extensions.Children(script))
end
end)() end,function()local wax, script, require=ImportGlobals(3)return (function(...)return function(Root)
    -- // Services
	local Services = Root.Services	
	local RunService,Lock ,Task ,Trove = Services.RunService,require(script.Lock)(Root),require(script.Task)(Root),Root:Get("RBXUtil/Trove")
	-- // Module
	local TaskManager = {
		Running = false,
		
        Connection = nil,
        Trove = Trove.new(),
		
        Tasks = {},
        PendingTasks = {},
	}	
	TaskManager.Task = Task	TaskManager.Lock = Lock	
	function TaskManager.Begin()
		if TaskManager.Running then return end		TaskManager.Running = true
		
		TaskManager.Connection = RunService.Heartbeat:Connect(function(DeltaTime)
			if (not TaskManager.Running) then return end			debug.profilebegin('TaskManager')
			
			for Identifier, Task in TaskManager.PendingTasks do 
                TaskManager.PendingTasks[Identifier] = nil                
				task.spawn(function()
					local Success = Task:Run()					
					if (not Success) or (not Task.Interval) then
						return TaskManager.RemoveTask(Identifier)                    end
                    
                    task.wait(Task.Interval)                    
                    if (TaskManager.Tasks[Identifier]) then
                        TaskManager.PendingTasks[Identifier] = Task
                    end				end)
			end
			
			debug.profileend()
		end)
	end
	
	function TaskManager.Stop()
		if not TaskManager.Running then return end		TaskManager.Running = false
		
		TaskManager.Connection:Disconnect()
		TaskManager.Connection = nil
		
		for Identifier in TaskManager.Tasks do 
			TaskManager.RemoveTask(Identifier)
        end
        
        TaskManager.Trove:Destroy()	end 
	
	function TaskManager.AddTask(Object)
		assert(Object and Task.is(Object), 'Task must be a Task object!')
        local Identifier = Object.Identifier        
        TaskManager.Tasks[Identifier] = Object        TaskManager.PendingTasks[Identifier] = Object		
		return Identifier
	end
	
	function TaskManager.RemoveTask(Identifier)
		local Task = TaskManager.Tasks[Identifier]		if (not Task) then return end 
		
        TaskManager.Tasks[Identifier] = nil
        TaskManager.PendingTasks[Identifier] = nil        
		Task:Destroy()
	end
	
	function TaskManager.GetTasksFromIndex(Index)
		local Tasks = {}		
		for Identifier, Task in TaskManager.Tasks do 
			if Task.Index ~= Index then continue end			
			Tasks[Identifier] = Task
		end
		
		return Tasks	end
	
	function TaskManager.RemoveTasksByIndex(Index)
		for Identifier in TaskManager.GetTasksFromIndex(Index) do
			TaskManager.RemoveTask(Identifier)
		end
	end

	return TaskManager
end
end)() end,function()ImportGlobals(4)return (function(...)return function(Root)
    local Task = {}    Task.__index = Task 
local t , Time , OutputMessage , CreateGUID , set_memory_cat , reset_memory_cat , profile_begin , profile_end =Root:Get('Modules/t'), Root:Get('Functions/Time'), Root:Get('Functions/OutputMessage'), Root:Get('Functions/CreateGUID'), debug.setmemorycategory, debug.resetmemorycategory, debug.profilebegin, debug.profileend    
    local TaskAssertion ,OptionalString = t.tuple(t.string, t['function'], t.optional(t.number), t.optional(t.boolean)),t.optional(t.string)    
    -- // Task
    --[[
        @name Task.new
        @description Creates a new task.
        @param Index: string -- The index of the task.
        @param Callback: function -- The callback function of the task.
        @param Interval: number? -- The interval of the task. Nil means it only runs once.
        @param UtilizeLocks: boolean? -- Indicates if task uses locks.
    ]]
    function Task.new(Index, Callback, Interval, UtilizeLocks)
        assert(TaskAssertion(Index, Callback, Interval, UtilizeLocks))
        
        return setmetatable({
            __TASK = true,
            
            Index = Index,
            Identifier = CreateGUID(),
            
            Callback = Callback,
            
            Running = false,
            Destroyed = false,
            
            Interval = Interval,
            CurrentStep = nil,
            Profiling = false,
            Priority = 1,
            
            Locks = if UtilizeLocks then {Groups = {}, Individual = {}} else nil,
        }, Task)
    end
    
    function Task.is(Object)
        return typeof(Object) == 'table' and rawget(Object, "__TASK")    end
    
    function Task.SetPriority(self, Priority)
        assert(t.number(Priority))        
        self.Priority = Priority
        
        return self 
    end
    
    function Task.GetPriority(self)
        return self.Priority
    end

    function Task.SetStep(self, Step)
        assert(OptionalString(Step))        
        local CurrentStep = self.CurrentStep        self.CurrentStep = Step        
        if CurrentStep then
            profile_end()        end
        
        if Step ~= nil then
            profile_begin(Step)
        end
        
        return self 
    end
    
    function Task.SetProfiling(self, Enabled)
        assert(t.boolean(Enabled))        
        if self.Profiling == Enabled then return self end

        self.Profiling = Enabled
        if Enabled then
            profile_begin(self.Index)        else
            if self.CurrentStep then
                self:SetStep(nil)            end
            
            profile_end()        end

        return self
    end
    
    function Task.Run(self)
        self.Running = true
        
        local Success, Result = pcall(self.Callback, self)        
        if (not Success) then
            OutputMessage('Error', `An error has occured during runtime of Thread '{self.Index}' on Step '{tostring(self.CurrentStep)}': {Result}`)
        end
        
        self.Running = false        
        if self.Profiling then  
            self:SetProfiling(false)        end
        
        return Success, Result
    end
    
    function Task.Destroy(self)
        self.Destroyed = true        
        local Locks = self.Locks        if Locks then
            for Group in Locks.Groups do
                Group:Release()            end
            
            for Individual in Locks.Individual do 
                Individual:Release()            end
            
            table.clear(Locks.Groups)
            table.clear(Locks.Individual)
        end 
        
        return self    end
    
    return {new = Task.new, is = Task.is}
end
end)() end,function()ImportGlobals(5)return (function(...)return function(Root)
	-- // simpler Lock (No queue, just early return)

    -- // Modules
    local t ,Signal ,TableUtil = Root:Get('Modules/t'),Root:Get('RBXUtil/Signal'),Root:Get('RBXUtil/TableUtil')
	-- // Variables
	local Dictionary ,Filter = TableUtil.Dictionary,TableUtil.Filter

	-- // Functions

	local function CompareTasks(TaskOne, TaskTwo)
		local PriorityOne, PriorityTwo = TaskOne:GetPriority(), TaskTwo:GetPriority()
		if PriorityOne ~= PriorityTwo then
			return PriorityOne > PriorityTwo
		end

		return TaskOne.Identifier > TaskTwo.Identifier	end

	local Lock = {Cache = {}}	Lock.__index = Lock

	function Lock.new(Index)
		assert(t.string(Index))
		if Lock.Cache[Index] then
			return Lock.Cache[Index]
		end

        local Object = setmetatable({
            __LOCK = true,

			Index = Index,

			User = nil,
			UserChanged = Signal.new(),

			TakeoverRecipient = nil,
			TakeoverInitiated = Signal.new(),

			Aborted = false,
			Destroyed = false
		}, Lock)

		Lock.Cache[Index] = Object

		return Object
	end

	function Lock.is(Object)
		return typeof(Object) == 'table' and rawget(Object, "__LOCK")	end

	function Lock.CanTake(self, Task)
		assert(Task and typeof(Task) == 'table', 'Must provide a Task object for evaluation!')		assert(Task.Locks, 'Task must be Lock-utilizing!')
		local CurrentUser = self.User		if (not CurrentUser) then return true end
		if (CurrentUser == Task) then
			return true
		end

		local TakeoverRecipient = self.TakeoverRecipient		if TakeoverRecipient then
			return CompareTasks(Task, TakeoverRecipient)
		end

		return CompareTasks(Task, CurrentUser)
	end

	function Lock.TakeAsync(self, Task)
		assert(Task and typeof(Task) == 'table', 'Must provide a Task object for evaluation!')		assert(Task.Locks, 'Task must be Lock-utilizing!')
		if (not self.User) then
			self.User = Task
			self.Aborted = false
			Task.Locks.Individual[self] = true

			self.UserChanged:Fire(Task, nil)

			return true
		end

		if (self.User == Task) then
			return true
		end

		self.Aborted = true
		self.TakeoverRecipient = Task
		self.TakeoverInitiated:Fire(Task, self.User)

		return self.UserChanged:Wait() == Task
	end

	function Lock.Release(self)
		if (not self.User) then return self end
		local OriginalUser ,TakeoverRecipient = self.User,self.TakeoverRecipient
		self.User = TakeoverRecipient		self.TakeoverRecipient = nil		self.Aborted = false
		OriginalUser.Locks.Individual[self] = nil
		if TakeoverRecipient then
			TakeoverRecipient.Locks.Individual[self] = true		end

		self.UserChanged:Fire(TakeoverRecipient, OriginalUser)

		return self
	end

	-- // Lock Group

	local Group = {}	Group.__index = Group

	function Group.new(Locks)
		assert(Locks and typeof(Locks) == 'table', 'Must provide Locks for a Group')
		local self = setmetatable({
			User = nil,
			UserChanged = Signal.new(),

			Locks = Dictionary(Filter(Locks, Lock.is)),

			TakeoverRecipient = nil,
			TakeoverInitiated = Signal.new(),

			Aborted = false,
			Connections = {},

			Destroyed = false
		}, Group)

		for Lock in self.Locks do
			table.insert(self.Connections, Lock.TakeoverInitiated:Connect(function(Initiator, OriginalUser)
				if (not self.User) or (self.User ~= OriginalUser) then return end
				self.Aborted = true
			end))
		end

		return self
	end

	function Group.CanTake(self, Task)
		for Lock in self.Locks do
			if Lock:CanTake(Task) then continue end
			return false
		end

		return true
	end

	function Group.TakeAsync(self, Task)
		local OriginalUser = self.User
		if (OriginalUser == Task) then
			return true
		end

		if OriginalUser then
			self.TakeoverRecipient = Task
			self.TakeoverInitiated:Fire(Task, OriginalUser)

			return self.UserChanged:Wait() == Task
		end

		local Allocated = {}
		for Lock in self.Locks do
			if Lock:TakeAsync(Task) then
				Allocated[Lock] = true				continue
			end

			for Claimed in Allocated do
				Claimed:Release()			end

			return false
		end

		self.User = Task
		self.Aborted = false
		Task.Locks.Groups[self] = true

		self.UserChanged:Fire(Task, OriginalUser)

		return true
	end

	function Group.Release(self)
		if (not self.User) then return self end
		local OriginalUser ,TakeoverRecipient = self.User,self.TakeoverRecipient
		for Lock in self.Locks do
			if (Lock.User ~= OriginalUser) then continue end
			if TakeoverRecipient then
				Lock.User = TakeoverRecipient				Lock.Aborted = false
				OriginalUser.Locks.Individual[Lock] = nil				TakeoverRecipient.Locks.Individual[Lock] = true			else
				Lock:Release()			end
		end

		self.User = TakeoverRecipient		self.TakeoverRecipient = nil		self.Aborted = false
		OriginalUser.Locks.Groups[self] = nil		if TakeoverRecipient then
			TakeoverRecipient.Locks.Groups[self] = true		end

		self.UserChanged:Fire(TakeoverRecipient, OriginalUser)

		return self
	end

	function Group.Destroy(self)
		if (not self.Destroyed) then
			self.Destroyed = true

			for _, Connection in self.Connections do
				Connection:Disconnect()			end

			table.clear(self.Connections)
		end

		return self
	end

	return table.freeze({new = Lock.new, Group = Group})
end
end)() end,function()ImportGlobals(6)return (function(...)    return function(Root)
	-- // Modules
	local t = Root:Get('Modules/t')	
    -- // Variables
    
	local EvaluateSequenceAssert ,PaintAssert ,MergeAssert ,floor = t.tuple(t.ColorSequence, t.numberConstrained(0, 1)),t.tuple(t.string, t.union(t.Color3, t.ColorSequence))
,t.intersection(t.array(t.Color3), function(value)
		return #value >= 2, 'Merge requires at least 2 colors'
	end)
,math.floor	
	-- // Functions
	local function FormatRichText(Text, Color)
		return `<font color="rgb({floor(Color.R * 255)},{floor(Color.G * 255)},{floor(Color.B * 255)})">{Text}</font>`
	end
	
	-- // Color
	local Color = {}	
	function Color.EvaluateColorSequence(Sequence, Time)
		assert(EvaluateSequenceAssert(Sequence, Time))		
		local Keypoints = Sequence.Keypoints		local Previous = Keypoints[1]		
		for Index = 2, #Keypoints do 
			local CurrentKey = Keypoints[Index]
			if Time <= CurrentKey.Time then
				local TimeSegment = (Time - Previous.Time) / (CurrentKey.Time - Previous.Time)
				
				return Previous.Value:Lerp(CurrentKey.Value, TimeSegment)			end

			Previous = CurrentKey
		end

		return Keypoints[#Keypoints].Value	end
	
	function Color.Paint(Text, InputColor)
		assert(PaintAssert(Text, InputColor))		
		if typeof(InputColor) == 'Color3' then
			return FormatRichText(Text, InputColor)		elseif typeof(InputColor) == 'ColorSequence' then
			local Result, Length = {}, #Text			
			for Index = 1, Length do 
				local Time = (Length == 1) and 0 or ((Index - 1) / (Length - 1))				
				Result[Index] = Color.Paint(Text:sub(Index, Index), Color.EvaluateColorSequence(InputColor, Time))
			end

			return table.concat(Result)
		end
	end
	
	function Color.Merge(...)
		local Arguments = {...} 		assert(MergeAssert(Arguments))		
		local Keypoints, Size = {}, #Arguments		
		for Index, InputColor in Arguments do 
			table.insert(Keypoints, ColorSequenceKeypoint.new((Index - 1) / (Size - 1), InputColor))
		end
		
		return ColorSequence.new(Keypoints)	end
	
	return Color
end
end)() end,function()ImportGlobals(7)return (function(...)return function(Root)
	local t = {}

	function t.type(typeName)
		return function(value)
			local valueType = type(value)
			if valueType == typeName then
				return true
			else
				return false, string.format("%s expected, got %s", typeName, valueType)
			end
		end
	end

	function t.typeof(typeName)
		return function(value)
			local valueType = typeof(value)
			if valueType == typeName then
				return true
			else
				return false, string.format("%s expected, got %s", typeName, valueType)
			end
		end
	end

	function t.any(value)
		if value ~= nil then
			return true
		else
			return false, "any expected, got nil"
		end
	end

	t.boolean = t.typeof("boolean")
	t.buffer = t.typeof("buffer")
	t.thread = t.typeof("thread")
	t.callback = t.typeof("function")
	t["function"] = t.callback
	t.none = t.typeof("nil")
	t["nil"] = t.none
	t.string = t.typeof("string")
	t.table = t.typeof("table")
	t.userdata = t.type("userdata")
	t.vector = t.type("vector")

	function t.number(value)
		local valueType = typeof(value)
		if valueType == "number" then
			if value == value then
				return true
			else
				return false, "unexpected NaN value"
			end
		else
			return false, string.format("number expected, got %s", valueType)
		end
	end

	function t.nan(value)
		local valueType = typeof(value)
		if valueType == "number" then
			if value ~= value then
				return true
			else
				return false, "unexpected non-NaN value"
			end
		else
			return false, string.format("number expected, got %s", valueType)
		end
	end

	t.Axes = t.typeof("Axes")
	t.BrickColor = t.typeof("BrickColor")
	t.CatalogSearchParams = t.typeof("CatalogSearchParams")
	t.CFrame = t.typeof("CFrame")
	t.Content = t.typeof("Content")
	t.Color3 = t.typeof("Color3")
	t.ColorSequence = t.typeof("ColorSequence")
	t.ColorSequenceKeypoint = t.typeof("ColorSequenceKeypoint")
	t.DateTime = t.typeof("DateTime")
	t.DockWidgetPluginGuiInfo = t.typeof("DockWidgetPluginGuiInfo")
	t.Enum = t.typeof("Enum")
	t.EnumItem = t.typeof("EnumItem")
	t.Enums = t.typeof("Enums")
	t.Faces = t.typeof("Faces")
	t.FloatCurveKey = t.typeof("FloatCurveKey")
	t.Font = t.typeof("Font")
	t.Instance = t.typeof("Instance")
	t.NumberRange = t.typeof("NumberRange")
	t.NumberSequence = t.typeof("NumberSequence")
	t.NumberSequenceKeypoint = t.typeof("NumberSequenceKeypoint")
	t.OverlapParams = t.typeof("OverlapParams")
	t.PathWaypoint = t.typeof("PathWaypoint")
	t.PhysicalProperties = t.typeof("PhysicalProperties")
	t.Random = t.typeof("Random")
	t.Ray = t.typeof("Ray")
	t.RaycastParams = t.typeof("RaycastParams")
	t.RaycastResult = t.typeof("RaycastResult")
	t.RBXScriptConnection = t.typeof("RBXScriptConnection")
	t.RBXScriptSignal = t.typeof("RBXScriptSignal")
	t.Rect = t.typeof("Rect")
	t.Region3 = t.typeof("Region3")
	t.Region3int16 = t.typeof("Region3int16")
	t.TweenInfo = t.typeof("TweenInfo")
	t.UDim = t.typeof("UDim")
	t.UDim2 = t.typeof("UDim2")
	t.Vector2 = t.typeof("Vector2")
	t.Vector2int16 = t.typeof("Vector2int16")
	t.Vector3 = t.typeof("Vector3")
	t.Vector3int16 = t.typeof("Vector3int16")

	-- PERF: builds a hash set at checker-creation time for O(1) lookups at runtime.
	-- The original also had a redundant ipairs fallback loop that could never catch
	-- anything the set missed — removed here.
	function t.literalList(literals)
		local set = {}
		for _, literal in ipairs(literals) do
			set[literal] = true
		end
		return function(value)
			if set[value] then
				return true
			end
			return false, "bad type for literal list"
		end
	end

	function t.literal(...)
		local size = select("#", ...)
		if size == 1 then
			local literal = ...
			return function(value)
				if value ~= literal then
					return false, string.format("expected %s, got %s", tostring(literal), tostring(value))
				end
				return true
			end
		else
			local literals = {}
			for i = 1, size do
				local value = select(i, ...)
				literals[i] = t.literal(value)
			end
			return t.unionList(literals)
		end
	end

	t.exactly = t.literal

	function t.keyOf(keyTable)
		local keys ,length = {}
,0
		for key in pairs(keyTable) do
			length = length + 1
			keys[length] = key
		end
		return t.literal(table.unpack(keys, 1, length))
	end

	function t.valueOf(valueTable)
		local values ,length = {}
,0
		for _, value in pairs(valueTable) do
			length = length + 1
			values[length] = value
		end
		return t.literal(table.unpack(values, 1, length))
	end

	function t.integer(value)
		local success, errMsg = t.number(value)
		if not success then
			return false, errMsg or ""
		end
		if value % 1 == 0 then
			return true
		else
			return false, string.format("integer expected, got %s", value)
		end
	end

	function t.numberMin(min)
		return function(value)
			local success, errMsg = t.number(value)
			if not success then
				return false, errMsg or ""
			end
			if value >= min then
				return true
			else
				return false, string.format("number >= %s expected, got %s", min, value)
			end
		end
	end

	function t.numberMax(max)
		return function(value)
			local success, errMsg = t.number(value)
			if not success then
				return false, errMsg
			end
			if value <= max then
				return true
			else
				return false, string.format("number <= %s expected, got %s", max, value)
			end
		end
	end

	function t.numberMinExclusive(min)
		return function(value)
			local success, errMsg = t.number(value)
			if not success then
				return false, errMsg or ""
			end
			if min < value then
				return true
			else
				return false, string.format("number > %s expected, got %s", min, value)
			end
		end
	end

	function t.numberMaxExclusive(max)
		return function(value)
			local success, errMsg = t.number(value)
			if not success then
				return false, errMsg or ""
			end
			if value < max then
				return true
			else
				return false, string.format("number < %s expected, got %s", max, value)
			end
		end
	end

	t.numberPositive = t.numberMinExclusive(0)
	t.numberNegative = t.numberMaxExclusive(0)

	function t.numberConstrained(min, max)
		assert(t.number(min))
		assert(t.number(max))
		local minCheck ,maxCheck = t.numberMin(min)
,t.numberMax(max)
		return function(value)
			local minSuccess, minErrMsg = minCheck(value)
			if not minSuccess then
				return false, minErrMsg or ""
			end
			local maxSuccess, maxErrMsg = maxCheck(value)
			if not maxSuccess then
				return false, maxErrMsg or ""
			end
			return true
		end
	end

	function t.numberConstrainedExclusive(min, max)
		assert(t.number(min))
		assert(t.number(max))
		local minCheck ,maxCheck = t.numberMinExclusive(min)
,t.numberMaxExclusive(max)
		return function(value)
			local minSuccess, minErrMsg = minCheck(value)
			if not minSuccess then
				return false, minErrMsg or ""
			end
			local maxSuccess, maxErrMsg = maxCheck(value)
			if not maxSuccess then
				return false, maxErrMsg or ""
			end
			return true
		end
	end

	function t.match(pattern)
		assert(t.string(pattern))
		return function(value)
			local stringSuccess, stringErrMsg = t.string(value)
			if not stringSuccess then
				return false, stringErrMsg
			end
			if string.match(value, pattern) == nil then
				return false, string.format("%q failed to match pattern %q", value, pattern)
			end
			return true
		end
	end

	function t.optional(check)
		assert(t.callback(check))
		return function(value)
			if value == nil then
				return true
			end
			local success, errMsg = check(value)
			if success then
				return true
			else
				return false, string.format("(optional) %s", errMsg or "")
			end
		end
	end

	function t.tuple(...)
		local checks = { ... }
		return function(...)
			local args = { ... }
			for i, check in ipairs(checks) do
				local success, errMsg = check(args[i])
				if success == false then
					return false, string.format("Bad tuple index #%s:\n\t%s", i, errMsg or "")
				end
			end
			return true
		end
	end

	function t.keys(check)
		assert(t.callback(check))
		return function(value)
			local tableSuccess, tableErrMsg = t.table(value)
			if tableSuccess == false then
				return false, tableErrMsg or ""
			end
			for key in pairs(value) do
				local success, errMsg = check(key)
				if success == false then
					return false, string.format("bad key %s:\n\t%s", tostring(key), errMsg or "")
				end
			end
			return true
		end
	end

	function t.values(check)
		assert(t.callback(check))
		return function(value)
			local tableSuccess, tableErrMsg = t.table(value)
			if tableSuccess == false then
				return false, tableErrMsg or ""
			end
			for key, val in pairs(value) do
				local success, errMsg = check(val)
				if success == false then
					return false, string.format("bad value for key %s:\n\t%s", tostring(key), errMsg or "")
				end
			end
			return true
		end
	end

	function t.map(keyCheck, valueCheck)
		assert(t.callback(keyCheck))
		assert(t.callback(valueCheck))
		local keyChecker ,valueChecker = t.keys(keyCheck)
,t.values(valueCheck)
		return function(value)
			local keySuccess, keyErr = keyChecker(value)
			if not keySuccess then
				return false, keyErr or ""
			end
			local valueSuccess, valueErr = valueChecker(value)
			if not valueSuccess then
				return false, valueErr or ""
			end
			return true
		end
	end

	function t.set(valueCheck)
		return t.map(valueCheck, t.literal(true))
	end

	do
		local arrayKeysCheck = t.keys(t.integer)

		function t.array(check)
			assert(t.callback(check))
			local valuesCheck = t.values(check)
			return function(value)
				local keySuccess, keyErrMsg = arrayKeysCheck(value)
				if keySuccess == false then
					return false, string.format("[array] %s", keyErrMsg or "")
				end
				local arraySize = 0
				for _ in ipairs(value) do
					arraySize = arraySize + 1
				end
				for key in pairs(value) do
					if key < 1 or key > arraySize then
						return false, string.format("[array] key %s must be sequential", tostring(key))
					end
				end
				local valueSuccess, valueErrMsg = valuesCheck(value)
				if not valueSuccess then
					return false, string.format("[array] %s", valueErrMsg or "")
				end
				return true
			end
		end

		function t.strictArray(...)
			local valueTypes = { ... }
			assert(t.array(t.callback)(valueTypes))
			return function(value)
				local keySuccess, keyErrMsg = arrayKeysCheck(value)
				if keySuccess == false then
					return false, string.format("[strictArray] %s", keyErrMsg or "")
				end
				if #valueTypes < #value then
					return false, string.format("[strictArray] Array size exceeds limit of %d", #valueTypes)
				end
				for idx, typeFn in pairs(valueTypes) do
					local typeSuccess, typeErrMsg = typeFn(value[idx])
					if not typeSuccess then
						return false, string.format("[strictArray] Array index #%d - %s", idx, typeErrMsg)
					end
				end
				return true
			end
		end
	end

	do
		local callbackArray = t.array(t.callback)

		function t.unionList(checks)
			assert(callbackArray(checks))
			return function(value)
				for _, check in ipairs(checks) do
					if check(value) then
						return true
					end
				end
				return false, "bad type for union"
			end
		end

		function t.union(...)
			return t.unionList({ ... })
		end

		t.some = t.union

		function t.intersectionList(checks)
			assert(callbackArray(checks))
			return function(value)
				for _, check in ipairs(checks) do
					local success, errMsg = check(value)
					if not success then
						return false, errMsg or ""
					end
				end
				return true
			end
		end

		function t.intersection(...)
			return t.intersectionList({ ... })
		end

		t.every = t.intersection
	end

	do
		local checkInterface = t.map(t.any, t.callback)

		function t.interface(checkTable)
			assert(checkInterface(checkTable))
			return function(value)
				local tableSuccess, tableErrMsg = t.table(value)
				if tableSuccess == false then
					return false, tableErrMsg or ""
				end
				for key, check in pairs(checkTable) do
					local success, errMsg = check(value[key])
					if success == false then
						return false, string.format("[interface] bad value for %s:\n\t%s", tostring(key), errMsg or "")
					end
				end
				return true
			end
		end

		function t.strictInterface(checkTable)
			assert(checkInterface(checkTable))
			return function(value)
				local tableSuccess, tableErrMsg = t.table(value)
				if tableSuccess == false then
					return false, tableErrMsg or ""
				end
				for key, check in pairs(checkTable) do
					local success, errMsg = check(value[key])
					if success == false then
						return false, string.format("[interface] bad value for %s:\n\t%s", tostring(key), errMsg or "")
					end
				end
				for key in pairs(value) do
					if not checkTable[key] then
						return false, string.format("[interface] unexpected field %q", tostring(key))
					end
				end
				return true
			end
		end
	end

	function t.instanceOf(className, childTable)
		assert(t.string(className))
		local childrenCheck
		if childTable ~= nil then
			childrenCheck = t.children(childTable)
		end
		return function(value)
			local instanceSuccess, instanceErrMsg = t.Instance(value)
			if not instanceSuccess then
				return false, instanceErrMsg or ""
			end
			if value.ClassName ~= className then
				return false, string.format("%s expected, got %s", className, value.ClassName)
			end
			if childrenCheck then
				local childrenSuccess, childrenErrMsg = childrenCheck(value)
				if not childrenSuccess then
					return false, childrenErrMsg
				end
			end
			return true
		end
	end

	t.instance = t.instanceOf

	function t.instanceIsA(className, childTable)
		assert(t.string(className))
		local childrenCheck
		if childTable ~= nil then
			childrenCheck = t.children(childTable)
		end
		return function(value)
			local instanceSuccess, instanceErrMsg = t.Instance(value)
			if not instanceSuccess then
				return false, instanceErrMsg or ""
			end
			if not value:IsA(className) then
				return false, string.format("%s expected, got %s", className, value.ClassName)
			end
			if childrenCheck then
				local childrenSuccess, childrenErrMsg = childrenCheck(value)
				if not childrenSuccess then
					return false, childrenErrMsg
				end
			end
			return true
		end
	end

	function t.enum(enum)
		assert(t.Enum(enum))
		return function(value)
			local enumItemSuccess, enumItemErrMsg = t.EnumItem(value)
			if not enumItemSuccess then
				return false, enumItemErrMsg
			end
			if value.EnumType == enum then
				return true
			else
				return false, string.format("enum of %s expected, got enum of %s", tostring(enum), tostring(value.EnumType))
			end
		end
	end

	do
		local checkWrap = t.tuple(t.callback, t.callback)

		function t.wrap(callback, checkArgs)
			assert(checkWrap(callback, checkArgs))
			return function(...)
				assert(checkArgs(...))
				return callback(...)
			end
		end
	end

	function t.strict(check)
		return function(...)
			assert(check(...))
		end
	end

	do
		local checkChildren = t.map(t.string, t.callback)

		function t.children(checkTable)
			assert(checkChildren(checkTable))
			return function(value)
				local instanceSuccess, instanceErrMsg = t.Instance(value)
				if not instanceSuccess then
					return false, instanceErrMsg or ""
				end
				local childrenByName = {}
				for _, child in ipairs(value:GetChildren()) do
					local name = child.Name
					if checkTable[name] then
						if childrenByName[name] then
							return false, string.format("Cannot process multiple children with the same name %q", name)
						end
						childrenByName[name] = child
					end
				end
				for name, check in pairs(checkTable) do
					local success, errMsg = check(childrenByName[name])
					if not success then
						return false, string.format("[%s.%s] %s", value:GetFullName(), name, errMsg or "")
					end
				end
				return true
			end
		end
	end

	return t
end
end)() end,function()local wax, script, require=ImportGlobals(8)return (function(...)return function(Root)
	-- // Interface
	local Interface = {
		Loaded = {};	
	}	
	function Interface.GetInterface(Name)
		assert(typeof(Name) == 'string', 'Must provide Inteface Name')		
		if Interface.Loaded[Name] then
			return Interface.Loaded[Name]
		end 
		
		local Target = script.List:FindFirstChild(Name)		assert(Target, `Failed to find Interface Components for: '{Name}'`)		
		local LoadedComponents = {}		
		for _, Component in Target:GetChildren() do 
            assert(Component.ClassName == 'ModuleScript', `Failed to load Interface Component '{Component.Name}' of '{Name}': Instance is not a ModuleScript.`)			
			LoadedComponents[Component.Name] = require(Component)(Root)		end
		
		Interface.Loaded[Name] = LoadedComponents
		
		return LoadedComponents
	end
	
	
	
	
	return Interface
end
end)() end,[11]=function()ImportGlobals(11)return (function(...)return function(Shared)
    local cloneref = (cloneref or clonereference or function(instance)
        return instance
    end)
    local CoreGui,Players,RunService,SoundService,UserInputService,TextService,Teams,TweenService,getgenv ,setclipboard ,protectgui = cloneref(game:GetService("CoreGui"))
,cloneref(game:GetService("Players"))
,cloneref(game:GetService("RunService"))
,cloneref(game:GetService("SoundService"))
,cloneref(game:GetService("UserInputService"))
,cloneref(game:GetService("TextService"))
,cloneref(game:GetService("Teams"))
,cloneref(game:GetService("TweenService"))
,getgenv or function()
        return shared
    end
,setclipboard or nil
,protectgui or (syn and syn.protect_gui) or function() end
    local gethui ,LocalPlayer = gethui or function()
        return CoreGui
    end
,Players.LocalPlayer or Players.PlayerAdded:Wait()
    local Mouse ,Labels ,Buttons ,Toggles ,Options ,Tooltips ,BaseURL ,CustomImageManager = cloneref(LocalPlayer:GetMouse())
,{}
,{}
,{}
,{}
,{}
,"https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"
,{}
    local CustomImageManagerAssets = {
        TransparencyTexture = {
            RobloxId = 139785960036434,
            Path = "Obsidian/assets/TransparencyTexture.png",
            URL = BaseURL .. "assets/TransparencyTexture.png",

            Id = nil,
        },

        SaturationMap = {
            RobloxId = 4155801252,
            Path = "Obsidian/assets/SaturationMap.png",
            URL = BaseURL .. "assets/SaturationMap.png",

            Id = nil,
        },

        LoadingIcon = {
            RobloxId = 97544096941083,
            Path = "Obsidian/assets/LoadingIcon.png",
            URL = BaseURL .. "assets/LoadingIcon.png",

            Id = nil,
        },

        CheckIcon = {
            RobloxId = 97682394690683,
            Path = "Obsidian/assets/CheckIcon.png",
            URL = BaseURL .. "assets/CheckIcon.png",

            Id = nil,
        },
    }
    do
        local function RecursiveCreatePath(Path, IsFile)
            if not isfolder or not makefolder then
                return
            end

            local Segments ,TraversedPath = Path:split("/")
,""

            if IsFile then
                table.remove(Segments, #Segments)
            end

            for _, Segment in ipairs(Segments) do
                if not isfolder(TraversedPath .. Segment) then
                    makefolder(TraversedPath .. Segment)
                end

                TraversedPath = TraversedPath .. Segment .. "/"
            end

            return TraversedPath
        end

        function CustomImageManager.AddAsset(
            AssetName,
            RobloxAssetId,
            URL,
            ForceRedownload        )
            if CustomImageManagerAssets[AssetName] ~= nil then
                error(string.format("Asset %q already exists", AssetName))
            end

            assert(typeof(RobloxAssetId) == "number", "RobloxAssetId must be a number")

            CustomImageManagerAssets[AssetName] = {
                RobloxId = RobloxAssetId,
                Path = string.format("Obsidian/custom_assets/%s", AssetName),
                URL = URL,

                Id = nil,
            }

            CustomImageManager.DownloadAsset(AssetName, ForceRedownload)
        end

        function CustomImageManager.GetAsset(AssetName)
            if not CustomImageManagerAssets[AssetName] then
                return nil
            end

            local AssetData = CustomImageManagerAssets[AssetName]
            if AssetData.Id then
                return AssetData.Id
            end

            local AssetID = string.format("rbxassetid://%s", AssetData.RobloxId)

            if getcustomasset then
                local Success, NewID = pcall(getcustomasset, AssetData.Path)

                if Success and NewID then
                    AssetID = NewID
                end
            end

            AssetData.Id = AssetID
            return AssetID
        end

        function CustomImageManager.DownloadAsset(AssetName, ForceRedownload)
            if not getcustomasset or not writefile or not isfile then
                return false, "missing functions"
            end

            local AssetData = CustomImageManagerAssets[AssetName]

            RecursiveCreatePath(AssetData.Path, true)

            if ForceRedownload ~= true and isfile(AssetData.Path) then
                return true, nil
            end

            local success, errorMessage = pcall(function()
                writefile(AssetData.Path, game:HttpGet(AssetData.URL))
            end)

            return success, errorMessage
        end

        for AssetName, _ in CustomImageManagerAssets do
            CustomImageManager.DownloadAsset(AssetName)
        end
    end

    local Library = {
        LocalPlayer = LocalPlayer,
        DevicePlatform = nil,
        IsMobile = false,
        IsRobloxFocused = true,

        ScreenGui = nil,

        SearchText = "",
        Searching = false,
        GlobalSearch = false,
        LastSearchTab = nil,

        ActiveTab = nil,
        Tabs = {},
        TabButtons = {},
        DependencyBoxes = {},

        KeybindFrame = nil,
        KeybindContainer = nil,
        KeybindToggles = {},

        Notifications = {},
        Dialogues = {},
        ActiveLoading = nil,
        ActiveDialog = nil,

        Corners = {},

        ToggleKeybind = Enum.KeyCode.RightControl,
        TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        NotifyTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

        Toggled = false,
        Unloaded = false,

        Labels = Labels,
        Buttons = Buttons,
        Toggles = Toggles,
        Options = Options,

        NotifySide = "Right",
        ShowCustomCursor = true,
        ForceCheckbox = false,
        ShowToggleFrameInKeybinds = true,
        NotifyOnError = false,

        CantDragForced = false,

        Signals = {},
        UnloadSignals = {},

        OriginalMinSize = Vector2.new(480, 360),
        MinSize = Vector2.new(480, 360),
        DPIScale = 1,
        CornerRadius = 4,
        CornerRadiusDropdown = false, -- Temporary

        IsLightTheme = false,
        Scheme = {
            BackgroundColor = Color3.fromRGB(15, 15, 15),
            MainColor = Color3.fromRGB(25, 25, 25),
            AccentColor = Color3.fromRGB(125, 85, 255),
            OutlineColor = Color3.fromRGB(40, 40, 40),
            FontColor = Color3.new(1, 1, 1),
            Font = Font.fromEnum(Enum.Font.Code),

            RedColor = Color3.fromRGB(255, 50, 50),
            DestructiveColor = Color3.fromRGB(220, 38, 38),
            DarkColor = Color3.new(0, 0, 0),
            WhiteColor = Color3.new(1, 1, 1),
        },

        Registry = {},
        Scales = {},
        ScalesOffset = {},

        ImageManager = CustomImageManager,
        ShowCursorBinding = string.sub(tostring({}), 10),
    }

    if RunService:IsStudio() then
        if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
            Library.IsMobile = true
            Library.OriginalMinSize = Vector2.new(480, 240)
        else
            Library.IsMobile = false
            Library.OriginalMinSize = Vector2.new(480, 360)
        end
    else
        pcall(function()
            Library.DevicePlatform = UserInputService:GetPlatform()
        end)
        Library.IsMobile = (Library.DevicePlatform == Enum.Platform.Android or Library.DevicePlatform == Enum.Platform.IOS)
        Library.OriginalMinSize = Library.IsMobile and Vector2.new(480, 240) or Vector2.new(480, 360)
    end

    local Templates ,Places ,Sizes ,SchemeReplaceAlias ,SchemeAlias = {
        --// UI \\-
        Frame = {
            BorderSizePixel = 0,
        },
        ImageLabel = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        },
        ImageButton = {
            AutoButtonColor = false,
            BorderSizePixel = 0,
        },
        ScrollingFrame = {
            BorderSizePixel = 0,
        },
        TextLabel = {
            BorderSizePixel = 0,
            FontFace = "Font",
            RichText = true,
            TextColor3 = "FontColor",
        },
        TextButton = {
            AutoButtonColor = false,
            BorderSizePixel = 0,
            FontFace = "Font",
            RichText = true,
            TextColor3 = "FontColor",
        },
        TextBox = {
            BorderSizePixel = 0,
            FontFace = "Font",
            PlaceholderColor3 = function()
                local H, S, V = Library.Scheme.FontColor:ToHSV()
                return Color3.fromHSV(H, S, V / 2)
            end,
            Text = "",
            TextColor3 = "FontColor",
        },
        UIListLayout = {
            SortOrder = Enum.SortOrder.LayoutOrder,
        },
        UIStroke = {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        },

        --// Library \\--
        Window = {
            Title = "No Title",
            Footer = "No Footer",
            Position = UDim2.fromOffset(6, 6),
            Size = UDim2.fromOffset(720, 600),
            IconSize = UDim2.fromOffset(30, 30),
            AutoShow = true,
            Center = true,
            Resizable = true,
            SearchbarSize = UDim2.fromScale(1, 1),
            GlobalSearch = false,
            CornerRadius = 4,
            NotifySide = "Right",
            ShowCustomCursor = true,
            Font = Enum.Font.Code,
            ToggleKeybind = Enum.KeyCode.RightControl,

            ShowMobileButtons = true,
            MobileButtonsSide = "Left",

            UnlockMouseWhileOpen = true,

            EnableSidebarResize = false,
            EnableCompacting = true,
            DisableCompactingSnap = false,
            SidebarCompacted = false,
            MinContainerWidth = 256,

            --// Snapping \\--
            MinSidebarWidth = 128,
            SidebarCompactWidth = 48,
            SidebarCollapseThreshold = 0.5,

            --// Dragging \\--
            CompactWidthActivation = 128,
        },
        Dialog = {
            Title = "Dialog",
            Description = "Description",
            AutoDismiss = true,
            OutsideClickDismiss = true,
            FooterButtons = {}
        },
        Loading = {
            Title = "mspaint",
            Icon = 95816097006870,
            IconSize = UDim2.fromOffset(30, 30),

            LoadingIcon = CustomImageManager.GetAsset("LoadingIcon"),
            LoadingIconColor = nil,
            LoadingIconTweenTime = 1,

            CurrentStep = 0,
            TotalSteps = 10,

            ShowSidebar = false,
            AutoResizeHeight = false,

            WindowWidth = 450,
            WindowHeight = 275,

            ContentWidth = 450,
            SidebarWidth = 250,
        },
        Toggle = {
            Text = "Toggle",
            Default = false,

            Callback = function() end,
            Changed = function() end,

            Risky = false,
            Disabled = false,
            Visible = true,
        },
        Input = {
            Text = "Input",
            Default = "",
            Finished = false,
            Numeric = false,
            ClearTextOnFocus = true,
            ClearTextOnBlur = false,
            Placeholder = "",
            AllowEmpty = true,
            EmptyReset = "---",

            Callback = function() end,
            Changed = function() end,
            VerifyValue = nil,

            Disabled = false,
            Visible = true,
        },
        Slider = {
            Text = "Slider",
            Default = 0,
            Min = 0,
            Max = 100,
            Rounding = 0,

            Prefix = "",
            Suffix = "",

            Callback = function() end,
            Changed = function() end,

            Disabled = false,
            Visible = true,
        },
        Dropdown = {
            Values = {},
            DisabledValues = {},
            ValueImages = {},
            
            RichText = false, -- vma added this

            Multi = false,
            MaxVisibleDropdownItems = 8,

            Callback = function() end,
            Changed = function() end,

            Disabled = false,
            Visible = true,
        },
        Viewport = {
            Object = nil,
            Camera = nil,
            Clone = true,
            AutoFocus = true,
            Interactive = false,
            Height = 200,
            Visible = true,
        },
        Image = {
            Image = "",
            Transparency = 0,
            BackgroundTransparency = 0,
            Color = Color3.new(1, 1, 1),
            RectOffset = Vector2.zero,
            RectSize = Vector2.zero,
            ScaleType = Enum.ScaleType.Fit,
            Height = 200,
            Outline = false, -- vma added this
            Visible = true,
        },
        Video = {
            Video = "",
            Looped = false,
            Playing = false,
            Volume = 1,
            Height = 200,
            Visible = true,
        },
        UIPassthrough = {
            Instance = nil,
            Height = 24,
            Visible = true,
        },

        --// Addons \\-
        KeyPicker = {
            Text = "KeyPicker",

            Default = "None",
            DefaultModifiers = {},

            Blacklisted = {},
            BlacklistedModifiers = {},
            Whitelisted = {},
            WhitelistedModifiers = {},

            Mode = "Toggle",
            Modes = { "Always", "Toggle", "Hold" },
            SyncToggleState = false,

            Callback = function() end,
            ChangedCallback = function() end,
            Changed = function() end,
            Clicked = function() end,
        },
        ColorPicker = {
            Default = Color3.new(1, 1, 1),

            Callback = function() end,
            Changed = function() end,
        },
    }
,{
        Bottom = { 0, 1 },
        Right = { 1, 0 },
    }
,{
        Left = { 0.5, 1 },
        Right = { 0.5, 1 },
    }
,{
        RedColor = "Red",
        WhiteColor = "White",
        DarkColor = "Dark"
    }
,{
        Red = "RedColor",
        White = "WhiteColor",
        Dark = "DarkColor"
    }

    local function GetSchemeValue(Index)
        if not Index then
            return nil
        end

        local ReplaceAliasIndex = SchemeReplaceAlias[Index]
        if ReplaceAliasIndex and Library.Scheme[ReplaceAliasIndex] ~= nil then
            Library.Scheme[Index] = Library.Scheme[ReplaceAliasIndex]
            Library.Scheme[ReplaceAliasIndex] = nil

            return Library.Scheme[Index]
        end

        local AliasIndex = SchemeAlias[Index]
        if AliasIndex and Library.Scheme[AliasIndex] ~= nil then
            warn(string.format("Scheme Value %q is deprecated, please use %q instead.", Index, AliasIndex))
            return Library.Scheme[AliasIndex]
        end

        return Library.Scheme[Index]
    end

    --// Basic Functions \\--
    local function WaitForEvent(Event, Timeout, Condition)
        local Bindable = Instance.new("BindableEvent")
        local Connection = Event:Once(function(...)
            if not Condition or typeof(Condition) == "function" and Condition(...) then
                Bindable:Fire(true)
            else
                Bindable:Fire(false)
            end
        end)
        task.delay(Timeout, function()
            Connection:Disconnect()
            Bindable:Fire(false)
        end)

        local Result = Bindable.Event:Wait()
        Bindable:Destroy()

        return Result
    end

    local function IsMouseInput(Input, IncludeM2)
        return Input.UserInputType == Enum.UserInputType.MouseButton1
            or (IncludeM2 == true and Input.UserInputType == Enum.UserInputType.MouseButton2)
            or Input.UserInputType == Enum.UserInputType.Touch
    end
    local function IsClickInput(Input, IncludeM2)
        return IsMouseInput(Input, IncludeM2)
            and Input.UserInputState == Enum.UserInputState.Begin
            and Library.IsRobloxFocused
    end
    local function IsHoverInput(Input)
        return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
            and Input.UserInputState == Enum.UserInputState.Change
    end
    local function IsDragInput(Input, IncludeM2)
        return IsMouseInput(Input, IncludeM2)
            and (Input.UserInputState == Enum.UserInputState.Begin or Input.UserInputState == Enum.UserInputState.Change)
            and Library.IsRobloxFocused
    end

    local function GetTableSize(Table)
        local Size = 0

        for _, _ in Table do
            Size += 1
        end

        return Size
    end
    local function StopTween(Tween)
        if not (Tween and Tween.PlaybackState == Enum.PlaybackState.Playing) then
            return
        end

        Tween:Cancel()
    end
    
    local function Trim(Text)
        return Text:match("^%s*(.-)%s*$")
    end
    local function Round(Value, Rounding)
        assert(Rounding >= 0, "Invalid rounding number.")

        if Rounding == 0 then
            return math.floor(Value)
        end

        return tonumber(string.format("%." .. Rounding .. "f", Value))
    end
    
    local function StripRichTextTags(String) -- // vma added
        String = String:gsub("<br%s*/>", "\n")
        return (String:gsub("<[^<>]->", ""))
    end

    local function GetPlayers(ExcludeLocalPlayer)
        local PlayerList = Players:GetPlayers()

        if ExcludeLocalPlayer then
            local Idx = table.find(PlayerList, LocalPlayer)
            if Idx then
                table.remove(PlayerList, Idx)
            end
        end

        table.sort(PlayerList, function(Player1, Player2)
            return Player1.Name:lower() < Player2.Name:lower()
        end)

        return PlayerList
    end
    local function GetTeams()
        local TeamList = Teams:GetTeams()

        table.sort(TeamList, function(Team1, Team2)
            return Team1.Name:lower() < Team2.Name:lower()
        end)

        return TeamList
    end

    function Library:UpdateDependencyBoxes()
        for _, Depbox in Library.DependencyBoxes do
            Depbox:Update(true)
        end

        if Library.Searching then
            Library:UpdateSearch(Library.SearchText)
        end
    end

    local function CheckDepbox(Box, Search)
        local VisibleElements = 0

        for _, ElementInfo in Box.Elements do
            if ElementInfo.Type == "Divider" then
                ElementInfo.Holder.Visible = false
                continue
            elseif ElementInfo.SubButton then
                --// Check if any of the Buttons Name matches with Search
                local Visible = false

                --// Check if Search matches Element's Name and if Element is Visible
                if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                    Visible = true
                else
                    ElementInfo.Base.Visible = false
                end
                if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then
                    Visible = true
                else
                    ElementInfo.SubButton.Base.Visible = false
                end
                ElementInfo.Holder.Visible = Visible
                if Visible then
                    VisibleElements += 1
                end

                continue
            end

            --// Check if Search matches Element's Name and if Element is Visible
            if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                ElementInfo.Holder.Visible = true
                VisibleElements += 1
            else
                ElementInfo.Holder.Visible = false
            end
        end

        for _, Depbox in Box.DependencyBoxes do
            if not Depbox.Visible then
                continue
            end

            VisibleElements += CheckDepbox(Depbox, Search)
        end

        Box.Holder.Visible = VisibleElements > 0
        return VisibleElements
    end
    local function RestoreDepbox(Box)
        for _, ElementInfo in Box.Elements do
            ElementInfo.Holder.Visible = typeof(ElementInfo.Visible) == "boolean" and ElementInfo.Visible or true

            if ElementInfo.SubButton then
                ElementInfo.Base.Visible = ElementInfo.Visible
                ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
            end
        end

        Box:Resize()
        Box.Holder.Visible = true

        for _, Depbox in Box.DependencyBoxes do
            if not Depbox.Visible then
                continue
            end

            RestoreDepbox(Depbox)
        end
    end

    local function ApplySearchToTab(Tab, Search)
        if not Tab then
            return
        end

        local HasVisible = false

        --// Loop through Groupboxes to get Elements Info
        for _, Groupbox in Tab.Groupboxes do
            local VisibleElements = 0

            for _, ElementInfo in Groupbox.Elements do
                if ElementInfo.Type == "Divider" then
                    ElementInfo.Holder.Visible = false
                    continue
                elseif ElementInfo.SubButton then
                    --// Check if any of the Buttons Name matches with Search
                    local Visible = false

                    --// Check if Search matches Element's Name and if Element is Visible
                    if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                        Visible = true
                    else
                        ElementInfo.Base.Visible = false
                    end
                    if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then
                        Visible = true
                    else
                        ElementInfo.SubButton.Base.Visible = false
                    end
                    ElementInfo.Holder.Visible = Visible
                    if Visible then
                        VisibleElements += 1
                    end

                    continue
                end

                --// Check if Search matches Element's Name and if Element is Visible
                if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                    ElementInfo.Holder.Visible = true
                    VisibleElements += 1
                else
                    ElementInfo.Holder.Visible = false
                end
            end

            for _, Depbox in Groupbox.DependencyBoxes do
                if not Depbox.Visible then
                    continue
                end

                VisibleElements += CheckDepbox(Depbox, Search)
            end

            --// Update Groupbox Size and Visibility if found any element
            if VisibleElements > 0 then
                Groupbox:Resize()
                HasVisible = true
            end
            Groupbox.BoxHolder.Visible = VisibleElements > 0
        end

        for _, Tabbox in Tab.Tabboxes do
            local VisibleTabs ,VisibleElements = 0
,{}

            for _, SubTab in Tabbox.Tabs do
                VisibleElements[SubTab] = 0

                for _, ElementInfo in SubTab.Elements do
                    if ElementInfo.Type == "Divider" then
                        ElementInfo.Holder.Visible = false
                        continue
                    elseif ElementInfo.SubButton then
                        --// Check if any of the Buttons Name matches with Search
                        local Visible = false

                        --// Check if Search matches Element's Name and if Element is Visible
                        if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                            Visible = true
                        else
                            ElementInfo.Base.Visible = false
                        end
                        if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then
                            Visible = true
                        else
                            ElementInfo.SubButton.Base.Visible = false
                        end
                        ElementInfo.Holder.Visible = Visible
                        if Visible then
                            VisibleElements[SubTab] += 1
                        end

                        continue
                    end

                    --// Check if Search matches Element's Name and if Element is Visible
                    if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                        ElementInfo.Holder.Visible = true
                        VisibleElements[SubTab] += 1
                    else
                        ElementInfo.Holder.Visible = false
                    end
                end

                for _, Depbox in SubTab.DependencyBoxes do
                    if not Depbox.Visible then
                        continue
                    end

                    VisibleElements[SubTab] += CheckDepbox(Depbox, Search)
                end
            end

            for SubTab, Visible in VisibleElements do
                SubTab.ButtonHolder.Visible = Visible > 0
                if Visible > 0 then
                    VisibleTabs += 1
                    HasVisible = true

                    if Tabbox.ActiveTab == SubTab then
                        SubTab:Resize()
                    elseif Tabbox.ActiveTab and VisibleElements[Tabbox.ActiveTab] == 0 then
                        SubTab:Show()
                    end
                end
            end

            --// Update Tabbox Visibility if any visible
            Tabbox.BoxHolder.Visible = VisibleTabs > 0
        end

        return HasVisible
    end
    local function ResetTab(Tab)
        if not Tab then
            return
        end

        for _, Groupbox in Tab.Groupboxes do
            for _, ElementInfo in Groupbox.Elements do
                ElementInfo.Holder.Visible = typeof(ElementInfo.Visible) == "boolean" and ElementInfo.Visible or true

                if ElementInfo.SubButton then
                    ElementInfo.Base.Visible = ElementInfo.Visible
                    ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
                end
            end

            for _, Depbox in Groupbox.DependencyBoxes do
                if not Depbox.Visible then
                    continue
                end

                RestoreDepbox(Depbox)
            end

            Groupbox:Resize()
            Groupbox.BoxHolder.Visible = true
        end

        for _, Tabbox in Tab.Tabboxes do
            for _, SubTab in Tabbox.Tabs do
                for _, ElementInfo in SubTab.Elements do
                    ElementInfo.Holder.Visible = typeof(ElementInfo.Visible) == "boolean" and ElementInfo.Visible or true

                    if ElementInfo.SubButton then
                        ElementInfo.Base.Visible = ElementInfo.Visible
                        ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
                    end
                end

                for _, Depbox in SubTab.DependencyBoxes do
                    if not Depbox.Visible then
                        continue
                    end

                    RestoreDepbox(Depbox)
                end

                SubTab.ButtonHolder.Visible = true
            end

            if Tabbox.ActiveTab then
                Tabbox.ActiveTab:Resize()
            end
            Tabbox.BoxHolder.Visible = true
        end
    end

    function Library:UpdateSearch(SearchText)
        Library.SearchText = SearchText

        local TabsToReset = {}

        if Library.GlobalSearch then
            for _, Tab in Library.Tabs do
                if typeof(Tab) == "table" and not Tab.IsKeyTab then
                    table.insert(TabsToReset, Tab)
                end
            end
        elseif Library.LastSearchTab and typeof(Library.LastSearchTab) == "table" then
            table.insert(TabsToReset, Library.LastSearchTab)
        end

        for _, Tab in ipairs(TabsToReset) do
            ResetTab(Tab)
        end

        local Search = SearchText:lower()
        if Trim(Search) == "" then
            Library.Searching = false
            Library.LastSearchTab = nil
            return
        end
        if not Library.GlobalSearch and Library.ActiveTab and Library.ActiveTab.IsKeyTab then
            Library.Searching = false
            Library.LastSearchTab = nil
            return
        end

        Library.Searching = true

        local TabsToSearch = {}

        if Library.GlobalSearch then
            TabsToSearch = TabsToReset
            if #TabsToSearch == 0 then
                for _, Tab in Library.Tabs do
                    if typeof(Tab) == "table" and not Tab.IsKeyTab then
                        table.insert(TabsToSearch, Tab)
                    end
                end
            end
        elseif Library.ActiveTab then
            table.insert(TabsToSearch, Library.ActiveTab)
        end

        local ActiveHasVisible ,FirstVisibleTab = false

        for _, Tab in ipairs(TabsToSearch) do
            local HasVisible = ApplySearchToTab(Tab, Search)
            if HasVisible then
                if not FirstVisibleTab then
                    FirstVisibleTab = Tab
                end
                if Tab == Library.ActiveTab then
                    ActiveHasVisible = true
                end
            end
        end

        if Library.GlobalSearch then
            if ActiveHasVisible and Library.ActiveTab then
                Library.ActiveTab:RefreshSides()
            elseif FirstVisibleTab then
                local SearchMarker = SearchText
                task.defer(function()
                    if Library.SearchText ~= SearchMarker then
                        return
                    end

                    if Library.ActiveTab ~= FirstVisibleTab then
                        FirstVisibleTab:Show()
                    end
                end)
            end
            Library.LastSearchTab = nil
        else
            Library.LastSearchTab = Library.ActiveTab
        end
    end

    function Library:AddToRegistry(Instance, Properties)
        Library.Registry[Instance] = Properties
    end

    function Library:RemoveFromRegistry(Instance)
        Library.Registry[Instance] = nil
    end

    function Library:UpdateColorsUsingRegistry()
        for Instance, Properties in Library.Registry do
            for Property, Index in Properties do
                local SchemeValue = GetSchemeValue(Index)

                if SchemeValue or typeof(Index) == "function" then
                    Instance[Property] = SchemeValue or Index()
                end
            end
        end
    end

    function Library:SetDPIScale(DPIScale)
        Library.DPIScale = DPIScale / 100
        Library.MinSize = Library.OriginalMinSize * Library.DPIScale

        for _, UIScale in Library.Scales do
            UIScale.Scale = Library.DPIScale - (tonumber(Library.ScalesOffset[UIScale]) or 0)
        end

        for _, Option in Options do
            if Option.Type == "Dropdown" then
                Option:RecalculateListSize()
            end
        end

        for _, Notification in Library.Notifications do
            Notification:Resize()
        end
    end

    function Library:GiveSignal(Connection)
        local ConnectionType = typeof(Connection)
        if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
            table.insert(Library.Signals, Connection)
        end

        return Connection
    end

    function IsValidCustomIcon(Icon)
        return typeof(Icon) == "string" and (Icon:match("rbxasset") or Icon:match("roblox%.com/asset/%?id=") or Icon:match("rbxthumb://type="))
    end

    local FetchIcons, Icons = pcall(function()
        return ((loadstring(
            game:HttpGet("https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua")
            ) ))()
    end)

    function Library:GetIcon(IconName)
        if not FetchIcons then
            return
        end

        local Success, Icon = pcall(Icons.GetAsset, IconName)
        if not Success then
            return
        end
        return Icon
    end

    function Library:GetCustomIcon(IconName)        if not IconName then
            return nil
        end

        if tonumber(IconName) then
            IconName = string.format("rbxassetid://%s", tostring(IconName))
        end

        local CustomIcon = IsValidCustomIcon(IconName)
        if CustomIcon then
            return {
                Url = IconName,
                ImageRectOffset = Vector2.zero,
                ImageRectSize = Vector2.zero,
                Custom = true,
            }
        end

        local LucideIcon = Library:GetIcon(IconName)
        if LucideIcon then
            return LucideIcon
        end

        return nil
    end

    function Library:Validate(Table, Template)        if typeof(Table) ~= "table" then
            return Template
        end

        for k, v in Template do
            if typeof(k) == "number" then
                continue
            end

            if typeof(v) == "table" then
                Table[k] = Library:Validate(Table[k], v)
            elseif Table[k] == nil then
                Table[k] = v
            end
        end

        return Table
    end

    --// Creator Functions \\--
    local function FillInstance(Table, Instance)
        local ThemeProperties = Library.Registry[Instance] or {}

        for key, value in Table do
            if key ~= "Text" then
                local SchemeValue = GetSchemeValue(value)

                if SchemeValue or typeof(value) == "function" then
                    ThemeProperties[key] = value
                    value = SchemeValue or value()
                else
                    ThemeProperties[key] = nil
                end
            end

            Instance[key] = value
        end

        if GetTableSize(ThemeProperties) > 0 then
            Library.Registry[Instance] = ThemeProperties
        end
    end

    local function New(ClassName, Properties)        local Instance = Instance.new(ClassName)

        if Templates[ClassName] then
            FillInstance(Templates[ClassName], Instance)
        end
        FillInstance(Properties, Instance)

        if Properties.Parent and not Properties.ZIndex then
            pcall(function()
                Instance.ZIndex = Properties.Parent.ZIndex
            end)
        end

        return Instance
    end

    --// Main Instances \\-
    local function SafeParentUI(Instance, Parent)
local success=pcall(function()
            if not Parent then
                Parent = CoreGui
            end

            local DestinationParent
            if typeof(Parent) == "function" then
                DestinationParent = Parent()
            else
                DestinationParent = Parent
            end

            Instance.Parent = DestinationParent
        end)

        if not (success and Instance.Parent) then
            Instance.Parent = Library.LocalPlayer:WaitForChild("PlayerGui", math.huge)
        end
    end

    local function ParentUI(UI, SkipHiddenUI)
        if SkipHiddenUI then
            SafeParentUI(UI, CoreGui)
            return
        end

        pcall(protectgui, UI)
        SafeParentUI(UI, gethui)
    end

    local ScreenGui = New("ScreenGui", {
        Name = "Obsidian",
        DisplayOrder = 998,
        ResetOnSpawn = false,
    })
    ParentUI(ScreenGui)
    Library.ScreenGui = ScreenGui

    ScreenGui.DescendantRemoving:Connect(function(Instance)
        Library:RemoveFromRegistry(Instance)
    end)

    local ModalElement ,Cursor,CursorCustomImage
=(New("TextButton", {
        BackgroundTransparency = 1,
        Modal = false,
        Size = UDim2.fromScale(0, 0),
        AnchorPoint = Vector2.zero,
        Text = "",
        ZIndex = -999,
        Parent = ScreenGui,
    })
)    do
        Cursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "WhiteColor",
            Size = UDim2.fromOffset(9, 1),
            Visible = false,
            ZIndex = 11000,
            Parent = ScreenGui,
        })
        New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "DarkColor",
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, 2, 1, 2),
            ZIndex = 10999,
            Parent = Cursor,
        })

        local CursorV = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "WhiteColor",
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(1, 9),
            ZIndex = 11000,
            Parent = Cursor,
        })
        New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "DarkColor",
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, 2, 1, 2),
            ZIndex = 10999,
            Parent = CursorV,
        })

        CursorCustomImage = New("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(20, 20),
            ZIndex = 11000,
            Visible = false,
            Parent = Cursor
        })
    end

    --// Notification
    local NotificationArea
,NotificationList
    do
        NotificationArea = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -6, 0, 6),
            Size = UDim2.new(0, 300, 1, -6),
            Parent = ScreenGui,
        })
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = NotificationArea,
            })
        )

        NotificationList = New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 8),
            Parent = NotificationArea,
        })
    end

    --// Lib Functions \\--
    function Library:ResetCursorIcon()
        CursorCustomImage.Visible = false
        CursorCustomImage.Size = UDim2.fromOffset(20, 20)
    end

    function Library:ChangeCursorIcon(ImageId)
        if not ImageId or ImageId == "" then
            Library:ResetCursorIcon()
            return
        end

        local Icon = Library:GetCustomIcon(ImageId)
        assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        CursorCustomImage.Visible = true
        CursorCustomImage.Image = Icon.Url
        CursorCustomImage.ImageRectOffset = Icon.ImageRectOffset
        CursorCustomImage.ImageRectSize = Icon.ImageRectSize
    end

    function Library:ChangeCursorIconSize(Size)
        assert(typeof(Size) == "UDim2", "UDim2 expected.")
        CursorCustomImage.Size = Size
    end

    function Library:GetBetterColor(Color, Add)        Add = Add * (Library.IsLightTheme and -4 or 2)
        return Color3.fromRGB(
            math.clamp(Color.R * 255 + Add, 0, 255),
            math.clamp(Color.G * 255 + Add, 0, 255),
            math.clamp(Color.B * 255 + Add, 0, 255)
        )
    end

    function Library:GetLighterColor(Color)        local H, S, V = Color:ToHSV()
        return Color3.fromHSV(H, math.max(0, S - 0.1), math.min(1, V + 0.1))
    end

    function Library:GetDarkerColor(Color)        local H, S, V = Color:ToHSV()
        return Color3.fromHSV(H, S, V / 2)
    end

    function Library:GetKeyString(KeyCode)
        if KeyCode.EnumType == Enum.KeyCode and KeyCode.Value > 33 and KeyCode.Value < 127 then
            return string.char(KeyCode.Value)
        end

        return KeyCode.Name
    end

    function Library:GetTextBounds(Text, Font, Size, Width)        local Params = Instance.new("GetTextBoundsParams")
        Params.Text = Text
        Params.RichText = true
        Params.Font = Font
        Params.Size = Size
        Params.Width = Width or workspace.CurrentCamera.ViewportSize.X - 32

        local Bounds = TextService:GetTextBoundsAsync(Params)
        return Bounds.X, Bounds.Y
    end

    function Library:MouseIsOverFrame(Frame, Mouse)        local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
        return Mouse.X >= AbsPos.X
            and Mouse.X <= AbsPos.X + AbsSize.X
            and Mouse.Y >= AbsPos.Y
            and Mouse.Y <= AbsPos.Y + AbsSize.Y
    end

    function Library:SafeCallback(Func, ...)
        if not (Func and typeof(Func) == "function") then
            return
        end

        local Result = table.pack(xpcall(Func, function(Error)
            task.defer(error, debug.traceback(Error, 2))
            if Library.NotifyOnError then
                Library:Notify(Error)
            end

            return Error
        end, ...))

        if not Result[1] then
            return nil
        end

        return table.unpack(Result, 2, Result.n)
    end

    function Library:MakeDraggable(UI, DragFrame, IgnoreToggled, IsMainWindow)
        local Dragging ,StartPos
,FramePos
,Changed
=false
        DragFrame.InputBegan:Connect(function(Input)
            if not IsClickInput(Input) or IsMainWindow and Library.CantDragForced then
                return
            end

            StartPos = Input.Position
            FramePos = UI.Position
            Dragging = true

            Changed = Input.Changed:Connect(function()
                if Input.UserInputState ~= Enum.UserInputState.End then
                    return
                end

                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end
            end)
        end)
        Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input)
            if
                (not IgnoreToggled and not Library.Toggled)
                or (IsMainWindow and Library.CantDragForced)
                or not (ScreenGui and ScreenGui.Parent)
            then
                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end

                return
            end

            if Dragging and IsHoverInput(Input) then
                local Delta = Input.Position - StartPos
                UI.Position =
                    UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
            end
        end))
    end

    function Library:MakeResizable(UI, DragFrame, Callback)
        local Dragging ,StartPos
,FrameSize
,Changed
=false

        DragFrame.InputBegan:Connect(function(Input)
            if not IsClickInput(Input) then
                return
            end

            StartPos = Input.Position
            FrameSize = UI.Size
            Dragging = true

            Changed = Input.Changed:Connect(function()
                if Input.UserInputState ~= Enum.UserInputState.End then
                    return
                end

                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end
            end)
        end)

        Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input)
            if not UI.Visible or not (ScreenGui and ScreenGui.Parent) then
                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end

                return
            end

            if Dragging and IsHoverInput(Input) then
                local Delta = Input.Position - StartPos
                UI.Size = UDim2.new(
                    FrameSize.X.Scale,
                    math.clamp(FrameSize.X.Offset + Delta.X, Library.MinSize.X, math.huge),
                    FrameSize.Y.Scale,
                    math.clamp(FrameSize.Y.Offset + Delta.Y, Library.MinSize.Y, math.huge)
                )
                if Callback then
                    Library:SafeCallback(Callback)
                end
            end
        end))
    end

    function Library:MakeCover(Holder, Place)
        local Pos ,Size = Places[Place] or { 0, 0 }
,Sizes[Place] or { 1, 0.5 }

        local Cover = New("Frame", {
            AnchorPoint = Vector2.new(Pos[1], Pos[2]),
            BackgroundColor3 = Holder.BackgroundColor3,
            Position = UDim2.fromScale(Pos[1], Pos[2]),
            Size = UDim2.fromScale(Size[1], Size[2]),
            Parent = Holder,
        })

        return Cover
    end

    function Library:MakeLine(Frame, Info)
        local Line = New("Frame", {
            AnchorPoint = Info.AnchorPoint or Vector2.zero,
            BackgroundColor3 = "OutlineColor",
            Position = Info.Position,
            Size = Info.Size,
            ZIndex = Info.ZIndex or Frame.ZIndex,
            Parent = Frame,
        })

        return Line
    end

    function Library:AddOutline(Frame)
        local OutlineStroke ,ShadowStroke = New("UIStroke", {
            Color = "OutlineColor",
            Thickness = 1,
            ZIndex = 2,
            Parent = Frame,
        })
,New("UIStroke", {
            Color = "DarkColor",
            Thickness = 1.5,
            ZIndex = 1,
            Parent = Frame,
        })
        return OutlineStroke, ShadowStroke
    end

    function Library:AddBlank(Frame, Size)
        return New("Frame", {
            BackgroundTransparency = 1,
            Size = Size or UDim2.fromScale(0, 0),
            Parent = Frame,
        })
    end

    --// Deprecated \\--
    function Library:MakeOutline(Frame, Corner, ZIndex)
        warn("Obsidian:MakeOutline is deprecated, please use Obsidian:AddOutline instead.")
        local Holder = New("Frame", {
            BackgroundColor3 = "DarkColor",
            Position = UDim2.fromOffset(-2, -2),
            Size = UDim2.new(1, 4, 1, 4),
            ZIndex = ZIndex,
            Parent = Frame,
        })

        local Outline = New("Frame", {
            BackgroundColor3 = "OutlineColor",
            Position = UDim2.fromOffset(1, 1),
            Size = UDim2.new(1, -2, 1, -2),
            ZIndex = ZIndex,
            Parent = Holder,
        })

        if Corner and Corner > 0 then
            New("UICorner", {
                CornerRadius = UDim.new(0, Corner + 1),
                Parent = Holder,
            })
            New("UICorner", {
                CornerRadius = UDim.new(0, Corner),
                Parent = Outline,
            })
        end

        return Holder, Outline
    end

    function Library:AddDraggableLabel(Text)
        local Table ,Label = {}
,New("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.XY,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundColor3 = "BackgroundColor",
            Size = UDim2.fromOffset(0, 0),
            Position = UDim2.fromOffset(6, 6),
            Text = Text,
            TextSize = 15,
            ZIndex = 10,
            Parent = ScreenGui,
        })
        table.insert(
            Library.Corners, 
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius),
                Parent = Label,
            })
        )
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 6),
            Parent = Label,
        })
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = Label,
            })
        )
        Library:AddOutline(Label)

        Library:MakeDraggable(Label, Label, true)

        Table.Label = Label

        function Table:SetText(Text)
            Label.Text = Text
        end

        function Table:SetVisible(Visible)
            Label.Visible = Visible
        end

        return Table
    end

    function Library:AddDraggableButton(Text, Func, ExcludeScaling)
        local Table ,Button = {}
,New("TextButton", {
            BackgroundColor3 = "BackgroundColor",
            Position = UDim2.fromOffset(6, 6),
            TextSize = 16,
            ZIndex = 10,
            Parent = ScreenGui,
        })
        table.insert(
            Library.Corners, 
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius),
                Parent = Button,
            })
        )
        if not ExcludeScaling then
            table.insert(
                Library.Scales,
                New("UIScale", {
                    Parent = Button,
                })
            )
        end
        Library:AddOutline(Button)

        Button.MouseButton1Click:Connect(function()
            Library:SafeCallback(Func, Table)
        end)
        Library:MakeDraggable(Button, Button, true)

        Table.Button = Button

        function Table:SetText(Text)
            local X, Y = Library:GetTextBounds(Text, Library.Scheme.Font, 16)

            Button.Text = Text
            Button.Size = UDim2.fromOffset(X * 2, Y * 2)
        end
        Table:SetText(Text)

        return Table
    end

    function Library:AddDraggableMenu(Name)
        local Holder = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundColor3 = "BackgroundColor",
            Position = UDim2.fromOffset(6, 6),
            Size = UDim2.fromOffset(0, 0),
            ZIndex = 10,
            Parent = ScreenGui,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius),
                Parent = Holder,
            })
        )
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = Holder,
            })
        )
        Library:AddOutline(Holder)

        Library:MakeLine(Holder, {
            Position = UDim2.fromOffset(0, 34),
            Size = UDim2.new(1, 0, 0, 1),
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 34),
            Text = Name,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            Parent = Label,
        })

        local Container = New("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 35),
            Size = UDim2.new(1, 0, 1, -35),
            Parent = Holder,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 7),
            Parent = Container,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 7),
            PaddingLeft = UDim.new(0, 7),
            PaddingRight = UDim.new(0, 7),
            PaddingTop = UDim.new(0, 7),
            Parent = Container,
        })

        Library:MakeDraggable(Holder, Label, true)
        return Holder, Container
    end

    --// Watermark - Deprecated \\--
    do
        local WatermarkLabel = Library:AddDraggableLabel("")
        WatermarkLabel:SetVisible(false)

        function Library:SetWatermark(Text)
            warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
            WatermarkLabel:SetText(Text)
        end

        function Library:SetWatermarkVisibility(Visible)
            warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
            WatermarkLabel:SetVisible(Visible)
        end
    end

    --// Context Menu \\--
    local CurrentMenu
    function Library:AddContextMenu(
        Holder,
        Size,
        Offset,
        List,
        ActiveCallback,
        IgnoreCornerRadius    )
        local ParentGui ,Menu
=(Holder:FindFirstAncestorOfClass("ScreenGui")
)        if ParentGui ~= ScreenGui and (Library.ActiveLoading and ParentGui ~= Library.ActiveLoading.ScreenGui) then
            ParentGui = ScreenGui
        end

        if List then
            Menu = New("ScrollingFrame", {
                AutomaticCanvasSize = List == 2 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
                AutomaticSize = List == 1 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
                BackgroundColor3 = "BackgroundColor",
                BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
                CanvasSize = UDim2.fromOffset(0, 0),
                ScrollBarImageColor3 = "OutlineColor",
                ScrollBarThickness = List == 2 and 2 or 0,
                Size = typeof(Size) == "function" and Size() or Size,
                TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
                Visible = false,
                ZIndex = 10,
                Parent = ParentGui,
            })
        else
            Menu = New("Frame", {
                BackgroundColor3 = "BackgroundColor",
                Size = typeof(Size) == "function" and Size() or Size,
                Visible = false,
                ZIndex = 10,
                Parent = ParentGui,
            })
        end
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = Menu,
            })
        )

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Menu,
        })

        if IgnoreCornerRadius ~= true then
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Menu,
                })
            )
        end

        local Table = {
            Active = false,
            Holder = Holder,
            Menu = Menu,
            List = nil,
            Signal = nil,

            Size = Size,
        }

        if List then
            Table.List = New("UIListLayout", {
                Parent = Menu,
            })
        end

        function Table:Open()
            if CurrentMenu == Table then
                return
            elseif CurrentMenu then
                CurrentMenu:Close()
            end

            CurrentMenu = Table
            Table.Active = true

            if typeof(Offset) == "function" then
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset()[2])
                )
            else
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset[2])
                )
            end
            Menu.Size = typeof(Table.Size) == "function" and Table.Size() or Table.Size
            if typeof(ActiveCallback) == "function" then
                Library:SafeCallback(ActiveCallback, true)
            end

            Menu.Visible = true

            Table.Signal = Holder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                if typeof(Offset) == "function" then
                    Menu.Position = UDim2.fromOffset(
                        math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                        math.floor(Holder.AbsolutePosition.Y + Offset()[2])
                    )
                else
                    Menu.Position = UDim2.fromOffset(
                        math.floor(Holder.AbsolutePosition.X + Offset[1]),
                        math.floor(Holder.AbsolutePosition.Y + Offset[2])
                    )
                end
            end)
        end

        function Table:Close()
            if CurrentMenu ~= Table then
                return
            end
            Menu.Visible = false

            if Table.Signal then
                Table.Signal:Disconnect()
                Table.Signal = nil
            end
            Table.Active = false
            CurrentMenu = nil
            if typeof(ActiveCallback) == "function" then
                Library:SafeCallback(ActiveCallback, false)
            end
        end

        function Table:Toggle()
            if Table.Active then
                Table:Close()
            else
                Table:Open()
            end
        end

        function Table:SetSize(Size)
            Table.Size = Size
            Menu.Size = typeof(Size) == "function" and Size() or Size
        end

        return Table
    end

    Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input)
        if Library.Unloaded then
            return
        end

        if IsClickInput(Input, true) then
            local Location = Input.Position

            if
                CurrentMenu
                and not (
                    Library:MouseIsOverFrame(CurrentMenu.Menu, Location)
                        or Library:MouseIsOverFrame(CurrentMenu.Holder, Location)
                )
            then
                CurrentMenu:Close()
            end
        end
    end))

    --// Tooltip \\--
    local TooltipLabel = New("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = "BackgroundColor",
        TextSize = 14,
        TextWrapped = true,
        Visible = false,
        ZIndex = 20,
        Parent = ScreenGui,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 2),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        PaddingTop = UDim.new(0, 2),
        Parent = TooltipLabel,
    })
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = TooltipLabel,
        })
    )
    New("UIStroke", {
        Color = "OutlineColor",
        Parent = TooltipLabel,
    })
    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = TooltipLabel,
        })
    )
    TooltipLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        if Library.Unloaded then
            return
        end
local X=Library:GetTextBounds(
            TooltipLabel.Text,
            TooltipLabel.FontFace,
            TooltipLabel.TextSize,
            (workspace.CurrentCamera.ViewportSize.X - TooltipLabel.AbsolutePosition.X - 8) / Library.DPIScale
        )

        TooltipLabel.Size = UDim2.fromOffset(X + 8)
    end)

    local CurrentHoverInstance
    function Library:AddTooltip(InfoStr, DisabledInfoStr, HoverInstance)
        local TooltipTable = {
            Disabled = false,
            Hovering = false,
            Signals = {},
        }

        local function DoHover()
            if
                CurrentHoverInstance == HoverInstance
                or Library.ActiveDialog
                or (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
                or (TooltipTable.Disabled and typeof(DisabledInfoStr) ~= "string")
                or (not TooltipTable.Disabled and typeof(InfoStr) ~= "string")
            then
                return
            end
            CurrentHoverInstance = HoverInstance

            local ParentGui = HoverInstance:FindFirstAncestorOfClass("ScreenGui")
            if ParentGui ~= ScreenGui and (Library.ActiveLoading and ParentGui ~= Library.ActiveLoading.ScreenGui) then
                ParentGui = ScreenGui
            end
            TooltipLabel.Parent = ParentGui

            TooltipLabel.Text = TooltipTable.Disabled and DisabledInfoStr or InfoStr
            TooltipLabel.Visible = true

            while
                (Library.Toggled or Library.ActiveLoading)
                and not Library.ActiveDialog
                and Library:MouseIsOverFrame(HoverInstance, Mouse)
                and not (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
            do
                TooltipLabel.Position = UDim2.fromOffset(
                    Mouse.X + (Library.ShowCustomCursor and 8 or 14),
                    Mouse.Y + (Library.ShowCustomCursor and 8 or 12)
                )

                RunService.RenderStepped:Wait()
            end

            TooltipLabel.Visible = false
            CurrentHoverInstance = nil
        end

        local function GiveSignal(Connection)
            local ConnectionType = typeof(Connection)
            if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
                table.insert(TooltipTable.Signals, Connection)
            end

            return Connection
        end

        GiveSignal(HoverInstance.MouseEnter:Connect(DoHover))
        GiveSignal(HoverInstance.MouseMoved:Connect(DoHover))
        GiveSignal(HoverInstance.MouseLeave:Connect(function()
            if CurrentHoverInstance ~= HoverInstance then
                return
            end

            TooltipLabel.Visible = false
            CurrentHoverInstance = nil
        end))

        function TooltipTable:Destroy()
            for Index = #TooltipTable.Signals, 1, -1 do
                local Connection = table.remove(TooltipTable.Signals, Index)
                if Connection and Connection.Connected then
                    Connection:Disconnect()
                end
            end

            if CurrentHoverInstance == HoverInstance then
                if TooltipLabel then
                    TooltipLabel.Visible = false
                end

                CurrentHoverInstance = nil
            end
        end

        table.insert(Tooltips, TooltipLabel)
        return TooltipTable
    end

    function Library:OnUnload(Callback)
        table.insert(Library.UnloadSignals, Callback)
    end

    function Library:Unload()
        for Index = #Library.Signals, 1, -1 do
            local Connection = table.remove(Library.Signals, Index)
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
        end

        for _, Callback in Library.UnloadSignals do
            Library:SafeCallback(Callback)
        end

        for _, Tooltip in Tooltips do
            Library:SafeCallback(Tooltip.Destroy, Tooltip)
        end

        Library.Unloaded = true

        if Library.ActiveLoading then
            Library.ActiveLoading:Destroy()
        end

        if ScreenGui then
            ScreenGui:Destroy()
        end

        getgenv().Library = nil
    end

    local CheckIcon ,ArrowIcon ,ResizeIcon ,KeyIcon ,MoveIcon = Library:GetIcon("check")
,Library:GetIcon("chevron-up")
,Library:GetIcon("move-diagonal-2")
,Library:GetIcon("key")
,Library:GetIcon("move")

    function Library:SetIconModule(module)
        FetchIcons = true
        Icons = module

        -- Top ten fixes 🚀
        CheckIcon = Library:GetIcon("check")
        ArrowIcon = Library:GetIcon("chevron-up")
        ResizeIcon = Library:GetIcon("move-diagonal-2")
        KeyIcon = Library:GetIcon("key")
        MoveIcon = Library:GetIcon("move")
    end

    local BaseAddons = {}
    do
        local Funcs = {}

        function Funcs:AddKeyPicker(Idx, Info)
            Info = Library:Validate(Info, Templates.KeyPicker)

            local ParentObj = self
            local ToggleLabel ,KeyPicker = ParentObj.TextLabel
,{
                Text = Info.Text,
                Value = Info.Default, -- Key
                Modifiers = Info.DefaultModifiers, -- Modifiers
                DisplayValue = Info.Default, -- Picker Text

                Blacklisted = Info.Blacklisted,
                BlacklistedModifiers = Info.BlacklistedModifiers,
                Whitelisted = Info.Whitelisted,
                WhitelistedModifiers = Info.WhitelistedModifiers,

                Toggled = false,
                Mode = Info.Mode,
                SyncToggleState = Info.SyncToggleState,

                Callback = Info.Callback,
                ChangedCallback = Info.ChangedCallback,
                Changed = Info.Changed,
                Clicked = Info.Clicked,

                Type = "KeyPicker",
            }

            if KeyPicker.Mode == "Press" then
                assert(ParentObj.Type == "Label", "KeyPicker with the mode 'Press' can be only applied on Labels.")

                KeyPicker.SyncToggleState = false
                Info.Modes = { "Press" }
                Info.Mode = "Press"
            end

            if KeyPicker.SyncToggleState then
                Info.Modes = { "Toggle", "Hold" }

                if not table.find(Info.Modes, Info.Mode) then
                    Info.Mode = "Toggle"
                end
            end

            local Picking ,SpecialKeys ,SpecialKeysInput ,Modifiers ,ModifiersInput = false
,{
MB1=Enum.UserInputType.MouseButton1,
MB2=Enum.UserInputType.MouseButton2,
MB3=Enum.UserInputType.MouseButton3,
            }
,{
                [Enum.UserInputType.MouseButton1] = "MB1",
                [Enum.UserInputType.MouseButton2] = "MB2",
                [Enum.UserInputType.MouseButton3] = "MB3",
            }
,{
LAlt=Enum.KeyCode.LeftAlt,
RAlt=Enum.KeyCode.RightAlt,
LCtrl=Enum.KeyCode.LeftControl,
RCtrl=Enum.KeyCode.RightControl,
LShift=Enum.KeyCode.LeftShift,
RShift=Enum.KeyCode.RightShift,
Tab=Enum.KeyCode.Tab,
CapsLock=Enum.KeyCode.CapsLock,
            }
,{
                [Enum.KeyCode.LeftAlt] = "LAlt",
                [Enum.KeyCode.RightAlt] = "RAlt",

                [Enum.KeyCode.LeftControl] = "LCtrl",
                [Enum.KeyCode.RightControl] = "RCtrl",

                [Enum.KeyCode.LeftShift] = "LShift",
                [Enum.KeyCode.RightShift] = "RShift",

                [Enum.KeyCode.Tab] = "Tab",
                [Enum.KeyCode.CapsLock] = "CapsLock",
            }

            local IsModifierInput ,GetActiveModifiers = function(Input)
                return Input.UserInputType == Enum.UserInputType.Keyboard and ModifiersInput[Input.KeyCode] ~= nil
            end
,function()
                local ActiveModifiers = {}

                for Name, Input in Modifiers do
                    if table.find(ActiveModifiers, Name) then
                        continue
                    end
                    if not UserInputService:IsKeyDown(Input) then
                        continue
                    end

                    table.insert(ActiveModifiers, Name)
                end

                return ActiveModifiers
            end

            local AreModifiersHeld ,IsInputDown ,ConvertToInputModifiers ,VerifyModifiers = function(Required)
                if not (typeof(Required) == "table" and GetTableSize(Required) > 0) then
                    return true
                end

                local ActiveModifiers ,Holding = GetActiveModifiers()
,true

                for _, Name in Required do
                    if table.find(ActiveModifiers, Name) then
                        continue
                    end

                    Holding = false
                    break
                end

                return Holding
            end
,function(Input)
                if not Input then
                    return false
                end

                if SpecialKeysInput[Input.UserInputType] ~= nil then
                    return UserInputService:IsMouseButtonPressed(Input.UserInputType)
                        and not UserInputService:GetFocusedTextBox()
                elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                    return UserInputService:IsKeyDown(Input.KeyCode) and not UserInputService:GetFocusedTextBox()
                else
                    return false
                end
            end
,function(CurrentModifiers)
                local InputModifiers = {}

                for _, name in CurrentModifiers do
                    table.insert(InputModifiers, Modifiers[name])
                end

                return InputModifiers
            end
,function(CurrentModifiers)
                if typeof(CurrentModifiers) ~= "table" then
                    return {}
                end

                local ValidModifiers = {}

                for _, name in CurrentModifiers do
                    if not Modifiers[name] then
                        continue
                    end

                    table.insert(ValidModifiers, name)
                end

                return ValidModifiers
            end

            KeyPicker.Modifiers = VerifyModifiers(KeyPicker.Modifiers)

            local Picker = New("TextButton", {
                BackgroundColor3 = "MainColor",
                Size = UDim2.fromOffset(18, 18),
                Text = KeyPicker.Value,
                TextSize = 14,
                Parent = ToggleLabel,
            })

            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Picker,
            })

            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Picker,
                })
            )

            local KeybindsToggle = { Normal = KeyPicker.Mode ~= "Toggle" }
            do
                local Holder = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    Text = "",
                    Visible = not Info.NoUI,
                    Parent = Library.KeybindContainer,
                })

                local Label ,Checkbox = New("TextLabel", {
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(0, 1),
                    Text = "",
                    TextSize = 14,
                    TextTransparency = 0.5,
                    Parent = Holder,
                })
,New("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = "MainColor",
                    Position = UDim2.fromScale(0, 0.5),
                    Size = UDim2.fromOffset(14, 14),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    Parent = Holder,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                        Parent = Checkbox,
                    })
                )
                New("UIStroke", {
                    Color = "OutlineColor",
                    Parent = Checkbox,
                })

                local CheckImage = New("ImageLabel", {
                    Image = CheckIcon and CheckIcon.Url or "",
                    ImageColor3 = "FontColor",
                    ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
                    ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
                    ImageTransparency = 1,
                    Position = UDim2.fromOffset(2, 2),
                    Size = UDim2.new(1, -4, 1, -4),
                    Parent = Checkbox,
                })

                function KeybindsToggle:Display(State)
                    Label.TextTransparency = State and 0 or 0.5
                    CheckImage.ImageTransparency = State and 0 or 1
                end

                function KeybindsToggle:SetText(Text)
                    Label.Text = Text
                end

                function KeybindsToggle:SetVisibility(Visibility)
                    Holder.Visible = Visibility
                end

                function KeybindsToggle:SetNormal(Normal)
                    KeybindsToggle.Normal = Normal

                    Holder.Active = not Normal
                    Label.Position = Normal and UDim2.fromOffset(0, 0) or UDim2.fromOffset(22, 0)
                    Checkbox.Visible = not Normal
                end

                KeyPicker.DoClick = function(...) end --// make luau lsp shut up
                Holder.MouseButton1Click:Connect(function()
                    if KeybindsToggle.Normal then
                        return
                    end

                    KeyPicker.Toggled = not KeyPicker.Toggled
                    KeyPicker:DoClick()
                end)

                KeybindsToggle.Holder = Holder
                KeybindsToggle.Label = Label
                KeybindsToggle.Checkbox = Checkbox
                KeybindsToggle.Loaded = true
                table.insert(Library.KeybindToggles, KeybindsToggle)
            end

            local MenuTable = Library:AddContextMenu(Picker, UDim2.fromOffset(62, 0), function()
                return { Picker.AbsoluteSize.X + 1.5, 0.5 }
            end, 1, nil, true)
            KeyPicker.Menu = MenuTable

            local ModeButtons = {}
            for _, Mode in Info.Modes do
                local ModeButton ,Button = {}
,New("TextButton", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 21),
                    Text = Mode,
                    TextSize = 14,
                    TextTransparency = 0.5,
                    Parent = MenuTable.Menu,
                })

                function ModeButton:Select()
                    for _, Button in ModeButtons do
                        Button:Deselect()
                    end

                    KeyPicker.Mode = Mode

                    Button.BackgroundTransparency = 0
                    Button.TextTransparency = 0

                    MenuTable:Close()
                end

                function ModeButton:Deselect()
                    KeyPicker.Mode = nil

                    Button.BackgroundTransparency = 1
                    Button.TextTransparency = 0.5
                end

                Button.MouseButton1Click:Connect(function()
                    ModeButton:Select()
                end)

                if KeyPicker.Mode == Mode then
                    ModeButton:Select()
                end

                ModeButtons[Mode] = ModeButton
            end

            function KeyPicker:Display(PickerText)
                if Library.Unloaded then
                    return
                end

                local X, Y = Library:GetTextBounds(
                    PickerText or KeyPicker.DisplayValue,
                    Picker.FontFace,
                    Picker.TextSize,
                    ToggleLabel.AbsoluteSize.X
                )
                Picker.Text = PickerText or KeyPicker.DisplayValue
                Picker.Size = UDim2.fromOffset((X + 9), (Y + 4))
            end

            function KeyPicker:Update()
                KeyPicker:Display()

                if Info.NoUI then
                    return
                end

                if KeyPicker.Mode == "Toggle" and ParentObj.Type == "Toggle" and ParentObj.Disabled then
                    KeybindsToggle:SetVisibility(false)
                    return
                end

                local State ,ShowToggle = KeyPicker:GetState()
,Library.ShowToggleFrameInKeybinds and KeyPicker.Mode == "Toggle"

                if KeyPicker.SyncToggleState and ParentObj.Value ~= State then
                    ParentObj:SetValue(State)
                end

                if KeybindsToggle.Loaded then
                    if ShowToggle then
                        KeybindsToggle:SetNormal(false)
                    else
                        KeybindsToggle:SetNormal(true)
                    end

                    KeybindsToggle:SetText(("[%s] %s (%s)"):format(KeyPicker.DisplayValue, KeyPicker.Text, KeyPicker.Mode))
                    KeybindsToggle:SetVisibility(true)
                    KeybindsToggle:Display(State)
                end
            end

            function KeyPicker:GetState()
                if KeyPicker.Mode == "Always" then
                    return true
                elseif KeyPicker.Mode == "Hold" then
                    local Key = KeyPicker.Value
                    if Key == "None" then
                        return false
                    end

                    if not AreModifiersHeld(KeyPicker.Modifiers) then
                        return false
                    end

                    if SpecialKeys[Key] ~= nil then
                        return UserInputService:IsMouseButtonPressed(SpecialKeys[Key])
                            and not UserInputService:GetFocusedTextBox()
                    else
                        return UserInputService:IsKeyDown(Enum.KeyCode[Key]) and not UserInputService:GetFocusedTextBox()
                    end
                else
                    return KeyPicker.Toggled
                end
            end

            function KeyPicker:OnChanged(Func)
                KeyPicker.Changed = Func
            end

            function KeyPicker:OnClick(Func)
                KeyPicker.Clicked = Func
            end

            function KeyPicker:DoClick()
                if KeyPicker.Mode == "Press" then
                    if KeyPicker.Toggled and Info.WaitForCallback == true then
                        return
                    end

                    KeyPicker.Toggled = true
                end

                Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
                Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)

                if KeyPicker.Mode == "Press" then
                    KeyPicker.Toggled = false
                end
            end

            function KeyPicker:SetValue(Data)
                local Key, Mode, Modifiers = Data[1], Data[2], Data[3]

                local IsKeyValid, KeyCode = pcall(function()
                    if Key == "None" then
                        Key = nil
                        return nil
                    end

                    if SpecialKeys[Key] == nil then
                        return Enum.KeyCode[Key]
                    end

                    return SpecialKeys[Key]
                end)

                if Key == nil then
                    KeyPicker.Value = "None"
                elseif IsKeyValid then
                    KeyPicker.Value = Key
                else
                    KeyPicker.Value = "Unknown"
                end

                KeyPicker.Modifiers =
                    VerifyModifiers(if typeof(Modifiers) == "table" then Modifiers else KeyPicker.Modifiers)
                KeyPicker.DisplayValue = if GetTableSize(KeyPicker.Modifiers) > 0
                    then (table.concat(KeyPicker.Modifiers, " + ") .. " + " .. KeyPicker.Value)
                    else KeyPicker.Value

                if ModeButtons[Mode] then
                    ModeButtons[Mode]:Select()
                end

                local NewModifiers = ConvertToInputModifiers(KeyPicker.Modifiers)
                Library:SafeCallback(KeyPicker.ChangedCallback, KeyCode, NewModifiers)
                Library:SafeCallback(KeyPicker.Changed, KeyCode, NewModifiers)

                KeyPicker:Update()
            end

            function KeyPicker:SetText(Text)
                KeybindsToggle:SetText(Text)
                KeyPicker:Update()
            end

            Picker.MouseButton1Click:Connect(function()
                if Picking then
                    return
                end

                Picking = true

                Picker.Text = "..."
                Picker.Size = UDim2.fromOffset(29, 18)

                -- Wait for an non modifier key --
                local ActiveModifiers ,Input
,GetInput ={}
GetInput = function()
                    Input = UserInputService.InputBegan:Wait()
                    if UserInputService:GetFocusedTextBox() ~= nil then
                        return true
                    end

                    if Input.KeyCode == Enum.KeyCode.Escape then
                        return false
                    end

                    local IsMod ,KeyName
=(IsModifierInput(Input)
)                    if SpecialKeysInput[Input.UserInputType] ~= nil then
                        KeyName = SpecialKeysInput[Input.UserInputType]
                    elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                        if IsMod then
                            KeyName = ModifiersInput[Input.KeyCode]
                        else
                            KeyName = Input.KeyCode.Name
                        end
                    end

                    if KeyName then
                        if IsMod then
                            if KeyPicker.WhitelistedModifiers and #KeyPicker.WhitelistedModifiers > 0 and not table.find(KeyPicker.WhitelistedModifiers, KeyName) then
                                return GetInput()
                            end

                            if KeyPicker.BlacklistedModifiers and table.find(KeyPicker.BlacklistedModifiers, KeyName) then
                                return GetInput()
                            end
                        else
                            if KeyPicker.Whitelisted and #KeyPicker.Whitelisted > 0 and not table.find(KeyPicker.Whitelisted, KeyName) then
                                return GetInput()
                            end

                            if KeyPicker.Blacklisted and table.find(KeyPicker.Blacklisted, KeyName) then
                                return GetInput()
                            end
                        end
                    end

                    return false
                end

                repeat
                    task.wait()

                    -- Wait for any input --
                    Picker.Text = "..."
                    Picker.Size = UDim2.fromOffset(29, 18)

                    if GetInput() then
                        Picking = false
                        KeyPicker:Update()
                        return
                    end

                    -- Escape --
                    if Input.KeyCode == Enum.KeyCode.Escape then
                        break
                    end

                    -- Handle modifier keys --
                    if IsModifierInput(Input) then
                        local StopLoop = false

                        repeat
                            task.wait()
                            if UserInputService:IsKeyDown(Input.KeyCode) then
                                task.wait(0.075)

                                if UserInputService:IsKeyDown(Input.KeyCode) then
                                    -- Add modifier to the key list --
                                    if not table.find(ActiveModifiers, ModifiersInput[Input.KeyCode]) then
                                        ActiveModifiers[#ActiveModifiers + 1] = ModifiersInput[Input.KeyCode]
                                        KeyPicker:Display(table.concat(ActiveModifiers, " + ") .. " + ...")
                                    end

                                    -- Wait for another input --
                                    if GetInput() then
                                        StopLoop = true
                                        break -- Invalid Input
                                    end

                                    -- Escape --
                                    if Input.KeyCode == Enum.KeyCode.Escape then
                                        break
                                    end

                                    -- Stop loop if its a normal key --
                                    if not IsModifierInput(Input) then
                                        break
                                    end
                                else
                                    if not table.find(ActiveModifiers, ModifiersInput[Input.KeyCode]) then
                                        break -- Modifier is meant to be used as a normal key --
                                    end
                                end
                            end
                        until false

                        if StopLoop then
                            Picking = false
                            KeyPicker:Update()
                            return
                        end
                    end

                    break -- Input found, end loop
                until false

                local Key = "Unknown"
                if SpecialKeysInput[Input.UserInputType] ~= nil then
                    Key = SpecialKeysInput[Input.UserInputType]
                elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                    Key = Input.KeyCode == Enum.KeyCode.Escape and "None" or Input.KeyCode.Name
                end

                ActiveModifiers = if Input.KeyCode == Enum.KeyCode.Escape or Key == "Unknown" then {} else ActiveModifiers

                KeyPicker.Toggled = false
                KeyPicker:SetValue({ Key, KeyPicker.Mode, ActiveModifiers })

                -- RunService.RenderStepped:Wait()
                repeat
                    task.wait()
                until not IsInputDown(Input) or UserInputService:GetFocusedTextBox()
                Picking = false
            end)
            Picker.MouseButton2Click:Connect(MenuTable.Toggle)

            Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input)
                if Library.Unloaded then
                    return
                end

                if
                    KeyPicker.Mode == "Always"
                    or KeyPicker.Value == "Unknown"
                    or KeyPicker.Value == "None"
                    or Picking
                    or UserInputService:GetFocusedTextBox()
                then
                    return
                end

                local Key ,HoldingModifiers ,HoldingKey = KeyPicker.Value
,AreModifiersHeld(KeyPicker.Modifiers)
,false

                if
                    Key
                    and HoldingModifiers == true
                    and (
                        SpecialKeysInput[Input.UserInputType] == Key
                            or (Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Key)
                    )
                then
                    HoldingKey = true
                end

                if KeyPicker.Mode == "Toggle" then
                    if HoldingKey then
                        KeyPicker.Toggled = not KeyPicker.Toggled
                        KeyPicker:DoClick()
                    end
                elseif KeyPicker.Mode == "Press" then
                    if HoldingKey then
                        KeyPicker:DoClick()
                    end
                end

                KeyPicker:Update()
            end))

            Library:GiveSignal(UserInputService.InputEnded:Connect(function()
                if Library.Unloaded then
                    return
                end

                if
                    KeyPicker.Value == "Unknown"
                    or KeyPicker.Value == "None"
                    or Picking
                    or UserInputService:GetFocusedTextBox()
                then
                    return
                end

                KeyPicker:Update()
            end))

            KeyPicker:Update()

            if ParentObj.Addons then
                table.insert(ParentObj.Addons, KeyPicker)
            end

            KeyPicker.Default = KeyPicker.Value
            KeyPicker.DefaultModifiers = table.clone(KeyPicker.Modifiers or {})

            Options[Idx] = KeyPicker

            return self
        end

        local HueSequenceTable = {}
        for Hue = 0, 1, 0.1 do
            table.insert(HueSequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
        end
        function Funcs:AddColorPicker(Idx, Info)
            Info = Library:Validate(Info, Templates.ColorPicker)

            local ParentObj = self
            local ToggleLabel ,ColorPicker = ParentObj.TextLabel
,{
                Value = Info.Default,

                Transparency = Info.Transparency or 0,
                Title = Info.Title,

                Callback = Info.Callback,
                Changed = Info.Changed,

                Type = "ColorPicker",
            }
            ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = ColorPicker.Value:ToHSV()

            local Holder = New("TextButton", {
                BackgroundColor3 = ColorPicker.Value,
                Size = UDim2.fromOffset(18, 18),
                Text = "",
                Parent = ToggleLabel,
            })

            local HolderStroke = New("UIStroke", {
                Color = Library:GetDarkerColor(ColorPicker.Value),
                Parent = Holder,
            })

            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Holder,
                })
            )

            local HolderTransparency = New("ImageLabel", {
                Image = CustomImageManager.GetAsset("TransparencyTexture"),
                ImageTransparency = (1 - ColorPicker.Transparency),
                ScaleType = Enum.ScaleType.Tile,
                Position = UDim2.new(0, -1, 0, -1),
                Size = UDim2.new(1, 2, 1, 2),
                TileSize = UDim2.fromOffset(9, 9),
                Parent = Holder,
            })

            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = HolderTransparency,
                })
            )

            --// Color Menu \\--
            local ColorMenu = Library:AddContextMenu(
                Holder,
                UDim2.fromOffset(Info.Transparency and 256 or 234, 0),
                function()
                    return { 0.5, Holder.AbsoluteSize.Y + 1.5 }
                end,
                1
            )
            ColorMenu.List.Padding = UDim.new(0, 8)
            ColorPicker.ColorMenu = ColorMenu

            New("UIPadding", {
                PaddingBottom = UDim.new(0, 6),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                PaddingTop = UDim.new(0, 6),
                Parent = ColorMenu.Menu,
            })

            if typeof(ColorPicker.Title) == "string" then
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 8),
                    Text = ColorPicker.Title,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ColorMenu.Menu,
                })
            end

            local ColorHolder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 200),
                Parent = ColorMenu.Menu,
            })
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 6),
                Parent = ColorHolder,
            })

            --// Sat Map
            local SatVipMap = New("ImageButton", {
                BackgroundColor3 = ColorPicker.Value,
                Image = CustomImageManager.GetAsset("SaturationMap"),
                Size = UDim2.fromOffset(200, 200),
                Parent = ColorHolder,
            })

            local SatVibCursor = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = "WhiteColor",
                Size = UDim2.fromOffset(6, 6),
                Parent = SatVipMap,
            })
            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SatVibCursor,
            })
            New("UIStroke", {
                Color = "DarkColor",
                Parent = SatVibCursor,
            })

            --// Hue
            local HueSelector = New("TextButton", {
                Size = UDim2.fromOffset(16, 200),
                Text = "",
                Parent = ColorHolder,
            })
            New("UIGradient", {
                Color = ColorSequence.new(HueSequenceTable),
                Rotation = 90,
                Parent = HueSelector,
            })

            local HueCursor ,TransparencySelector,TransparencyColor,TransparencyCursor
=(New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = "WhiteColor",
                BorderColor3 = "DarkColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0.5, ColorPicker.Hue),
                Size = UDim2.new(1, 2, 0, 1),
                Parent = HueSelector,
            })
)            if Info.Transparency then
                TransparencySelector = New("ImageButton", {
                    Image = CustomImageManager.GetAsset("TransparencyTexture"),
                    ScaleType = Enum.ScaleType.Tile,
                    Size = UDim2.fromOffset(16, 200),
                    TileSize = UDim2.fromOffset(8, 8),
                    Parent = ColorHolder,
                })

                TransparencyColor = New("Frame", {
                    BackgroundColor3 = ColorPicker.Value,
                    Size = UDim2.fromScale(1, 1),
                    Parent = TransparencySelector,
                })
                New("UIGradient", {
                    Rotation = 90,
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(1, 1),
                    }),
                    Parent = TransparencyColor,
                })

                TransparencyCursor = New("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = "WhiteColor",
                    BorderColor3 = "DarkColor",
                    BorderSizePixel = 1,
                    Position = UDim2.fromScale(0.5, ColorPicker.Transparency),
                    Size = UDim2.new(1, 2, 0, 1),
                    Parent = TransparencySelector,
                })
            end

            local InfoHolder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Parent = ColorMenu.Menu,
            })
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDim.new(0, 8),
                Parent = InfoHolder,
            })

            local HueBox = New("TextBox", {
                BackgroundColor3 = "MainColor",
                ClearTextOnFocus = false,
                Size = UDim2.fromScale(1, 1),
                Text = "#??????",
                TextSize = 14,
                Parent = InfoHolder,
            })

            New("UIStroke", {
                Color = "OutlineColor",
                Parent = HueBox,
            })

            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = HueBox,
                })
            )

            local RgbBox = New("TextBox", {
                BackgroundColor3 = "MainColor",
                ClearTextOnFocus = false,
                Size = UDim2.fromScale(1, 1),
                Text = "?, ?, ?",
                TextSize = 14,
                Parent = InfoHolder,
            })

            New("UIStroke", {
                Color = "OutlineColor",
                Parent = RgbBox,
            })

            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = RgbBox,
                })
            )

            --// Context Menu \\--
            local ContextMenu = Library:AddContextMenu(Holder, UDim2.fromOffset(93, 0), function()
                return { Holder.AbsoluteSize.X + 1.5, 0.5 }
            end, 1)
            ColorPicker.ContextMenu = ContextMenu
            ContextMenu.List.Padding = UDim.new(0, 6)
            do
                local function CreateButton(Text, Func)
                    local Button = New("TextButton", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 21),
                        Text = Text,
                        TextSize = 14,
                        Parent = ContextMenu.Menu,
                    })

                    Button.MouseButton1Click:Connect(function()
                        Library:SafeCallback(Func)
                        ContextMenu:Close()
                    end)
                end

                CreateButton("Copy color", function()
                    Library.CopiedColor = { ColorPicker.Value, ColorPicker.Transparency }
                end)

                ColorPicker.SetValueRGB = function(...) end --// make luau lsp shut up
                CreateButton("Paste color", function()
                    ColorPicker:SetValueRGB(Library.CopiedColor[1], Library.CopiedColor[2])
                end)

                if setclipboard then
                    CreateButton("Copy Hex", function()
                        setclipboard(tostring(ColorPicker.Value:ToHex()))
                    end)

                    CreateButton("Copy RGB", function()
                        setclipboard(table.concat({
                            math.floor(ColorPicker.Value.R * 255),
                            math.floor(ColorPicker.Value.G * 255),
                            math.floor(ColorPicker.Value.B * 255),
                        }, ", "))
                    end)
                end
            end

            --// End \\--
            function ColorPicker:SetHSVFromRGB(Color)
                ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
            end

            function ColorPicker:Display()
                if Library.Unloaded then
                    return
                end

                ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)

                Holder.BackgroundColor3 = ColorPicker.Value
                HolderStroke.Color = Library:GetDarkerColor(ColorPicker.Value)
                HolderTransparency.ImageTransparency = (1 - ColorPicker.Transparency)

                SatVipMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1)
                if TransparencyColor then
                    TransparencyColor.BackgroundColor3 = ColorPicker.Value
                end

                SatVibCursor.Position = UDim2.fromScale(ColorPicker.Sat, 1 - ColorPicker.Vib)
                HueCursor.Position = UDim2.fromScale(0.5, ColorPicker.Hue)
                if TransparencyCursor then
                    TransparencyCursor.Position = UDim2.fromScale(0.5, ColorPicker.Transparency)
                end

                HueBox.Text = "#" .. ColorPicker.Value:ToHex()
                RgbBox.Text = table.concat({
                    math.floor(ColorPicker.Value.R * 255),
                    math.floor(ColorPicker.Value.G * 255),
                    math.floor(ColorPicker.Value.B * 255),
                }, ", ")
            end

            function ColorPicker:Update()
                ColorPicker:Display()

                Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value)
                Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value)
            end

            function ColorPicker:OnChanged(Func)
                ColorPicker.Changed = Func
            end

            function ColorPicker:SetValue(HSV, Transparency)
                if typeof(HSV) == "Color3" then
                    ColorPicker:SetValueRGB(HSV, Transparency)
                    return
                end

                local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])
                ColorPicker.Transparency = Info.Transparency and Transparency or 0
                ColorPicker:SetHSVFromRGB(Color)
                ColorPicker:Update()
            end

            function ColorPicker:SetValueRGB(Color, Transparency)
                ColorPicker.Transparency = Info.Transparency and Transparency or 0
                ColorPicker:SetHSVFromRGB(Color)
                ColorPicker:Update()
            end

            Holder.MouseButton1Click:Connect(ColorMenu.Toggle)
            Holder.MouseButton2Click:Connect(ContextMenu.Toggle)

            SatVipMap.InputBegan:Connect(function(Input)
                while IsDragInput(Input) do
                    local MinX = SatVipMap.AbsolutePosition.X
                    local MaxX = MinX + SatVipMap.AbsoluteSize.X
                    local LocationX ,MinY = math.clamp(Mouse.X, MinX, MaxX)
,SatVipMap.AbsolutePosition.Y
                    local MaxY = MinY + SatVipMap.AbsoluteSize.Y
                    local LocationY ,OldSat ,OldVib = math.clamp(Mouse.Y, MinY, MaxY)
,ColorPicker.Sat
,ColorPicker.Vib
                    ColorPicker.Sat = (LocationX - MinX) / (MaxX - MinX)
                    ColorPicker.Vib = 1 - ((LocationY - MinY) / (MaxY - MinY))

                    if ColorPicker.Sat ~= OldSat or ColorPicker.Vib ~= OldVib then
                        ColorPicker:Update()
                    end

                    RunService.RenderStepped:Wait()
                end
            end)
            HueSelector.InputBegan:Connect(function(Input)
                while IsDragInput(Input) do
                    local Min = HueSelector.AbsolutePosition.Y
                    local Max = Min + HueSelector.AbsoluteSize.Y
                    local Location ,OldHue = math.clamp(Mouse.Y, Min, Max)
,ColorPicker.Hue
                    ColorPicker.Hue = (Location - Min) / (Max - Min)

                    if ColorPicker.Hue ~= OldHue then
                        ColorPicker:Update()
                    end

                    RunService.RenderStepped:Wait()
                end
            end)
            if TransparencySelector then
                TransparencySelector.InputBegan:Connect(function(Input)
                    while IsDragInput(Input) do
                        local Min ,Max = TransparencySelector.AbsolutePosition.Y
,TransparencySelector.AbsolutePosition.Y + TransparencySelector.AbsoluteSize.Y
                        local Location ,OldTransparency = math.clamp(Mouse.Y, Min, Max)
,ColorPicker.Transparency
                        ColorPicker.Transparency = (Location - Min) / (Max - Min)

                        if ColorPicker.Transparency ~= OldTransparency then
                            ColorPicker:Update()
                        end

                        RunService.RenderStepped:Wait()
                    end
                end)
            end

            HueBox.FocusLost:Connect(function(Enter)
                if not Enter then
                    return
                end

                local Success, Color = pcall(Color3.fromHex, HueBox.Text)
                if Success and typeof(Color) == "Color3" then
                    ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
                end

                ColorPicker:Update()
            end)
            RgbBox.FocusLost:Connect(function(Enter)
                if not Enter then
                    return
                end

                local R, G, B = RgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
                if R and G and B then
                    ColorPicker:SetHSVFromRGB(Color3.fromRGB(R, G, B))
                end

                ColorPicker:Update()
            end)

            ColorPicker:Display()

            if ParentObj.Addons then
                table.insert(ParentObj.Addons, ColorPicker)
            end

            ColorPicker.Default = ColorPicker.Value

            Options[Idx] = ColorPicker

            return self
        end

        BaseAddons.__index = Funcs
        BaseAddons.__namecall = function(_, Key, ...)
            return Funcs[Key](...)
        end
    end

    local BaseGroupbox = {}
    do
        local Funcs = {}

        function Funcs:AddDivider(...)
            local Params ,MarginTop ,MarginBottom ,Text
= select(1, ...)
,0
,0

            if typeof(Params) == "table" then
                Text = Params.Text
                MarginTop = Params.MarginTop or Params.Margin or 0
                MarginBottom = Params.MarginBottom or Params.Margin or 0
            elseif typeof(Params) == "string" then
                Text = Params
            end

            local Groupbox = self
            local Container = Groupbox.Container

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 6 + MarginTop + MarginBottom),
                Parent = Container,
            })

            local InnerHolder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = Holder,
            })

            New("UIPadding", {
                PaddingTop = UDim.new(0, MarginTop),
                PaddingBottom = UDim.new(0, MarginBottom),
                Parent = Holder,
            })

            if Text then
                local TextLabel = New("TextLabel", {
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0),
                    Text = Text,
                    TextSize = 14,
                    TextTransparency = 0.5,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Parent = InnerHolder,
                })
local X=Library:GetTextBounds(Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
                local SizeX = X // 2 + 10

                New("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = "MainColor",
                    BorderColor3 = "OutlineColor",
                    BorderSizePixel = 1,
                    Position = UDim2.fromScale(0, 0.5),
                    Size = UDim2.new(0.5, -SizeX, 0, 2),
                    Parent = InnerHolder,
                })
                New("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = "MainColor",
                    BorderColor3 = "OutlineColor",
                    BorderSizePixel = 1,
                    Position = UDim2.fromScale(1, 0.5),
                    Size = UDim2.new(0.5, -SizeX, 0, 2),
                    Parent = InnerHolder,
                })
            else
                New("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = "MainColor",
                    BorderColor3 = "OutlineColor",
                    BorderSizePixel = 1,
                    Position = UDim2.fromScale(0, 0.5),
                    Size = UDim2.new(1, 0, 0, 2),
                    Parent = InnerHolder,
                })
            end

            Groupbox:Resize()

            local Divider = {
                Holder = Holder,
                Text = Text,
                MarginTop = MarginTop,
                MarginBottom = MarginBottom,
                Type = "Divider",
            }

            table.insert(Groupbox.Elements, Divider)
            return Divider
        end

        function Funcs:AddLabel(...)
            local Data ,Addons ,First ,Second = {}
,{}
,select(1, ...)
,select(2, ...)

            if typeof(First) == "table" or typeof(Second) == "table" then
                local Params = typeof(First) == "table" and First or Second

                Data.Text = Params.Text or ""
                Data.DoesWrap = Params.DoesWrap or false
                Data.Size = Params.Size or 14
                Data.Visible = Params.Visible or true
                Data.Idx = typeof(Second) == "table" and First or nil
                Data.Alignment = Params.Alignment or Enum.TextXAlignment.Left
            else
                Data.Text = First or ""
                Data.DoesWrap = Second or false
                Data.Size = 14
                Data.Visible = true
                Data.Idx = select(3, ...) or nil
            end

            local Groupbox = self
            local Container ,Label = Groupbox.Container
,{
                Text = Data.Text,
                DoesWrap = Data.DoesWrap,
                Alignment = Data.Alignment or Enum.TextXAlignment.Left, -- vma added this

                Addons = Addons,

                Visible = Data.Visible,
                Type = "Label",
            }

            local TextLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                Text = Label.Text,
                TextSize = Data.Size,
                TextWrapped = Label.DoesWrap,
                TextXAlignment = Groupbox.IsKeyTab and Enum.TextXAlignment.Center or Label.Alignment,
                Parent = Container,
            })

            function Label:SetVisible(Visible)
                Label.Visible = Visible

                TextLabel.Visible = Label.Visible
                Groupbox:Resize()
            end

            function Label:SetText(Text)
                Label.Text = Text
                TextLabel.Text = Text

                if Label.DoesWrap then
local _, Y =                        Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
                    TextLabel.Size = UDim2.new(1, 0, 0, Y + 4)
                end

                Groupbox:Resize()
            end

            if Label.DoesWrap then
local _, Y =                    Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
                TextLabel.Size = UDim2.new(1, 0, 0, Y + 4)

                local Last = TextLabel.AbsoluteSize
                TextLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    if TextLabel.AbsoluteSize == Last then
                        return
                    end
local _, Y =                        Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
                    TextLabel.Size = UDim2.new(1, 0, 0, Y + 4)

                    Last = TextLabel.AbsoluteSize
                    Groupbox:Resize()
                end)
            else
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim.new(0, 6),
                    Parent = TextLabel,
                })
            end

            Groupbox:Resize()

            Label.TextLabel = TextLabel
            Label.Container = Container
            if not Data.DoesWrap then
                setmetatable(Label, BaseAddons)
            end

            Label.Holder = TextLabel
            table.insert(Groupbox.Elements, Label)

            if Data.Idx then
                Labels[Data.Idx] = Label
            else
                table.insert(Labels, Label)
            end

            return Label
        end

        function Funcs:AddButton(...)
            local function GetInfo(...)
                local Info ,First ,Second = {}
,select(1, ...)
,select(2, ...)

                if typeof(First) == "table" or typeof(Second) == "table" then
                    local Params = typeof(First) == "table" and First or Second

                    Info.Text = Params.Text or ""
                    Info.Func = Params.Func or Params.Callback or function() end
                    Info.DoubleClick = Params.DoubleClick

                    Info.Tooltip = Params.Tooltip
                    Info.DisabledTooltip = Params.DisabledTooltip

                    Info.Risky = Params.Risky or false
                    Info.Disabled = Params.Disabled or false
                    Info.Visible = Params.Visible or true
                    Info.Idx = typeof(Second) == "table" and First or nil
                else
                    Info.Text = First or ""
                    Info.Func = Second or function() end
                    Info.DoubleClick = false

                    Info.Tooltip = nil
                    Info.DisabledTooltip = nil

                    Info.Risky = false
                    Info.Disabled = false
                    Info.Visible = true
                    Info.Idx = select(3, ...) or nil
                end

                return Info
            end
            local Info ,Groupbox = GetInfo(...)
,self
            local Container ,Button = Groupbox.Container
,{
                Text = Info.Text,
                Func = Info.Func,
                DoubleClick = Info.DoubleClick,

                Tooltip = Info.Tooltip,
                DisabledTooltip = Info.DisabledTooltip,
                TooltipTable = nil,

                Risky = Info.Risky,
                Disabled = Info.Disabled,
                Visible = Info.Visible,

                Tween = nil,
                Type = "Button",
            }

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 21),
                Parent = Container,
            })

            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDim.new(0, 9),
                Parent = Holder,
            })

            local function CreateButton(Button)
                local Base = New("TextButton", {
                    Active = not Button.Disabled,
                    BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor",
                    Size = UDim2.fromScale(1, 1),
                    Text = Button.Text,
                    TextSize = 14,
                    TextTransparency = 0.4,
                    Visible = Button.Visible,
                    Parent = Holder,
                })

                local Stroke = New("UIStroke", {
                    Color = "OutlineColor",
                    Transparency = Button.Disabled and 0.5 or 0,
                    Parent = Base,
                })

                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                        Parent = Base,
                    })
                )

                return Base, Stroke
            end

            local function InitEvents(Button)
                Button.Base.MouseEnter:Connect(function()
                    if Button.Disabled then
                        return
                    end

                    Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
                        TextTransparency = 0,
                    })
                    Button.Tween:Play()
                end)
                Button.Base.MouseLeave:Connect(function()
                    if Button.Disabled then
                        return
                    end

                    Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
                        TextTransparency = 0.4,
                    })
                    Button.Tween:Play()
                end)

                Button.Base.MouseButton1Click:Connect(function()
                    if Button.Disabled or Button.Locked then
                        return
                    end

                    if Button.DoubleClick then
                        Button.Locked = true

                        Button.Base.Text = "Are you sure?"
                        Button.Base.TextColor3 = Library.Scheme.AccentColor
                        Library.Registry[Button.Base].TextColor3 = "AccentColor"

                        local Clicked = WaitForEvent(Button.Base.MouseButton1Click, 0.5)

                        Button.Base.Text = Button.Text
                        Button.Base.TextColor3 = Button.Risky and Library.Scheme.RedColor or Library.Scheme.FontColor
                        Library.Registry[Button.Base].TextColor3 = Button.Risky and "RedColor" or "FontColor"

                        if Clicked then
                            Library:SafeCallback(Button.Func)
                        end

                        RunService.RenderStepped:Wait() --// Mouse Button fires without waiting (i hate roblox)
                        Button.Locked = false
                        return
                    end

                    Library:SafeCallback(Button.Func)
                end)
            end

            Button.Base, Button.Stroke = CreateButton(Button)
            InitEvents(Button)

            function Button:AddButton(...)
                local Info = GetInfo(...)

                local SubButton = {
                    Text = Info.Text,
                    Func = Info.Func,
                    DoubleClick = Info.DoubleClick,

                    Tooltip = Info.Tooltip,
                    DisabledTooltip = Info.DisabledTooltip,
                    TooltipTable = nil,

                    Risky = Info.Risky,
                    Disabled = Info.Disabled,
                    Visible = Info.Visible,

                    Tween = nil,
                    Type = "SubButton",
                }

                Button.SubButton = SubButton
                SubButton.Base, SubButton.Stroke = CreateButton(SubButton)
                InitEvents(SubButton)

                function SubButton:UpdateColors()
                    if Library.Unloaded then
                        return
                    end

                    StopTween(SubButton.Tween)

                    SubButton.Base.BackgroundColor3 = SubButton.Disabled and Library.Scheme.BackgroundColor
                        or Library.Scheme.MainColor
                    SubButton.Base.TextTransparency = SubButton.Disabled and 0.8 or 0.4
                    SubButton.Stroke.Transparency = SubButton.Disabled and 0.5 or 0

                    Library.Registry[SubButton.Base].BackgroundColor3 = SubButton.Disabled and "BackgroundColor"
                        or "MainColor"
                end

                function SubButton:SetDisabled(Disabled)
                    SubButton.Disabled = Disabled

                    if SubButton.TooltipTable then
                        SubButton.TooltipTable.Disabled = SubButton.Disabled
                    end

                    SubButton.Base.Active = not SubButton.Disabled
                    SubButton:UpdateColors()
                end

                function SubButton:SetVisible(Visible)
                    SubButton.Visible = Visible

                    SubButton.Base.Visible = SubButton.Visible
                    Groupbox:Resize()
                end

                function SubButton:SetText(Text)
                    SubButton.Text = Text
                    SubButton.Base.Text = Text
                end

                if typeof(SubButton.Tooltip) == "string" or typeof(SubButton.DisabledTooltip) == "string" then
                    SubButton.TooltipTable =
                        Library:AddTooltip(SubButton.Tooltip, SubButton.DisabledTooltip, SubButton.Base)
                    SubButton.TooltipTable.Disabled = SubButton.Disabled
                end

                if SubButton.Risky then
                    SubButton.Base.TextColor3 = Library.Scheme.RedColor
                    Library.Registry[SubButton.Base].TextColor3 = "RedColor"
                end

                SubButton:UpdateColors()

                if Info.Idx then
                    Buttons[Info.Idx] = SubButton
                else
                    table.insert(Buttons, SubButton)
                end

                return SubButton
            end

            function Button:UpdateColors()
                if Library.Unloaded then
                    return
                end

                StopTween(Button.Tween)

                Button.Base.BackgroundColor3 = Button.Disabled and Library.Scheme.BackgroundColor
                    or Library.Scheme.MainColor
                Button.Base.TextTransparency = Button.Disabled and 0.8 or 0.4
                Button.Stroke.Transparency = Button.Disabled and 0.5 or 0

                Library.Registry[Button.Base].BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor"
            end

            function Button:SetDisabled(Disabled)
                Button.Disabled = Disabled

                if Button.TooltipTable then
                    Button.TooltipTable.Disabled = Button.Disabled
                end

                Button.Base.Active = not Button.Disabled
                Button:UpdateColors()
            end

            function Button:SetVisible(Visible)
                Button.Visible = Visible

                Holder.Visible = Button.Visible
                Groupbox:Resize()
            end

            function Button:SetText(Text)
                Button.Text = Text
                Button.Base.Text = Text
            end

            if typeof(Button.Tooltip) == "string" or typeof(Button.DisabledTooltip) == "string" then
                Button.TooltipTable = Library:AddTooltip(Button.Tooltip, Button.DisabledTooltip, Button.Base)
                Button.TooltipTable.Disabled = Button.Disabled
            end

            if Button.Risky then
                Button.Base.TextColor3 = Library.Scheme.RedColor
                Library.Registry[Button.Base].TextColor3 = "RedColor"
            end

            Button:UpdateColors()
            Groupbox:Resize()

            Button.Holder = Holder
            table.insert(Groupbox.Elements, Button)

            if Info.Idx then
                Buttons[Info.Idx] = Button
            else
                table.insert(Buttons, Button)
            end

            return Button
        end

        function Funcs:AddCheckbox(Idx, Info)
            Info = Library:Validate(Info, Templates.Toggle)

            local Groupbox = self
            local Container ,Toggle = Groupbox.Container
,{
                Text = Info.Text,
                Value = Info.Default,

                Tooltip = Info.Tooltip,
                DisabledTooltip = Info.DisabledTooltip,
                TooltipTable = nil,

                Callback = Info.Callback,
                Changed = Info.Changed,

                Risky = Info.Risky,
                Disabled = Info.Disabled,
                Visible = Info.Visible,
                Addons = {},

                Variant = "Checkbox",
                Type = "Toggle",
            }

            local Button = New("TextButton", {
                Active = not Toggle.Disabled,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                Text = "",
                Visible = Toggle.Visible,
                Parent = Container,
            })

            local Label = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(26, 0),
                Size = UDim2.new(1, -26, 1, 0),
                Text = Toggle.Text,
                TextSize = 14,
                TextTransparency = 0.4,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button,
            })

            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 6),
                Parent = Label,
            })

            local Checkbox = New("Frame", {
                BackgroundColor3 = "MainColor",
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = Button,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Checkbox,
                })
            )

            local CheckboxStroke ,CheckImage = New("UIStroke", {
                Color = "OutlineColor",
                Parent = Checkbox,
            })
,New("ImageLabel", {
                Image = CheckIcon and CheckIcon.Url or "",
                ImageColor3 = "FontColor",
                ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
                ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
                ImageTransparency = 1,
                Position = UDim2.fromOffset(2, 2),
                Size = UDim2.new(1, -4, 1, -4),
                Parent = Checkbox,
            })

            function Toggle:UpdateColors()
                Toggle:Display()
            end

            function Toggle:Display()
                if Library.Unloaded then
                    return
                end

                CheckboxStroke.Transparency = Toggle.Disabled and 0.5 or 0

                if Toggle.Disabled then
                    Label.TextTransparency = 0.8
                    CheckImage.ImageTransparency = Toggle.Value and 0.8 or 1

                    Checkbox.BackgroundColor3 = Library.Scheme.BackgroundColor
                    Library.Registry[Checkbox].BackgroundColor3 = "BackgroundColor"

                    return
                end

                TweenService:Create(Label, Library.TweenInfo, {
                    TextTransparency = Toggle.Value and 0 or 0.4,
                }):Play()
                TweenService:Create(CheckImage, Library.TweenInfo, {
                    ImageTransparency = Toggle.Value and 0 or 1,
                }):Play()

                Checkbox.BackgroundColor3 = Library.Scheme.MainColor
                Library.Registry[Checkbox].BackgroundColor3 = "MainColor"
            end

            function Toggle:OnChanged(Func)
                Toggle.Changed = Func
            end

            function Toggle:SetValue(Value)
                if Toggle.Disabled then
                    return
                end

                Toggle.Value = Value
                Toggle:Display()

                for _, Addon in Toggle.Addons do
                    if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                        Addon.Toggled = Toggle.Value
                        Addon:Update()
                    end
                end

                Library:UpdateDependencyBoxes()
                Library:SafeCallback(Toggle.Callback, Toggle.Value)
                Library:SafeCallback(Toggle.Changed, Toggle.Value)
            end

            function Toggle:SetDisabled(Disabled)
                Toggle.Disabled = Disabled

                if Toggle.TooltipTable then
                    Toggle.TooltipTable.Disabled = Toggle.Disabled
                end

                for _, Addon in Toggle.Addons do
                    if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                        Addon:Update()
                    end
                end

                Button.Active = not Toggle.Disabled
                Toggle:Display()
            end

            function Toggle:SetVisible(Visible)
                Toggle.Visible = Visible

                Button.Visible = Toggle.Visible
                Groupbox:Resize()
            end

            function Toggle:SetText(Text)
                Toggle.Text = Text
                Label.Text = Text
            end

            Button.MouseButton1Click:Connect(function()
                if Toggle.Disabled then
                    return
                end

                Toggle:SetValue(not Toggle.Value)
            end)

            if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
                Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
                Toggle.TooltipTable.Disabled = Toggle.Disabled
            end

            if Toggle.Risky then
                Label.TextColor3 = Library.Scheme.RedColor
                Library.Registry[Label].TextColor3 = "RedColor"
            end

            Toggle:Display()
            Groupbox:Resize()

            Toggle.TextLabel = Label
            Toggle.Container = Container
            setmetatable(Toggle, BaseAddons)

            Toggle.Holder = Button
            table.insert(Groupbox.Elements, Toggle)

            Toggle.Default = Toggle.Value

            Toggles[Idx] = Toggle

            return Toggle
        end

        function Funcs:AddToggle(Idx, Info)
            if Library.ForceCheckbox then
                return Funcs.AddCheckbox(self, Idx, Info)
            end

            Info = Library:Validate(Info, Templates.Toggle)

            local Groupbox = self
            local Container ,Toggle = Groupbox.Container
,{
                Text = Info.Text,
                Value = Info.Default,

                Tooltip = Info.Tooltip,
                DisabledTooltip = Info.DisabledTooltip,
                TooltipTable = nil,

                Callback = Info.Callback,
                Changed = Info.Changed,

                Risky = Info.Risky,
                Disabled = Info.Disabled,
                Visible = Info.Visible,
                Addons = {},

                Variant = "Switch",
                Type = "Toggle",
            }

            local Button = New("TextButton", {
                Active = not Toggle.Disabled,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                Text = "",
                Visible = Toggle.Visible,
                Parent = Container,
            })

            local Label = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -40, 1, 0),
                Text = Toggle.Text,
                TextSize = 14,
                TextTransparency = 0.4,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button,
            })

            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 6),
                Parent = Label,
            })

            local Switch = New("Frame", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = "MainColor",
                Position = UDim2.fromScale(1, 0),
                Size = UDim2.fromOffset(32, 18),
                Parent = Button,
            })
            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = Switch,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                PaddingTop = UDim.new(0, 2),
                Parent = Switch,
            })
            local SwitchStroke ,Ball = New("UIStroke", {
                Color = "OutlineColor",
                Parent = Switch,
            })
,New("Frame", {
                BackgroundColor3 = "FontColor",
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = Switch,
            })
            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = Ball,
            })

            function Toggle:UpdateColors()
                Toggle:Display()
            end

            function Toggle:Display()
                if Library.Unloaded then
                    return
                end

                local Offset = Toggle.Value and 1 or 0

                Switch.BackgroundTransparency = Toggle.Disabled and 0.75 or 0
                SwitchStroke.Transparency = Toggle.Disabled and 0.75 or 0

                Switch.BackgroundColor3 = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.MainColor
                SwitchStroke.Color = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.OutlineColor

                Library.Registry[Switch].BackgroundColor3 = Toggle.Value and "AccentColor" or "MainColor"
                Library.Registry[SwitchStroke].Color = Toggle.Value and "AccentColor" or "OutlineColor"

                if Toggle.Disabled then
                    Label.TextTransparency = 0.8
                    Ball.AnchorPoint = Vector2.new(Offset, 0)
                    Ball.Position = UDim2.fromScale(Offset, 0)

                    Ball.BackgroundColor3 = Library:GetDarkerColor(Library.Scheme.FontColor)
                    Library.Registry[Ball].BackgroundColor3 = function()
                        return Library:GetDarkerColor(Library.Scheme.FontColor)
                    end

                    return
                end

                TweenService:Create(Label, Library.TweenInfo, {
                    TextTransparency = Toggle.Value and 0 or 0.4,
                }):Play()
                TweenService:Create(Ball, Library.TweenInfo, {
                    AnchorPoint = Vector2.new(Offset, 0),
                    Position = UDim2.fromScale(Offset, 0),
                }):Play()

                Ball.BackgroundColor3 = Library.Scheme.FontColor
                Library.Registry[Ball].BackgroundColor3 = "FontColor"
            end

            function Toggle:OnChanged(Func)
                Toggle.Changed = Func
            end

            function Toggle:SetValue(Value)
                if Toggle.Disabled then
                    return
                end

                Toggle.Value = Value
                Toggle:Display()

                for _, Addon in Toggle.Addons do
                    if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                        Addon.Toggled = Toggle.Value
                        Addon:Update()
                    end
                end

                Library:UpdateDependencyBoxes()
                Library:SafeCallback(Toggle.Callback, Toggle.Value)
                Library:SafeCallback(Toggle.Changed, Toggle.Value)
            end

            function Toggle:SetDisabled(Disabled)
                Toggle.Disabled = Disabled

                if Toggle.TooltipTable then
                    Toggle.TooltipTable.Disabled = Toggle.Disabled
                end

                for _, Addon in Toggle.Addons do
                    if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                        Addon:Update()
                    end
                end

                Button.Active = not Toggle.Disabled
                Toggle:Display()
            end

            function Toggle:SetVisible(Visible)
                Toggle.Visible = Visible

                Button.Visible = Toggle.Visible
                Groupbox:Resize()
            end

            function Toggle:SetText(Text)
                Toggle.Text = Text
                Label.Text = Text
            end

            Button.MouseButton1Click:Connect(function()
                if Toggle.Disabled then
                    return
                end

                Toggle:SetValue(not Toggle.Value)
            end)

            if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
                Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
                Toggle.TooltipTable.Disabled = Toggle.Disabled
            end

            if Toggle.Risky then
                Label.TextColor3 = Library.Scheme.RedColor
                Library.Registry[Label].TextColor3 = "RedColor"
            end

            Toggle:Display()
            Groupbox:Resize()

            Toggle.TextLabel = Label
            Toggle.Container = Container
            setmetatable(Toggle, BaseAddons)

            Toggle.Holder = Button
            table.insert(Groupbox.Elements, Toggle)

            Toggle.Default = Toggle.Value

            Toggles[Idx] = Toggle

            return Toggle
        end

        function Funcs:AddInput(Idx, Info)
            if typeof(Info) == "table" and (typeof(Info.VerifyValue) == "function" and Info.Finished ~= true) then
                Info.Finished = true
            end

            Info = Library:Validate(Info, Templates.Input)

            local Groupbox = self
            local Container ,Input = Groupbox.Container
,{
                Text = Info.Text,
                Value = Info.Default,

                Finished = Info.Finished,
                Numeric = Info.Numeric,
                ClearTextOnFocus = Info.ClearTextOnFocus,
                ClearTextOnBlur = Info.ClearTextOnBlur,
                Placeholder = Info.Placeholder,
                AllowEmpty = Info.AllowEmpty,
                EmptyReset = Info.EmptyReset,

                Tooltip = Info.Tooltip,
                DisabledTooltip = Info.DisabledTooltip,
                TooltipTable = nil,

                Callback = Info.Callback,
                Changed = Info.Changed,
                VerifyValue = Info.VerifyValue,

                Disabled = Info.Disabled,
                Visible = Info.Visible,

                Type = "Input",
            }

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 39),
                Visible = Input.Visible,
                Parent = Container,
            })

            local Label ,Box = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                Text = Input.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })
,New("TextBox", {
                AnchorPoint = Vector2.new(0, 1),
                BackgroundColor3 = "MainColor",
                ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus,
                PlaceholderText = Input.Placeholder,
                Position = UDim2.fromScale(0, 1),
                Size = UDim2.new(1, 0, 0, 21),
                Text = Input.Value,
                TextEditable = not Input.Disabled,
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })

            New("UIPadding", {
                PaddingBottom = UDim.new(0, 3),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 4),
                Parent = Box,
            })

            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Box,
            })

            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Box,
                })
            )

            function Input:UpdateColors()
                if Library.Unloaded then
                    return
                end

                Label.TextTransparency = Input.Disabled and 0.8 or 0
                Box.TextTransparency = Input.Disabled and 0.8 or 0
            end

            function Input:OnChanged(Func)
                Input.Changed = Func
            end

            function Input:SetValue(Text)
                if not Input.AllowEmpty and Trim(Text) == "" then
                    Text = Input.EmptyReset
                end

                if Info.MaxLength and #Text > Info.MaxLength then
                    Text = Text:sub(1, Info.MaxLength)
                end

                if Input.Numeric then
                    if #tostring(Text) > 0 and not tonumber(Text) then
                        Text = Input.Value
                    end
                end

                if typeof(Info.VerifyValue) == "function" and (Text ~= Input.EmptyReset and Info.VerifyValue(Text) ~= true) then
                    Text = Input.EmptyReset
                end

                Input.Value = Text
                Box.Text = Text

                if not Input.Disabled then
                    Library:SafeCallback(Input.Callback, Input.Value)
                    Library:SafeCallback(Input.Changed, Input.Value)
                end
            end

            function Input:SetDisabled(Disabled)
                Input.Disabled = Disabled

                if Input.TooltipTable then
                    Input.TooltipTable.Disabled = Input.Disabled
                end

                Box.ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus
                Box.TextEditable = not Input.Disabled
                Input:UpdateColors()
            end

            function Input:SetVisible(Visible)
                Input.Visible = Visible

                Holder.Visible = Input.Visible
                Groupbox:Resize()
            end

            function Input:SetText(Text)
                Input.Text = Text
                Label.Text = Text
            end

            if Input.Finished then
                Box.FocusLost:Connect(function(Enter)
                    if not Enter then
                        if Input.ClearTextOnBlur then
                            Box.Text = Input.Value
                        end

                        return
                    end

                    Input:SetValue(Box.Text)
                end)
            else
                Box:GetPropertyChangedSignal("Text"):Connect(function()
                    if Box.Text == Input.Value then return end

                    Input:SetValue(Box.Text)
                end)
            end

            if typeof(Input.Tooltip) == "string" or typeof(Input.DisabledTooltip) == "string" then
                Input.TooltipTable = Library:AddTooltip(Input.Tooltip, Input.DisabledTooltip, Box)
                Input.TooltipTable.Disabled = Input.Disabled
            end

            Groupbox:Resize()

            Input.Holder = Holder
            table.insert(Groupbox.Elements, Input)

            Input.Default = Input.Value
            if typeof(Info.VerifyValue) == "function" and (Input.Default ~= Input.EmptyReset and Info.VerifyValue(Input.Default) ~= true) then
                Input:SetValue(Input.EmptyReset)
                Input.Default = Input.EmptyReset
            end

            Options[Idx] = Input

            return Input
        end

        function Funcs:AddSlider(Idx, Info)
            Info = Library:Validate(Info, Templates.Slider)

            local Groupbox = self
            local Container ,Slider = Groupbox.Container
,{
                Text = Info.Text,
                Value = Info.Default,

                Min = Info.Min,
                Max = Info.Max,

                Prefix = Info.Prefix,
                Suffix = Info.Suffix,
                Compact = Info.Compact,
                Rounding = Info.Rounding,
                HideMax = Info.HideMax,

                Tooltip = Info.Tooltip,
                DisabledTooltip = Info.DisabledTooltip,
                TooltipTable = nil,

                Callback = Info.Callback,
                Changed = Info.Changed,

                Disabled = Info.Disabled,
                Visible = Info.Visible,

                Type = "Slider",
            }

            local Holder ,SliderLabel
=(New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, Info.Compact and 15 or 33),
                Visible = Slider.Visible,
                Parent = Container,
            })
)            if not Info.Compact then
                SliderLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 14),
                    Text = Slider.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Holder,
                })
            end

            local Bar = New("TextButton", {
                Active = not Slider.Disabled,
                AnchorPoint = Vector2.new(0, 1),
                BackgroundColor3 = "MainColor",
                Position = UDim2.fromScale(0, 1),
                Size = UDim2.new(1, 0, 0, 15),
                Text = "",
                Parent = Holder,
            })

            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Bar,
            })

            local DisplayLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                TextSize = 14,
                ZIndex = 2,
                Parent = Bar,
            })
            New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = "DarkColor",
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = DisplayLabel,
            })

            local Fill = New("Frame", {
                BackgroundColor3 = "AccentColor",
                Size = UDim2.fromScale(0.5, 1),
                Parent = Bar,
            })

            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Bar,
                })
            )

            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Fill,
                })
            )

            function Slider:UpdateColors()
                if Library.Unloaded then
                    return
                end

                if SliderLabel then
                    SliderLabel.TextTransparency = Slider.Disabled and 0.8 or 0
                end
                DisplayLabel.TextTransparency = Slider.Disabled and 0.8 or 0

                Fill.BackgroundColor3 = Slider.Disabled and Library.Scheme.OutlineColor or Library.Scheme.AccentColor
                Library.Registry[Fill].BackgroundColor3 = Slider.Disabled and "OutlineColor" or "AccentColor"
            end

            function Slider:Display()
                if Library.Unloaded then
                    return
                end

                local CustomDisplayText                 if Info.FormatDisplayValue then
                    CustomDisplayText = Info.FormatDisplayValue(Slider, Slider.Value)
                end

                if CustomDisplayText then
                    DisplayLabel.Text = tostring(CustomDisplayText)
                else
                    if Info.Compact then
                        DisplayLabel.Text =
                            string.format("%s: %s%s%s", Slider.Text, Slider.Prefix, Slider.Value, Slider.Suffix)
                    elseif Info.HideMax then
                        DisplayLabel.Text = string.format("%s%s%s", Slider.Prefix, Slider.Value, Slider.Suffix)
                    else
                        DisplayLabel.Text = string.format(
                            "%s%s%s/%s%s%s",
                            Slider.Prefix,
                            Slider.Value,
                            Slider.Suffix,
                            Slider.Prefix,
                            Slider.Max,
                            Slider.Suffix
                        )
                    end
                end

                local X = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
                Fill.Size = UDim2.fromScale(X, 1)
            end

            function Slider:OnChanged(Func)
                Slider.Changed = Func
            end

            function Slider:SetMax(Value)
                assert(Value > Slider.Min, "Max value cannot be less than the current min value.")

                Slider:SetValue(math.clamp(Slider.Value, Slider.Min, Value))
                Slider.Max = Value
                Slider:Display()
            end

            function Slider:SetMin(Value)
                assert(Value < Slider.Max, "Min value cannot be greater than the current max value.")

                Slider:SetValue(math.clamp(Slider.Value, Value, Slider.Max))
                Slider.Min = Value
                Slider:Display()
            end

            function Slider:SetValue(Str)
                if Slider.Disabled then
                    return
                end

                local Num = tonumber(Str)
                if not Num or Num == Slider.Value then
                    return
                end

                Num = math.clamp(Num, Slider.Min, Slider.Max)

                Slider.Value = Num
                Slider:Display()

                Library:SafeCallback(Slider.Callback, Slider.Value)
                Library:SafeCallback(Slider.Changed, Slider.Value)
            end

            function Slider:SetDisabled(Disabled)
                Slider.Disabled = Disabled

                if Slider.TooltipTable then
                    Slider.TooltipTable.Disabled = Slider.Disabled
                end

                Bar.Active = not Slider.Disabled
                Slider:UpdateColors()
            end

            function Slider:SetVisible(Visible)
                Slider.Visible = Visible

                Holder.Visible = Slider.Visible
                Groupbox:Resize()
            end

            function Slider:SetText(Text)
                Slider.Text = Text
                if SliderLabel then
                    SliderLabel.Text = Text
                    return
                end
                Slider:Display()
            end

            function Slider:SetPrefix(Prefix)
                Slider.Prefix = Prefix
                Slider:Display()
            end

            function Slider:SetSuffix(Suffix)
                Slider.Suffix = Suffix
                Slider:Display()
            end

            Bar.InputBegan:Connect(function(Input)
                if not IsClickInput(Input) or Slider.Disabled then
                    return
                end

                if Library.ActiveTab then
                    for _, Side in Library.ActiveTab.Sides do
                        Side.ScrollingEnabled = false
                    end
                end

                if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
                    Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = false
                end

                while IsDragInput(Input) do
                    local Location = Mouse.X
                    local Scale ,OldValue = math.clamp((Location - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
,Slider.Value
                    Slider.Value = Round(Slider.Min + ((Slider.Max - Slider.Min) * Scale), Slider.Rounding)

                    Slider:Display()
                    if Slider.Value ~= OldValue then
                        Library:SafeCallback(Slider.Callback, Slider.Value)
                        Library:SafeCallback(Slider.Changed, Slider.Value)
                    end

                    RunService.RenderStepped:Wait()
                end

                if Library.ActiveTab then
                    for _, Side in Library.ActiveTab.Sides do
                        Side.ScrollingEnabled = true
                    end
                end

                if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
                    Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = true
                end
            end)

            if typeof(Slider.Tooltip) == "string" or typeof(Slider.DisabledTooltip) == "string" then
                Slider.TooltipTable = Library:AddTooltip(Slider.Tooltip, Slider.DisabledTooltip, Bar)
                Slider.TooltipTable.Disabled = Slider.Disabled
            end

            Slider:UpdateColors()
            Slider:Display()
            Groupbox:Resize()

            Slider.Holder = Holder
            table.insert(Groupbox.Elements, Slider)

            Slider.Default = Slider.Value

            Options[Idx] = Slider

            return Slider
        end

        function Funcs:AddDropdown(Idx, Info)
            Info = Library:Validate(Info, Templates.Dropdown)

            local Groupbox = self
            local Container = Groupbox.Container

            if Info.SpecialType == "Player" then
                Info.Values = GetPlayers(Info.ExcludeLocalPlayer)
                Info.AllowNull = true
            elseif Info.SpecialType == "Team" then
                Info.Values = GetTeams()
                Info.AllowNull = true
            end

            local Dropdown = {
                Text = typeof(Info.Text) == "string" and Info.Text or nil,

                Value = Info.Multi and {} or nil,
                Values = Info.Values,
                DisabledValues = Info.DisabledValues,
                ValueImages = Info.ValueImages,

                Multi = Info.Multi,

                SpecialType = Info.SpecialType,
                ExcludeLocalPlayer = Info.ExcludeLocalPlayer,
                EnablePlayerImages = Info.EnablePlayerImages,

                Tooltip = Info.Tooltip,
                RichText = Info.RichText,
                DisabledTooltip = Info.DisabledTooltip,
                TooltipTable = nil,

                Callback = Info.Callback,
                Changed = Info.Changed,

                Disabled = Info.Disabled,
                Visible = Info.Visible,

                Type = "Dropdown",
            }

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, Dropdown.Text and 39 or 21),
                Visible = Dropdown.Visible,
                Parent = Container,
            })

            local Label ,DisplayContainer = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                Text = Dropdown.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = not not Info.Text,
                ZIndex = 3,
                Parent = Holder,
            })
,New("TextButton", {
                AnchorPoint = Vector2.new(0, 1),
                BackgroundColor3 = "MainColor",
                Position = UDim2.fromScale(0, 1),
                Size = UDim2.new(1, 0, 0, 21),
                Text = "",
                TextTransparency = 1,
                ZIndex = 2,
                Parent = Holder,
            })

            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 4),
                Parent = DisplayContainer,
            })

            New("UIStroke", {
                Color = "OutlineColor",
                Parent = DisplayContainer,
            })

            if Library.CornerRadiusDropdown == true then
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                        Parent = DisplayContainer,
                    })
                )
            end

            local DisplayImage ,DisplayButton ,ArrowImage ,SearchBox
= New("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(-4, 3),
                Size = UDim2.fromOffset(16, 16),
                Image = "",
                ImageTransparency = 1,
                ZIndex = 2,
                Parent = DisplayContainer,
            })
,New("TextButton", {
                Active = not Dropdown.Disabled,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 21),
                Text = "---",
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, -- vma added this
                RichText = Info.RichText,
                ZIndex = 2,
                Parent = DisplayContainer,
            })
,(New("ImageLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Image = ArrowIcon and ArrowIcon.Url or "",
                ImageColor3 = "FontColor",
                ImageRectOffset = ArrowIcon and ArrowIcon.ImageRectOffset or Vector2.zero,
                ImageRectSize = ArrowIcon and ArrowIcon.ImageRectSize or Vector2.zero,
                ImageTransparency = 0.5,
                Position = UDim2.fromScale(1, 0.5),
                Size = UDim2.fromOffset(16, 16),
                Parent = DisplayContainer,
            })
)            if Info.Searchable then
                SearchBox = New("TextBox", {
                    BackgroundTransparency = 1,
                    PlaceholderText = "Search...",
                    Position = UDim2.fromOffset(-8, 0),
                    Size = UDim2.new(1, -12, 1, 0),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Visible = false,
                    Parent = DisplayButton,
                })
                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    Parent = SearchBox,
                })
            end

            local GetValueImage ,MenuTable = function(Value)
                if not Value then
                    return nil
                end

                local ValueImage                 if Dropdown.SpecialType == "Player" and Dropdown.EnablePlayerImages == true then
                    if typeof(Value) == "Instance" and Value:IsA("Player") then
                        ValueImage = { Url = string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=48&h=48", tostring(Value.UserId)) }
                    end
                else
                    if Info.ValueImages and Info.ValueImages[Value] then
                        ValueImage = Library:GetCustomIcon(Info.ValueImages[Value])
                    end
                end

                return ValueImage
            end
,Library:AddContextMenu(
                DisplayContainer,
                function()
                    return UDim2.fromOffset((DisplayContainer.AbsoluteSize.X / Library.DPIScale) + 1, 0)
                end,
                function()
                    return { 0.5, DisplayContainer.AbsoluteSize.Y + 1.5 }
                end,
                2,
                function(Active)
                    DisplayButton.TextTransparency = (Active and SearchBox) and 1 or 0
                    ArrowImage.ImageTransparency = Active and 0 or 0.5
                    ArrowImage.Rotation = Active and 180 or 0
                    if SearchBox then
                        SearchBox.Text = ""
                        SearchBox.Visible = Active
                    end
                end,
                true
            )
            Dropdown.Menu = MenuTable
            
            local Buttons = {} -- must move this from below (vma)

            function Dropdown:RecalculateListSize(Count)
                local Y ,X = math.clamp((Count or GetTableSize(Dropdown.Values)) * 21, 0, Info.MaxVisibleDropdownItems * 21)
,(DisplayContainer.AbsoluteSize.X / Library.DPIScale) + 1                for Button in Buttons do 
                    local RawText = Info.RichText and StripRichTextTags(Button.Text) or Button.Text                    local TextSizeX = Library:GetTextBounds(RawText, Button.FontFace, Button.TextSize, math.huge)                    
                    if TextSizeX > X then
                        X = TextSizeX
                    end
                end
                
                MenuTable:SetSize(function()
                    return UDim2.fromOffset(X, Y)
                end)
            end

            function Dropdown:UpdateColors()
                if Library.Unloaded then
                    return
                end

                Label.TextTransparency = Dropdown.Disabled and 0.8 or 0
                DisplayButton.TextTransparency = Dropdown.Disabled and 0.8 or 0
                DisplayImage.ImageTransparency = Dropdown.Disabled and 0.8 or 0
                ArrowImage.ImageTransparency = Dropdown.Disabled and 0.8 or MenuTable.Active and 0 or 0.5
            end

            function Dropdown:Display()
                if Library.Unloaded then
                    return
                end

                local Str ,ValueImage = ""

                if Info.Multi then
                    for _, Value in Dropdown.Values do
                        if Dropdown.Value[Value] then
                            if not ValueImage then
                                ValueImage = GetValueImage(Value)
                            end

                            Str = Str
                                .. (Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(Value)) or tostring(Value))
                                .. ", "
                        end
                    end

                    Str = Str:sub(1, #Str - 2)
                else
                    ValueImage = GetValueImage(Dropdown.Value)
                    Str = Dropdown.Value and tostring(Dropdown.Value) or ""

                    if Str ~= "" and Info.FormatDisplayValue then
                        Str = tostring(Info.FormatDisplayValue(Str))
                    end
                end

                DisplayButton.Text = (Str == "" and "---" or Str)

                if ValueImage then
                    DisplayImage.Image = ValueImage.Url
                    DisplayImage.ImageRectOffset = ValueImage.ImageRectOffset or Vector2.zero
                    DisplayImage.ImageRectSize = ValueImage.ImageRectSize or Vector2.zero
                    DisplayImage.ImageTransparency = 0
                else
                    DisplayImage.Image = ""
                    DisplayImage.ImageTransparency = 1
                end

                DisplayButton.Size = ValueImage and UDim2.new(1, -8, 0, 21) or UDim2.new(1, 0, 0, 21)
                DisplayButton.Position = ValueImage and UDim2.fromOffset(14, 0) or UDim2.fromOffset(0, 0)
            end

            function Dropdown:OnChanged(Func)
                Dropdown.Changed = Func
            end

            function Dropdown:GetActiveValues()
                if Info.Multi then
                    local Table = {}

                    for Value, _ in Dropdown.Value do
                        table.insert(Table, Value)
                    end

                    return Table
                end

                return Dropdown.Value and 1 or 0
            end

            function Dropdown:BuildDropdownList()
                local Values ,DisabledValues = Dropdown.Values
,Dropdown.DisabledValues

                -- Destroy old utility buttons
                if Dropdown.UtilityButtonsHolder then
                    Dropdown.UtilityButtonsHolder:Destroy()
                    Dropdown.UtilityButtonsHolder = nil
                end

                for Button, _ in Buttons do
                    Button.Parent:Destroy()
                end
                table.clear(Buttons)

                local Count = 0

                -- vma added this
                if Dropdown.Multi and next(Dropdown.Values) and (not SearchBox or SearchBox.Text:len() == 0) then
                    Count = 1
                    local UtilHolder = New("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 21),
                        Parent = MenuTable.Menu,
                    })
                    Dropdown.UtilityButtonsHolder = UtilHolder

                    New("UIListLayout", {
                        Parent = UtilHolder,
                        Padding = UDim.new(0, 8),
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                    })

                    local function MakeUtilButton(Text, Callback)
                        local Btn = New("TextButton", {
                            BackgroundColor3 = "MainColor",
                            Size = UDim2.fromScale(0.45, 0.8),
                            Text = Text,
                            TextSize = 13,
                            TextTransparency = 0.4,
                            Parent = UtilHolder,
                        })
                        New("UIStroke", { Color = "OutlineColor", Parent = Btn })
                        table.insert(Library.Corners, New("UICorner", {
                            CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                            Parent = Btn,
                        }))
                        Btn.MouseButton1Click:Connect(Callback)
                    end

                    MakeUtilButton("Select All", function()
                        local Dict = {}
                        for _, Value in Dropdown.Values do
                            Dict[Value] = true
                        end
                        Dropdown:SetValue(Dict)
                    end)

                    MakeUtilButton("Deselect All", function()
                        Dropdown:SetValue({})
                    end)
                end

                for _, Value in Values do
                    local FormattedValue = tostring(Info.FormatListValue and Info.FormatListValue(Value) or (Info.FormatDisplayValue and Info.FormatDisplayValue(Value) or Value))
                    local RawText = Info.RichText and StripRichTextTags(FormattedValue) or FormattedValue

                    if SearchBox and not RawText:lower():match(SearchBox.Text:lower()) then
                        continue
                    end

                    Count += 1
                    local IsDisabled ,Table ,ValueImage = table.find(DisabledValues, Value)
,{}
,GetValueImage(Value)

                    local Container = New("Frame", {
                        BackgroundColor3 = "MainColor",
                        BackgroundTransparency = 1,
                        LayoutOrder = IsDisabled and 1 or 0,
                        Size = UDim2.new(1, 0, 0, 21),
                        Parent = MenuTable.Menu,
                    })

                    local Image ,Button = ValueImage and New("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = ValueImage.Url,
                        ImageRectOffset = ValueImage.ImageRectOffset,
                        ImageRectSize = ValueImage.ImageRectSize,
                        ImageTransparency = 0.5,
                        Size = UDim2.fromOffset(16, 16),
                        Position = UDim2.fromOffset(4, 3),
                        Parent = Container,
                    })
,New("TextButton", {
                        BackgroundTransparency = 1,
                        RichText = Info.RichText, -- ADD THIS
                        Size = ValueImage and UDim2.new(1, -18, 0, 21) or UDim2.new(1, 0, 0, 21),
                        Position = ValueImage and UDim2.fromOffset(18, 0) or UDim2.fromOffset(0, 0),
                        Text = FormattedValue,
                        TextSize = 14,
                        TextTransparency = 0.5,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = Container,
                    })
                    New("UIPadding", {
                        PaddingLeft = UDim.new(0, 7),
                        PaddingRight = UDim.new(0, 7),
                        Parent = Button,
                    })

                    local Selected
                    if Info.Multi then
                        Selected = Dropdown.Value[Value]
                    else
                        Selected = Dropdown.Value == Value
                    end

                    function Table:UpdateButton()
                        if Info.Multi then
                            Selected = Dropdown.Value[Value]
                        else
                            Selected = Dropdown.Value == Value
                        end

                        Container.BackgroundTransparency = Selected and 0 or 1
                        Button.TextTransparency = IsDisabled and 0.8 or Selected and 0 or 0.5

                        if Image then
                            Image.ImageTransparency = IsDisabled and 0.8 or Selected and 0 or 0.5
                        end
                    end

                    if not IsDisabled then
                        Button.MouseButton1Click:Connect(function()
                            local Try = not Selected

                            if not (Dropdown:GetActiveValues() == 1 and not Try and not Info.AllowNull) then
                                Selected = Try
                                if Info.Multi then
                                    Dropdown.Value[Value] = Selected and true or nil
                                else
                                    Dropdown.Value = Selected and Value or nil
                                end

                                for _, OtherButton in Buttons do
                                    OtherButton:UpdateButton()
                                end
                            end

                            Table:UpdateButton()
                            Dropdown:Display()

                            Library:UpdateDependencyBoxes()
                            Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
                            Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
                        end)
                    end

                    Table:UpdateButton()
                    Dropdown:Display()

                    Buttons[Button] = Table
                end

                Dropdown:RecalculateListSize(Count)
            end

            function Dropdown:SetValue(Value)
                if Info.Multi then
                    local Table = {}

                    for Val, Active in Value or {} do
                        if typeof(Active) ~= "boolean" then
                            Table[Active] = true
                        elseif Active and table.find(Dropdown.Values, Val) then
                            Table[Val] = true
                        end
                    end

                    Dropdown.Value = Table
                else
                    if table.find(Dropdown.Values, Value) then
                        Dropdown.Value = Value
                    elseif not Value then
                        Dropdown.Value = nil
                    end
                end

                Dropdown:Display()
                for _, Button in Buttons do
                    Button:UpdateButton()
                end

                if not Dropdown.Disabled then
                    Library:UpdateDependencyBoxes()
                    Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
                    Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
                end
            end

            function Dropdown:SetValues(Values)
                Dropdown.Values = Values
                Dropdown:BuildDropdownList()
            end

            function Dropdown:AddValues(Values)
                if typeof(Values) == "table" then
                    for _, val in Values do
                        table.insert(Dropdown.Values, val)
                    end
                elseif typeof(Values) == "string" then
                    table.insert(Dropdown.Values, Values)
                else
                    return
                end

                Dropdown:BuildDropdownList()
            end

            function Dropdown:SetDisabledValues(DisabledValues)
                Dropdown.DisabledValues = DisabledValues
                Dropdown:BuildDropdownList()
            end

            function Dropdown:AddDisabledValues(DisabledValues)
                if typeof(DisabledValues) == "table" then
                    for _, val in DisabledValues do
                        table.insert(Dropdown.DisabledValues, val)
                    end
                elseif typeof(DisabledValues) == "string" then
                    table.insert(Dropdown.DisabledValues, DisabledValues)
                else
                    return
                end

                Dropdown:BuildDropdownList()
            end

            function Dropdown:SetValueImages(ValueImages)
                if typeof(ValueImages) ~= "table" then
                    return
                end

                Dropdown.ValueImages = ValueImages
                Dropdown:BuildDropdownList()
            end

            function Dropdown:AddValueImages(ValueImages)
                if typeof(ValueImages) ~= "table" then
                    return
                end

                for key, val in ValueImages do
                    Dropdown.ValueImages[key] = val
                end

                Dropdown:BuildDropdownList()
            end

            function Dropdown:SetDisabled(Disabled)
                Dropdown.Disabled = Disabled

                if Dropdown.TooltipTable then
                    Dropdown.TooltipTable.Disabled = Dropdown.Disabled
                end

                MenuTable:Close()
                DisplayButton.Active = not Dropdown.Disabled
                Dropdown:UpdateColors()
            end

            function Dropdown:SetVisible(Visible)
                Dropdown.Visible = Visible

                Holder.Visible = Dropdown.Visible
                Groupbox:Resize()
            end

            function Dropdown:SetText(Text)
                Dropdown.Text = Text
                Holder.Size = UDim2.new(1, 0, 0, Text and 39 or 21)

                Label.Text = Text and Text or ""
                Label.Visible = not not Text
            end

            local ToggleDropdown = function()
                if Dropdown.Disabled then
                    return
                end

                MenuTable:Toggle()
            end

            DisplayContainer.MouseButton1Click:Connect(ToggleDropdown)
            DisplayButton.MouseButton1Click:Connect(ToggleDropdown)

            if SearchBox then
                SearchBox:GetPropertyChangedSignal("Text"):Connect(Dropdown.BuildDropdownList)
            end

            local Defaults = {}
            if typeof(Info.Default) == "string" then
                local Index = table.find(Dropdown.Values, Info.Default)
                if Index then
                    table.insert(Defaults, Index)
                end
            elseif typeof(Info.Default) == "table" then
                for _, Value in next, Info.Default do
                    local Index = table.find(Dropdown.Values, Value)
                    if Index then
                        table.insert(Defaults, Index)
                    end
                end
            elseif Dropdown.Values[Info.Default] ~= nil then
                table.insert(Defaults, Info.Default)
            end

            if next(Defaults) then
                for i = 1, #Defaults do
                    local Index = Defaults[i]
                    if Info.Multi then
                        Dropdown.Value[Dropdown.Values[Index] ] = true
                    else
                        Dropdown.Value = Dropdown.Values[Index]
                    end

                    if not Info.Multi then
                        break
                    end
                end
            end

            if typeof(Dropdown.Tooltip) == "string" or typeof(Dropdown.DisabledTooltip) == "string" then
                Dropdown.TooltipTable = Library:AddTooltip(Dropdown.Tooltip, Dropdown.DisabledTooltip, DisplayContainer)
                Dropdown.TooltipTable.Disabled = Dropdown.Disabled
            end

            Dropdown:UpdateColors()
            Dropdown:Display()
            Dropdown:BuildDropdownList()
            Groupbox:Resize()

            Dropdown.Holder = Holder
            table.insert(Groupbox.Elements, Dropdown)

            Dropdown.Default = Defaults
            Dropdown.DefaultValues = Dropdown.Values

            Options[Idx] = Dropdown

            return Dropdown
        end

        function Funcs:AddViewport(Idx, Info)
            Info = Library:Validate(Info, Templates.Viewport)

            local Groupbox = self
            local Container ,Dragging,Pinching ,LastPinchDist ,ViewportObject ,LastMousePos= Groupbox.Container
,false,false
,0
,(Info.Object
)            if Info.Clone and typeof(Info.Object) == "Instance" then
                if Info.Object.Archivable then
                    ViewportObject = ViewportObject:Clone()
                else
                    Info.Object.Archivable = true
                    ViewportObject = ViewportObject:Clone()
                    Info.Object.Archivable = false
                end
            end

            local Viewport = {
                Object = ViewportObject,
                Camera = if not Info.Camera then Instance.new("Camera") else Info.Camera,
                Interactive = Info.Interactive,
                AutoFocus = Info.AutoFocus,
                Visible = Info.Visible,
                Type = "Viewport",
            }

            assert(
                typeof(Viewport.Object) == "Instance" and (Viewport.Object:IsA("BasePart") or Viewport.Object:IsA("Model")),
                "Instance must be a BasePart or Model."
            )

            assert(
                typeof(Viewport.Camera) == "Instance" and Viewport.Camera:IsA("Camera"),
                "Camera must be a valid Camera instance."
            )

            local function GetModelSize(model)
                if model:IsA("BasePart") then
                    return model.Size
                end

                return select(2, model:GetBoundingBox())
            end

            local function FocusCamera()
                local ModelSize = GetModelSize(Viewport.Object)
                local MaxExtent = math.max(ModelSize.X, ModelSize.Y, ModelSize.Z)
                local CameraDistance ,ModelPosition = MaxExtent * 2
,Viewport.Object:GetPivot().Position

                Viewport.Camera.CFrame =
                    CFrame.new(ModelPosition + Vector3.new(0, MaxExtent / 2, CameraDistance), ModelPosition)
            end

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, Info.Height),
                Visible = Viewport.Visible,
                Parent = Container,
            })

            local Box = New("Frame", {
                AnchorPoint = Vector2.new(0, 1),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0, 1),
                Size = UDim2.fromScale(1, 1),
                Parent = Holder,
            })

            New("UIPadding", {
                PaddingBottom = UDim.new(0, 3),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 4),
                Parent = Box,
            })

            local ViewportFrame = New("ViewportFrame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Parent = Box,
                CurrentCamera = Viewport.Camera,
                Active = Viewport.Interactive,
            })

            ViewportFrame.MouseEnter:Connect(function()
                if not Viewport.Interactive then
                    return
                end

                for _, Side in Groupbox.Tab.Sides do
                    Side.ScrollingEnabled = false
                end
            end)

            ViewportFrame.MouseLeave:Connect(function()
                if not Viewport.Interactive then
                    return
                end

                for _, Side in Groupbox.Tab.Sides do
                    Side.ScrollingEnabled = true
                end
            end)

            ViewportFrame.InputBegan:Connect(function(input)
                if not Viewport.Interactive then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Dragging = true
                    LastMousePos = input.Position
                elseif input.UserInputType == Enum.UserInputType.Touch and not Pinching then
                    Dragging = true
                    LastMousePos = input.Position
                end
            end)

            Library:GiveSignal(UserInputService.InputEnded:Connect(function(input)
                if Library.Unloaded then
                    return
                end

                if not Viewport.Interactive then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Dragging = false
                elseif input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end))

            Library:GiveSignal(UserInputService.InputChanged:Connect(function(input)
                if Library.Unloaded then
                    return
                end

                if not Viewport.Interactive or not Dragging or Pinching then
                    return
                end

                if
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    local MouseDelta = input.Position - LastMousePos
                    LastMousePos = input.Position

                    local Position ,Camera ,RotationY = Viewport.Object:GetPivot().Position
,Viewport.Camera
,CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -MouseDelta.X * 0.01)
                    Camera.CFrame = CFrame.new(Position) * RotationY * CFrame.new(-Position) * Camera.CFrame

                    local RotationX = CFrame.fromAxisAngle(Camera.CFrame.RightVector, -MouseDelta.Y * 0.01)
                    local PitchedCFrame = CFrame.new(Position) * RotationX * CFrame.new(-Position) * Camera.CFrame

                    if PitchedCFrame.UpVector.Y > 0.1 then
                        Camera.CFrame = PitchedCFrame
                    end
                end
            end))

            ViewportFrame.InputChanged:Connect(function(input)
                if not Viewport.Interactive then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseWheel then
                    local ZoomAmount = input.Position.Z * 2
                    Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * ZoomAmount
                end
            end)

            Library:GiveSignal(UserInputService.TouchPinch:Connect(function(touchPositions, scale, velocity, state)
                if Library.Unloaded then
                    return
                end

                if not Viewport.Interactive or not Library:MouseIsOverFrame(ViewportFrame, touchPositions[1]) then
                    return
                end

                if state == Enum.UserInputState.Begin then
                    Pinching = true
                    Dragging = false
                    LastPinchDist = (touchPositions[1] - touchPositions[2]).Magnitude
                elseif state == Enum.UserInputState.Change then
                    local currentDist = (touchPositions[1] - touchPositions[2]).Magnitude
                    local delta = (currentDist - LastPinchDist) * 0.1
                    LastPinchDist = currentDist
                    Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * delta
                elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
                    Pinching = false
                end
            end))

            Viewport.Object.Parent = ViewportFrame
            if Viewport.AutoFocus then
                FocusCamera()
            end

            function Viewport:SetObject(Object, Clone)
                assert(Object, "Object cannot be nil.")

                if Clone then
                    Object = Object:Clone()
                end

                if Viewport.Object then
                    Viewport.Object:Destroy()
                end

                Viewport.Object = Object
                Viewport.Object.Parent = ViewportFrame

                Groupbox:Resize()
            end

            function Viewport:SetHeight(Height)
                assert(Height > 0, "Height must be greater than 0.")

                Holder.Size = UDim2.new(1, 0, 0, Height)
                Groupbox:Resize()
            end

            function Viewport:Focus()
                if not Viewport.Object then
                    return
                end

                FocusCamera()
            end

            function Viewport:SetCamera(Camera)
                assert(
                    Camera and typeof(Camera) == "Instance" and Camera:IsA("Camera"),
                    "Camera must be a valid Camera instance."
                )

                Viewport.Camera = Camera
                ViewportFrame.CurrentCamera = Camera
            end

            function Viewport:SetInteractive(Interactive)
                Viewport.Interactive = Interactive
                ViewportFrame.Active = Interactive
            end

            function Viewport:SetVisible(Visible)
                Viewport.Visible = Visible

                Holder.Visible = Viewport.Visible
                Groupbox:Resize()
            end

            Groupbox:Resize()

            Viewport.Holder = Holder
            table.insert(Groupbox.Elements, Viewport)

            Options[Idx] = Viewport

            return Viewport
        end

        function Funcs:AddImage(Idx, Info)
            Info = Library:Validate(Info, Templates.Image)

            local Groupbox = self
            local Container ,Image = Groupbox.Container
,{
                Image = Info.Image,
                Color = Info.Color,
                RectOffset = Info.RectOffset,
                RectSize = Info.RectSize,
                Outline = Info.Outline,
                Height = Info.Height,
                ScaleType = Info.ScaleType,
                Transparency = Info.Transparency,
                BackgroundTransparency = Info.BackgroundTransparency,

                Visible = Info.Visible,
                Type = "Image",
            }

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, Info.Height),
                Visible = Image.Visible,
                Parent = Container,
            })

            local Box = New("Frame", {
                AnchorPoint = Vector2.new(0, 1),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                BackgroundTransparency = Image.BackgroundTransparency,
                Position = UDim2.fromScale(0, 1),
                Size = UDim2.fromScale(1, 1),
                Parent = Holder,
            })
            
            if Image.Outline then
                Library:AddOutline(Box)
            end

            New("UIPadding", {
                PaddingBottom = UDim.new(0, 3),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 4),
                Parent = Box,
            })

            local ImageProperties = {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Image = Image.Image,
                ImageTransparency = Image.Transparency,
                ImageColor3 = Image.Color,
                ImageRectOffset = Image.RectOffset,
                ImageRectSize = Image.RectSize,
                ScaleType = Image.ScaleType,
                Parent = Box,
            }

            local Icon = Library:GetCustomIcon(ImageProperties.Image)
            assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

            ImageProperties.Image = Icon.Url
            ImageProperties.ImageRectOffset = Icon.ImageRectOffset
            ImageProperties.ImageRectSize = Icon.ImageRectSize

            local ImageLabel = New("ImageLabel", ImageProperties)

            function Image:SetHeight(Height)
                assert(Height > 0, "Height must be greater than 0.")

                Image.Height = Height
                Holder.Size = UDim2.new(1, 0, 0, Height)
                Groupbox:Resize()
            end

            function Image:SetImage(NewImage)
                assert(typeof(NewImage) == "string", "Image must be a string.")

                local Icon = Library:GetCustomIcon(NewImage)
                assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

                NewImage = Icon.Url
                Image.RectOffset = Icon.ImageRectOffset
                Image.RectSize = Icon.ImageRectSize

                ImageLabel.Image = NewImage
                Image.Image = NewImage
            end

            function Image:SetColor(Color)
                assert(typeof(Color) == "Color3", "Color must be a Color3 value.")

                ImageLabel.ImageColor3 = Color
                Image.Color = Color
            end

            function Image:SetRectOffset(RectOffset)
                assert(typeof(RectOffset) == "Vector2", "RectOffset must be a Vector2 value.")

                ImageLabel.ImageRectOffset = RectOffset
                Image.RectOffset = RectOffset
            end

            function Image:SetRectSize(RectSize)
                assert(typeof(RectSize) == "Vector2", "RectSize must be a Vector2 value.")

                ImageLabel.ImageRectSize = RectSize
                Image.RectSize = RectSize
            end

            function Image:SetScaleType(ScaleType)
                assert(
                    typeof(ScaleType) == "EnumItem" and ScaleType:IsA("ScaleType"),
                    "ScaleType must be a valid Enum.ScaleType."
                )

                ImageLabel.ScaleType = ScaleType
                Image.ScaleType = ScaleType
            end

            function Image:SetTransparency(Transparency)
                assert(typeof(Transparency) == "number", "Transparency must be a number between 0 and 1.")
                assert(Transparency >= 0 and Transparency <= 1, "Transparency must be between 0 and 1.")

                ImageLabel.ImageTransparency = Transparency
                Image.Transparency = Transparency
            end

            function Image:SetVisible(Visible)
                Image.Visible = Visible

                Holder.Visible = Image.Visible
                Groupbox:Resize()
            end

            Groupbox:Resize()

            Image.Holder = Holder
            table.insert(Groupbox.Elements, Image)

            Options[Idx] = Image

            return Image
        end

        function Funcs:AddVideo(Idx, Info)
            Info = Library:Validate(Info, Templates.Video)

            local Groupbox = self
            local Container ,Video = Groupbox.Container
,{
                Video = Info.Video,
                Looped = Info.Looped,
                Playing = Info.Playing,
                Volume = Info.Volume,
                Height = Info.Height,
                Visible = Info.Visible,

                Type = "Video",
            }

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, Info.Height),
                Visible = Video.Visible,
                Parent = Container,
            })

            local Box = New("Frame", {
                AnchorPoint = Vector2.new(0, 1),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0, 1),
                Size = UDim2.fromScale(1, 1),
                Parent = Holder,
            })

            New("UIPadding", {
                PaddingBottom = UDim.new(0, 3),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 4),
                Parent = Box,
            })

            local VideoFrameInstance = New("VideoFrame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Video = Video.Video,
                Looped = Video.Looped,
                Volume = Video.Volume,
                Parent = Box,
            })

            VideoFrameInstance.Playing = Video.Playing

            function Video:SetHeight(Height)
                assert(Height > 0, "Height must be greater than 0.")

                Video.Height = Height
                Holder.Size = UDim2.new(1, 0, 0, Height)
                Groupbox:Resize()
            end

            function Video:SetVideo(NewVideo)
                assert(typeof(NewVideo) == "string", "Video must be a string.")

                VideoFrameInstance.Video = NewVideo
                Video.Video = NewVideo
            end

            function Video:SetLooped(Looped)
                assert(typeof(Looped) == "boolean", "Looped must be a boolean.")

                VideoFrameInstance.Looped = Looped
                Video.Looped = Looped
            end

            function Video:SetVolume(Volume)
                assert(typeof(Volume) == "number", "Volume must be a number between 0 and 10.")

                VideoFrameInstance.Volume = Volume
                Video.Volume = Volume
            end

            function Video:SetPlaying(Playing)
                assert(typeof(Playing) == "boolean", "Playing must be a boolean.")

                VideoFrameInstance.Playing = Playing
                Video.Playing = Playing
            end

            function Video:Play()
                VideoFrameInstance.Playing = true
                Video.Playing = true
            end

            function Video:Pause()
                VideoFrameInstance.Playing = false
                Video.Playing = false
            end

            function Video:SetVisible(Visible)
                Video.Visible = Visible

                Holder.Visible = Video.Visible
                Groupbox:Resize()
            end

            Groupbox:Resize()

            Video.Holder = Holder
            Video.VideoFrame = VideoFrameInstance
            table.insert(Groupbox.Elements, Video)

            Options[Idx] = Video

            return Video
        end

        function Funcs:AddUIPassthrough(Idx, Info)
            Info = Library:Validate(Info, Templates.UIPassthrough)

            local Groupbox = self
            local Container = Groupbox.Container

            assert(Info.Instance, "Instance must be provided.")
            assert(
                typeof(Info.Instance) == "Instance" and Info.Instance:IsA("GuiBase2d"),
                "Instance must inherit from GuiBase2d."
            )
            assert(typeof(Info.Height) == "number" and Info.Height > 0, "Height must be a number greater than 0.")

            local Passthrough = {
                Instance = Info.Instance,
                Height = Info.Height,
                Visible = Info.Visible,

                Type = "UIPassthrough",
            }

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, Info.Height),
                Visible = Passthrough.Visible,
                Parent = Container,
            })

            Passthrough.Instance.Parent = Holder

            Groupbox:Resize()

            function Passthrough:SetHeight(Height)
                assert(typeof(Height) == "number" and Height > 0, "Height must be a number greater than 0.")

                Passthrough.Height = Height
                Holder.Size = UDim2.new(1, 0, 0, Height)
                Groupbox:Resize()
            end

            function Passthrough:SetInstance(Instance)
                assert(Instance, "Instance must be provided.")
                assert(
                    typeof(Instance) == "Instance" and Instance:IsA("GuiBase2d"),
                    "Instance must inherit from GuiBase2d."
                )

                if Passthrough.Instance then
                    Passthrough.Instance.Parent = nil
                end

                Passthrough.Instance = Instance
                Passthrough.Instance.Parent = Holder
            end

            function Passthrough:SetVisible(Visible)
                Passthrough.Visible = Visible

                Holder.Visible = Passthrough.Visible
                Groupbox:Resize()
            end

            Passthrough.Holder = Holder
            table.insert(Groupbox.Elements, Passthrough)

            Options[Idx] = Passthrough

            return Passthrough
        end

        function Funcs:AddDependencyBox()
            local Groupbox = self
            local Container ,DepboxContainer
,DepboxList
=(Groupbox.Container
)
            do
                DepboxContainer = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    Visible = false,
                    Parent = Container,
                })

                DepboxList = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = DepboxContainer,
                })
            end

            local Depbox = {
                Visible = false,
                Dependencies = {},

                Holder = DepboxContainer,
                Container = DepboxContainer,

                Elements = {},
                DependencyBoxes = {},
            }

            function Depbox:Resize()
                DepboxContainer.Size = UDim2.new(1, 0, 0, DepboxList.AbsoluteContentSize.Y / Library.DPIScale)
                Groupbox:Resize()
            end

            function Depbox:Update(CancelSearch)
                for _, Dependency in Depbox.Dependencies do
                    local Element ,Value = Dependency[1]
,Dependency[2]

                    if Element.Type == "Toggle" and Element.Value ~= Value then
                        DepboxContainer.Visible = false
                        Depbox.Visible = false
                        return
                    elseif Element.Type == "Dropdown" then
                        if typeof(Element.Value) == "table" then
                            if not Element.Value[Value] then
                                DepboxContainer.Visible = false
                                Depbox.Visible = false
                                return
                            end
                        else
                            if Element.Value ~= Value then
                                DepboxContainer.Visible = false
                                Depbox.Visible = false
                                return
                            end
                        end
                    end
                end

                Depbox.Visible = true
                DepboxContainer.Visible = true
                if not Library.Searching then
                    task.defer(function()
                        Depbox:Resize()
                    end)
                elseif not CancelSearch then
                    Library:UpdateSearch(Library.SearchText)
                end
            end

            DepboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if not Depbox.Visible then
                    return
                end

                Depbox:Resize()
            end)

            function Depbox:SetupDependencies(Dependencies)
                for _, Dependency in Dependencies do
                    assert(typeof(Dependency) == "table", "Dependency should be a table.")
                    assert(Dependency[1] ~= nil, "Dependency is missing element.")
                    assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
                end

                Depbox.Dependencies = Dependencies
                Depbox:Update()
            end

            DepboxContainer:GetPropertyChangedSignal("Visible"):Connect(function()
                Depbox:Resize()
            end)

            setmetatable(Depbox, BaseGroupbox)

            table.insert(Groupbox.DependencyBoxes, Depbox)
            table.insert(Library.DependencyBoxes, Depbox)

            return Depbox
        end

        function Funcs:AddDependencyGroupbox()
            local Groupbox = self
            local Tab ,BoxHolder ,DepGroupboxContainer
,DepGroupboxList
= Groupbox.Tab
,(Groupbox.BoxHolder
)
            do
                DepGroupboxContainer = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    Size = UDim2.fromScale(1, 0),
                    Visible = false,
                    Parent = BoxHolder,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, Library.CornerRadius),
                        Parent = DepGroupboxContainer,
                    })
                )
                Library:AddOutline(DepGroupboxContainer)

                DepGroupboxList = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = DepGroupboxContainer,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    PaddingTop = UDim.new(0, 7),
                    Parent = DepGroupboxContainer,
                })
            end

            local DepGroupbox = {
                Visible = false,
                Dependencies = {},

                BoxHolder = BoxHolder,
                Holder = DepGroupboxContainer,
                Container = DepGroupboxContainer,

                Tab = Tab,
                Elements = {},
                DependencyBoxes = {},
            }

            function DepGroupbox:Resize()
                DepGroupboxContainer.Size = UDim2.new(1, 0, 0, (DepGroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 18)
            end

            function DepGroupbox:Update(CancelSearch)
                for _, Dependency in DepGroupbox.Dependencies do
                    local Element ,Value = Dependency[1]
,Dependency[2]

                    if Element.Type == "Toggle" and Element.Value ~= Value then
                        DepGroupboxContainer.Visible = false
                        DepGroupbox.Visible = false
                        return
                    elseif Element.Type == "Dropdown" then
                        if typeof(Element.Value) == "table" then
                            if not Element.Value[Value] then
                                DepGroupboxContainer.Visible = false
                                DepGroupbox.Visible = false
                                return
                            end
                        else
                            if Element.Value ~= Value then
                                DepGroupboxContainer.Visible = false
                                DepGroupbox.Visible = false
                                return
                            end
                        end
                    end
                end

                DepGroupbox.Visible = true
                if not Library.Searching then
                    DepGroupboxContainer.Visible = true
                    DepGroupbox:Resize()
                elseif not CancelSearch then
                    Library:UpdateSearch(Library.SearchText)
                end
            end

            function DepGroupbox:SetupDependencies(Dependencies)
                for _, Dependency in Dependencies do
                    assert(typeof(Dependency) == "table", "Dependency should be a table.")
                    assert(Dependency[1] ~= nil, "Dependency is missing element.")
                    assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
                end

                DepGroupbox.Dependencies = Dependencies
                DepGroupbox:Update()
            end

            setmetatable(DepGroupbox, BaseGroupbox)

            table.insert(Tab.DependencyGroupboxes, DepGroupbox)
            table.insert(Library.DependencyBoxes, DepGroupbox)

            return DepGroupbox
        end

        BaseGroupbox.__index = Funcs
        BaseGroupbox.__namecall = function(_, Key, ...)
            return Funcs[Key](...)
        end
    end

    function Library:SetFont(FontFace)
        if typeof(FontFace) == "EnumItem" then
            FontFace = Font.fromEnum(FontFace)
        end

        Library.Scheme.Font = FontFace
        Library:UpdateColorsUsingRegistry()
    end

    function Library:SetNotifySide(Side)
        Library.NotifySide = Side

        if Side:lower() == "left" then
            NotificationArea.AnchorPoint = Vector2.new(0, 0)
            NotificationArea.Position = UDim2.fromOffset(6, 6)
            NotificationList.HorizontalAlignment = Enum.HorizontalAlignment.Left
        else
            NotificationArea.AnchorPoint = Vector2.new(1, 0)
            NotificationArea.Position = UDim2.new(1, -6, 0, 6)
            NotificationList.HorizontalAlignment = Enum.HorizontalAlignment.Right
        end
    end

    function Library:Notify(...)
        local Data ,Info = {}
,select(1, ...)

        if typeof(Info) == "table" then
            Data.Title = tostring(Info.Title)
            Data.Description = tostring(Info.Description)
            Data.Time = Info.Time or 5
            Data.SoundId = Info.SoundId
            Data.Steps = Info.Steps
            Data.Persist = Info.Persist
            Data.Icon = Info.Icon
            Data.BigIcon = Info.BigIcon
            Data.IconColor = Info.IconColor
        else
            Data.Description = tostring(Info)
            Data.Time = select(2, ...) or 5
            Data.SoundId = select(3, ...)
        end
        Data.Destroyed = false

        local DeletedInstance ,DeleteConnection = false
        if typeof(Data.Time) == "Instance" then
            DeleteConnection = Data.Time.Destroying:Connect(function()
                DeletedInstance = true

                DeleteConnection:Disconnect()
                DeleteConnection = nil
            end)
        end

        local FakeBackground = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            Visible = false,
            Parent = NotificationArea,
        })

        local Holder = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = "MainColor",
            Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, -2) or UDim2.new(1, 8, 0, -2),
            Size = UDim2.fromScale(1, 1),
            ZIndex = 5,
            Parent = FakeBackground,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius),
                Parent = Holder,
            })
        )
        New("UIListLayout", {
            Padding = UDim.new(0, 4),
            Parent = Holder,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8),
            Parent = Holder,
        })
        Library:AddOutline(Holder)

        local ContentContainer = New("Frame", {
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            Size = UDim2.fromScale(1, 0),
            Parent = Holder,
        })

        if Data.BigIcon then
            New("UIListLayout", {
                Padding = UDim.new(0, 8),
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Parent = ContentContainer,
            })
        end

        local BigIconLabel
        if Data.BigIcon then
            local ParsedIcon = Library:GetCustomIcon(Data.BigIcon)
            if ParsedIcon then
                BigIconLabel = New("ImageLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromOffset(24, 24),
                    Image = ParsedIcon.Url,
                    ImageColor3 = Data.IconColor or "AccentColor",
                    ImageRectOffset = ParsedIcon.ImageRectOffset,
                    ImageRectSize = ParsedIcon.ImageRectSize,
                    Parent = ContentContainer,
                })
            end
        end

        local TextContainer = New("Frame", {
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            Size = UDim2.fromScale(0, 0),
            Parent = ContentContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 4),
            Parent = TextContainer,
        })

        local TitleContainer
        if Data.Title then
            TitleContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0, 0),
                Parent = TextContainer,
            })
        end

        local IconLabel
        if Data.Icon and TitleContainer then
            local ParsedIcon = Library:GetCustomIcon(Data.Icon)
            if ParsedIcon then
                IconLabel = New("ImageLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 1),
                    Size = UDim2.fromOffset(15, 15),
                    Image = ParsedIcon.Url,
                    ImageColor3 = Data.IconColor or "FontColor",
                    ImageRectOffset = ParsedIcon.ImageRectOffset,
                    ImageRectSize = ParsedIcon.ImageRectSize,
                    Parent = TitleContainer,
                })
            end
        end

        local TitleX ,DescX ,Title
,Desc
,TimerFill
=0
,0

        if Data.Title then
            Title = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.None,
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, (Data.Icon and 21 or 0), 0.5, 0),
                Size = UDim2.fromScale(0, 0),
                Text = Data.Title,
                TextSize = 15,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                TextWrapped = true,
                Parent = TitleContainer,
            })
        end

        if Data.Description then
            Desc = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.None,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0, 0),
                Text = Data.Description,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = TextContainer,
            })
        end

        function Data:Resize()
            local ExtraWidth ,IconWidth = BigIconLabel and 32 or 0
,IconLabel and 21 or 0

            if Title then
                local X, Y =
                    Library:GetTextBounds(Title.Text, Title.FontFace, Title.TextSize, (NotificationArea.AbsoluteSize.X / Library.DPIScale) - 24 - ExtraWidth - IconWidth)
                Title.Size = UDim2.fromOffset(X, Y)
                TitleX = X + IconWidth
                TitleContainer.Size = UDim2.fromOffset(TitleX, math.max(Y, IconLabel and 16 or 0))
            end

            if Desc then
                local X, Y =
                    Library:GetTextBounds(Desc.Text, Desc.FontFace, Desc.TextSize, (NotificationArea.AbsoluteSize.X / Library.DPIScale) - 24 - ExtraWidth)
                Desc.Size = UDim2.fromOffset(X, Y)
                DescX = X
            end

            FakeBackground.Size = UDim2.fromOffset(math.max(TitleX, DescX) + 24 + ExtraWidth, 0)
        end

        function Data:ChangeTitle(Text)
            if Title then
                Data.Title = tostring(Text)
                Title.Text = Data.Title
                Data:Resize()
            end
        end

        function Data:ChangeDescription(Text)
            if Desc then
                Data.Description = tostring(Text)
                Desc.Text = Data.Description
                Data:Resize()
            end
        end

        function Data:ChangeStep(NewStep)
            if TimerFill and Data.Steps then
                NewStep = math.clamp(NewStep or 0, 0, Data.Steps)
                TimerFill.Size = UDim2.fromScale(NewStep / Data.Steps, 1)
            end
        end

        function Data:Destroy()
            Data.Destroyed = true

            if typeof(Data.Time) == "Instance" then
                pcall(Data.Time.Destroy, Data.Time)
            end

            if DeleteConnection then
                DeleteConnection:Disconnect()
            end

            TweenService
                :Create(Holder, Library.NotifyTweenInfo, {
                    Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, -2) or UDim2.new(1, 8, 0, -2),
                })
                :Play()

            task.delay(Library.NotifyTweenInfo.Time, function()
                Library.Notifications[FakeBackground] = nil
                FakeBackground:Destroy()
            end)
        end

        Data:Resize()

        local TimerHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 7),
            Visible = (Data.Persist ~= true and typeof(Data.Time) ~= "Instance") or typeof(Data.Steps) == "number",
            Parent = Holder,
        })
        local TimerBar = New("Frame", {
            BackgroundColor3 = "BackgroundColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Position = UDim2.fromOffset(0, 3),
            Size = UDim2.new(1, 0, 0, 2),
            Parent = TimerHolder,
        })
        TimerFill = New("Frame", {
            BackgroundColor3 = "AccentColor",
            Size = UDim2.fromScale(1, 1),
            Parent = TimerBar,
        })

        if typeof(Data.Time) == "Instance" then
            TimerFill.Size = UDim2.fromScale(0, 1)
        end
        if Data.SoundId then
            local SoundId = Data.SoundId
            if typeof(SoundId) == "number" then
                SoundId = string.format("rbxassetid://%d", SoundId)
            end

            New("Sound", {
                SoundId = SoundId,
                Volume = 3,
                PlayOnRemove = true,
                Parent = SoundService,
            }):Destroy()
        end

        Library.Notifications[FakeBackground] = Data

        FakeBackground.Visible = true
        TweenService:Create(Holder, Library.NotifyTweenInfo, {
            Position = UDim2.fromOffset(0, 0),
        }):Play()

        task.delay(Library.NotifyTweenInfo.Time, function()
            if Data.Persist then
                return
            elseif typeof(Data.Time) == "Instance" then
                repeat
                    task.wait()
                until DeletedInstance or Data.Destroyed
            else
                TweenService
                    :Create(TimerFill, TweenInfo.new(Data.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                        Size = UDim2.fromScale(0, 1),
                    })
                    :Play()
                task.wait(Data.Time)
            end

            if not Data.Destroyed then
                Data:Destroy()
            end
        end)

        return Data
    end

    function Library:CreateWindow(WindowInfo)
        WindowInfo = Library:Validate(WindowInfo, Templates.Window)
        local ViewportSize= workspace.CurrentCamera.ViewportSize
        if RunService:IsStudio() and ViewportSize.X <= 5 and ViewportSize.Y <= 5 then
            repeat
                ViewportSize = workspace.CurrentCamera.ViewportSize
                task.wait()
            until ViewportSize.X > 5 and ViewportSize.Y > 5
        end

        local MaxX ,MaxY = ViewportSize.X - 64
,ViewportSize.Y - 64

        Library.OriginalMinSize =
            Vector2.new(math.min(Library.OriginalMinSize.X, MaxX), math.min(Library.OriginalMinSize.Y, MaxY))
        Library.MinSize = Library.OriginalMinSize

        WindowInfo.Size = UDim2.fromOffset(
            math.clamp(WindowInfo.Size.X.Offset, Library.MinSize.X, MaxX),
            math.clamp(WindowInfo.Size.Y.Offset, Library.MinSize.Y, MaxY)
        )
        if typeof(WindowInfo.Font) == "EnumItem" then
            WindowInfo.Font = Font.fromEnum(WindowInfo.Font)
        end
        WindowInfo.CornerRadius = math.min(WindowInfo.CornerRadius, 20)

        --// Old Naming \\--
        if WindowInfo.Compact ~= nil then
            WindowInfo.SidebarCompacted = WindowInfo.Compact
        end
        if WindowInfo.SidebarMinWidth ~= nil then
            WindowInfo.MinSidebarWidth = WindowInfo.SidebarMinWidth
        end
        WindowInfo.MinSidebarWidth = math.max(64, WindowInfo.MinSidebarWidth)
        WindowInfo.SidebarCompactWidth = math.max(48, WindowInfo.SidebarCompactWidth)
        WindowInfo.SidebarCollapseThreshold = math.clamp(WindowInfo.SidebarCollapseThreshold, 0.1, 0.9)
        WindowInfo.CompactWidthActivation = math.max(48, WindowInfo.CompactWidthActivation)

        Library.CornerRadius = WindowInfo.CornerRadius
        Library:SetNotifySide(WindowInfo.NotifySide)
        Library.ShowCustomCursor = WindowInfo.ShowCustomCursor
        Library.Scheme.Font = WindowInfo.Font
        Library.ToggleKeybind = WindowInfo.ToggleKeybind
        Library.GlobalSearch = WindowInfo.GlobalSearch

        local IsDefaultSearchbarSize ,InitialLeftWidth ,IsCompact ,MainFrame
,DividerLine
,TitleHolder
,WindowTitle
,WindowIcon
,RightWrapper
,SearchBox
,CurrentTabInfo
,CurrentTabLabel
,CurrentTabDescription
,ResizeButton
,Tabs
,Container
,BackgroundImage
,BottomBackground
,FooterLabel
= WindowInfo.SearchbarSize == UDim2.fromScale(1, 1)
,math.ceil(WindowInfo.Size.X.Offset * 0.3)
,(WindowInfo.SidebarCompacted
)        local LastExpandedWidth = InitialLeftWidth

        do
            Library.KeybindFrame, Library.KeybindContainer = Library:AddDraggableMenu("Keybinds")
            Library.KeybindFrame.AnchorPoint = Vector2.new(0, 0.5)
            Library.KeybindFrame.Position = UDim2.new(0, 6, 0.5, 0)
            Library.KeybindFrame.Visible = false

            MainFrame = New("TextButton", {
                BackgroundColor3 = function()
                    return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
                end,
                Name = "Main",
                Text = "",
                Position = WindowInfo.Position,
                Size = WindowInfo.Size,
                Visible = false,
                Parent = ScreenGui,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                    Parent = MainFrame,
                })
            )
            table.insert(
                Library.Scales,
                New("UIScale", {
                    Parent = MainFrame,
                })
            )
            Library:AddOutline(MainFrame)
            Library:MakeLine(MainFrame, {
                Position = UDim2.fromOffset(0, 48),
                Size = UDim2.new(1, 0, 0, 1),
            })

            DividerLine = New("Frame", {
                BackgroundColor3 = "OutlineColor",
                Position = UDim2.fromOffset(InitialLeftWidth, 0),
                Size = UDim2.new(0, 1, 1, -21),
                Parent = MainFrame,
            })

            if WindowInfo.BackgroundImage then
                BackgroundImage = New("ImageLabel", {
                    Image = WindowInfo.BackgroundImage,
                    Position = UDim2.fromScale(0, 0),
                    Size = UDim2.fromScale(1, 1),
                    ScaleType = Enum.ScaleType.Stretch,
                    ZIndex = 999,
                    BackgroundTransparency = 1,
                    ImageTransparency = 0.75,
                    Parent = MainFrame,
                })

                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                        Parent = BackgroundImage,
                    })
                )
            end

            if WindowInfo.Center then
                MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -MainFrame.Size.Y.Offset / 2)
            end

            --// Top Bar \\-
            local TopBar = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 48),
                Parent = MainFrame,
            })
            Library:MakeDraggable(MainFrame, TopBar, false, true)

            --// Title
            TitleHolder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, InitialLeftWidth, 1, 0),
                Parent = TopBar,
            })
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 6),
                Parent = TitleHolder,
            })

            if WindowInfo.Icon then
                local Icon = Library:GetCustomIcon(WindowInfo.Icon)
                WindowIcon = New("ImageLabel", {
                    Image = Icon.Url,
                    ImageRectOffset = Icon.ImageRectOffset,
                    ImageRectSize = Icon.ImageRectSize,
                    Size = WindowInfo.IconSize,
                    Parent = TitleHolder,
                })
            else
                WindowIcon = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = WindowInfo.IconSize,
                    Text = WindowInfo.Title:sub(1, 1),
                    TextScaled = true,
                    Visible = false,
                    Parent = TitleHolder,
                })
            end

            local X = Library:GetTextBounds(
                WindowInfo.Title,
                Library.Scheme.Font,
                20,
                TitleHolder.AbsoluteSize.X - (WindowInfo.Icon and WindowInfo.IconSize.X.Offset + 6 or 0) - 12
            )
            WindowTitle = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, X, 1, 0),
                Text = WindowInfo.Title,
                TextSize = 20,
                Parent = TitleHolder,
            })

            --// Top Right Bar
            RightWrapper = New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -49, 0.5, 0),
                Size = UDim2.new(1, -InitialLeftWidth - 57 - 1, 1, -16),
                Parent = TopBar,
            })

            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 8),
                Parent = RightWrapper,
            })

            CurrentTabInfo = New("Frame", {
                Size = UDim2.fromScale(WindowInfo.DisableSearch and 1 or 0.5, 1),
                Visible = false,
                BackgroundTransparency = 1,
                Parent = RightWrapper,
            })

            New("UIFlexItem", {
                FlexMode = Enum.UIFlexMode.Grow,
                Parent = CurrentTabInfo,
            })

            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Parent = CurrentTabInfo,
            })

            New("UIPadding", {
                PaddingBottom = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 8),
                Parent = CurrentTabInfo,
            })

            CurrentTabLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Text = "",
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = CurrentTabInfo,
            })

            CurrentTabDescription = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Text = "",
                TextWrapped = true,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTransparency = 0.5,
                Parent = CurrentTabInfo,
            })

            SearchBox = New("TextBox", {
                BackgroundColor3 = "MainColor",
                PlaceholderText = "Search",
                Size = WindowInfo.SearchbarSize,
                TextScaled = true,
                Visible = not (WindowInfo.DisableSearch or false),
                Parent = RightWrapper,
            })
            New("UIFlexItem", {
                FlexMode = Enum.UIFlexMode.Shrink,
                Parent = SearchBox,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                    Parent = SearchBox,
                })
            )
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 8),
                Parent = SearchBox,
            })
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = SearchBox,
            })

            local SearchIcon = Library:GetIcon("search")
            if SearchIcon then
                New("ImageLabel", {
                    Image = SearchIcon.Url,
                    ImageColor3 = "FontColor",
                    ImageRectOffset = SearchIcon.ImageRectOffset,
                    ImageRectSize = SearchIcon.ImageRectSize,
                    ImageTransparency = 0.5,
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    Parent = SearchBox,
                })
            end

            if MoveIcon then
                New("ImageLabel", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = MoveIcon.Url,
                    ImageColor3 = "OutlineColor",
                    ImageRectOffset = MoveIcon.ImageRectOffset,
                    ImageRectSize = MoveIcon.ImageRectSize,
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.fromOffset(28, 28),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    Parent = TopBar,
                })
            end

            --// Bottom Bar \\--
            BottomBackground = New("Frame", {
                AnchorPoint = Vector2.new(0, 1),
                BackgroundColor3 = function()
                    return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
                end,
                Position = UDim2.fromScale(0, 1),
                Size = UDim2.new(1, 0, 0, 20 + WindowInfo.CornerRadius),
                Parent = MainFrame
            })
            Library:MakeLine(MainFrame, {
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0, 0, 1, -20),
                Size = UDim2.new(1, 0, 0, 1),
            })

            local BottomBar = New("Frame", {
                AnchorPoint = Vector2.new(0, 1),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0, 1),
                Size = UDim2.new(1, 0, 0, 20),
                Parent = MainFrame,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                    Parent = BottomBackground,
                })
            )

            --// Footer
            FooterLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = WindowInfo.Footer,
                TextSize = 14,
                TextTransparency = 0.5,
                Parent = BottomBar,
            })

            --// Resize Button
            if WindowInfo.Resizable then
                ResizeButton = New("TextButton", {
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -WindowInfo.CornerRadius / 4, 0, 0),
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    Text = "",
                    Parent = BottomBar,
                })

                Library:MakeResizable(MainFrame, ResizeButton, function()
                    for _, Tab in Library.Tabs do
                        Tab:Resize(true)
                    end
                end)
            end

            New("ImageLabel", {
                Image = ResizeIcon and ResizeIcon.Url or "",
                ImageColor3 = "FontColor",
                ImageRectOffset = ResizeIcon and ResizeIcon.ImageRectOffset or Vector2.zero,
                ImageRectSize = ResizeIcon and ResizeIcon.ImageRectSize or Vector2.zero,
                ImageTransparency = 0.5,
                Position = UDim2.fromOffset(2, 2),
                Size = UDim2.new(1, -4, 1, -4),
                Parent = ResizeButton,
            })

            --// Tabs \\--
            Tabs = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = "BackgroundColor",
                CanvasSize = UDim2.fromScale(0, 0),
                Position = UDim2.fromOffset(0, 49),
                ScrollBarThickness = 0,
                Size = UDim2.new(0, InitialLeftWidth, 1, -70),
                Parent = MainFrame,
            })
            New("UIListLayout", {
                Parent = Tabs,
            })

            --// Container \\--
            Container = New("Frame", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = function()
                    return Library:GetBetterColor(Library.Scheme.BackgroundColor, 1)
                end,
                Name = "Container",
                Position = UDim2.new(1, 0, 0, 49),
                Size = UDim2.new(1, -InitialLeftWidth - 1, 1, -70),
                Parent = MainFrame,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 0),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                PaddingTop = UDim.new(0, 0),
                Parent = Container,
            })
        end

        --// Window Table \\--
        local Window = {}

        function Window:ChangeTitle(title)
            assert(typeof(title) == "string", "Expected string for title got: " .. typeof(title))

            WindowTitle.Text = title
            WindowInfo.Title = title
        end

        if WindowInfo.BackgroundImage then
            function Window:SetBackgroundImage(Image)
                assert(typeof(Image) == "string", "Expected string for Image got: " .. typeof(Image))

                BackgroundImage.Image = Image
                WindowInfo.BackgroundImage = Image
            end
        end

        function Window:SetFooter(footer)
            assert(typeof(footer) == "string", "Expected string for footer got: " .. typeof(footer))

            FooterLabel.Text = footer
            WindowInfo.Footer = footer
        end

        function Window:SetCornerRadius(Radius)
            assert(typeof(Radius) == "number", "Expected number for Radius got: " .. typeof(Radius))
            Radius = math.min(Radius, 20)

            for _, UICorner in Library.Corners do
                if UICorner.CornerRadius.Offset == Library.CornerRadius / 2 then
                    UICorner.CornerRadius = UDim.new(0, Radius / 2)
                else
                    UICorner.CornerRadius = UDim.new(0, Radius)
                end
            end

            Library.CornerRadius = Radius
            WindowInfo.CornerRadius = Radius

            ResizeButton.Position = UDim2.new(1, -Radius / 4, 0, 0)
            BottomBackground.Size = UDim2.new(1, 0, 0, 20 + Radius)

            for _, Tab in Library.Tabs do
                if Tab.IsKeyTab then
                    continue
                end

                for _, Tabbox in Tab.Tabboxes do
                    Tabbox:UpdateCorners()
                end
            end
        end

        local function ApplyCompact()
            IsCompact = Window:GetSidebarWidth() == WindowInfo.SidebarCompactWidth
            if WindowInfo.DisableCompactingSnap then
                IsCompact = Window:GetSidebarWidth() <= WindowInfo.CompactWidthActivation
            end

            WindowTitle.Visible = not IsCompact
            if not WindowInfo.Icon then
                WindowIcon.Visible = IsCompact
            end

            for _, Button in Library.TabButtons do
                if not Button.Icon then
                    continue
                end

                Button.Label.Visible = not IsCompact
                Button.Padding.PaddingBottom = UDim.new(0, IsCompact and 6 or 11)
                Button.Padding.PaddingLeft = UDim.new(0, IsCompact and 6 or 12)
                Button.Padding.PaddingRight = UDim.new(0, IsCompact and 6 or 12)
                Button.Padding.PaddingTop = UDim.new(0, IsCompact and 6 or 11)
                Button.Icon.SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY
            end
        end

        function Window:IsSidebarCompacted()
            return IsCompact
        end

        function Window:SetCompact(State)
            Window:SetSidebarWidth(State and WindowInfo.SidebarCompactWidth or LastExpandedWidth)
        end

        function Window:GetSidebarWidth()
            return Tabs.Size.X.Offset
        end

        function Window:SetSidebarWidth(Width)
            Width = math.clamp(Width, 48, MainFrame.Size.X.Offset - WindowInfo.MinContainerWidth - 1)

            DividerLine.Position = UDim2.fromOffset(Width, 0)

            TitleHolder.Size = UDim2.new(0, Width, 1, 0)
            RightWrapper.Size = UDim2.new(1, -Width - 57 - 1, 1, -16)
            Tabs.Size = UDim2.new(0, Width, 1, -70)
            Container.Size = UDim2.new(1, -Width - 1, 1, -70)

            if WindowInfo.EnableCompacting then
                ApplyCompact()
            end
            if not IsCompact then
                LastExpandedWidth = Width
            end
        end

        function Window:ShowTabInfo(Name, Description)
            CurrentTabLabel.Text = Name
            CurrentTabDescription.Text = Description

            if IsDefaultSearchbarSize then
                SearchBox.Size = UDim2.fromScale(0.5, 1)
            end
            CurrentTabInfo.Visible = true
        end
        function Window:HideTabInfo()
            CurrentTabInfo.Visible = false
            if IsDefaultSearchbarSize then
                SearchBox.Size = UDim2.fromScale(1, 1)
            end
        end

        function Window:AddTab(...)
            local Name ,Icon ,Description 
            if select("#", ...) == 1 and typeof(...) == "table" then
                local Info = select(1, ...)
                Name = Info.Name or "Tab"
                Icon = Info.Icon
                Description = Info.Description
            else
                Name = select(1, ...)
                Icon = select(2, ...)
                Description = select(3, ...)
            end

            local TabButton,TabLabel
,TabIcon
,TabContainer
,TabLeft
,TabRight

            Icon = Library:GetCustomIcon(Icon)
            do
                TabButton = New("TextButton", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
                    Text = "",
                    Parent = Tabs,
                })
                local ButtonPadding = New("UIPadding", {
                    PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
                    PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
                    PaddingRight = UDim.new(0, IsCompact and 6 or 12),
                    PaddingTop = UDim.new(0, IsCompact and 6 or 11),
                    Parent = TabButton,
                })

                TabLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(30, 0),
                    Size = UDim2.new(1, -30, 1, 0),
                    Text = Name,
                    TextSize = 16,
                    TextTransparency = 0.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Visible = not IsCompact,
                    Parent = TabButton,
                })

                if Icon then
                    TabIcon = New("ImageLabel", {
                        Image = Icon.Url,
                        ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
                        ImageRectOffset = Icon.ImageRectOffset,
                        ImageRectSize = Icon.ImageRectSize,
                        ImageTransparency = 0.5,
                        ScaleType = Enum.ScaleType.Fit,
                        Size = UDim2.fromScale(1, 1),
                        SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,
                        Parent = TabButton,
                    })
                end

                table.insert(Library.TabButtons, {
                    Label = TabLabel,
                    Padding = ButtonPadding,
                    Icon = TabIcon,
                })

                --// Tab Container \\--
                TabContainer = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    Visible = false,
                    Parent = Container,
                })

                TabLeft = New("ScrollingFrame", {
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    CanvasSize = UDim2.fromScale(0, 0),
                    ScrollBarImageTransparency = 1,
                    ScrollBarThickness = 0,
                    Size = UDim2.new(0.5, -3, 1, 0),
                    Parent = TabContainer,
                })
                New("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    Parent = TabLeft,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 2),
                    PaddingLeft = UDim.new(0, 2),
                    PaddingRight = UDim.new(0, 2),
                    PaddingTop = UDim.new(0, 2),
                    Parent = TabLeft,
                })
                do
                    New("Frame", {
                        BackgroundTransparency = 1,
                        LayoutOrder = -1,
                        Parent = TabLeft,
                    })
                    New("Frame", {
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,
                        Parent = TabLeft,
                    })
                end

                TabRight = New("ScrollingFrame", {
                    AnchorPoint = Vector2.new(1, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    CanvasSize = UDim2.fromScale(0, 0),
                    Position = UDim2.fromScale(1, 0),
                    ScrollBarImageTransparency = 1,
                    ScrollBarThickness = 0,
                    Size = UDim2.new(0.5, -3, 1, 0),
                    Parent = TabContainer,
                })
                New("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    Parent = TabRight,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 2),
                    PaddingLeft = UDim.new(0, 2),
                    PaddingRight = UDim.new(0, 2),
                    PaddingTop = UDim.new(0, 2),
                    Parent = TabRight,
                })
                do
                    New("Frame", {
                        BackgroundTransparency = 1,
                        LayoutOrder = -1,
                        Parent = TabRight,
                    })
                    New("Frame", {
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,
                        Parent = TabRight,
                    })
                end
            end

            --// Warning Box \\--
            local WarningBoxHolder ,WarningBox
,WarningBoxOutline
,WarningBoxShadowOutline
,WarningBoxScrollingFrame
,WarningTitle
,WarningStroke
,WarningText
=(New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(0, 7),
                Size = UDim2.fromScale(1, 0),
                Visible = false,
                Parent = TabContainer,
            })
)            do
                WarningBox = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    Position = UDim2.fromOffset(2, 0),
                    Size = UDim2.new(1, -5, 0, 0),
                    Parent = WarningBoxHolder,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                        Parent = WarningBox,
                    })
                )
                WarningBoxOutline, WarningBoxShadowOutline = Library:AddOutline(WarningBox)

                WarningBoxScrollingFrame = New("ScrollingFrame", {
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.fromScale(1, 1),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 3,
                    ScrollingDirection = Enum.ScrollingDirection.Y,
                    Parent = WarningBox,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 6),
                    PaddingRight = UDim.new(0, 6),
                    PaddingTop = UDim.new(0, 4),
                    Parent = WarningBoxScrollingFrame,
                })

                WarningTitle = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -4, 0, 14),
                    Text = "",
                    TextColor3 = Color3.fromRGB(255, 50, 50),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = WarningBoxScrollingFrame,
                })

                WarningStroke = New("UIStroke", {
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                    Color = Color3.fromRGB(169, 0, 0),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Parent = WarningTitle,
                })

                WarningText = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(0, 16),
                    Size = UDim2.new(1, -4, 0, 0),
                    Text = "",
                    TextSize = 14,
                    TextWrapped = true,
                    Parent = WarningBoxScrollingFrame,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                })

                New("UIStroke", {
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                    Color = "DarkColor",
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Parent = WarningText,
                })
            end

            --// Tab Table \\--
            local Tab = {
                Groupboxes = {},
                Tabboxes = {},
                DependencyGroupboxes = {},
                Description = Description,
                Sides = {
                    TabLeft,
                    TabRight,
                },
                WarningBox = {
                    IsNormal = false,
                    LockSize = false,
                    Visible = false,
                    Title = "WARNING",
                    Text = "",
                },
            }

            function Tab:UpdateWarningBox(Info)
                if typeof(Info.IsNormal) == "boolean" then
                    Tab.WarningBox.IsNormal = Info.IsNormal
                end
                if typeof(Info.LockSize) == "boolean" then
                    Tab.WarningBox.LockSize = Info.LockSize
                end
                if typeof(Info.Visible) == "boolean" then
                    Tab.WarningBox.Visible = Info.Visible
                end
                if typeof(Info.Title) == "string" then
                    Tab.WarningBox.Title = Info.Title
                end
                if typeof(Info.Text) == "string" then
                    Tab.WarningBox.Text = Info.Text
                end

                WarningBoxHolder.Visible = Tab.WarningBox.Visible
                WarningTitle.Text = Tab.WarningBox.Title
                WarningText.Text = Tab.WarningBox.Text
                Tab:Resize(true)

                WarningBox.BackgroundColor3 = Tab.WarningBox.IsNormal == true and Library.Scheme.BackgroundColor
                    or Color3.fromRGB(127, 0, 0)

                WarningBoxShadowOutline.Color = Tab.WarningBox.IsNormal == true and Library.Scheme.DarkColor
                    or Color3.fromRGB(85, 0, 0)
                WarningBoxOutline.Color = Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor
                    or Color3.fromRGB(255, 50, 50)

                WarningTitle.TextColor3 = Tab.WarningBox.IsNormal == true and Library.Scheme.FontColor
                    or Color3.fromRGB(255, 50, 50)
                WarningStroke.Color = Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor
                    or Color3.fromRGB(169, 0, 0)

                if not Library.Registry[WarningBox] then
                    Library:AddToRegistry(WarningBox, {})
                end
                if not Library.Registry[WarningBoxShadowOutline] then
                    Library:AddToRegistry(WarningBoxShadowOutline, {})
                end
                if not Library.Registry[WarningBoxOutline] then
                    Library:AddToRegistry(WarningBoxOutline, {})
                end
                if not Library.Registry[WarningTitle] then
                    Library:AddToRegistry(WarningTitle, {})
                end
                if not Library.Registry[WarningStroke] then
                    Library:AddToRegistry(WarningStroke, {})
                end

                Library.Registry[WarningBox].BackgroundColor3 = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.BackgroundColor or Color3.fromRGB(127, 0, 0)
                end

                Library.Registry[WarningBoxShadowOutline].Color = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.DarkColor or Color3.fromRGB(85, 0, 0)
                end

                Library.Registry[WarningBoxOutline].Color = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(255, 50, 50)
                end

                Library.Registry[WarningTitle].TextColor3 = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.FontColor or Color3.fromRGB(255, 50, 50)
                end

                Library.Registry[WarningStroke].Color = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(169, 0, 0)
                end
            end

            function Tab:RefreshSides()
                local Offset = WarningBoxHolder.Visible and WarningBox.Size.Y.Offset + 8 or 0
                for _, Side in Tab.Sides do
                    Side.Position = UDim2.new(Side.Position.X.Scale, 0, 0, Offset)
                    Side.Size = UDim2.new(0.5, -3, 1, -Offset)
                end
            end

            function Tab:Resize(ResizeWarningBox)
                if ResizeWarningBox then
local MaximumSize , _, YText =math.floor(TabContainer.AbsoluteSize.Y / 3.25)
, Library:GetTextBounds(
                        WarningText.Text,
                        Library.Scheme.Font,
                        WarningText.TextSize,
                        WarningText.AbsoluteSize.X
                    )

                    local YBox = 24 + YText
                    if Tab.WarningBox.LockSize == true and YBox >= MaximumSize then
                        WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, YBox)
                        YBox = MaximumSize
                    else
                        WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
                    end

                    WarningText.Size = UDim2.new(1, -4, 0, YText)
                    WarningBox.Size = UDim2.new(1, -5, 0, YBox + 4)
                end

                Tab:RefreshSides()
            end

            function Tab:AddGroupbox(Info)
                local BoxHolder = New("Frame", {
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0),
                    Parent = Info.Side == 1 and TabLeft or TabRight,
                })
                New("UIListLayout", {
                    Padding = UDim.new(0, 6),
                    Parent = BoxHolder,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 4),
                    PaddingTop = UDim.new(0, 4),
                    Parent = BoxHolder,
                })

                local GroupboxHolder
,GroupboxLabel
,GroupboxContainer
,GroupboxList

                do
                    GroupboxHolder = New("Frame", {
                        BackgroundColor3 = "BackgroundColor",
                        Size = UDim2.fromScale(1, 0),
                        Parent = BoxHolder,
                    })
                    table.insert(
                        Library.Corners,
                        New("UICorner", {
                            CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                            Parent = GroupboxHolder,
                        })
                    )
                    Library:AddOutline(GroupboxHolder)

                    Library:MakeLine(GroupboxHolder, {
                        Position = UDim2.fromOffset(0, 34),
                        Size = UDim2.new(1, 0, 0, 1),
                    })

                    local BoxIcon = Library:GetCustomIcon(Info.IconName)
                    if BoxIcon then
                        New("ImageLabel", {
                            Image = BoxIcon.Url,
                            ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
                            ImageRectOffset = BoxIcon.ImageRectOffset,
                            ImageRectSize = BoxIcon.ImageRectSize,
                            Position = UDim2.fromOffset(6, 6),
                            Size = UDim2.fromOffset(22, 22),
                            Parent = GroupboxHolder,
                        })
                    end

                    GroupboxLabel = New("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.fromOffset(BoxIcon and 24 or 0, 0),
                        Size = UDim2.new(1, 0, 0, 34),
                        Text = Info.Name,
                        TextSize = 15,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = GroupboxHolder,
                    })
                    New("UIPadding", {
                        PaddingLeft = UDim.new(0, 12),
                        PaddingRight = UDim.new(0, 12),
                        Parent = GroupboxLabel,
                    })

                    GroupboxContainer = New("Frame", {
                        BackgroundTransparency = 1,
                        Position = UDim2.fromOffset(0, 35),
                        Size = UDim2.new(1, 0, 1, -35),
                        Parent = GroupboxHolder,
                    })

                    GroupboxList = New("UIListLayout", {
                        Padding = UDim.new(0, 8),
                        Parent = GroupboxContainer,
                    })
                    New("UIPadding", {
                        PaddingBottom = UDim.new(0, 7),
                        PaddingLeft = UDim.new(0, 7),
                        PaddingRight = UDim.new(0, 7),
                        PaddingTop = UDim.new(0, 7),
                        Parent = GroupboxContainer,
                    })
                end

                local Groupbox = {
                    BoxHolder = BoxHolder,
                    Holder = GroupboxHolder,
                    Container = GroupboxContainer,

                    Tab = Tab,
                    DependencyBoxes = {},
                    Elements = {},
                }

                function Groupbox:Resize()
                    GroupboxHolder.Size = UDim2.new(1, 0, 0, (GroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 49)
                end

                setmetatable(Groupbox, BaseGroupbox)

                Groupbox:Resize()
                Tab.Groupboxes[Info.Name] = Groupbox

                return Groupbox
            end

            function Tab:AddLeftGroupbox(Name, IconName)
                return Tab:AddGroupbox({ Side = 1, Name = Name, IconName = IconName })
            end

            function Tab:AddRightGroupbox(Name, IconName)
                return Tab:AddGroupbox({ Side = 2, Name = Name, IconName = IconName })
            end

            function Tab:AddTabbox(Info)
                local BoxHolder = New("Frame", {
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0),
                    Parent = Info.Side == 1 and TabLeft or TabRight,
                })
                New("UIListLayout", {
                    Padding = UDim.new(0, 6),
                    Parent = BoxHolder,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 4),
                    PaddingTop = UDim.new(0, 4),
                    Parent = BoxHolder,
                })

                local TabboxHolder
,TabboxButtons

                do
                    TabboxHolder = New("Frame", {
                        BackgroundColor3 = "BackgroundColor",
                        Size = UDim2.fromScale(1, 0),
                        Parent = BoxHolder,
                    })
                    table.insert(
                        Library.Corners,
                        New("UICorner", {
                            CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                            Parent = TabboxHolder,
                        })
                    )
                    Library:AddOutline(TabboxHolder)

                    TabboxButtons = New("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 34),
                        Parent = TabboxHolder,
                    })
                    New("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Parent = TabboxButtons,
                    })
                end

                local TotalButtons, TotalTabs ,Tabbox = 0, 1
,{
                    ActiveTab = nil,

                    BoxHolder = BoxHolder,
                    Holder = TabboxHolder,
                    Tabs = {}
                }

                function Tabbox:UpdateCorners()
                    for _, Tab in Tabbox.Tabs do
                        Tab:UpdateCorners()
                    end
                end

                function Tabbox:AddTab(Name, IconName)
                    local TabIndex = TotalTabs

                    TotalButtons = TotalButtons + 1
                    TotalTabs = TotalTabs + 1

                    local BoxIcon ,Button = Library:GetCustomIcon(IconName)
,New("TextButton", {
                        BackgroundColor3 = "MainColor",
                        BackgroundTransparency = 0,
                        Size = UDim2.fromOffset(0, 34),
                        Text = "",
                        Parent = TabboxButtons,
                    })

                    table.insert(
                        Library.Corners,
                        New("UICorner", {
                            CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                            Parent = Button,
                        })
                    )

                    local BottomCover ,LeftCover ,RightCover ,ButtonContent = New("Frame", {
                        Name = "BottomCover",
                        BackgroundColor3 = "MainColor",
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 1, -WindowInfo.CornerRadius),
                        Size = UDim2.new(1, 0, 0, WindowInfo.CornerRadius),
                        Parent = Button,
                    })
,New("Frame", {
                        Name = "LeftCover",
                        BackgroundColor3 = "MainColor",
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 0, 0),
                        Size = UDim2.new(0, WindowInfo.CornerRadius, 1, 0),
                        Visible = false,
                        Parent = Button,
                    })
,New("Frame", {
                        Name = "RightCover",
                        AnchorPoint = Vector2.new(1, 0),
                        BackgroundColor3 = "MainColor",
                        BorderSizePixel = 0,
                        Position = UDim2.new(1, 0, 0, 0),
                        Size = UDim2.new(0, WindowInfo.CornerRadius, 1, 0),
                        Visible = false,
                        Parent = Button,
                    })
,New("Frame", {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromOffset(0, 16),
                        Parent = Button,
                    })
                    New("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 8),
                        Parent = ButtonContent,
                    })

                    local ButtonIcon
                    if BoxIcon then
                        ButtonIcon = New("ImageLabel", {
                            Image = BoxIcon.Url,
                            ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
                            ImageRectOffset = BoxIcon.ImageRectOffset,
                            ImageRectSize = BoxIcon.ImageRectSize,
                            ImageTransparency = 0.5,
                            Size = UDim2.fromOffset(16, 16),
                            Parent = ButtonContent,
                        })
                    end

                    local ButtonLabel ,Line ,Container = New("TextLabel", {
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(0, 16),
                        Text = Name,
                        TextSize = 15,
                        TextTransparency = 0.5,
                        Parent = ButtonContent,
                    })
,Library:MakeLine(Button, {
                        AnchorPoint = Vector2.new(0, 1),
                        Position = UDim2.new(0, 0, 1, 1),
                        Size = UDim2.new(1, 0, 0, 1),
                    })
,New("Frame", {
                        BackgroundTransparency = 1,
                        Position = UDim2.fromOffset(0, 35),
                        Size = UDim2.new(1, 0, 1, -35),
                        Visible = false,
                        Parent = TabboxHolder,
                    })
                    local List = New("UIListLayout", {
                        Padding = UDim.new(0, 8),
                        Parent = Container,
                    })
                    New("UIPadding", {
                        PaddingBottom = UDim.new(0, 7),
                        PaddingLeft = UDim.new(0, 7),
                        PaddingRight = UDim.new(0, 7),
                        PaddingTop = UDim.new(0, 7),
                        Parent = Container,
                    })

                    local Tab = {
                        ButtonHolder = Button,
                        Container = Container,

                        ButtonCovers = {
                            BottomCover = BottomCover,
                            LeftCover = LeftCover,
                            RightCover = RightCover
                        },

                        Tab = Tab,
                        Elements = {},
                        DependencyBoxes = {},
                    }

                    function Tab:Show()
                        if Tabbox.ActiveTab then
                            Tabbox.ActiveTab:Hide()
                        end

                        Button.BackgroundTransparency = 1
                        BottomCover.BackgroundTransparency = 1
                        LeftCover.BackgroundTransparency = 1
                        RightCover.BackgroundTransparency = 1

                        ButtonLabel.TextTransparency = 0
                        if ButtonIcon then
                            ButtonIcon.ImageTransparency = 0
                        end
                        Line.Visible = false

                        Container.Visible = true

                        Tabbox.ActiveTab = Tab
                        Tab:Resize()
                    end

                    function Tab:Hide()
                        Button.BackgroundTransparency = 0
                        BottomCover.BackgroundTransparency = 0
                        LeftCover.BackgroundTransparency = 0
                        RightCover.BackgroundTransparency = 0

                        ButtonLabel.TextTransparency = 0.5
                        if ButtonIcon then
                            ButtonIcon.ImageTransparency = 0.5
                        end
                        Line.Visible = true
                        Container.Visible = false

                        Tabbox.ActiveTab = nil
                    end

                    function Tab:Resize()
                        if Tabbox.ActiveTab ~= Tab then
                            return
                        end

                        TabboxHolder.Size = UDim2.new(1, 0, 0, (List.AbsoluteContentSize.Y / Library.DPIScale) + 49)
                    end

                    function Tab:UpdateCorners()
                        LeftCover.Visible = TabIndex ~= 1
                        RightCover.Visible = TabIndex ~= TotalButtons

                        BottomCover.Position = UDim2.new(0, 0, 1, -WindowInfo.CornerRadius)
                        BottomCover.Size = UDim2.new(1, 0, 0, WindowInfo.CornerRadius)

                        LeftCover.Size = UDim2.new(0, WindowInfo.CornerRadius, 1, 0)
                        RightCover.Size = UDim2.new(0, WindowInfo.CornerRadius, 1, 0)
                    end

                    --// Execution \\--
                    if not Tabbox.ActiveTab then
                        Tab:Show()
                    end

                    Button.MouseButton1Click:Connect(Tab.Show)

                    setmetatable(Tab, BaseGroupbox)

                    Tabbox.Tabs[Name] = Tab
                    Tabbox:UpdateCorners()

                    return Tab
                end

                if Info.Name then
                    Tab.Tabboxes[Info.Name] = Tabbox
                else
                    table.insert(Tab.Tabboxes, Tabbox)
                end

                return Tabbox
            end

            function Tab:AddLeftTabbox(Name)
                return Tab:AddTabbox({ Side = 1, Name = Name })
            end

            function Tab:AddRightTabbox(Name)
                return Tab:AddTabbox({ Side = 2, Name = Name })
            end

            function Tab:Hover(Hovering)
                if Library.ActiveTab == Tab then
                    return
                end

                TweenService:Create(TabLabel, Library.TweenInfo, {
                    TextTransparency = Hovering and 0.25 or 0.5,
                }):Play()
                if TabIcon then
                    TweenService:Create(TabIcon, Library.TweenInfo, {
                        ImageTransparency = Hovering and 0.25 or 0.5,
                    }):Play()
                end
            end

            function Tab:Show()
                if Library.ActiveTab then
                    Library.ActiveTab:Hide()
                end

                TweenService:Create(TabButton, Library.TweenInfo, {
                    BackgroundTransparency = 0,
                }):Play()
                TweenService:Create(TabLabel, Library.TweenInfo, {
                    TextTransparency = 0,
                }):Play()
                if TabIcon then
                    TweenService:Create(TabIcon, Library.TweenInfo, {
                        ImageTransparency = 0,
                    }):Play()
                end

                if Description then
                    Window:ShowTabInfo(Name, Description)
                end

                TabContainer.Visible = true
                Tab:RefreshSides()

                Library.ActiveTab = Tab

                if Library.Searching then
                    Library:UpdateSearch(Library.SearchText)
                end
            end

            function Tab:Hide()
                TweenService:Create(TabButton, Library.TweenInfo, {
                    BackgroundTransparency = 1,
                }):Play()
                TweenService:Create(TabLabel, Library.TweenInfo, {
                    TextTransparency = 0.5,
                }):Play()
                if TabIcon then
                    TweenService:Create(TabIcon, Library.TweenInfo, {
                        ImageTransparency = 0.5,
                    }):Play()
                end
                TabContainer.Visible = false

                Window:HideTabInfo()

                Library.ActiveTab = nil
            end

            function Tab:SetVisible(Visible)
                TabButton.Visible = Visible

                if not Visible and Library.ActiveTab == Tab then
                    Tab:Hide()
                end
            end

            --// Execution \\--
            if not Library.ActiveTab then
                Tab:Show()
            end

            TabButton.MouseEnter:Connect(function()
                Tab:Hover(true)
            end)
            TabButton.MouseLeave:Connect(function()
                Tab:Hover(false)
            end)
            TabButton.MouseButton1Click:Connect(Tab.Show)

            Library.Tabs[Name] = Tab

            return Tab
        end

        function Window:AddKeyTab(...)
            local Name ,Icon ,Description 
            if select("#", ...) == 1 and typeof(...) == "table" then
                local Info = select(1, ...)
                Name = Info.Name or "Tab"
                Icon = Info.Icon
                Description = Info.Description
            else
                Name = select(1, ...) or "Tab"
                Icon = select(2, ...)
                Description = select(3, ...)
            end

            Icon = Icon or "key"

            local TabButton,TabLabel
,TabIcon
,TabContainer

            Icon = if Icon == "key" then KeyIcon else Library:GetCustomIcon(Icon)
            do
                TabButton = New("TextButton", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
                    Text = "",
                    Parent = Tabs,
                })
                local ButtonPadding = New("UIPadding", {
                    PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
                    PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
                    PaddingRight = UDim.new(0, IsCompact and 6 or 12),
                    PaddingTop = UDim.new(0, IsCompact and 6 or 11),
                    Parent = TabButton,
                })

                TabLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(30, 0),
                    Size = UDim2.new(1, -30, 1, 0),
                    Text = Name,
                    TextSize = 16,
                    TextTransparency = 0.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Visible = not IsCompact,
                    Parent = TabButton,
                })

                if Icon then
                    TabIcon = New("ImageLabel", {
                        Image = Icon.Url,
                        ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
                        ImageRectOffset = Icon.ImageRectOffset,
                        ImageRectSize = Icon.ImageRectSize,
                        ImageTransparency = 0.5,
                        Size = UDim2.fromScale(1, 1),
                        SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,
                        Parent = TabButton,
                    })
                end

                table.insert(Library.TabButtons, {
                    Label = TabLabel,
                    Padding = ButtonPadding,
                    Icon = TabIcon,
                })

                --// Tab Container \\--
                TabContainer = New("ScrollingFrame", {
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    CanvasSize = UDim2.fromScale(0, 0),
                    ScrollBarThickness = 0,
                    Size = UDim2.fromScale(1, 1),
                    Visible = false,
                    Parent = Container,
                })
                New("UIListLayout", {
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    Padding = UDim.new(0, 8),
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Parent = TabContainer,
                })
                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 1),
                    PaddingRight = UDim.new(0, 1),
                    Parent = TabContainer,
                })
            end

            --// Tab Table \\--
            local Tab = {
                Elements = {},
                Description = Description,
                IsKeyTab = true,
            }

            function Tab:AddKeyBox(Callback)
                assert(typeof(Callback) == "function", "Callback must be a function")

                local Holder = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.75, 0, 0, 21),
                    Parent = TabContainer,
                })

                local Box = New("TextBox", {
                    BackgroundColor3 = "MainColor",
                    PlaceholderText = "Key",
                    Size = UDim2.new(1, -71, 1, 0),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Holder,
                })
                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                    Parent = Box,
                })
                New("UIStroke", {
                    Color = "OutlineColor",
                    Parent = Box,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                        Parent = Box,
                    })
                )

                local Button = New("TextButton", {
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = "MainColor",
                    Position = UDim2.fromScale(1, 0),
                    Size = UDim2.new(0, 63, 1, 0),
                    Text = "Execute",
                    TextSize = 14,
                    Parent = Holder,
                })
                New("UIStroke", {
                    Color = "OutlineColor",
                    Parent = Button,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                        Parent = Button,
                    })
                )

                Button.InputBegan:Connect(function(Input)
                    if not IsClickInput(Input) then
                        return
                    end

                    if not Library:MouseIsOverFrame(Button, Input.Position) then
                        return
                    end

                    Callback(Box.Text)
                end)
            end

            function Tab:RefreshSides() end
            function Tab:Resize() end
            function Tab:UpdateCorners() end

            function Tab:Hover(Hovering)
                if Library.ActiveTab == Tab then
                    return
                end

                TweenService:Create(TabLabel, Library.TweenInfo, {
                    TextTransparency = Hovering and 0.25 or 0.5,
                }):Play()
                if TabIcon then
                    TweenService:Create(TabIcon, Library.TweenInfo, {
                        ImageTransparency = Hovering and 0.25 or 0.5,
                    }):Play()
                end
            end

            function Tab:Show()
                if Library.ActiveTab then
                    Library.ActiveTab:Hide()
                end

                TweenService:Create(TabButton, Library.TweenInfo, {
                    BackgroundTransparency = 0,
                }):Play()
                TweenService:Create(TabLabel, Library.TweenInfo, {
                    TextTransparency = 0,
                }):Play()
                if TabIcon then
                    TweenService:Create(TabIcon, Library.TweenInfo, {
                        ImageTransparency = 0,
                    }):Play()
                end
                TabContainer.Visible = true

                if Description then
                    Window:ShowTabInfo(Name, Description)
                end

                Tab:RefreshSides()

                Library.ActiveTab = Tab

                if Library.Searching then
                    Library:UpdateSearch(Library.SearchText)
                end
            end

            function Tab:Hide()
                TweenService:Create(TabButton, Library.TweenInfo, {
                    BackgroundTransparency = 1,
                }):Play()
                TweenService:Create(TabLabel, Library.TweenInfo, {
                    TextTransparency = 0.5,
                }):Play()
                if TabIcon then
                    TweenService:Create(TabIcon, Library.TweenInfo, {
                        ImageTransparency = 0.5,
                    }):Play()
                end
                TabContainer.Visible = false

                Window:HideTabInfo()

                Library.ActiveTab = nil
            end

            function Tab:SetVisible(Visible)
                TabButton.Visible = Visible

                if not Visible and Library.ActiveTab == Tab then
                    Tab:Hide()
                end
            end

            --// Execution \\--
            if not Library.ActiveTab then
                Tab:Show()
            end

            TabButton.MouseEnter:Connect(function()
                Tab:Hover(true)
            end)
            TabButton.MouseLeave:Connect(function()
                Tab:Hover(false)
            end)
            TabButton.MouseButton1Click:Connect(Tab.Show)

            Tab.Container = TabContainer
            setmetatable(Tab, BaseGroupbox)

            Library.Tabs[Name] = Tab

            return Tab
        end

        function Window:AddDialog(Idx, Info)
            Info = Library:Validate(Info, Templates.Dialog)

            local FooterButtonsList ,DialogFrame
,DialogOverlay
,DialogContainer
,ButtonsHolder
={}

            DialogOverlay = New("TextButton", {
                AutoButtonColor = false,
                BackgroundColor3 = "DarkColor",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                Active = false,
                ZIndex = 9000,
                Visible = true,
                Parent = MainFrame,
            })
            TweenService:Create(DialogOverlay, Library.TweenInfo, {
                BackgroundTransparency = 0.5,
            }):Play()

            DialogFrame = New("TextButton", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = "BackgroundColor",
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(300, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 9001,
                Parent = DialogOverlay,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                    Parent = DialogFrame,
                })
            )
            Library:AddOutline(DialogFrame)

            local InnerContainer ,DialogScale = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 9002,
                Parent = DialogFrame,
            })
,New("UIScale", {
                Scale = 0.95,
                Parent = DialogFrame,
            })
            TweenService:Create(DialogScale, Library.TweenInfo, {
                Scale = 1
            }):Play()
local _InnerPadding , _InnerLayout , HeaderContainer =New("UIPadding", {
                PaddingBottom = UDim.new(0, 15),
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                PaddingTop = UDim.new(0, 15),
                Parent = InnerContainer,
            })
, New("UIListLayout", {
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = InnerContainer,
            })
, New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 1,
                ZIndex = 9002,
                Parent = InnerContainer,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = HeaderContainer,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 5),
                Parent = HeaderContainer,
            })

            local TitleRow = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 1,
                ZIndex = 9002,
                Parent = HeaderContainer,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 6),
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = TitleRow,
            })

            if Info.Icon then
                local ParsedIcon = Library:GetCustomIcon(Info.Icon)
                if ParsedIcon then
                    local IconImg = New("ImageLabel", {
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(16, 16),
                        Image = ParsedIcon.Url,
                        ImageColor3 = "FontColor",
                        ImageRectOffset = ParsedIcon.ImageRectOffset,
                        ImageRectSize = ParsedIcon.ImageRectSize,
                        LayoutOrder = 1,
                        ZIndex = 9002,
                        Parent = TitleRow,
                    })
                    if Info.TitleColor then
                        IconImg.ImageColor3 = Info.TitleColor
                    end
                end
            end

            local TitleLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                AutomaticSize = Enum.AutomaticSize.Y,
                Text = Info.Title,
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 2,
                ZIndex = 9002,
                Parent = TitleRow,
            })
            if Info.TitleColor then
                TitleLabel.TextColor3 = Info.TitleColor
            end

            local DescriptionLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                AutomaticSize = Enum.AutomaticSize.Y,
                Text = Info.Description,
                TextSize = 14,
                TextTransparency = Info.DescriptionColor and 0 or 0.2,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                LayoutOrder = 2,
                ZIndex = 9002,
                Parent = HeaderContainer,
            })
            if Info.DescriptionColor then
                DescriptionLabel.TextColor3 = Info.DescriptionColor
            end

            DialogContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 4,
                ZIndex = 9002,
                Parent = InnerContainer,
            })
New("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = DialogContainer,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 5),
                Parent = DialogContainer,
            })

            local _Sep2 = New("Frame", {
                BackgroundColor3 = "OutlineColor",
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 1),
                LayoutOrder = 5,
                ZIndex = 9002,
                Parent = InnerContainer,
            })

            ButtonsHolder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 6,
                ZIndex = 9002,
                Parent = InnerContainer,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 8),
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Wraps = true,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = ButtonsHolder,
            })
            New("UIPadding", {
                PaddingTop = UDim.new(0, 5),
                Parent = ButtonsHolder,
            })

            local Dialog = {
                Elements = {},
                Container = DialogContainer,
            }

            function Dialog:Resize()
                local MaxWidth ,MinWidth ,TotalButtonWidth ,ButtonCount ,HasButtons = MainFrame.AbsoluteSize.X * 0.75
,400
,0
,0
,false

                for _, BtnWrap in FooterButtonsList do
                    HasButtons = true
                    ButtonCount = ButtonCount + 1
                    TotalButtonWidth = TotalButtonWidth + BtnWrap.Container.Size.X.Offset
                end

                local TargetWidth = MinWidth
                if HasButtons then
                    local RequiredWidth = TotalButtonWidth + ((ButtonCount - 1) * 8) + 30
                    TargetWidth = math.max(MinWidth, math.min(RequiredWidth, MaxWidth))
                end

                DialogFrame.Size = UDim2.fromOffset(TargetWidth, 0)
local _DescX, DescY =Library:GetTextBounds(DescriptionLabel.Text, Library.Scheme.Font, 14, TargetWidth - 30)
                DescriptionLabel.Size = UDim2.new(1, 0, 0, DescY)

                local HasElements = false
                for _, v in DialogContainer:GetChildren() do
                    if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
                        HasElements = true
                        break
                    end
                end
                DialogContainer.Visible = HasElements

                ButtonsHolder.Visible = HasButtons
                _Sep2.Visible = HasButtons
            end

            function Dialog:SetTitle(Title)
                TitleLabel.Text = Title
                Dialog:Resize()
            end

            function Dialog:SetDescription(Description)
                DescriptionLabel.Text = Description
                Dialog:Resize()
            end

            function Dialog:Dismiss()
                Library.ActiveDialog = nil
                local CloseTween = TweenService:Create(DialogScale, Library.TweenInfo, { Scale = 0.95 })
                TweenService:Create(DialogOverlay, Library.TweenInfo, { BackgroundTransparency = 1 }):Play()
                CloseTween:Play()

                task.delay(Library.TweenInfo.Time, function()
                    DialogOverlay:Destroy()
                end)
                Library.Dialogues[Idx] = nil
            end

            DialogOverlay.MouseButton1Click:Connect(function()
                if Info.OutsideClickDismiss then
                    Dialog:Dismiss()
                end
            end)

            function Dialog:RemoveFooterButton(ButtonIdx)
                if FooterButtonsList[ButtonIdx] then
                    FooterButtonsList[ButtonIdx].Container:Destroy()
                    FooterButtonsList[ButtonIdx] = nil
                end
            end

            function Dialog:SetButtonDisabled(ButtonIdx, Disabled)
                if FooterButtonsList[ButtonIdx] and type(FooterButtonsList[ButtonIdx].SetDisabled) == "function" then
                    FooterButtonsList[ButtonIdx]:SetDisabled(Disabled)
                end
            end

            function Dialog:SetButtonOrder(ButtonIdx, Order)
                if FooterButtonsList[ButtonIdx] and FooterButtonsList[ButtonIdx].Container then
                    FooterButtonsList[ButtonIdx].Container.LayoutOrder = Order
                end
            end

            function Dialog:AddFooterButton(ButtonIdx, ButtonInfo)
                Dialog:RemoveFooterButton(ButtonIdx)

                local WaitTime ,ButtonContainer ,BtnColor ,BtnOutline ,Variant = ButtonInfo.WaitTime or 0
,New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromOffset(0, 26),
                    LayoutOrder = ButtonInfo.Order or 0,
                    ZIndex = 9002,
                    Parent = ButtonsHolder,
                })
,"MainColor"
,"OutlineColor"
,ButtonInfo.Variant or "Primary"

                if Variant == "Primary" then
                    BtnColor = "FontColor"
                    BtnOutline = "FontColor"
                elseif Variant == "Secondary" then
                    BtnColor = "MainColor"
                    BtnOutline = "OutlineColor"
                elseif Variant == "Destructive" then
                    BtnColor = "DestructiveColor"
                    BtnOutline = "DestructiveColor"
                elseif Variant == "Ghost" then
                    BtnColor = "BackgroundColor"
                    BtnOutline = "BackgroundColor"
                end

                local TextBtn = New("TextButton", {
                    BackgroundColor3 = BtnColor,
                    BorderColor3 = BtnOutline,
                    BackgroundTransparency = WaitTime > 0 and 0.5 or 0,
                    Size = UDim2.fromOffset(0, 26),
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 9002,
                    Parent = ButtonContainer,
                })
                Library:AddOutline(TextBtn)
                table.insert(
                    Library.Corners,
                    New("UICorner", { 
                        CornerRadius = UDim.new(0, Library.CornerRadius), 
                        Parent = TextBtn 
                    })
                )
local _BtnPadding , TextColor =New("UIPadding", {
                    PaddingLeft = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 15),
                    Parent = TextBtn,
                })
, Library.Scheme.FontColor
                if Variant == "Primary" then
                    TextColor = Library.Scheme.BackgroundColor
                elseif Variant == "Destructive" then
                    TextColor = Color3.new(1, 1, 1)
                end

                local BtnLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    Text = ButtonInfo.Title or ButtonIdx,
                    TextColor3 = TextColor,
                    TextTransparency = WaitTime > 0 and 0.5 or 0,
                    TextSize = 14,
                    ZIndex = 9002,
                    Parent = TextBtn,
                })
local LabelX=Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
                ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
                TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

                local ProgressBar
                if WaitTime > 0 then
                    ProgressBar = New("Frame", {
                        BackgroundColor3 = "AccentColor",
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 1, -2),
                        Size = UDim2.new(0, 0, 0, 2),
                        ZIndex = 2,
                        Parent = TextBtn,
                    })
                    table.insert(
                        Library.Corners,
                        New("UICorner", { 
                            CornerRadius = UDim.new(0, Library.CornerRadius), 
                            Parent = ProgressBar 
                        })
                    )
                end

                local IsActive = WaitTime <= 0

                local ButtonWrap ,ActiveColor = {
                    Container = ButtonContainer,
                    SetDisabled = function(self, Disabled)
                        IsActive = not Disabled
                        if Disabled then
                            TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0.5 }):Play()
                            TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0.5 }):Play()
                        else
                            TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0 }):Play()
                            TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0 }):Play()
                        end
                    end
                }
,typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
                local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor or Library:GetBetterColor(ActiveColor, 10)

                TextBtn.MouseEnter:Connect(function()
                    if not IsActive then return end
                    TweenService:Create(TextBtn, Library.TweenInfo, {
                        BackgroundColor3 = HoverColor
                    }):Play()
                end)
                TextBtn.MouseLeave:Connect(function()
                    if not IsActive then return end
                    TweenService:Create(TextBtn, Library.TweenInfo, {
                        BackgroundColor3 = ActiveColor
                    }):Play()
                end)

                TextBtn.MouseButton1Click:Connect(function()
                    if not IsActive then return end
                    if ButtonInfo.Callback then
                        ButtonInfo.Callback(Dialog)
                    end
                    if Info.AutoDismiss then
                        Dialog:Dismiss()
                    end
                end)

                if WaitTime > 0 then
                    TweenService:Create(ProgressBar, TweenInfo.new(WaitTime, Enum.EasingStyle.Linear), {
                        Size = UDim2.new(1, 0, 0, 2)
                    }):Play()

                    task.delay(WaitTime, function()
                        ButtonWrap:SetDisabled(false)
                        if ProgressBar then
                            TweenService:Create(ProgressBar, Library.TweenInfo, {
                                BackgroundTransparency = 1
                            }):Play()
                        end
                    end)
                end

                FooterButtonsList[ButtonIdx] = ButtonWrap
            end

            for BIdx, BInfo in Info.FooterButtons do
                if type(BIdx) == "number" and BInfo.Id then BIdx = BInfo.Id end
                Dialog:AddFooterButton(BIdx, BInfo)
            end

            setmetatable(Dialog, BaseGroupbox)
            Library.Dialogues[Idx] = Dialog

            Dialog:Resize()

            Library.ActiveDialog = Dialog
            return Dialog
        end

        function Window:Toggle(Value)
            if Library.ActiveLoading then
                if Value == true then
                    return
                end

                if not Library.Toggled then
                    return
                end
            end

            if typeof(Value) == "boolean" then
                Library.Toggled = Value
            else
                Library.Toggled = not Library.Toggled
            end

            MainFrame.Visible = Library.Toggled

            if WindowInfo.UnlockMouseWhileOpen then
                ModalElement.Modal = Library.Toggled
            end

            if Library.Toggled and not Library.IsMobile then
                local OldMouseIconEnabled ,ShowCursorBinding = UserInputService.MouseIconEnabled
,Library.ShowCursorBinding
                pcall(function()
                    RunService:UnbindFromRenderStep(ShowCursorBinding)
                end)
                RunService:BindToRenderStep(ShowCursorBinding, Enum.RenderPriority.Last.Value, function()
                    UserInputService.MouseIconEnabled = not Library.ShowCustomCursor

                    Cursor.Position = UDim2.fromOffset(Mouse.X, Mouse.Y)
                    Cursor.Visible = Library.ShowCustomCursor

                    if not (Library.Toggled and ScreenGui and ScreenGui.Parent) then
                        UserInputService.MouseIconEnabled = OldMouseIconEnabled
                        Cursor.Visible = false
                        RunService:UnbindFromRenderStep(ShowCursorBinding)
                    end
                end)
            elseif not Library.Toggled then
                TooltipLabel.Visible = false

                for _, Option in Library.Options do
                    if Option.Type == "ColorPicker" then
                        Option.ColorMenu:Close()
                        Option.ContextMenu:Close()
                    elseif Option.Type == "Dropdown" or Option.Type == "KeyPicker" then
                        Option.Menu:Close()
                    end
                end
            end
        end

        function Library:Toggle(Value)
            return Window:Toggle(Value)
        end

        if WindowInfo.EnableSidebarResize then
            local Threshold ,Dragging ,SidebarGrabber ,StartPos,StartWidth
,Changed
= (WindowInfo.MinSidebarWidth + WindowInfo.SidebarCompactWidth) * WindowInfo.SidebarCollapseThreshold
,false
,(New("TextButton", {
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0),
                Size = UDim2.new(0, 8, 1, 0),
                Text = "",
                Parent = DividerLine,
            })
)            SidebarGrabber.MouseEnter:Connect(function()
                TweenService:Create(DividerLine, Library.TweenInfo, {
                    BackgroundColor3 = Library:GetLighterColor(Library.Scheme.OutlineColor),
                }):Play()
            end)
            SidebarGrabber.MouseLeave:Connect(function()
                if Dragging then
                    return
                end
                TweenService:Create(DividerLine, Library.TweenInfo, {
                    BackgroundColor3 = Library.Scheme.OutlineColor,
                }):Play()
            end)

            SidebarGrabber.InputBegan:Connect(function(Input)
                if not IsClickInput(Input) then
                    return
                end

                Library.CantDragForced = true

                StartPos = Input.Position
                StartWidth = Window:GetSidebarWidth()
                Dragging = true

                Changed = Input.Changed:Connect(function()
                    if Input.UserInputState ~= Enum.UserInputState.End then
                        return
                    end

                    Library.CantDragForced = false
                    TweenService:Create(DividerLine, Library.TweenInfo, {
                        BackgroundColor3 = Library.Scheme.OutlineColor,
                    }):Play()

                    Dragging = false
                    if Changed and Changed.Connected then
                        Changed:Disconnect()
                        Changed = nil
                    end
                end)
            end)

            Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input)
                if not Library.Toggled or not (ScreenGui and ScreenGui.Parent) then
                    Dragging = false
                    if Changed and Changed.Connected then
                        Changed:Disconnect()
                        Changed = nil
                    end

                    return
                end

                if Dragging and IsHoverInput(Input) then
                    local Delta = Input.Position - StartPos
                    local Width = StartWidth + Delta.X

                    if WindowInfo.DisableCompactingSnap then
                        Window:SetSidebarWidth(Width)
                        return
                    end

                    if Width > Threshold then
                        Window:SetSidebarWidth(math.max(Width, WindowInfo.MinSidebarWidth))
                    else
                        Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
                    end
                end
            end))
        end
        if WindowInfo.EnableCompacting and WindowInfo.SidebarCompacted then
            Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
        end
        if WindowInfo.AutoShow and not Library.ActiveLoading then
            task.spawn(Library.Toggle)
        end

        if Library.IsMobile then
            local ToggleButton ,LockButton = Library:AddDraggableButton("Toggle", function()
                Library:Toggle()
            end, true)
,Library:AddDraggableButton("Lock", function(self)
                Library.CantDragForced = not Library.CantDragForced
                self:SetText(Library.CantDragForced and "Unlock" or "Lock")
            end, true)

            if WindowInfo.MobileButtonsSide == "Right" then
                ToggleButton.Button.Position = UDim2.new(1, -6, 0, 6)
                ToggleButton.Button.AnchorPoint = Vector2.new(1, 0)

                LockButton.Button.Position = UDim2.new(1, -6, 0, 46)
                LockButton.Button.AnchorPoint = Vector2.new(1, 0)
            else
                LockButton.Button.Position = UDim2.fromOffset(6, 46)
            end

            if WindowInfo.ShowMobileButtons == false then
                ToggleButton.Button.Visible = false
                LockButton.Button.Visible = false
            end
        end

        --// Execution \\--
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            Library:UpdateSearch(SearchBox.Text)
        end)

        Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input)
            if Library.Unloaded then
                return
            end

            if UserInputService:GetFocusedTextBox() then
                return
            end

            if
                (
                    typeof(Library.ToggleKeybind) == "table"
                        and Library.ToggleKeybind.Type == "KeyPicker"
                        and Input.KeyCode.Name == Library.ToggleKeybind.Value
                ) or Input.KeyCode == Library.ToggleKeybind
            then
                Library.Toggle()
            end
        end))

        Library:GiveSignal(UserInputService.WindowFocused:Connect(function()
            Library.IsRobloxFocused = true
        end))
        Library:GiveSignal(UserInputService.WindowFocusReleased:Connect(function()
            Library.IsRobloxFocused = false
        end))

        return Window
    end

    function Library:CreateLoading(LoadingInfo)
        if Library.ActiveLoading then
            warn("Loading GUI already exists, you cannot create multiple Loading GUIs.")
            return Library.ActiveLoading
        end

        LoadingInfo = Library:Validate(LoadingInfo, Templates.Loading)

        local Loading ,ScreenGui = {
            CurrentStep = LoadingInfo.CurrentStep,
            TotalSteps = LoadingInfo.TotalSteps,

            ShowSidebar = LoadingInfo.ShowSidebar,
            AutoResizeHeight = LoadingInfo.AutoResizeHeight,
            IsError = false,
            Destroyed = false,

            WindowWidth = LoadingInfo.WindowWidth,
            WindowHeight = LoadingInfo.WindowHeight,
            BaseWindowHeight = LoadingInfo.WindowHeight,
            WindowErrorHeight = LoadingInfo.WindowHeight,

            ContentWidth = LoadingInfo.ContentWidth,
            SidebarWidth = LoadingInfo.SidebarWidth,
        }
,New("ScreenGui", {
            Name = "ObsidianLoading",
            DisplayOrder = 999,
            ResetOnSpawn = false
        })
        ParentUI(ScreenGui)
        Loading.ScreenGui = ScreenGui

        ScreenGui.DescendantRemoving:Connect(function(Instance)
            Library:RemoveFromRegistry(Instance)
        end)

        --// Main Frame \\--
        local MainFrame = New("TextButton", {
            Name = "Main",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
            end,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(Loading.ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth, Loading.WindowHeight),
            ClipsDescendants = true,
            Text = "",
            AutoButtonColor = false,
            Parent = ScreenGui,
        })
        Library:AddOutline(MainFrame)
        table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = MainFrame }))

        local MainScale = New("UIScale", {
            Scale = Library.IsMobile and 0.8 or 1,
            Parent = MainFrame
        })
        table.insert(Library.Scales, MainScale)
        Library.ScalesOffset[MainScale] = Library.IsMobile and 0.2 or 0

        --// Layout Containers \\--
        local Container ,SideBar = New("Frame", {
            Name = "Content",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(0, Loading.ContentWidth, 1, 0),
            Parent = MainFrame,
        })
,New("Frame", {
            Name = "SideBar",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(Loading.ContentWidth, 0),
            Size = UDim2.new(0, Loading.ShowSidebar and Loading.SidebarWidth or 0, 1, 0),
            ClipsDescendants = true,
            Visible = Loading.ShowSidebar,
            Parent = MainFrame,
        })
        local SidebarCorner = New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = SideBar })
        table.insert(Library.Corners, SidebarCorner)

        Library:AddOutline(SideBar)

        local SidebarDivider ,TopBar = New("Frame", {
            BackgroundColor3 = "OutlineColor",
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(0, 1, 1, 0),
            Visible = Loading.ShowSidebar,
            Parent = SideBar,
        })
,New("Frame", {
            Name = "TopBar",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 48),
            ZIndex = 2,
            Parent = Container,
        })
        Library:MakeDraggable(MainFrame, TopBar, true, true)

        local TitleHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = TopBar,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6),
            Parent = TitleHolder,
        })
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            Parent = TitleHolder,
        })

        if LoadingInfo.Icon then
            local Icon = Library:GetCustomIcon(LoadingInfo.Icon)
New("ImageLabel", {
                Image = Icon.Url,
                ImageRectOffset = Icon.ImageRectOffset,
                ImageRectSize = Icon.ImageRectSize,
                Size = LoadingInfo.IconSize,
                Parent = TitleHolder,
            })
        else
New("TextLabel", {
                BackgroundTransparency = 1,
                Size = LoadingInfo.IconSize,
                Text = LoadingInfo.Title:sub(1, 1),
                TextScaled = true,
                Visible = false,
                Parent = TitleHolder,
            })
        end

        local TitleX = Library:GetTextBounds(
            LoadingInfo.Title,
            Library.Scheme.Font,
            20,
            TitleHolder.AbsoluteSize.X - (LoadingInfo.Icon and (LoadingInfo.IconSize.X.Offset + 6) or 0) - 12
        )
New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, TitleX, 1, 0),
            Text = LoadingInfo.Title,
            TextSize = 20,
            Parent = TitleHolder,
        })

        Library:MakeLine(Container, {
            Position = UDim2.fromOffset(0, 48),
            Size = UDim2.new(1, 0, 0, 1),
        })

        --// Loading Content Elements \\--
        local InnerContent = New("Frame", {
            Name = "InnerContent",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 49),
            Size = UDim2.new(1, 0, 1, -49),
            Parent = Container,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 12),
            Parent = InnerContent,
        })

        local IconHolder ,LoaderIcon = New("Frame", {
            Name = "IconHolder",
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(64, 64),
            Parent = InnerContent,
        })
,Library:GetCustomIcon(LoadingInfo.LoadingIcon)
        local LoadingIcon ,RotationTween
=(New("ImageLabel", {
            Name = "LoaderIcon",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            Image = LoaderIcon.Url,
            ImageRectOffset = LoaderIcon.ImageRectOffset,
            ImageRectSize = LoaderIcon.ImageRectSize,
            ImageColor3 = LoadingInfo.LoadingIconColor or ((LoadingInfo.LoadingIcon == Templates.Loading.LoadingIcon) and "AccentColor" or "WhiteColor"),
            Parent = IconHolder,
        })
)        if LoadingInfo.LoadingIconTweenTime > 0 then
            RotationTween = TweenService:Create(
                LoadingIcon,
                TweenInfo.new(LoadingInfo.LoadingIconTweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
                { Rotation = 360 }
            )
            RotationTween:Play()
        end

        local MessageLabel ,DescriptionLabel ,SliderBar = New("TextLabel", {
            BackgroundTransparency = 1,
            AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
            Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
            Text = "",
            TextSize = 18,
            TextWrapped = Loading.AutoResizeHeight,
            Parent = InnerContent,
        })
,New("TextLabel", {
            BackgroundTransparency = 1,
            AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
            Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
            Text = "",
            TextSize = 14,
            TextTransparency = 0.5,
            TextWrapped = Loading.AutoResizeHeight,
            Parent = InnerContent,
        })
,New("Frame", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.new(0.7, 0, 0, 15),
            Parent = InnerContent,
        })
        Library:AddOutline(SliderBar)
        table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderBar }))

        local SliderFill = New("Frame", {
            BackgroundColor3 = "AccentColor",
            BorderSizePixel = 0,
            Size = UDim2.fromScale(0, 1),
            Parent = SliderBar,
        })
        table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderFill }))

        local ProgressLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            TextSize = 14,
            ZIndex = 2,
            Parent = SliderBar,
        })
        New("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
            Color = "DarkColor",
            LineJoinMode = Enum.LineJoinMode.Miter,
            Parent = ProgressLabel,
        })

        --// Sidebar Object \\--
        local SidebarScrolling = New("ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Size = UDim2.fromScale(1, 1),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = "OutlineColor",
            Parent = SideBar,
        })
        local SidebarList = New("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = SidebarScrolling,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 12),
            Parent = SidebarScrolling,
        })

        local SidebarObject = {
            Elements = {},
            DependencyBoxes = {},
            Tabboxes = {},

            BoxHolder = SidebarScrolling,
            Container = SidebarScrolling,

            Resize = function(self)
                SidebarScrolling.CanvasSize = UDim2.fromOffset(0, SidebarList.AbsoluteContentSize.Y + 24)
            end,
            Tab = {
                Elements = {},
                DependencyBoxes = {},
                DependencyGroupboxes = {},
                Tabboxes = {},
            },
        }

        SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SidebarObject:Resize()
        end)

        setmetatable(SidebarObject, BaseGroupbox)
        Loading.Sidebar = SidebarObject

        --// Error Frame \\--
        local ErrorFrame = New("Frame", {
            Name = "Error",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 49),
            Size = UDim2.new(1, 0, 1, -49),
            ClipsDescendants = true,
            Visible = false,
            Parent = Container,
        })
local _ErrorTitle , ErrorLabel , ErrorButtonsDivider , ErrorButtonsHolder =New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 15),
            Size = UDim2.new(1, -30, 0, 18),
            Text = "Error",
            TextColor3 = "RedColor",
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = ErrorFrame,
        })
, New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 39),
            Size = UDim2.new(1, -30, 1, -90),
            Text = "Error Message",
            TextSize = 14,
            TextTransparency = 0.2,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            Parent = ErrorFrame,
        })
, New("Frame", {
            BackgroundColor3 = "OutlineColor",
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 1, -48),
            Size = UDim2.new(1, -30, 0, 1),
            Visible = false,
            Parent = ErrorFrame,
        })
, New("Frame", {
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 1, 0),
            Size = UDim2.new(1, 0, 0, 42),
            Visible = false,
            Parent = ErrorFrame,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ErrorButtonsHolder,
        })
        New("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            Parent = ErrorButtonsHolder,
        })

        function Loading:UpdateLayout()
            if Loading.IsError then
                Loading:RecalculateErrorHeight()
            end

            local ShowSidebar = Loading.ShowSidebar
            local FinalWidth ,FinalHeight = ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth
,Loading.IsError and Loading.WindowErrorHeight or Loading.WindowHeight

            if ShowSidebar then
                SideBar.Visible = true
                SidebarDivider.Visible = true
            end

            TweenService:Create(MainFrame, Library.TweenInfo, { Size = UDim2.fromOffset(FinalWidth, FinalHeight) }):Play()
            TweenService:Create(SideBar, Library.TweenInfo, { Position = UDim2.fromOffset(Loading.ContentWidth, 0), Size = UDim2.new(0, ShowSidebar and Loading.SidebarWidth or 0, 1, 0) }):Play()
            TweenService:Create(Container, Library.TweenInfo, { Size = UDim2.new(0, ShowSidebar and Loading.ContentWidth or Loading.WindowWidth, 1, 0) }):Play()

            if not ShowSidebar then
                task.delay(Library.TweenInfo.Time, function()
                    if not Loading.ShowSidebar then
                        SideBar.Visible = false
                        SidebarDivider.Visible = false
                    end
                end)
            end
        end

        --// Content Page \\--
        function Loading:RecalculateLoadingHeight()
            if not Loading.AutoResizeHeight then
                return
            end

            local RequiredHeight = 
97                + InnerContent.UIListLayout.AbsoluteContentSize.Y

            Loading.WindowHeight = math.max(Loading.BaseWindowHeight, RequiredHeight)
        end

        function Loading:SetMessage(Text)
            MessageLabel.Text = Text

            if Loading.AutoResizeHeight then
                Loading:RecalculateLoadingHeight()
                Loading:UpdateLayout()
            end
        end

        function Loading:SetDescription(Text)
            DescriptionLabel.Text = Text

            if Loading.AutoResizeHeight then
                Loading:RecalculateLoadingHeight()
                Loading:UpdateLayout()
            end
        end

        function Loading:SetLoadingIcon(Icon)
            local IconData = Library:GetCustomIcon(Icon)
            LoadingIcon.Image = IconData.Url
            LoadingIcon.ImageRectOffset = IconData.ImageRectOffset
            LoadingIcon.ImageRectSize = IconData.ImageRectSize
        end

        function Loading:SetLoadingIconTweenTime(TweenTime)
            if RotationTween then
                RotationTween:Cancel()
                RotationTween:Destroy()
            end

            if TweenTime > 0 then
                RotationTween = TweenService:Create(
                    LoadingIcon,
                    TweenInfo.new(TweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
                    { Rotation = 360 }
                )
                RotationTween:Play()
            else
                LoadingIcon.Rotation = 0
            end
        end

        function Loading:SetLoadingIconColor(Color)
            LoadingIcon.ImageColor3 = Color
        end

        function Loading:SetCurrentStep(Step)
            Loading.CurrentStep = math.clamp(Step, 0, Loading.TotalSteps)

            local Progress = Loading.CurrentStep / Loading.TotalSteps
            TweenService:Create(SliderFill, Library.TweenInfo, { Size = UDim2.fromScale(Progress, 1) }):Play()

            ProgressLabel.Text = string.format("%d/%d", Loading.CurrentStep, Loading.TotalSteps)
        end

        function Loading:SetTotalSteps(Steps)
            Loading.TotalSteps = Steps
            Loading:SetCurrentStep(Loading.CurrentStep)
        end

        --// Size \\--
        function Loading:SetWindowHeight(Height)
            Loading.WindowHeight = Height
            Loading:UpdateLayout()
        end

        function Loading:SetWindowWidth(Width)
            Loading.WindowWidth = Width
            Loading:UpdateLayout()
        end

        function Loading:SetContentWidth(Width)
            Loading.ContentWidth = Width
            Loading:UpdateLayout()
        end

        function Loading:SetSidebarWidth(Width)
            Loading.SidebarWidth = Width
            Loading:UpdateLayout()
        end

        --// Sidebar \\--
        function Loading:ShowSidebarPage(Bool)
            Loading.ShowSidebar = Bool
            Loading:UpdateLayout()
        end

        --// Error Page \\--
        function Loading:ShowErrorPage(Enabled)
            Loading.IsError = Enabled
            InnerContent.Visible = not Enabled
            ErrorFrame.Visible = Enabled

            if Loading.ShowSidebar then
                Loading:ShowSidebarPage(not Enabled)
            else
                Loading:UpdateLayout()
            end
        end

        function Loading:RecalculateErrorHeight()
            local TargetWidth = (Loading.ShowSidebar and Loading.ContentWidth or Loading.WindowWidth) - 30
local _, ErrorY =Library:GetTextBounds(ErrorLabel.Text, Library.Scheme.Font, 14, TargetWidth)

            ErrorLabel.Size = UDim2.new(1, -30, 0, ErrorY)

            local HasButtons = ErrorButtonsHolder.Visible
            local RequiredHeight =
88                + ErrorY                    -- Label Height
                + 15                        -- Padding between Label and Buttons
                + (HasButtons and 48 or 0)  -- Buttons Area

            Loading.WindowErrorHeight = RequiredHeight -- math.max(Loading.WindowHeight, RequiredHeight)
        end

        function Loading:SetErrorMessage(Text)
            ErrorLabel.Text = Text
            Loading:UpdateLayout()
        end

        function Loading:SetErrorButtons(Buttons)
            assert(typeof(Buttons) == "table", "Buttons must be a table")

            for _, button in ErrorButtonsHolder:GetChildren() do
                if button:IsA("Frame") then 
                    button:Destroy() 
                end
            end

            local HasButtons = GetTableSize(Buttons) > 0
            ErrorButtonsHolder.Visible = HasButtons
            ErrorButtonsDivider.Visible = HasButtons

            for Idx, ButtonInfo in Buttons do
                local ButtonContainer ,BtnColor ,BtnOutline ,Variant = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromOffset(0, 26),
                    Parent = ErrorButtonsHolder,
                })
,"MainColor"
,"OutlineColor"
,ButtonInfo.Variant or "Primary"

                if Variant == "Primary" then
                    BtnColor = "FontColor"
                    BtnOutline = "FontColor"
                elseif Variant == "Secondary" then
                    BtnColor = "MainColor"
                    BtnOutline = "OutlineColor"
                elseif Variant == "Destructive" then
                    BtnColor = "DestructiveColor"
                    BtnOutline = "DestructiveColor"
                elseif Variant == "Ghost" then
                    BtnColor = "BackgroundColor"
                    BtnOutline = "BackgroundColor"
                end

                local TextBtn = New("TextButton", {
                    BackgroundColor3 = BtnColor,
                    BorderColor3 = BtnOutline,
                    Size = UDim2.fromOffset(0, 26),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ButtonContainer,
                })
                Library:AddOutline(TextBtn)
                table.insert(
                    Library.Corners,
                    New("UICorner", { 
                        CornerRadius = UDim.new(0, Library.CornerRadius), 
                        Parent = TextBtn 
                    })
                )

                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 15),
                    Parent = TextBtn,
                })

                local TextColor = Library.Scheme.FontColor
                if Variant == "Primary" then
                    TextColor = Library.Scheme.BackgroundColor
                elseif Variant == "Destructive" then
                    TextColor = Color3.new(1, 1, 1)
                end

                local BtnLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    Text = ButtonInfo.Title or Idx,
                    TextColor3 = TextColor,
                    TextSize = 14,
                    Parent = TextBtn,
                })
local LabelX=Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
                ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
                TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

                local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
                local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor or Library:GetBetterColor(ActiveColor, 10)

                TextBtn.MouseEnter:Connect(function()
                    TweenService:Create(TextBtn, Library.TweenInfo, {
                        BackgroundColor3 = HoverColor
                    }):Play()
                end)
                TextBtn.MouseLeave:Connect(function()
                    TweenService:Create(TextBtn, Library.TweenInfo, {
                        BackgroundColor3 = ActiveColor
                    }):Play()
                end)

                TextBtn.MouseButton1Click:Connect(function()
                    if ButtonInfo.Callback then
                        ButtonInfo.Callback(Loading)
                    end
                end)
            end

            Loading:UpdateLayout()
        end

        --// Destroy/Continue \\--
        function Loading:Destroy()
            if RotationTween then
                RotationTween:Cancel()
            end

            ScreenGui:Destroy()
            Loading.Destroyed = true
            Library.ActiveLoading = nil

            if Library.Toggle and Library.Toggled == false and Library.Unloaded ~= true then
                Library:Toggle(true)
            end
        end

        Loading.Continue = Loading.Destroy
        if Library.Toggle and Library.Toggled and Library.Unloaded ~= true then
            Library:Toggle(false)
        end

        Loading:SetCurrentStep(Loading.CurrentStep)

        Library.ActiveLoading = Loading
        return Loading
    end

    local function OnPlayerChange()
        if Library.Unloaded then
            return
        end

        local PlayerList, ExcludedPlayerList = GetPlayers(), GetPlayers(true)
        for _, Dropdown in Options do
            if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Player" then
                Dropdown:SetValues(Dropdown.ExcludeLocalPlayer and ExcludedPlayerList or PlayerList)
            end
        end
    end

    local function OnTeamChange()
        if Library.Unloaded then
            return
        end

        local TeamList = GetTeams()
        for _, Dropdown in Options do
            if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Team" then
                Dropdown:SetValues(TeamList)
            end
        end
    end

    Library:GiveSignal(Players.PlayerAdded:Connect(OnPlayerChange))
    Library:GiveSignal(Players.PlayerRemoving:Connect(OnPlayerChange))

    Library:GiveSignal(Teams.ChildAdded:Connect(OnTeamChange))
    Library:GiveSignal(Teams.ChildRemoved:Connect(OnTeamChange))

    getgenv().Library = Library
    return Library
end
end)() end,[12]=function()ImportGlobals(12)return (function(...)return function(Shared)
    local cloneref ,clonefunction = (cloneref or clonereference or function(instance)
        return instance
    end)
,(clonefunction or copyfunction or function(func) 
        return func 
    end)

    local HttpService,isfolder,isfile,listfiles = cloneref(game:GetService("HttpService"))
,isfolder,isfile,listfiles

    if typeof(clonefunction) == "function" then
        -- Fix is_____ functions for shitsploits, those functions should never error, only return a boolean.

        local
        isfolder_copy,
        isfile_copy,
        listfiles_copy = clonefunction(isfolder), clonefunction(isfile), clonefunction(listfiles)

        local isfolder_success, isfolder_error = pcall(function()
            return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
        end)

        if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
            isfolder = function(folder)
                local success, data = pcall(isfolder_copy, folder)
                return (if success then data else false)
            end

            isfile = function(file)
                local success, data = pcall(isfile_copy, file)
                return (if success then data else false)
            end

            listfiles = function(folder)
                local success, data = pcall(listfiles_copy, folder)
                return (if success then data else {})
            end
        end
    end

    local SaveManager = {} do
        SaveManager.Folder = "ObsidianLibSettings"
        SaveManager.SubFolder = ""
        SaveManager.Ignore = {}
        SaveManager.Library = nil
        SaveManager.UseLoadingOrder = false
        SaveManager.LoadingOrder = {}
        SaveManager.Parser = {
            Toggle = {
                Save = function(idx, object)
                    return { type = "Toggle", idx = idx, value = object.Value }
                end,
                Load = function(idx, data)
                    local object = SaveManager.Library.Toggles[idx]
                    if object and object.Value ~= data.value then
                        object:SetValue(data.value)
                    end
                end,
            },
            Slider = {
                Save = function(idx, object)
                    return { type = "Slider", idx = idx, value = tostring(object.Value) }
                end,
                Load = function(idx, data)
                    local object = SaveManager.Library.Options[idx]
                    if object and object.Value ~= data.value then
                        object:SetValue(data.value)
                    end
                end,
            },
            Dropdown = {
                Save = function(idx, object)
                    return { type = "Dropdown", idx = idx, value = object.Value, multi = object.Multi }
                end,
                Load = function(idx, data)
                    local object = SaveManager.Library.Options[idx]
                    if object and object.Value ~= data.value then
                        object:SetValue(data.value)
                    end
                end,
            },
            ColorPicker = {
                Save = function(idx, object)
                    return { type = "ColorPicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
                end,
                Load = function(idx, data)
                    if SaveManager.Library.Options[idx] then
                        SaveManager.Library.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
                    end
                end,
            },
            KeyPicker = {
                Save = function(idx, object)
                    return { type = "KeyPicker", idx = idx, mode = object.Mode, key = object.Value, modifiers = object.Modifiers }
                end,
                Load = function(idx, data)
                    if SaveManager.Library.Options[idx] then
                        SaveManager.Library.Options[idx]:SetValue({ data.key, data.mode, data.modifiers })
                    end
                end,
            },
            Input = {
                Save = function(idx, object)
                    return { type = "Input", idx = idx, text = object.Value }
                end,
                Load = function(idx, data)
                    local object = SaveManager.Library.Options[idx]
                    if object and object.Value ~= data.text and type(data.text) == "string" then
                        SaveManager.Library.Options[idx]:SetValue(data.text)
                    end
                end,
            },
        }

        function SaveManager:SetLibrary(library)
            self.Library = library
        end

        function SaveManager:SetLoadingOrder(enabled, order)
            self.UseLoadingOrder = enabled

            if typeof(order) == "table" then
                self.LoadingOrder = order
            end
        end

        function SaveManager:IgnoreThemeSettings()
            self:SetIgnoreIndexes({
                "BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", "FontFace", -- themes
                "ThemeManager_ThemeList", "ThemeManager_CustomThemeList", "ThemeManager_CustomThemeName", -- themes
            })
        end

        --// Folders \\--
        function SaveManager:CheckSubFolder(createFolder)
            if typeof(self.SubFolder) ~= "string" or self.SubFolder == "" then return false end

            if createFolder == true then
                if not isfolder(self.Folder .. "/settings/" .. self.SubFolder) then
                    makefolder(self.Folder .. "/settings/" .. self.SubFolder)
                end
            end

            return true
        end

        function SaveManager:GetPaths()
            local paths ,parts = {}
,self.Folder:split("/")
            for idx = 1, #parts do
                local path = table.concat(parts, "/", 1, idx)
                if not table.find(paths, path) then paths[#paths + 1] = path end
            end

            paths[#paths + 1] = self.Folder .. "/themes"
            paths[#paths + 1] = self.Folder .. "/settings"

            if self:CheckSubFolder(false) then
                local subFolder = self.Folder .. "/settings/" .. self.SubFolder
                parts = subFolder:split("/")

                for idx = 1, #parts do
                    local path = table.concat(parts, "/", 1, idx)
                    if not table.find(paths, path) then paths[#paths + 1] = path end
                end
            end

            return paths
        end

        function SaveManager:BuildFolderTree()
            local paths = self:GetPaths()

            for i = 1, #paths do
                local str = paths[i]
                if isfolder(str) then continue end

                makefolder(str)
            end
        end

        function SaveManager:CheckFolderTree()
            if isfolder(self.Folder) then return end
            SaveManager:BuildFolderTree()

            task.wait(0.1)
        end

        function SaveManager:SetIgnoreIndexes(list)
            for _, key in pairs(list) do
                self.Ignore[key] = true
            end
        end

        function SaveManager:SetFolder(folder)
            self.Folder = folder
            self:BuildFolderTree()
        end

        function SaveManager:SetSubFolder(folder)
            self.SubFolder = folder
            self:BuildFolderTree()
        end

        --// Save, Load, Delete, Refresh \\--
        function SaveManager:Save(name)
            if (not name) then
                return false, "no config file is selected"
            end
            SaveManager:CheckFolderTree()

            local fullPath = self.Folder .. "/settings/" .. name .. ".json"
            if SaveManager:CheckSubFolder(true) then
                fullPath = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
            end

            local data = {
                objects = {}
            }

            for idx, toggle in pairs(self.Library.Toggles) do
                if not toggle.Type then continue end
                if not self.Parser[toggle.Type] then continue end
                if self.Ignore[idx] then continue end

                table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
            end

            for idx, option in pairs(self.Library.Options) do
                if not option.Type then continue end
                if not self.Parser[option.Type] then continue end
                if self.Ignore[idx] then continue end

                table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
            end

            local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
            if not success then
                return false, "failed to encode data"
            end

            writefile(fullPath, encoded)
            return true
        end

        function SaveManager:Load(name)
            if (not name) then
                return false, "no config file is selected"
            end
            SaveManager:CheckFolderTree()

            local file = self.Folder .. "/settings/" .. name .. ".json"
            if SaveManager:CheckSubFolder(true) then
                file = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
            end

            if not isfile(file) then return false, "invalid file" end

            local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
            if not success then return false, "decode error" end

            if self.UseLoadingOrder == true and typeof(self.LoadingOrder) == "table" then
                table.sort(decoded.objects, function(a, b)
                    local aIndex ,bIndex = table.find(self.LoadingOrder, a.type) or math.huge
,table.find(self.LoadingOrder, b.type) or math.huge
                    return aIndex < bIndex
                end)
            end

            for _, option in decoded.objects do
                if not option.type then continue end
                if not self.Parser[option.type] then continue end
                if self.Ignore[option.idx] then continue end

                task.spawn(self.Parser[option.type].Load, option.idx, option) -- task.spawn() so the config loading wont get stuck.
            end

            return true
        end

        function SaveManager:Delete(name)
            if (not name) then
                return false, "no config file is selected"
            end

            local file = self.Folder .. "/settings/" .. name .. ".json"
            if SaveManager:CheckSubFolder(true) then
                file = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
            end

            if not isfile(file) then return false, "invalid file" end

            local success = pcall(delfile, file)
            if not success then return false, "delete file error" end

            return true
        end

        function SaveManager:RefreshConfigList()
            local success, data = pcall(function()
                SaveManager:CheckFolderTree()

                local list ,out = {}
,{}

                if SaveManager:CheckSubFolder(true) then
                    list = listfiles(self.Folder .. "/settings/" .. self.SubFolder)
                else
                    list = listfiles(self.Folder .. "/settings")
                end
                if typeof(list) ~= "table" then list = {} end

                for i = 1, #list do
                    local file = list[i]
                    if file:sub(-5) == ".json" then
                        -- i hate this but it has to be done ...

                        local pos = file:find(".json", 1, true)
                        local start ,char = pos
,file:sub(pos, pos)
                        while char ~= "/" and char ~= "\\" and char ~= "" do
                            pos = pos - 1
                            char = file:sub(pos, pos)
                        end

                        if char == "/" or char == "\\" then
                            table.insert(out, file:sub(pos + 1, start - 1))
                        end
                    end
                end

                return out
            end)

            if (not success) then
                if self.Library then
                    self.Library:Notify("Failed to load config list: " .. tostring(data))
                else
                    warn("Failed to load config list: " .. tostring(data))
                end

                return {}
            end

            return data
        end

        --// Auto Load \\--
        function SaveManager:GetAutoloadConfig()
            SaveManager:CheckFolderTree()

            local autoLoadPath = self.Folder .. "/settings/autoload.txt"
            if SaveManager:CheckSubFolder(true) then
                autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
            end

            if isfile(autoLoadPath) then
                local successRead, name = pcall(readfile, autoLoadPath)
                if not successRead then
                    return "none"
                end

                name = tostring(name)
                return if name == "" then "none" else name
            end

            return "none"
        end

        function SaveManager:LoadAutoloadConfig()
            SaveManager:CheckFolderTree()

            local autoLoadPath = self.Folder .. "/settings/autoload.txt"
            if SaveManager:CheckSubFolder(true) then
                autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
            end

            if isfile(autoLoadPath) then
                local successRead, name = pcall(readfile, autoLoadPath)
                if not successRead then
                    self.Library:Notify("Failed to load autoload config: write file error")
                    return
                end

                local success, err = self:Load(name)
                if not success then
                    self.Library:Notify("Failed to load autoload config: " .. err)
                    return
                end

                self.Library:Notify(string.format("Auto loaded config %q", name))
            end
        end

        function SaveManager:SaveAutoloadConfig(name)
            SaveManager:CheckFolderTree()

            local autoLoadPath = self.Folder .. "/settings/autoload.txt"
            if SaveManager:CheckSubFolder(true) then
                autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
            end

            local success = pcall(writefile, autoLoadPath, name)
            if not success then return false, "write file error" end

            return true, ""
        end

        function SaveManager:DeleteAutoLoadConfig()
            SaveManager:CheckFolderTree()

            local autoLoadPath = self.Folder .. "/settings/autoload.txt"
            if SaveManager:CheckSubFolder(true) then
                autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
            end

            local success = pcall(delfile, autoLoadPath)
            if not success then return false, "delete file error" end

            return true, ""
        end

        --// GUI \\--
        function SaveManager:BuildConfigSection(tab)
            assert(self.Library, "Must set SaveManager.Library")

            local section = tab:AddRightGroupbox("Configuration", "folder-cog")

            section:AddInput("SaveManager_ConfigName", { Text = "Config name" })
            section:AddButton({
                Text = "Create config",
                Tooltip = "creates a new config file with the name entered above",
                Func = function()
                    local name = self.Library.Options.SaveManager_ConfigName.Value

                    if name:gsub(" ", "") == "" then
                        self.Library:Notify("Invalid config name (empty)", 2)
                        return
                    end

                    local success, err = self:Save(name)
                    if not success then
                        self.Library:Notify("Failed to create config: " .. err)
                        return
                    end

                    self.Library:Notify(string.format("Created config %q", name))
                    self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
                    self.Library.Options.SaveManager_ConfigList:SetValue(nil)
                end,
            })

            section:AddDivider({Text = "config options"})

            section:AddDropdown("SaveManager_ConfigList", { Text = "Config list", Values = self:RefreshConfigList(), AllowNull = true })
            section:AddButton({
                Text = "Load config",
                Tooltip = "loads the selected config from the list",
                Func = function()
                    local name = self.Library.Options.SaveManager_ConfigList.Value

                    local success, err = self:Load(name)
                    if not success then
                        self.Library:Notify("Failed to load config: " .. err)
                        return
                    end

                    self.Library:Notify(string.format("Loaded config %q", name))
                end,
            })
            section:AddButton({
                Text = "Overwrite config",
                Tooltip = "overwrites the selected config with current settings",
                Func = function()
                    local name = self.Library.Options.SaveManager_ConfigList.Value

                    local success, err = self:Save(name)
                    if not success then
                        self.Library:Notify("Failed to overwrite config: " .. err)
                        return
                    end

                    self.Library:Notify(string.format("Overwrote config %q", name))
                end,
            })
            section:AddButton({
                Text = "Delete config",
                Tooltip = "permanently deletes the selected config file",
                Risky = true,
                DoubleClick = true,
                Func = function()
                    local name = self.Library.Options.SaveManager_ConfigList.Value

                    local success, err = self:Delete(name)
                    if not success then
                        self.Library:Notify("Failed to delete config: " .. err)
                        return
                    end

                    self.Library:Notify(string.format("Deleted config %q", name))
                    self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
                    self.Library.Options.SaveManager_ConfigList:SetValue(nil)
                end,
            })
            section:AddButton({
                Text = "Refresh list",
                Tooltip = "refreshes the config list from disk",
                Func = function()
                    self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
                    self.Library.Options.SaveManager_ConfigList:SetValue(nil)
                end,
            })
            section:AddButton({
                Text = "Set as autoload",
                Tooltip = "sets the selected config to automatically load on next launch",
                Func = function()
                    local name = self.Library.Options.SaveManager_ConfigList.Value

                    local success, err = self:SaveAutoloadConfig(name)
                    if not success then
                        self.Library:Notify("Failed to set autoload config: " .. err)
                        return
                    end

                    self.Library:Notify(string.format("Set %q to auto load", name))
                    self.AutoloadConfigLabel:SetText("Current autoload config: " .. name)
                end,
            })
            section:AddButton({
                Text = "Reset autoload",
                Tooltip = "clears the autoload config so nothing loads automatically",
                Func = function()
                    local success, err = self:DeleteAutoLoadConfig()
                    if not success then
                        self.Library:Notify("Failed to set autoload config: " .. err)
                        return
                    end

                    self.Library:Notify("Set autoload to none")
                    self.AutoloadConfigLabel:SetText("Current autoload config: none")
                end,
            })

            self.AutoloadConfigLabel = section:AddLabel("Current autoload config: " .. self:GetAutoloadConfig(), true)

            self:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })
        end

        SaveManager:BuildFolderTree()
    end

    return SaveManager
end
end)() end,[13]=function()local wax, script, require=ImportGlobals(13)return (function(...)return function(Root)
    return {
        Home = require(script.Home)(Root),
        Settings = require(script.Settings)(Root)
    }
end
end)() end,[14]=function()ImportGlobals(14)return (function(...)return function(Root)
    local Services ,Global = Root.Services,getgenv()local Players, RunService, TeleportService, Constants =Services.Players
, Services.RunService
, Services.TeleportService
, Root:Get('Constants')local Characters , Places , Color , TaskManager , Preference , Time , Numbers , Strings , GetPing , PromptDiscord , LocalPlayer =Constants.Characters, Root:Get('Modules/Places')
, Root:Get('Modules/Color')
, Root:Get('Modules/TaskManager'), Root:Get('Modules/Preference'), Root:Get('Functions/Time')
, Root:Get('Functions/Numbers'), Root:Get('Functions/Strings'), Root:Get('Functions/GetPing'), Root:Get('Functions/PromptDiscord'), Players.LocalPlayer
    local SessionStart ,Pink ,Blue ,CurrentKey ,GenericPreference = Time.now(),Color3.fromRGB(255, 170, 255)
,Color3.fromRGB(0, 170, 255)
,Global.script_key or "abcdef",Preference.new()    
    local function GetTimeOfTheDay()
        local Hour = os.date("*t").hour        
        if Hour >= 0 and Hour < 6 then
            return "Night"
        elseif Hour >= 6 and Hour < 12 then
            return "Morning"
        elseif Hour >= 12 and Hour < 16 then
            return "Afternoon"
        elseif Hour >= 16 and Hour < 20 then
            return "Evening"
        end 
        
        return "Night"    end
    
	return function(Tab, Window)
        local Interface ,CurrentPlace ,LRM_Constants ,AccountGroupbox = Root:Get('Modules/Interface').GetInterface('Obsidian'),Places.GetPlaceFromId(game.PlaceId)
,Constants.LRM_Constants
,Tab:AddGroupbox({Side = 1, Name = 'Account', IconName = 'circle-user'})        
        local UserImage = AccountGroupbox:AddImage("UserImage", {
            Image = "http://www.roblox.com/asset/?id=131927632408540",
            Height = 200,
            Outline = true,
            ScaleType = Enum.ScaleType.Stretch,
            BackgroundTransparency = 1,
        })
        
        task.spawn(function()
            local Success, Result = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size352x352)
            if Success then
                UserImage:SetImage(Result)
            end
        end)
        
        AccountGroupbox:AddLabel({Text = `Good {GetTimeOfTheDay()}, <b>{LocalPlayer.DisplayName}</b>!`, DoesWrap = true})        AccountGroupbox:AddLabel({Text = `Welcome to <b>{Color.Paint("strelizia.cc", Pink)}</b>!`, DoesWrap = true})        
        AccountGroupbox:AddDivider({Text = "account info"})        
        AccountGroupbox:AddLabel({Text = `{Characters.BulletPoint} User Id: <b>{LocalPlayer.UserId}</b>`})
        
        AccountGroupbox:AddLabel({Text = `{Characters.BulletPoint} Account Age: <b>{LocalPlayer.AccountAge} Days</b>`})
        local FriendsOnline = AccountGroupbox:AddLabel({Text = `{Characters.BulletPoint} Friends Online: <b>?</b>`})        
        task.spawn(function()
            local Success, Result = pcall(LocalPlayer.GetFriendsOnlineAsync, LocalPlayer)            
            if Success then
                FriendsOnline:SetText(`{Characters.BulletPoint} Friends Online: <b>{Numbers.Comma(#Result)}</b>`)
            end
        end)
        
        -- // Session 
        
        local SessionGroupbox = Tab:AddGroupbox({Side = 1, Name = "Session", IconName = "server"})        
        local SessionTime ,FPSLabel ,PingLabel ,FPS = SessionGroupbox:AddLabel({Text = `{Characters.BulletPoint} Session Time: <b>00:00:00</b>`, DoesWrap = true}),SessionGroupbox:AddLabel({Text = `{Characters.BulletPoint} FPS: <b>?</b>`, DoesWrap = true}),(SessionGroupbox:AddLabel({Text = `{Characters.BulletPoint} Ping: <b>? ms</b>`, DoesWrap = true}))do
            local FrameCount ,NextUpdate = 0,Time.now()            TaskManager.AddTask(TaskManager.Task.new("FrameCounter", function(Task)
                FrameCount += 1

                local Now = Time.now()
                if Now >= NextUpdate then
                    FPS = FrameCount

                    FrameCount = 0
                    NextUpdate = Now + 1
                end
            end, 0))
        end
        
        TaskManager.AddTask(TaskManager.Task.new("SessionGroupboxUpdater", function(Task)
            SessionTime:SetText(`{Characters.BulletPoint} Session Time: <b>{Time.FormatDuration(Time.now() - SessionStart, "%h:%m:%s", true)}</b>`)            FPSLabel:SetText(`{Characters.BulletPoint} FPS: <b>{FPS or "N/A"}</b>`)            PingLabel:SetText(`{Characters.BulletPoint} Ping: <b>{math.floor(GetPing() * 1000)} ms</b>`)        end, 1))
        
        SessionGroupbox:AddDivider({Text = "server info"})        
        local PlayersLabel = SessionGroupbox:AddLabel({Text = `{Characters.BulletPoint} Players Online: ? out of ?`, DoesWrap = true})        
        do 
            local function Update()
                PlayersLabel:SetText(`{Characters.BulletPoint} Players Online: <b>{#Players:GetPlayers()}</b> out of <b>{Players.MaxPlayers}</b>`)
            end
            
            local Joined, Left = Players.PlayerAdded:Connect(Update), Players.PlayerRemoving:Connect(Update)
            
            Interface.Main:OnUnload(function()
                Joined:Disconnect()Left:Disconnect()            end)
            
            Update()
        end
        
        SessionGroupbox:AddLabel({Text = `{Characters.BulletPoint} Place Version: <b>v{game.PlaceVersion}</b>`, DoesWrap = true})        
        SessionGroupbox:AddDivider({Text = "session sharing"})        
        local SelectedJobId = SessionGroupbox:AddInput("SessionShareJobId", {
            Text = "Server Job Id",
            Tooltip = "enter job id of the server you want to join, must be in the same game",

            Placeholder = "click here",
            ClearTextOnFocus = true,
        })
        
        SessionGroupbox:AddButton({
            Text = "Join Server",
            Tooltip = "joins the server using the job id from above",
            DoubleClick = true,
            Func = function()
                local JobId = SelectedJobId.Value or ''                
                if #JobId ~= 36 then
                    return Interface.Main:Notify({Title = "strelizia.cc", Description = "invalid job id", Duration = 2})                end
                
                local Success, Result = pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, JobId, LocalPlayer)                if (not Success) then
                    Interface.Main:Notify({Title = "strelizia.cc", Description = `failed to join server: {tostring(Result)}; click to try again`, Duration = 2})                end
            end
        })
        
        SessionGroupbox:AddButton({
            Text = "Copy Job Id",
            Tooltip = "copies the job id from the current server to clipboard",
            Func = function()
                setclipboard(game.JobId)                Interface.Main:Notify({Title = "strelizia.cc", Description = "copied job id to clipboard", Duration = 2})            end
        })
        
        -- // Key Information
        
        if LRM_Constants.Authenticated then
            local KeyGroupbox ,IsLifetime ,ExpiryTimestamp = Tab:AddGroupbox({Side = 2, Name = "Key Information", IconName = "key"}),(LRM_Constants.SecondsLeft == -1) or (LRM_Constants.SecondsLeft == math.huge),Time.now() + LRM_Constants.SecondsLeft
            KeyGroupbox:AddLabel({Text = `{Characters.BulletPoint} Key Expiry: <b>{if IsLifetime then Color.Paint('Never!', Blue) else Time.FormatTime(ExpiryTimestamp, 'MM/DD/YYYY HH:mm')}</b>`, DoesWrap = true})
            KeyGroupbox:AddLabel({Text = `{Characters.BulletPoint} Total Executions: <b>{Numbers.Comma(LRM_Constants.TotalExecutions)}</b>`, DoesWrap = true})
            KeyGroupbox:AddLabel({Text = `{Characters.BulletPoint} User Note: <b>{LRM_Constants.UserNote}</b>`, DoesWrap = true})
            
            KeyGroupbox:AddDivider({Text = "key stuff"})            
            KeyGroupbox:AddLabel({Text = `{Characters.BulletPoint} Script Key: <b>...{string.sub(CurrentKey, -5)}</b>`, DoesWrap = true})
            KeyGroupbox:AddButton({
                Text = "Copy Script Key",
                Tooltip = "copies user key to clipboard",
                Func = function()
                    setclipboard(CurrentKey)                    Interface.Main:Notify({Title = "strelizia.cc", Description = "copied script key to clipboard", Duration = 2})                end
            })
        end
        
        -- // Credits
        
        local CreditsGroupbox ,CreditsList = Tab:AddGroupbox({Side = 2, Name = "Credits", IconName = "list"}),{}        
        for _, Data in (CurrentPlace.Credits or {}) do 
            local RoleInfo = Constants.ProductionRoleInfo[Data.Role] or Constants.ProductionRoleInfo.generic            
            table.insert(CreditsList, `{Characters.BulletPoint} {Data.Name} - <b>{Color.Paint(Data.Role, RoleInfo.Color)}</b>`) 
        end        
        CreditsGroupbox:AddLabel('CreditsLabel', {Text = table.concat(CreditsList, '\n'), DoesWrap = true})
        CreditsGroupbox:AddDivider({Text = "discord (pls join)"})        
        local JoinDiscordButton = CreditsGroupbox:AddButton({
            Text = 'Join Discord Server', 
            Func = function()
                PromptDiscord(Constants.DiscordInviteCode, true)                Interface.Main:Notify({Title = 'strelizia.cc', Description = 'successfully copied/prompted discord join code!'})
            end
        })
        
        if (not GenericPreference:Read("PRESSED_JOIN_DISCORD")) then
            print('mueheheh')            task.spawn(function()
                task.wait(math.random(5, 10))                
                local Dialog = Window:AddDialog("DiscordJoinDialog", {
                    Title = "sorry for disturbing you",
                    Description = "would you please join our discord? it helps us grow and stay connected with our community. you also benefit from being able to make suggestions, bug reports and stay updated with latest features.",
                    FooterButtons = {
                        Confirm = {
                            Title = "yes!",
                            Variant = "Primary",
                            Callback = function()
                                GenericPreference:Write("PRESSED_JOIN_DISCORD", true)                                
                                JoinDiscordButton.Func()                            end,
                        },
                        Decline = {
                            Title = "no, thanks",
                            Variant = "Secondary",
                            WaitTime = 3
                        }
                    }
                }) 

                Dialog:AddToggle("DontAskDiscord", {Text = "don't ask me again", Tooltip = "okay :(", Callback = function(Value) GenericPreference:Write("PRESSED_JOIN_DISCORD", Value) end})            end)
        end
	end
end
end)() end,[15]=function()ImportGlobals(15)return (function(...)return function(Root)
	local Places = Root:Get("Modules/Places")
	
    return function(Tab)
        local Components ,CurrentPlace = Root:Get("Modules/Interface").GetInterface("Obsidian")
,Places.GetPlaceFromId(game.PlaceId)
		
		local Main ,SaveManager ,ThemeManager ,InterfaceSettingsGroupbox = Components.Main
,Components.SaveManager
,Components.ThemeManager
,Tab:AddGroupbox({Side = 1, Name = "Menu", IconName = "wrench"})
        
        InterfaceSettingsGroupbox:AddButton({
            Text = "Clear User Key",
            Tooltip = "clears saved key from the loader allowing you to enter a new one",
            Disabled = (not isfile("strelizia/key.bin")),
            DoubleClick = true,
            Func = function()
                delfile("strelizia/key.bin")
                
                Main:Notify({Title = "strelizia.cc", Description = "successfully deleted the saved key, re-execute the loader in order to enter a new one", Time = 2})            end,
        })
        
        InterfaceSettingsGroupbox:AddButton({
            Text = "Erase Cache",
            Tooltip = "deletes cache files used for quality of life, only run if you experience issues",
            DoubleClick = true,
            Func = function()
                if (not isfolder("strelizia/cache")) then
                    return
                end

                for _, SubFolder in listfiles("strelizia/cache") do 
                    for _, FilePath in listfiles(SubFolder) do 
                        delfile(FilePath)                    end
                end
                
                for _, PreferencePath in listfiles("strelizia/pref") do 
                    delfile(PreferencePath)                end
                
                Main:Notify({Title = "strelizia.cc", Description = `successfully deleted all cached files!`, Time = 2})            end,
        })

        InterfaceSettingsGroupbox:AddDivider({Text = "ui settings"})        
		InterfaceSettingsGroupbox:AddToggle("KeybindMenuOpen", {
			Default = Main.KeybindFrame.Visible,
            Text = "Open Keybind Menu",
            Tooltip = "opens menu with keybinds",
			Callback = function(value)
				Main.KeybindFrame.Visible = value
			end,
		})
		InterfaceSettingsGroupbox:AddToggle("ShowCustomCursor", {
            Text = "Custom Cursor",
            Tooltip = "determines if roblox cursor will be replaced with a custom one",
			Default = true,
			Callback = function(Value)
				Main.ShowCustomCursor = Value
			end,
		})
		InterfaceSettingsGroupbox:AddDropdown("NotificationSide", {
			Values = { "Left", "Right" },
			Default = "Right",

            Text = "Notification Side",
            Tooltip = "determines on which side will ui notifications pop up",

			Callback = function(Value)
				Main:SetNotifySide(Value)
			end,
		})
		InterfaceSettingsGroupbox:AddDropdown("DPIDropdown", {
			Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
			Default = "100%",

            Text = "DPI Scale",
            Tooltip = "determines the size of the ui",

			Callback = function(Value)
				Value = Value:gsub("%%", "")
				local DPI = tonumber(Value)

				Main:SetDPIScale(DPI)
			end,
        })
        
        InterfaceSettingsGroupbox:AddDivider({Text = "misc"})        
		InterfaceSettingsGroupbox:AddLabel("Menu bind")
			:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

        InterfaceSettingsGroupbox:AddButton({
            Text = "Unload",
            Tooltip = "unloads the script",
            Risky = true,
            DoubleClick = true,
            Func = function()
                Main:Unload()
            end,
        })
        
		Main.ToggleKeybind = Main.Options.MenuKeybind 
		
		ThemeManager:SetLibrary(Main)
		SaveManager:SetLibrary(Main)
		SaveManager:IgnoreThemeSettings()
        SaveManager:SetIgnoreIndexes({ "MenuKeybind", "DontAskDiscord", "RememberMyChoiceProvider" })
		ThemeManager:SetFolder("strelizia/ui")
		SaveManager:SetFolder(`strelizia/ui/configs/{CurrentPlace.Name}`)
		SaveManager:BuildConfigSection(Tab)
		ThemeManager:ApplyToTab(Tab)
		SaveManager:LoadAutoloadConfig()
	end
end
end)() end,[16]=function()ImportGlobals(16)return (function(...)return function(Shared)
    local cloneref ,clonefunction = (cloneref or clonereference or function(instance)
        return instance
    end)
,(clonefunction or copyfunction or function(func) 
        return func 
    end)

    local HttpService,isfolder,isfile,listfiles = cloneref(game:GetService("HttpService"))
,isfolder,isfile,listfiles

    if typeof(clonefunction) == "function" then
        -- Fix is_____ functions for shitsploits, those functions should never error, only return a boolean.

        local
        isfolder_copy,
        isfile_copy,
        listfiles_copy = clonefunction(isfolder), clonefunction(isfile), clonefunction(listfiles)

        local isfolder_success, isfolder_error = pcall(function()
            return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
        end)

        if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
            isfolder = function(folder)
                local success, data = pcall(isfolder_copy, folder)
                return (if success then data else false)
            end

            isfile = function(file)
                local success, data = pcall(isfile_copy, file)
                return (if success then data else false)
            end

            listfiles = function(folder)
                local success, data = pcall(listfiles_copy, folder)
                return (if success then data else {})
            end
        end
    end

    local ThemeManager = {}
    do
        local ThemeFields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
        ThemeManager.Folder = "ObsidianLibSettings"
        -- if not isfolder(ThemeManager.Folder) then makefolder(ThemeManager.Folder) end

        ThemeManager.Library = nil
        ThemeManager.AppliedToTab = false
        ThemeManager.BuiltInThemes = {
Default={
                1,
                { FontColor = "ffffff", MainColor = "191919", AccentColor = "7d55ff", BackgroundColor = "0f0f0f", OutlineColor = "282828" },
            },
BBot={
                2,
                { FontColor = "ffffff", MainColor = "1e1e1e", AccentColor = "7e48a3", BackgroundColor = "232323", OutlineColor = "141414" },
            },
Fatality={
                3,
                { FontColor = "ffffff", MainColor = "1e1842", AccentColor = "c50754", BackgroundColor = "191335", OutlineColor = "3c355d" },
            },
Jester={
                4,
                { FontColor = "ffffff", MainColor = "242424", AccentColor = "db4467", BackgroundColor = "1c1c1c", OutlineColor = "373737" },
            },
Mint={
                5,
                { FontColor = "ffffff", MainColor = "242424", AccentColor = "3db488", BackgroundColor = "1c1c1c", OutlineColor = "373737" },
            },
            ["Tokyo Night"] = {
                6,
                { FontColor = "ffffff", MainColor = "191925", AccentColor = "6759b3", BackgroundColor = "16161f", OutlineColor = "323232" },
            },
Ubuntu={
                7,
                { FontColor = "ffffff", MainColor = "3e3e3e", AccentColor = "e2581e", BackgroundColor = "323232", OutlineColor = "191919" },
            },
Quartz={
                8,
                { FontColor = "ffffff", MainColor = "232330", AccentColor = "426e87", BackgroundColor = "1d1b26", OutlineColor = "27232f" },
            },
Nord={
                9,
                { FontColor = "eceff4", MainColor = "3b4252", AccentColor = "88c0d0", BackgroundColor = "2e3440", OutlineColor = "4c566a" },
            },
Dracula={
                10,
                { FontColor = "f8f8f2", MainColor = "44475a", AccentColor = "ff79c6", BackgroundColor = "282a36", OutlineColor = "6272a4" },
            },
Monokai={
                11,
                { FontColor = "f8f8f2", MainColor = "272822", AccentColor = "f92672", BackgroundColor = "1e1f1c", OutlineColor = "49483e" },
            },
Gruvbox={
                12,
                { FontColor = "ebdbb2", MainColor = "3c3836", AccentColor = "fb4934", BackgroundColor = "282828", OutlineColor = "504945" },
            },
Solarized={
                13,
                { FontColor = "839496", MainColor = "073642", AccentColor = "cb4b16", BackgroundColor = "002b36", OutlineColor = "586e75" },
            },
Catppuccin={
                14,
                { FontColor = "d9e0ee", MainColor = "302d41", AccentColor = "f5c2e7", BackgroundColor = "1e1e2e", OutlineColor = "575268" },
            },
            ["One Dark"] = {
                15,
                { FontColor = "abb2bf", MainColor = "282c34", AccentColor = "c678dd", BackgroundColor = "21252b", OutlineColor = "5c6370" },
            },
Cyberpunk={
                16,
                { FontColor = "f9f9f9", MainColor = "262335", AccentColor = "00ff9f", BackgroundColor = "1a1a2e", OutlineColor = "413c5e" },
            },
            ["Oceanic Next"] = {
                17,
                { FontColor = "d8dee9", MainColor = "1b2b34", AccentColor = "6699cc", BackgroundColor = "16232a", OutlineColor = "343d46" },
            },
Material={
                18,
                { FontColor = "eeffff", MainColor = "212121", AccentColor = "82aaff", BackgroundColor = "151515", OutlineColor = "424242" },
            }
        }

        function ThemeManager:SetLibrary(library)
            self.Library = library
        end

        --// Folders \\--
        function ThemeManager:GetPaths()
            local paths ,parts = {}
,self.Folder:split("/")
            for idx = 1, #parts do
                paths[#paths + 1] = table.concat(parts, "/", 1, idx)
            end

            paths[#paths + 1] = self.Folder .. "/themes"

            return paths
        end

        function ThemeManager:BuildFolderTree()
            local paths = self:GetPaths()

            for i = 1, #paths do
                local str = paths[i]
                if isfolder(str) then
                    continue
                end
                makefolder(str)
            end
        end

        function ThemeManager:CheckFolderTree()
            if isfolder(self.Folder) then
                return
            end
            self:BuildFolderTree()

            task.wait(0.1)
        end

        function ThemeManager:SetFolder(folder)
            self.Folder = folder
            self:BuildFolderTree()
        end

        --// Apply, Update theme \\--
        function ThemeManager:ApplyTheme(theme)
            local customThemeData = self:GetCustomTheme(theme)
            local data = customThemeData or self.BuiltInThemes[theme]

            if not data then
                return
            end

            local scheme = data[2]
            for idx, val in pairs(customThemeData or scheme) do
                if idx == "VideoLink" then
                    continue
                elseif idx == "FontFace" then
                    self.Library:SetFont(Enum.Font[val])

                    if self.Library.Options[idx] then
                        self.Library.Options[idx]:SetValue(val)
                    end
                else
                    self.Library.Scheme[idx] = Color3.fromHex(val)

                    if self.Library.Options[idx] then
                        self.Library.Options[idx]:SetValueRGB(Color3.fromHex(val))
                    end
                end
            end

            self:ThemeUpdate()
        end

        function ThemeManager:ThemeUpdate()
            for i, field in ThemeFields do
                if self.Library.Options and self.Library.Options[field] then
                    self.Library.Scheme[field] = self.Library.Options[field].Value
                end
            end

            self.Library:UpdateColorsUsingRegistry()
        end

        --// Get, Load, Save, Delete, Refresh \\--
        function ThemeManager:GetCustomTheme(file)
            local path = self.Folder .. "/themes/" .. file .. ".json"
            if not isfile(path) then
                return nil
            end

            local data = readfile(path)
            local success, decoded = pcall(HttpService.JSONDecode, HttpService, data)

            if not success then
                return nil
            end

            return decoded
        end

        function ThemeManager:LoadDefault()
            local theme ,content ,isDefault = "Default"
,isfile(self.Folder .. "/themes/default.txt") and readfile(self.Folder .. "/themes/default.txt")
,true
            if content then
                if self.BuiltInThemes[content] then
                    theme = content
                elseif self:GetCustomTheme(content) then
                    theme = content
                    isDefault = false
                end
            elseif self.BuiltInThemes[self.DefaultTheme] then
                theme = self.DefaultTheme
            end

            if isDefault then
                self.Library.Options.ThemeManager_ThemeList:SetValue(theme)
            else
                self:ApplyTheme(theme)
            end
        end

        function ThemeManager:SaveDefault(theme)
            writefile(self.Folder .. "/themes/default.txt", theme)
        end

        function ThemeManager:SetDefaultTheme(theme)
            assert(self.Library, "Must set ThemeManager.Library first!")
            assert(not self.AppliedToTab, "Cannot set default theme after applying ThemeManager to a tab!")

            local FinalTheme ,LibraryScheme = {}
,{}
            for _, field in ThemeFields do
                if typeof(theme[field]) == "Color3" then
                    FinalTheme[field] = "#" .. theme[field]:ToHex()
                    LibraryScheme[field] = theme[field]

                elseif typeof(theme[field]) == "string" then
                    FinalTheme[field] = if theme[field]:sub(1, 1) == "#" then theme[field] else ("#" .. theme[field])
                    LibraryScheme[field] = Color3.fromHex(theme[field])

                else
                    FinalTheme[field] = ThemeManager.BuiltInThemes.Default[2][field]
                    LibraryScheme[field] = Color3.fromHex(ThemeManager.BuiltInThemes.Default[2][field])
                end
            end

            if typeof(theme.FontFace) == "EnumItem" then
                FinalTheme.FontFace= theme.FontFace.Name
                LibraryScheme.Font= Font.fromEnum(theme.FontFace)

            elseif typeof(theme.FontFace) == "string" then
                FinalTheme.FontFace= theme.FontFace                LibraryScheme.Font= Font.fromEnum(Enum.Font[theme.FontFace])

            else
                FinalTheme.FontFace= "Code"
                LibraryScheme.Font= Font.fromEnum(Enum.Font.Code)
            end

            for _, field in { "RedColor", "DarkColor", "WhiteColor" } do
                LibraryScheme[field] = self.Library.Scheme[field]
            end

            self.Library.Scheme = LibraryScheme
            self.BuiltInThemes.Default= { 1, FinalTheme }

            self.Library:UpdateColorsUsingRegistry()
        end

        function ThemeManager:SaveCustomTheme(file)
            if file:gsub(" ", "") == "" then
                self.Library:Notify("Invalid file name for theme (empty)", 3)
                return
            end

            local theme = {}
            for _, field in ThemeFields do
                theme[field] = self.Library.Options[field].Value:ToHex()
            end
            theme.FontFace= self.Library.Options.FontFace.Value

            writefile(self.Folder .. "/themes/" .. file .. ".json", HttpService:JSONEncode(theme))
        end

        function ThemeManager:Delete(name)
            if not name then
                return false, "no config file is selected"
            end

            local file = self.Folder .. "/themes/" .. name .. ".json"
            if not isfile(file) then
                return false, "invalid file"
            end

            local success = pcall(delfile, file)
            if not success then
                return false, "delete file error"
            end

            return true
        end

        function ThemeManager:ReloadCustomThemes()
            local list ,out = listfiles(self.Folder .. "/themes")
,{}
            for i = 1, #list do
                local file = list[i]
                if file:sub(-5) == ".json" then
                    -- i hate this but it has to be done ...

                    local pos = file:find(".json", 1, true)
                    local start ,char = pos
,file:sub(pos, pos)
                    while char ~= "/" and char ~= "\\" and char ~= "" do
                        pos = pos - 1
                        char = file:sub(pos, pos)
                    end

                    if char == "/" or char == "\\" then
                        table.insert(out, file:sub(pos + 1, start - 1))
                    end
                end
            end

            return out
        end

        --// GUI \\--
        function ThemeManager:CreateThemeManager(groupbox)
            groupbox
                :AddLabel("Background color")
                :AddColorPicker("BackgroundColor", { Default = self.Library.Scheme.BackgroundColor })
            groupbox:AddLabel("Main color"):AddColorPicker("MainColor", { Default = self.Library.Scheme.MainColor })
            groupbox:AddLabel("Accent color"):AddColorPicker("AccentColor", { Default = self.Library.Scheme.AccentColor })
            groupbox
                :AddLabel("Outline color")
                :AddColorPicker("OutlineColor", { Default = self.Library.Scheme.OutlineColor })
            groupbox:AddLabel("Font color"):AddColorPicker("FontColor", { Default = self.Library.Scheme.FontColor })
            groupbox:AddDropdown("FontFace", {
                Text = "Font Face",
                Default = "Code",
                Values = { "BuilderSans", "Code", "Fantasy", "Gotham", "Jura", "Roboto", "RobotoMono", "SourceSans" },
            })

            local ThemesArray = {}
            for Name, Theme in pairs(self.BuiltInThemes) do
                table.insert(ThemesArray, Name)
            end

            table.sort(ThemesArray, function(a, b)
                return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1]
            end)

            groupbox:AddDivider({ Text = "built-in themes" })

            groupbox:AddDropdown("ThemeManager_ThemeList", { Text = "Theme list", Values = ThemesArray, Default = 1 })
            groupbox:AddButton({
                Text = "Set as default",
                Tooltip = "sets the selected built-in theme as the default on load",
                Func = function()
                    self:SaveDefault(self.Library.Options.ThemeManager_ThemeList.Value)
                    self.Library:Notify(
                        string.format("Set default theme to %q", self.Library.Options.ThemeManager_ThemeList.Value)
                    )
                end,
            })

            self.Library.Options.ThemeManager_ThemeList:OnChanged(function()
                self:ApplyTheme(self.Library.Options.ThemeManager_ThemeList.Value)
            end)

            groupbox:AddDivider({ Text = "custom themes" })

            groupbox:AddInput("ThemeManager_CustomThemeName", { Text = "Custom theme name" })
            groupbox:AddButton({
                Text = "Create theme",
                Tooltip = "creates a new custom theme from current colors using the name entered above",
                Func = function()
                    local name = self.Library.Options.ThemeManager_CustomThemeName.Value

                    if name:gsub(" ", "") == "" then
                        self.Library:Notify("Invalid theme name (empty)", 2)
                        return
                    end

                    self:SaveCustomTheme(name)

                    self.Library:Notify(string.format("Created theme %q", name))
                    self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                    self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                end,
            })

            groupbox:AddDivider({ Text = "custom theme options" })

            groupbox:AddDropdown(
                "ThemeManager_CustomThemeList",
                { Text = "Custom themes", Values = self:ReloadCustomThemes(), AllowNull = true, Default = 1 }
            )
            groupbox:AddButton({
                Text = "Load theme",
                Tooltip = "loads the selected custom theme and applies it",
                Func = function()
                    local name = self.Library.Options.ThemeManager_CustomThemeList.Value

                    self:ApplyTheme(name)
                    self.Library:Notify(string.format("Loaded theme %q", name))
                end,
            })
            groupbox:AddButton({
                Text = "Overwrite theme",
                Tooltip = "overwrites the selected custom theme with current colors",
                Func = function()
                    local name = self.Library.Options.ThemeManager_CustomThemeList.Value

                    self:SaveCustomTheme(name)
                    self.Library:Notify(string.format("Overwrote theme %q", name))
                end,
            })
            groupbox:AddButton({
                Text = "Delete theme",
                Tooltip = "permanently deletes the selected custom theme file",
                Risky = true,
                DoubleClick = true,
                Func = function()
                    local name = self.Library.Options.ThemeManager_CustomThemeList.Value

                    local success, err = self:Delete(name)
                    if not success then
                        self.Library:Notify("Failed to delete theme: " .. err)
                        return
                    end

                    self.Library:Notify(string.format("Deleted theme %q", name))
                    self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                    self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                end,
            })
            groupbox:AddButton({
                Text = "Refresh list",
                Tooltip = "refreshes the custom theme list from disk",
                Func = function()
                    self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                    self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                end,
            })
            groupbox:AddButton({
                Text = "Set as default",
                Tooltip = "sets the selected custom theme as the default on load",
                Func = function()
                    if
                        self.Library.Options.ThemeManager_CustomThemeList.Value ~= nil
                        and self.Library.Options.ThemeManager_CustomThemeList.Value ~= ""
                    then
                        self:SaveDefault(self.Library.Options.ThemeManager_CustomThemeList.Value)
                        self.Library:Notify(
                            string.format("Set default theme to %q", self.Library.Options.ThemeManager_CustomThemeList.Value)
                        )
                    end
                end,
            })
            groupbox:AddButton({
                Text = "Reset default",
                Tooltip = "clears the saved default theme so nothing is applied on load",
                Func = function()
                    local success = pcall(delfile, self.Folder .. "/themes/default.txt")
                    if not success then
                        self.Library:Notify("Failed to reset default: delete file error")
                        return
                    end

                    self.Library:Notify("Set default theme to nothing")
                    self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                    self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                end,
            })

            self:LoadDefault()
            self.AppliedToTab = true

            local function UpdateTheme()
                self:ThemeUpdate()
            end

            self.Library.Options.BackgroundColor:OnChanged(UpdateTheme)
            self.Library.Options.MainColor:OnChanged(UpdateTheme)
            self.Library.Options.AccentColor:OnChanged(UpdateTheme)
            self.Library.Options.OutlineColor:OnChanged(UpdateTheme)
            self.Library.Options.FontColor:OnChanged(UpdateTheme)
            self.Library.Options.FontFace:OnChanged(function(Value)
                self.Library:SetFont(Enum.Font[Value])
                self.Library:UpdateColorsUsingRegistry()
            end)
        end

        function ThemeManager:CreateGroupBox(tab)
            assert(self.Library, "Must set ThemeManager.Library first!")
            return tab:AddLeftGroupbox("Themes", "paintbrush")
        end

        function ThemeManager:ApplyToTab(tab)
            assert(self.Library, "Must set ThemeManager.Library first!")
            local groupbox = self:CreateGroupBox(tab)
            self:CreateThemeManager(groupbox)
        end

        function ThemeManager:ApplyToGroupbox(groupbox)
            assert(self.Library, "Must set ThemeManager.Library first!")
            self:CreateThemeManager(groupbox)
        end

        ThemeManager:BuildFolderTree()
    end

    getgenv().ObsidianThemeManager = ThemeManager
    return ThemeManager
end
end)() end,[17]=function()local wax, script, require=ImportGlobals(17)return (function(...)return function(Root)
    local Places = {List = {}}    
    Places.RecommendedExecutors = {
        {Name = "Volt", Paid = true, Price = "$20 monthly", Note = "dev tested"},
        {Name = "Potassium", Paid = true, Price = "20$ lifetime", Note = "dev tested"},
        {Name = "Velocity", Paid = false},
        {Name = "Delta", Paid = false, Note = "emulator only"}
    }
	
	for _, Place in script:GetChildren() do 
		table.insert(Places.List, require(Place)(Root))	end
	
	function Places.GetPlaceFromId(PlaceId)
		for _, Place in Places.List do 
			if not Place.Ids[tostring(PlaceId)] then continue end 
			
			return Place 
		end
		
		return nil
	end
	
    function Places.IsExecutorBlacklisted(List)
        local GetNameFunction = (identifyexecutor or getexecutorname)        if not GetNameFunction then
            return true
        end

        local ExecutorName = GetNameFunction()        if not ExecutorName then
            return true
        end

        for _, Blacklisted in List or {} do
            if ExecutorName:find(Blacklisted, 1, true) ~= nil then
                return true
            end
        end

        return false
    end
	
	
	return Places
end
end)() end,[18]=function()ImportGlobals(18)return (function(...)return function(Root)
local Color , Green , Red , Yellow =Root:Get('Modules/Color'), Color3.new(0, 1, 0), Color3.new(1, 0, 0), Color3.new(0, 0, 1)	
	return {
		Name = 'Slime RNG',
		Ids = {
			['92416421522960'] = true
		},
		
		Keyless = false,
        Downtime = {Status = false, Message = 'Placeholder'},
        
		BlacklistedExecutors = {'Solara', 'Xeno'},
		
		Credits = {
			{Name = 'vma', Role = 'developer'},
			{Name = 'felik', Role = 'contributor'}
		},
		
        Script = 'd0595bedc8bfc40178f522fe49b5285f',
        Update = {
            Time = 1780179066,
            Log = {
                Color.Paint('[+] Added auto use special dices', Green),
                Color.Paint('[+] Added auto craft slimes', Green),
                Color.Paint('[+] Added auto find crafting recipe', Green),
                Color.Paint('[+] Added auto follow UFO', Green),
                Color.Paint('[+] Added auto apply power fruits', Green),
                Color.Paint('[+] Added auto upgrade power fruits', Green),
                Color.Paint('[+] Added auto extract power fruits', Green),
                Color.Paint('[+] Added auto claim codes', Green),
                Color.Paint('[+] Added auto equip best pets', Green),
                Color.Paint('[+] Added goop gun target priority', Green),
                Color.Paint('[+] Added manual enemy farming zone', Green),
                Color.Paint('[+] Added FPS cap', Green),
                Color.Paint('[+] Added disable rendering', Green),
                Color.Paint('[+] Added rejoin on disconnect', Green),
                Color.Paint('[+] Added execute on teleport', Green),
                Color.Paint('[+] Added auto load config on teleport', Green),
                '\n',
                Color.Paint('[*] Decoupled enemy farming (auto teleport to zone, auto goop gun)', Yellow),
                Color.Paint('[*] Mitigated unexpected auto equip behavior', Yellow),
                Color.Paint('[*] Mitigated unexpected XP transfer behavior', Yellow),
            }
        }
	}
end
end)() end,[19]=function()ImportGlobals(19)return (function(...)return function(Root)
local Color , Green , Red , Yellow =Root:Get("Modules/Color"), Color3.new(0, 1, 0), Color3.new(1, 0, 0), Color3.new(0, 0, 1)	
	return {
		Name = "Kick a Lucky Block",
		Ids = {
            ["89469502395769"] = true
		},
		
		Keyless = false,
		Downtime = {Status = false, Message = "Placeholder"},
		BlacklistedExecutors = {"Solara", "Xeno"},
		
		Credits = {
			{Name = "felix", Role = "developer"},
		},
		
        Script = "dbf4452a0cf919c7bad6aef8117e789f",
		Update = {
			Time = 1763296128,
			Log = {
				Color.Paint("[+] Released", Green),
			}
		}
	}
end
end)() end,[20]=function()ImportGlobals(20)return (function(...)return function(Root)
    local Services = Root.Services    
    local HttpService,t ,PREFERENCE_BASE_PATH ,GENERIC_PREF = Services.HttpService 
,Root:Get("Modules/t"),"strelizia/pref","generic"
    
    local ALLOWED_TYPES ,OptionalString ,Preference = t.union(t.string, t.number, t.table, t.boolean, t["nil"]),t.optional(t.string)
,{}    Preference.__index = Preference
    
    function Preference.new(Subcategory)
        Subcategory = Subcategory or GENERIC_PREF
        return setmetatable({
            Path = `{PREFERENCE_BASE_PATH}/{Subcategory}.json`,
        }, Preference)
    end
    
    function Preference:Read(Key)        assert(OptionalString(Key))        
        local AssertedReturn = if Key then nil else {}        
        if (not isfile(self.Path)) then
            return AssertedReturn
        end
        
        local Success, Result = pcall(HttpService.JSONDecode, HttpService, readfile(self.Path))        if (not Success) then
            self:Erase()            
            return AssertedReturn        end
        
        return if Key then Result[Key] else Result    end
    
    function Preference:Write(Key, Value)        assert(t.string(Key))        assert(ALLOWED_TYPES(Value))        
        local Data = self:Read()        Data[Key] = Value        
        local Success, Result = pcall(HttpService.JSONEncode, HttpService, Data)        if Success then
            writefile(self.Path, Result)        end

        return self
    end
    
    function Preference:Update(Key, Predicate)
        assert(t.string(Key))        assert(t['function'](Predicate))
        
        return self:Write(Key, Predicate(self:Read(Key)))
    end
    
    function Preference:Erase()
        writefile(self.Path, "{}")        
        return self 
    end
    
    return Preference
end
end)() end,[21]=function()local wax, script=ImportGlobals(21)return (function(...)return function(Root)
	return Root.new(Root):Extend(Root.Extensions.Children(script))
end
end)() end,[22]=function()ImportGlobals(22)return (function(...)return function(Root)
    local TableUtil = {}
    
    function TableUtil.IsDict(T)
        return T[1] == nil    end

	function TableUtil.Dictionary(Table)
		local Result = {}
		for _, Value in Table do 
			Result[Value] = true
		end

		return Result
	end

	function TableUtil.Filter(Table, Predicate)
		local Result ,IsDictionary = {},TableUtil.IsDict(Table)
		for Key, Value in Table do 
			local Ok = Predicate(Value, Key)			if (not Ok) then continue end
			if IsDictionary then
				Result[Key] = Value
			else 
				table.insert(Result, Value)
			end
		end

		return Result
	end

	function TableUtil.Reconcile(To, From)
		for Index, Value in From do
			local v1 ,TypeValue = To[Index],typeof(Value)
			if v1 == nil or typeof(v1) ~= TypeValue then
				To[Index] = Value			elseif TypeValue == 'table' then
				TableUtil.Reconcile(v1, Value)			end
		end

		return To    end
    
    function TableUtil.FullMap(Table, Predicate)
        local Result ,IsDictionary = {},TableUtil.IsDict(Table)        
        for Index, Value in Table do 
            local NewValue, NewIndex = Predicate(Value, Index)            if not (NewValue) then continue end
            if IsDictionary then
                Result[NewIndex] = NewValue
            else
                table.insert(Result, NewValue)            end
        end

        return Result
    end
    
    function TableUtil.JoinArrays(...)        local Result = {}

        for i = 1, select('#', ...) do
            for _, Value in select(i, ...) do
                Result[#Result + 1] = Value
            end
        end

        return Result
    end

	return TableUtil
end
end)() end,[23]=function()ImportGlobals(23)return (function(...)return function(Root)
	-- // Good Signal
	
	local freeRunnerThread 
	local function acquireRunnerThreadAndCallEventHandler(fn, ...)
		local acquiredRunnerThread = freeRunnerThread
		freeRunnerThread = nil
		fn(...)
		freeRunnerThread = acquiredRunnerThread
	end

	local function runEventHandlerInFreeThread()
		while true do
			acquireRunnerThreadAndCallEventHandler(coroutine.yield())
		end
	end

	local Connection = {}
	Connection.__index = Connection

	function Connection.new(signal, fn)
		return setmetatable({
			_connected = true,
			_signal = signal,
			_fn = fn,
			_next = false,
		}, Connection)
	end

	function Connection:Disconnect()
		self._connected = false

		if self._signal._handlerListHead == self then
			self._signal._handlerListHead = self._next
		else
			local prev = self._signal._handlerListHead
			while prev and prev._next ~= self do
				prev = prev._next
			end
			if prev then
				prev._next = self._next
			end
		end
	end

	setmetatable(Connection, {
		__index = function(tb, key)
			error(("Attempt to get Connection::%s (not a valid member)"):format(tostring(key)), 2)
		end,
		__newindex = function(tb, key, value)
			error(("Attempt to set Connection::%s (not a valid member)"):format(tostring(key)), 2)
		end
	})

	local Signal = {}
	Signal.__index = Signal

	function Signal.new()
		return setmetatable({
			_handlerListHead = false,
		}, Signal)
	end

	function Signal:Connect(fn)
		local connection = Connection.new(self, fn)
		if self._handlerListHead then
			connection._next = self._handlerListHead
			self._handlerListHead = connection
		else
			self._handlerListHead = connection
		end
		return connection
	end

	function Signal:DisconnectAll()
		self._handlerListHead = false
	end

	function Signal:Fire(...)
		local item = self._handlerListHead
		while item do
			if item._connected then
				if not freeRunnerThread then
					freeRunnerThread = coroutine.create(runEventHandlerInFreeThread)
					coroutine.resume(freeRunnerThread)
				end
				task.spawn(freeRunnerThread, item._fn, ...)
			end
			item = item._next
		end
	end

	function Signal:Wait()
		local waitingCoroutine ,cn=(coroutine.running()
)		cn = self:Connect(function(...)
			cn:Disconnect()
			task.spawn(waitingCoroutine, ...)
		end)
		return coroutine.yield()
	end

	function Signal:Once(fn)
		local cn		cn = self:Connect(function(...)
			if cn._connected then
				cn:Disconnect()
			end
			fn(...)
		end)
		return cn
	end

	setmetatable(Signal, {
		__index = function(tb, key)
			error(("Attempt to get Signal::%s (not a valid member)"):format(tostring(key)), 2)
		end,
		__newindex = function(tb, key, value)
			error(("Attempt to set Signal::%s (not a valid member)"):format(tostring(key)), 2)
		end
	})

	return Signal
end
end)() end,[24]=function()ImportGlobals(24)return (function(...)return function(Root)
    --[[
	An implementation of Promises similar to Promise/A+.
]]

    local ERROR_NON_PROMISE_IN_LIST ,ERROR_NON_LIST ,ERROR_NON_FUNCTION ,MODE_KEY_METATABLE = "Non-promise value passed into %s at index %s"
,"Please pass a list of promises to %s"
,"Please pass a handler function to %s!"
,{ __mode = "k" }

    local function isCallable(value)
        if type(value) == "function" then
            return true
        end

        if type(value) == "table" then
            local metatable = getmetatable(value)
            if metatable and type(rawget(metatable, "__call")) == "function" then
                return true
            end
        end

        return false
    end

--[[
	Creates an enum dictionary with some metamethods to prevent common mistakes.
]]
    local function makeEnum(enumName, members)
        local enum = {}

        for _, memberName in ipairs(members) do
            enum[memberName] = memberName
        end

        return setmetatable(enum, {
            __index = function(_, k)
                error(string.format("%s is not in %s!", k, enumName), 2)
            end,
            __newindex = function()
                error(string.format("Creating new members in %s is not allowed!", enumName), 2)
            end,
        })
    end

--[=[
	An object to represent runtime errors that occur during execution.
	Promises that experience an error like this will be rejected with
	an instance of this object.

	@class Error
]=]
    local Error
    do
        Error = {
            Kind = makeEnum("Promise.Error.Kind", {
                "ExecutionError",
                "AlreadyCancelled",
                "NotResolvedInTime",
                "TimedOut",
            }),
        }
        Error.__index = Error

        function Error.new(options, parent)
            options = options or {}
            return setmetatable({
                error = tostring(options.error) or "[This error has no error text.]",
                trace = options.trace,
                context = options.context,
                kind = options.kind,
                parent = parent,
                createdTick = os.clock(),
                createdTrace = debug.traceback(),
            }, Error)
        end

        function Error.is(anything)
            if type(anything) == "table" then
                local metatable = getmetatable(anything)

                if type(metatable) == "table" then
                    return rawget(anything, "error") ~= nil and type(rawget(metatable, "extend")) == "function"
                end
            end

            return false
        end

        function Error.isKind(anything, kind)
            assert(kind ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")

            return Error.is(anything) and anything.kind == kind
        end

        function Error:extend(options)
            options = options or {}

            options.kind = options.kind or self.kind

            return Error.new(options, self)
        end

        function Error:getErrorChain()
            local runtimeErrors = { self }

            while runtimeErrors[#runtimeErrors].parent do
                table.insert(runtimeErrors, runtimeErrors[#runtimeErrors].parent)
            end

            return runtimeErrors
        end

        function Error:__tostring()
            local errorStrings = {
                string.format("-- Promise.Error(%s) --", self.kind or "?"),
            }

            for _, runtimeError in ipairs(self:getErrorChain()) do
                table.insert(
                    errorStrings,
                    table.concat({
                        runtimeError.trace or runtimeError.error,
                        runtimeError.context,
                    }, "\n")
                )
            end

            return table.concat(errorStrings, "\n")
        end
    end

--[[
	Packs a number of arguments into a table and returns its length.

	Used to cajole varargs without dropping sparse values.
]]
    local function pack(...)
        return select("#", ...), { ... }
    end

--[[
	Returns first value (success), and packs all following values.
]]
    local function packResult(success, ...)
        return success, select("#", ...), { ... }
    end

    local function makeErrorHandler(traceback)
        assert(traceback ~= nil, "traceback is nil")

        return function(err)
            -- If the error object is already a table, forward it directly.
            -- Should we extend the error here and add our own trace?

            if type(err) == "table" then
                return err
            end

            return Error.new({
                error = err,
                kind = Error.Kind.ExecutionError,
                trace = debug.traceback(tostring(err), 2),
                context = "Promise created at:\n\n" .. traceback,
            })
        end
    end

--[[
	Calls a Promise executor with error handling.
]]
    local function runExecutor(traceback, callback, ...)
        return packResult(xpcall(callback, makeErrorHandler(traceback), ...))
    end

--[[
	Creates a function that invokes a callback with correct error handling and
	resolution mechanisms.
]]
    local function createAdvancer(traceback, callback, resolve, reject)
        return function(...)
            local ok, resultLength, result = runExecutor(traceback, callback, ...)

            if ok then
                resolve(unpack(result, 1, resultLength))
            else
                reject(result[1])
            end
        end
    end

    local function isEmpty(t)
        return next(t) == nil
    end

--[=[
	An enum value used to represent the Promise's status.
	@interface Status
	@tag enum
	@within Promise
	.Started "Started" -- The Promise is executing, and not settled yet.
	.Resolved "Resolved" -- The Promise finished successfully.
	.Rejected "Rejected" -- The Promise was rejected.
	.Cancelled "Cancelled" -- The Promise was cancelled before it finished.
]=]
--[=[
	@prop Status Status
	@within Promise
	@readonly
	@tag enums
	A table containing all members of the `Status` enum, e.g., `Promise.Status.Resolved`.
]=]
--[=[
	A Promise is an object that represents a value that will exist in the future, but doesn't right now.
	Promises allow you to then attach callbacks that can run once the value becomes available (known as *resolving*),
	or if an error has occurred (known as *rejecting*).

	@class Promise
	@__index prototype
]=]
    local Promise = {
        Error = Error,
        Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
        _getTime = os.clock,
        _timeEvent = game:GetService("RunService").Heartbeat,
        _unhandledRejectionCallbacks = {},
    }
    Promise.prototype = {}
    Promise.__index = Promise.prototype

    function Promise._new(traceback, callback, parent)
        if parent ~= nil and not Promise.is(parent) then
            error("Argument #2 to Promise.new must be a promise or nil", 2)
        end

        local self = {
            -- The executor thread.
            _thread = nil,

            -- Used to locate where a promise was created
            _source = traceback,

            _status = Promise.Status.Started,

            -- A table containing a list of all results, whether success or failure.
            -- Only valid if _status is set to something besides Started
            _values = nil,

            -- Lua doesn't like sparse arrays very much, so we explicitly store the
            -- length of _values to handle middle nils.
            _valuesLength = -1,

            -- Tracks if this Promise has no error observers..
            _unhandledRejection = true,

            -- Queues representing functions we should invoke when we update!
            _queuedResolve = {},
            _queuedReject = {},
            _queuedFinally = {},

            -- The function to run when/if this promise is cancelled.
            _cancellationHook = nil,

            -- The "parent" of this promise in a promise chain. Required for
            -- cancellation propagation upstream.
            _parent = parent,

            -- Consumers are Promises that have chained onto this one.
            -- We track them for cancellation propagation downstream.
            _consumers = setmetatable({}, MODE_KEY_METATABLE),
        }

        if parent and parent._status == Promise.Status.Started then
            parent._consumers[self] = true
        end

        setmetatable(self, Promise)

        local function resolve(...)
            self:_resolve(...)
        end

        local function reject(...)
            self:_reject(...)
        end

        local function onCancel(cancellationHook)
            if cancellationHook then
                if self._status == Promise.Status.Cancelled then
                    cancellationHook()
                else
                    self._cancellationHook = cancellationHook
                end
            end

            return self._status == Promise.Status.Cancelled
        end

        self._thread = coroutine.create(function()
local ok, _, result =runExecutor(self._source, callback, resolve, reject, onCancel)

            if not ok then
                reject(result[1])
            end
        end)

        task.spawn(self._thread)

        return self
    end

--[=[
	Construct a new Promise that will be resolved or rejected with the given callbacks.

	If you `resolve` with a Promise, it will be chained onto.

	You can safely yield within the executor function and it will not block the creating thread.

	```lua
	local myFunction()
		return Promise.new(function(resolve, reject, onCancel)
			wait(1)
			resolve("Hello world!")
		end)
	end

	myFunction():andThen(print)
	```

	You do not need to use `pcall` within a Promise. Errors that occur during execution will be caught and turned into a rejection automatically. If `error()` is called with a table, that table will be the rejection value. Otherwise, string errors will be converted into `Promise.Error(Promise.Error.Kind.ExecutionError)` objects for tracking debug information.

	You may register an optional cancellation hook by using the `onCancel` argument:

	* This should be used to abort any ongoing operations leading up to the promise being settled.
	* Call the `onCancel` function with a function callback as its only argument to set a hook which will in turn be called when/if the promise is cancelled.
	* `onCancel` returns `true` if the Promise was already cancelled when you called `onCancel`.
	* Calling `onCancel` with no argument will not override a previously set cancellation hook, but it will still return `true` if the Promise is currently cancelled.
	* You can set the cancellation hook at any time before resolving.
	* When a promise is cancelled, calls to `resolve` or `reject` will be ignored, regardless of if you set a cancellation hook or not.

	:::caution
	If the Promise is cancelled, the `executor` thread is closed with `coroutine.close` after the cancellation hook is called.

	You must perform any cleanup code in the cancellation hook: any time your executor yields, it **may never resume**.
	:::

	@param executor (resolve: (...: any) -> (), reject: (...: any) -> (), onCancel: (abortHandler?: () -> ()) -> boolean) -> ()
	@return Promise
]=]
    function Promise.new(executor)
        return Promise._new(debug.traceback(nil, 2), executor)
    end

    function Promise:__tostring()
        return string.format("Promise(%s)", self._status)
    end

--[=[
	The same as [Promise.new](/api/Promise#new), except execution begins after the next `Heartbeat` event.

	This is a spiritual replacement for `spawn`, but it does not suffer from the same [issues](https://eryn.io/gist/3db84579866c099cdd5bb2ff37947cec) as `spawn`.

	```lua
	local function waitForChild(instance, childName, timeout)
	  return Promise.defer(function(resolve, reject)
		local child = instance:WaitForChild(childName, timeout)

		;(child and resolve or reject)(child)
	  end)
	end
	```

	@param executor (resolve: (...: any) -> (), reject: (...: any) -> (), onCancel: (abortHandler?: () -> ()) -> boolean) -> ()
	@return Promise
]=]
    function Promise.defer(executor)
        local traceback ,promise
=(debug.traceback(nil, 2)
)        promise = Promise._new(traceback, function(resolve, reject, onCancel)
            local connection
            connection = Promise._timeEvent:Connect(function()
                connection:Disconnect()
local ok, _, result =runExecutor(traceback, executor, resolve, reject, onCancel)

                if not ok then
                    reject(result[1])
                end
            end)
        end)

        return promise
    end

    -- Backwards compatibility
    Promise.async = Promise.defer

--[=[
	Creates an immediately resolved Promise with the given value.

	```lua
	-- Example using Promise.resolve to deliver cached values:
	function getSomething(name)
		if cache[name] then
			return Promise.resolve(cache[name])
		else
			return Promise.new(function(resolve, reject)
				local thing = getTheThing()
				cache[name] = thing

				resolve(thing)
			end)
		end
	end
	```

	@param ... any
	@return Promise<...any>
]=]
    function Promise.resolve(...)
        local length, values = pack(...)
        return Promise._new(debug.traceback(nil, 2), function(resolve)
            resolve(unpack(values, 1, length))
        end)
    end

--[=[
	Creates an immediately rejected Promise with the given value.

	:::caution
	Something needs to consume this rejection (i.e. `:catch()` it), otherwise it will emit an unhandled Promise rejection warning on the next frame. Thus, you should not create and store rejected Promises for later use. Only create them on-demand as needed.
	:::

	@param ... any
	@return Promise<...any>
]=]
    function Promise.reject(...)
        local length, values = pack(...)
        return Promise._new(debug.traceback(nil, 2), function(_, reject)
            reject(unpack(values, 1, length))
        end)
    end

--[[
	Runs a non-promise-returning function as a Promise with the
  given arguments.
]]
    function Promise._try(traceback, callback, ...)
        local valuesLength, values = pack(...)

        return Promise._new(traceback, function(resolve)
            resolve(callback(unpack(values, 1, valuesLength)))
        end)
    end

--[=[
	Begins a Promise chain, calling a function and returning a Promise resolving with its return value. If the function errors, the returned Promise will be rejected with the error. You can safely yield within the Promise.try callback.

	:::info
	`Promise.try` is similar to [Promise.promisify](#promisify), except the callback is invoked immediately instead of returning a new function.
	:::

	```lua
	Promise.try(function()
		return math.random(1, 2) == 1 and "ok" or error("Oh an error!")
	end)
		:andThen(function(text)
			print(text)
		end)
		:catch(function(err)
			warn("Something went wrong")
		end)
	```

	@param callback (...: T...) -> ...any
	@param ... T... -- Additional arguments passed to `callback`
	@return Promise
]=]
    function Promise.try(callback, ...)
        return Promise._try(debug.traceback(nil, 2), callback, ...)
    end

--[[
	Returns a new promise that:
		* is resolved when all input promises resolve
		* is rejected if ANY input promises reject
]]
    function Promise._all(traceback, promises, amount)
        if type(promises) ~= "table" then
            error(string.format(ERROR_NON_LIST, "Promise.all"), 3)
        end

        -- We need to check that each value is a promise here so that we can produce
        -- a proper error rather than a rejected promise with our error.
        for i, promise in pairs(promises) do
            if not Promise.is(promise) then
                error(string.format(ERROR_NON_PROMISE_IN_LIST, "Promise.all", tostring(i)), 3)
            end
        end

        -- If there are no values then return an already resolved promise.
        if #promises == 0 or amount == 0 then
            return Promise.resolve({})
        end

        return Promise._new(traceback, function(resolve, reject, onCancel)
            -- An array to contain our resolved values from the given promises.
            local resolvedValues ,newPromises ,resolvedCount ,rejectedCount ,done = {}
,{}
,0
,0
,false

            local function cancel()
                for _, promise in ipairs(newPromises) do
                    promise:cancel()
                end
            end

            -- Called when a single value is resolved and resolves if all are done.
            local function resolveOne(i, ...)
                if done then
                    return
                end

                resolvedCount = resolvedCount + 1

                if amount == nil then
                    resolvedValues[i] = ...
                else
                    resolvedValues[resolvedCount] = ...
                end

                if resolvedCount >= (amount or #promises) then
                    done = true
                    resolve(resolvedValues)
                    cancel()
                end
            end

            onCancel(cancel)

            -- We can assume the values inside `promises` are all promises since we
            -- checked above.
            for i, promise in ipairs(promises) do
                newPromises[i] = promise:andThen(function(...)
                    resolveOne(i, ...)
                end, function(...)
                    rejectedCount = rejectedCount + 1

                    if amount == nil or #promises - rejectedCount < amount then
                        cancel()
                        done = true

                        reject(...)
                    end
                end)
            end

            if done then
                cancel()
            end
        end)
    end

--[=[
	Accepts an array of Promises and returns a new promise that:
	* is resolved after all input promises resolve.
	* is rejected if *any* input promises reject.

	:::info
	Only the first return value from each promise will be present in the resulting array.
	:::

	After any input Promise rejects, all other input Promises that are still pending will be cancelled if they have no other consumers.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.all(promises)
	```

	@param promises {Promise<T>}
	@return Promise<{T}>
]=]
    function Promise.all(promises)
        return Promise._all(debug.traceback(nil, 2), promises)
    end

--[=[
	Folds an array of values or promises into a single value. The array is traversed sequentially.

	The reducer function can return a promise or value directly. Each iteration receives the resolved value from the previous, and the first receives your defined initial value.

	The folding will stop at the first rejection encountered.
	```lua
	local basket = {"blueberry", "melon", "pear", "melon"}
	Promise.fold(basket, function(cost, fruit)
		if fruit == "blueberry" then
			return cost -- blueberries are free!
		else
			-- call a function that returns a promise with the fruit price
			return fetchPrice(fruit):andThen(function(fruitCost)
				return cost + fruitCost
			end)
		end
	end, 0)
	```

	@since v3.1.0
	@param list {T | Promise<T>}
	@param reducer (accumulator: U, value: T, index: number) -> U | Promise<U>
	@param initialValue U
]=]
    function Promise.fold(list, reducer, initialValue)
        assert(type(list) == "table", "Bad argument #1 to Promise.fold: must be a table")
        assert(isCallable(reducer), "Bad argument #2 to Promise.fold: must be a function")

        local accumulator = Promise.resolve(initialValue)
        return Promise.each(list, function(resolvedElement, i)
            accumulator = accumulator:andThen(function(previousValueResolved)
                return reducer(previousValueResolved, resolvedElement, i)
            end)
        end):andThen(function()
            return accumulator
        end)
    end

--[=[
	Accepts an array of Promises and returns a Promise that is resolved as soon as `count` Promises are resolved from the input array. The resolved array values are in the order that the Promises resolved in. When this Promise resolves, all other pending Promises are cancelled if they have no other consumers.

	`count` 0 results in an empty array. The resultant array will never have more than `count` elements.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.some(promises, 2) -- Only resolves with first 2 promises to resolve
	```

	@param promises {Promise<T>}
	@param count number
	@return Promise<{T}>
]=]
    function Promise.some(promises, count)
        assert(type(count) == "number", "Bad argument #2 to Promise.some: must be a number")

        return Promise._all(debug.traceback(nil, 2), promises, count)
    end

--[=[
	Accepts an array of Promises and returns a Promise that is resolved as soon as *any* of the input Promises resolves. It will reject only if *all* input Promises reject. As soon as one Promises resolves, all other pending Promises are cancelled if they have no other consumers.

	Resolves directly with the value of the first resolved Promise. This is essentially [[Promise.some]] with `1` count, except the Promise resolves with the value directly instead of an array with one element.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.any(promises) -- Resolves with first value to resolve (only rejects if all 3 rejected)
	```

	@param promises {Promise<T>}
	@return Promise<T>
]=]
    function Promise.any(promises)
        return Promise._all(debug.traceback(nil, 2), promises, 1):andThen(function(values)
            return values[1]
        end)
    end

--[=[
	Accepts an array of Promises and returns a new Promise that resolves with an array of in-place Statuses when all input Promises have settled. This is equivalent to mapping `promise:finally` over the array of Promises.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.allSettled(promises)
	```

	@param promises {Promise<T>}
	@return Promise<{Status}>
]=]
    function Promise.allSettled(promises)
        if type(promises) ~= "table" then
            error(string.format(ERROR_NON_LIST, "Promise.allSettled"), 2)
        end

        -- We need to check that each value is a promise here so that we can produce
        -- a proper error rather than a rejected promise with our error.
        for i, promise in pairs(promises) do
            if not Promise.is(promise) then
                error(string.format(ERROR_NON_PROMISE_IN_LIST, "Promise.allSettled", tostring(i)), 2)
            end
        end

        -- If there are no values then return an already resolved promise.
        if #promises == 0 then
            return Promise.resolve({})
        end

        return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)
            -- An array to contain our resolved values from the given promises.
            local fates ,newPromises ,finishedCount = {}
,{}
,0

            -- Called when a single value is resolved and resolves if all are done.
            local function resolveOne(i, ...)
                finishedCount = finishedCount + 1

                fates[i] = ...

                if finishedCount >= #promises then
                    resolve(fates)
                end
            end

            onCancel(function()
                for _, promise in ipairs(newPromises) do
                    promise:cancel()
                end
            end)

            -- We can assume the values inside `promises` are all promises since we
            -- checked above.
            for i, promise in ipairs(promises) do
                newPromises[i] = promise:finally(function(...)
                    resolveOne(i, ...)
                end)
            end
        end)
    end

--[=[
	Accepts an array of Promises and returns a new promise that is resolved or rejected as soon as any Promise in the array resolves or rejects.

	:::warning
	If the first Promise to settle from the array settles with a rejection, the resulting Promise from `race` will reject.

	If you instead want to tolerate rejections, and only care about at least one Promise resolving, you should use [Promise.any](#any) or [Promise.some](#some) instead.
	:::

	All other Promises that don't win the race will be cancelled if they have no other consumers.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.race(promises) -- Only returns 1st value to resolve or reject
	```

	@param promises {Promise<T>}
	@return Promise<T>
]=]
    function Promise.race(promises)
        assert(type(promises) == "table", string.format(ERROR_NON_LIST, "Promise.race"))

        for i, promise in pairs(promises) do
            assert(Promise.is(promise), string.format(ERROR_NON_PROMISE_IN_LIST, "Promise.race", tostring(i)))
        end

        return Promise._new(debug.traceback(nil, 2), function(resolve, reject, onCancel)
            local newPromises ,finished = {}
,false

            local function cancel()
                for _, promise in ipairs(newPromises) do
                    promise:cancel()
                end
            end

            local function finalize(callback)
                return function(...)
                    cancel()
                    finished = true
                    return callback(...)
                end
            end

            if onCancel(finalize(reject)) then
                return
            end

            for i, promise in ipairs(promises) do
                newPromises[i] = promise:andThen(finalize(resolve), finalize(reject))
            end

            if finished then
                cancel()
            end
        end)
    end

--[=[
	Iterates serially over the given an array of values, calling the predicate callback on each value before continuing.

	If the predicate returns a Promise, we wait for that Promise to resolve before moving on to the next item
	in the array.

	:::info
	`Promise.each` is similar to `Promise.all`, except the Promises are ran in order instead of all at once.

	But because Promises are eager, by the time they are created, they're already running. Thus, we need a way to defer creation of each Promise until a later time.

	The predicate function exists as a way for us to operate on our data instead of creating a new closure for each Promise. If you would prefer, you can pass in an array of functions, and in the predicate, call the function and return its return value.
	:::

	```lua
	Promise.each({
		"foo",
		"bar",
		"baz",
		"qux"
	}, function(value, index)
		return Promise.delay(1):andThen(function()
		print(("%d) Got %s!"):format(index, value))
		end)
	end)

	--[[
		(1 second passes)
		> 1) Got foo!
		(1 second passes)
		> 2) Got bar!
		(1 second passes)
		> 3) Got baz!
		(1 second passes)
		> 4) Got qux!
	]]
	```

	If the Promise a predicate returns rejects, the Promise from `Promise.each` is also rejected with the same value.

	If the array of values contains a Promise, when we get to that point in the list, we wait for the Promise to resolve before calling the predicate with the value.

	If a Promise in the array of values is already Rejected when `Promise.each` is called, `Promise.each` rejects with that value immediately (the predicate callback will never be called even once). If a Promise in the list is already Cancelled when `Promise.each` is called, `Promise.each` rejects with `Promise.Error(Promise.Error.Kind.AlreadyCancelled`). If a Promise in the array of values is Started at first, but later rejects, `Promise.each` will reject with that value and iteration will not continue once iteration encounters that value.

	Returns a Promise containing an array of the returned/resolved values from the predicate for each item in the array of values.

	If this Promise returned from `Promise.each` rejects or is cancelled for any reason, the following are true:
	- Iteration will not continue.
	- Any Promises within the array of values will now be cancelled if they have no other consumers.
	- The Promise returned from the currently active predicate will be cancelled if it hasn't resolved yet.

	@since 3.0.0
	@param list {T | Promise<T>}
	@param predicate (value: T, index: number) -> U | Promise<U>
	@return Promise<{U}>
]=]
    function Promise.each(list, predicate)
        assert(type(list) == "table", string.format(ERROR_NON_LIST, "Promise.each"))
        assert(isCallable(predicate), string.format(ERROR_NON_FUNCTION, "Promise.each"))

        return Promise._new(debug.traceback(nil, 2), function(resolve, reject, onCancel)
            local results ,promisesToCancel ,cancelled = {}
,{}
,false

            local function cancel()
                for _, promiseToCancel in ipairs(promisesToCancel) do
                    promiseToCancel:cancel()
                end
            end

            onCancel(function()
                cancelled = true

                cancel()
            end)

            -- We need to preprocess the list of values and look for Promises.
            -- If we find some, we must register our andThen calls now, so that those Promises have a consumer
            -- from us registered. If we don't do this, those Promises might get cancelled by something else
            -- before we get to them in the series because it's not possible to tell that we plan to use it
            -- unless we indicate it here.

            local preprocessedList = {}

            for index, value in ipairs(list) do
                if Promise.is(value) then
                    if value:getStatus() == Promise.Status.Cancelled then
                        cancel()
                        return reject(Error.new({
                            error = "Promise is cancelled",
                            kind = Error.Kind.AlreadyCancelled,
                            context = string.format(
                                "The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s",
                                index,
                                value._source
                            ),
                        }))
                    elseif value:getStatus() == Promise.Status.Rejected then
                        cancel()
                        return reject(select(2, value:await()))
                    end

                    -- Chain a new Promise from this one so we only cancel ours
                    local ourPromise = value:andThen(function(...)
                        return ...
                    end)

                    table.insert(promisesToCancel, ourPromise)
                    preprocessedList[index] = ourPromise
                else
                    preprocessedList[index] = value
                end
            end

            for index, value in ipairs(preprocessedList) do
                if Promise.is(value) then
                    local success
                    success, value = value:await()

                    if not success then
                        cancel()
                        return reject(value)
                    end
                end

                if cancelled then
                    return
                end

                local predicatePromise = Promise.resolve(predicate(value, index))

                table.insert(promisesToCancel, predicatePromise)

                local success, result = predicatePromise:await()

                if not success then
                    cancel()
                    return reject(result)
                end

                results[index] = result
            end

            resolve(results)
        end)
    end

--[=[
	Checks whether the given object is a Promise via duck typing. This only checks if the object is a table and has an `andThen` method.

	@param object any
	@return boolean -- `true` if the given `object` is a Promise.
]=]
    function Promise.is(object)
        if type(object) ~= "table" then
            return false
        end

        local objectMetatable = getmetatable(object)

        if objectMetatable == Promise then
            -- The Promise came from this library.
            return true
        elseif objectMetatable == nil then
            -- No metatable, but we should still chain onto tables with andThen methods
            return isCallable(object.andThen)
        elseif
            type(objectMetatable) == "table"
            and type(rawget(objectMetatable, "__index")) == "table"
            and isCallable(rawget(rawget(objectMetatable, "__index"), "andThen"))
        then
            -- Maybe this came from a different or older Promise library.
            return true
        end

        return false
    end

--[=[
	Wraps a function that yields into one that returns a Promise.

	Any errors that occur while executing the function will be turned into rejections.

	:::info
	`Promise.promisify` is similar to [Promise.try](#try), except the callback is returned as a callable function instead of being invoked immediately.
	:::

	```lua
	local sleep = Promise.promisify(wait)

	sleep(1):andThen(print)
	```

	```lua
	local isPlayerInGroup = Promise.promisify(function(player, groupId)
		return player:IsInGroup(groupId)
	end)
	```

	@param callback (...: any) -> ...any
	@return (...: any) -> Promise
]=]
    function Promise.promisify(callback)
        return function(...)
            return Promise._try(debug.traceback(nil, 2), callback, ...)
        end
    end

--[=[
	Returns a Promise that resolves after `seconds` seconds have passed. The Promise resolves with the actual amount of time that was waited.

	This function is **not** a wrapper around `wait`. `Promise.delay` uses a custom scheduler which provides more accurate timing. As an optimization, cancelling this Promise instantly removes the task from the scheduler.

	:::warning
	Passing `NaN`, infinity, or a number less than 1/60 is equivalent to passing 1/60.
	:::

	```lua
		Promise.delay(5):andThenCall(print, "This prints after 5 seconds")
	```

	@function delay
	@within Promise
	@param seconds number
	@return Promise<number>
]=]
    do
        -- uses a sorted doubly linked list (queue) to achieve O(1) remove operations and O(n) for insert

        -- the initial node in the linked list
        local first
,connection

        function Promise.delay(seconds)
            assert(type(seconds) == "number", "Bad argument #1 to Promise.delay, must be a number.")
            -- If seconds is -INF, INF, NaN, or less than 1 / 60, assume seconds is 1 / 60.
            -- This mirrors the behavior of wait()
            if not (seconds >= 1.6666666666666665E-2) or seconds == math.huge then
                seconds = 1.6666666666666665E-2            end

            return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)
                local startTime = Promise._getTime()
                local endTime = startTime + seconds

                local node = {
                    resolve = resolve,
                    startTime = startTime,
                    endTime = endTime,
                }

                if connection == nil then -- first is nil when connection is nil
                    first = node
                    connection = Promise._timeEvent:Connect(function()
                        local threadStart = Promise._getTime()

                        while first ~= nil and first.endTime < threadStart do
                            local current = first
                            first = current.next

                            if first == nil then
                                connection:Disconnect()
                                connection = nil
                            else
                                first.previous = nil
                            end

                            current.resolve(Promise._getTime() - current.startTime)
                        end
                    end)
                else -- first is non-nil
                    if first.endTime < endTime then -- if `node` should be placed after `first`
                        -- we will insert `node` between `current` and `next`
                        -- (i.e. after `current` if `next` is nil)
                        local current = first
                        local next = current.next

                        while next ~= nil and next.endTime < endTime do
                            current = next
                            next = current.next
                        end

                        -- `current` must be non-nil, but `next` could be `nil` (i.e. last item in list)
                        current.next = node
                        node.previous = current

                        if next ~= nil then
                            node.next = next
                            next.previous = node
                        end
                    else
                        -- set `node` to `first`
                        node.next = first
                        first.previous = node
                        first = node
                    end
                end

                onCancel(function()
                    -- remove node from queue
                    local next = node.next

                    if first == node then
                        if next == nil then -- if `node` is the first and last
                            connection:Disconnect()
                            connection = nil
                        else -- if `node` is `first` and not the last
                            next.previous = nil
                        end
                        first = next
                    else
                        local previous = node.previous
                        -- since `node` is not `first`, then we know `previous` is non-nil
                        previous.next = next

                        if next ~= nil then
                            next.previous = previous
                        end
                    end
                end)
            end)
        end
    end

--[=[
	Returns a new Promise that resolves if the chained Promise resolves within `seconds` seconds, or rejects if execution time exceeds `seconds`. The chained Promise will be cancelled if the timeout is reached.

	Rejects with `rejectionValue` if it is non-nil. If a `rejectionValue` is not given, it will reject with a `Promise.Error(Promise.Error.Kind.TimedOut)`. This can be checked with [[Error.isKind]].

	```lua
	getSomething():timeout(5):andThen(function(something)
		-- got something and it only took at max 5 seconds
	end):catch(function(e)
		-- Either getting something failed or the time was exceeded.

		if Promise.Error.isKind(e, Promise.Error.Kind.TimedOut) then
			warn("Operation timed out!")
		else
			warn("Operation encountered an error!")
		end
	end)
	```

	Sugar for:

	```lua
	Promise.race({
		Promise.delay(seconds):andThen(function()
			return Promise.reject(
				rejectionValue == nil
				and Promise.Error.new({ kind = Promise.Error.Kind.TimedOut })
				or rejectionValue
			)
		end),
		promise
	})
	```

	@param seconds number
	@param rejectionValue? any -- The value to reject with if the timeout is reached
	@return Promise
]=]
    function Promise.prototype:timeout(seconds, rejectionValue)
        local traceback = debug.traceback(nil, 2)

        return Promise.race({
            Promise.delay(seconds):andThen(function()
                return Promise.reject(rejectionValue == nil and Error.new({
                    kind = Error.Kind.TimedOut,
                    error = "Timed out",
                    context = string.format(
                        "Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s",
                        seconds,
                        traceback
                    ),
                }) or rejectionValue)
            end),
            self,
        })
    end

--[=[
	Returns the current Promise status.

	@return Status
]=]
    function Promise.prototype:getStatus()
        return self._status
    end

--[[
	Creates a new promise that receives the result of this promise.

	The given callbacks are invoked depending on that result.
]]
    function Promise.prototype:_andThen(traceback, successHandler, failureHandler)
        self._unhandledRejection = false

        -- If we are already cancelled, we return a cancelled Promise
        if self._status == Promise.Status.Cancelled then
            local promise = Promise.new(function() end)
            promise:cancel()

            return promise
        end

        -- Create a new promise to follow this part of the chain
        return Promise._new(traceback, function(resolve, reject, onCancel)
            -- Our default callbacks just pass values onto the next promise.
            -- This lets success and failure cascade correctly!

            local successCallback = resolve
            if successHandler then
                successCallback = createAdvancer(traceback, successHandler, resolve, reject)
            end

            local failureCallback = reject
            if failureHandler then
                failureCallback = createAdvancer(traceback, failureHandler, resolve, reject)
            end

            if self._status == Promise.Status.Started then
                -- If we haven't resolved yet, put ourselves into the queue
                table.insert(self._queuedResolve, successCallback)
                table.insert(self._queuedReject, failureCallback)

                onCancel(function()
                    -- These are guaranteed to exist because the cancellation handler is guaranteed to only
                    -- be called at most once
                    if self._status == Promise.Status.Started then
                        table.remove(self._queuedResolve, table.find(self._queuedResolve, successCallback))
                        table.remove(self._queuedReject, table.find(self._queuedReject, failureCallback))
                    end
                end)
            elseif self._status == Promise.Status.Resolved then
                -- This promise has already resolved! Trigger success immediately.
                successCallback(unpack(self._values, 1, self._valuesLength))
            elseif self._status == Promise.Status.Rejected then
                -- This promise died a terrible death! Trigger failure immediately.
                failureCallback(unpack(self._values, 1, self._valuesLength))
            end
        end, self)
    end

--[=[
	Chains onto an existing Promise and returns a new Promise.

	:::warning
	Within the failure handler, you should never assume that the rejection value is a string. Some rejections within the Promise library are represented by [[Error]] objects. If you want to treat it as a string for debugging, you should call `tostring` on it first.
	:::

	You can return a Promise from the success or failure handler and it will be chained onto.

	Calling `andThen` on a cancelled Promise returns a cancelled Promise.

	:::tip
	If the Promise returned by `andThen` is cancelled, `successHandler` and `failureHandler` will not run.

	To run code no matter what, use [Promise:finally].
	:::

	@param successHandler (...: any) -> ...any
	@param failureHandler? (...: any) -> ...any
	@return Promise<...any>
]=]
    function Promise.prototype:andThen(successHandler, failureHandler)
        assert(successHandler == nil or isCallable(successHandler), string.format(ERROR_NON_FUNCTION, "Promise:andThen"))
        assert(failureHandler == nil or isCallable(failureHandler), string.format(ERROR_NON_FUNCTION, "Promise:andThen"))

        return self:_andThen(debug.traceback(nil, 2), successHandler, failureHandler)
    end

--[=[
	Shorthand for `Promise:andThen(nil, failureHandler)`.

	Returns a Promise that resolves if the `failureHandler` worked without encountering an additional error.

	:::warning
	Within the failure handler, you should never assume that the rejection value is a string. Some rejections within the Promise library are represented by [[Error]] objects. If you want to treat it as a string for debugging, you should call `tostring` on it first.
	:::

	Calling `catch` on a cancelled Promise returns a cancelled Promise.

	:::tip
	If the Promise returned by `catch` is cancelled,  `failureHandler` will not run.

	To run code no matter what, use [Promise:finally].
	:::

	@param failureHandler (...: any) -> ...any
	@return Promise<...any>
]=]
    function Promise.prototype:catch(failureHandler)
        assert(failureHandler == nil or isCallable(failureHandler), string.format(ERROR_NON_FUNCTION, "Promise:catch"))
        return self:_andThen(debug.traceback(nil, 2), nil, failureHandler)
    end

--[=[
	Similar to [Promise.andThen](#andThen), except the return value is the same as the value passed to the handler. In other words, you can insert a `:tap` into a Promise chain without affecting the value that downstream Promises receive.

	```lua
		getTheValue()
		:tap(print)
		:andThen(function(theValue)
			print("Got", theValue, "even though print returns nil!")
		end)
	```

	If you return a Promise from the tap handler callback, its value will be discarded but `tap` will still wait until it resolves before passing the original value through.

	@param tapHandler (...: any) -> ...any
	@return Promise<...any>
]=]
    function Promise.prototype:tap(tapHandler)
        assert(isCallable(tapHandler), string.format(ERROR_NON_FUNCTION, "Promise:tap"))
        return self:_andThen(debug.traceback(nil, 2), function(...)
            local callbackReturn = tapHandler(...)

            if Promise.is(callbackReturn) then
                local length, values = pack(...)
                return callbackReturn:andThen(function()
                    return unpack(values, 1, length)
                end)
            end

            return ...
        end)
    end

--[=[
	Attaches an `andThen` handler to this Promise that calls the given callback with the predefined arguments. The resolved value is discarded.

	```lua
		promise:andThenCall(someFunction, "some", "arguments")
	```

	This is sugar for

	```lua
		promise:andThen(function()
		return someFunction("some", "arguments")
		end)
	```

	@param callback (...: any) -> any
	@param ...? any -- Additional arguments which will be passed to `callback`
	@return Promise
]=]
    function Promise.prototype:andThenCall(callback, ...)
        assert(isCallable(callback), string.format(ERROR_NON_FUNCTION, "Promise:andThenCall"))
        local length, values = pack(...)
        return self:_andThen(debug.traceback(nil, 2), function()
            return callback(unpack(values, 1, length))
        end)
    end

--[=[
	Attaches an `andThen` handler to this Promise that discards the resolved value and returns the given value from it.

	```lua
		promise:andThenReturn("some", "values")
	```

	This is sugar for

	```lua
		promise:andThen(function()
			return "some", "values"
		end)
	```

	:::caution
	Promises are eager, so if you pass a Promise to `andThenReturn`, it will begin executing before `andThenReturn` is reached in the chain. Likewise, if you pass a Promise created from [[Promise.reject]] into `andThenReturn`, it's possible that this will trigger the unhandled rejection warning. If you need to return a Promise, it's usually best practice to use [[Promise.andThen]].
	:::

	@param ... any -- Values to return from the function
	@return Promise
]=]
    function Promise.prototype:andThenReturn(...)
        local length, values = pack(...)
        return self:_andThen(debug.traceback(nil, 2), function()
            return unpack(values, 1, length)
        end)
    end

--[=[
	Cancels this promise, preventing the promise from resolving or rejecting. Does not do anything if the promise is already settled.

	Cancellations will propagate upwards and downwards through chained promises.

	Promises will only be cancelled if all of their consumers are also cancelled. This is to say that if you call `andThen` twice on the same promise, and you cancel only one of the child promises, it will not cancel the parent promise until the other child promise is also cancelled.

	```lua
		promise:cancel()
	```
]=]
    function Promise.prototype:cancel()
        if self._status ~= Promise.Status.Started then
            return
        end

        self._status = Promise.Status.Cancelled

        if self._cancellationHook then
            self._cancellationHook()
        end

        coroutine.close(self._thread)

        if self._parent then
            self._parent:_consumerCancelled(self)
        end

        for child in pairs(self._consumers) do
            child:cancel()
        end

        self:_finalize()
    end

--[[
	Used to decrease the number of consumers by 1, and if there are no more,
	cancel this promise.
]]
    function Promise.prototype:_consumerCancelled(consumer)
        if self._status ~= Promise.Status.Started then
            return
        end

        self._consumers[consumer] = nil

        if next(self._consumers) == nil then
            self:cancel()
        end
    end

--[[
	Used to set a handler for when the promise resolves, rejects, or is
	cancelled.
]]
    function Promise.prototype:_finally(traceback, finallyHandler)
        self._unhandledRejection = false

        local promise = Promise._new(traceback, function(resolve, reject, onCancel)
            local handlerPromise

            onCancel(function()
                -- The finally Promise is not a proper consumer of self. We don't care about the resolved value.
                -- All we care about is running at the end. Therefore, if self has no other consumers, it's safe to
                -- cancel. We don't need to hold out cancelling just because there's a finally handler.
                self:_consumerCancelled(self)

                if handlerPromise then
                    handlerPromise:cancel()
                end
            end)

            local finallyCallback = resolve
            if finallyHandler then
                finallyCallback = function(...)
                    local callbackReturn = finallyHandler(...)

                    if Promise.is(callbackReturn) then
                        handlerPromise = callbackReturn

                        callbackReturn
                            :finally(function(status)
                                if status ~= Promise.Status.Rejected then
                                    resolve(self)
                                end
                            end)
                            :catch(function(...)
                                reject(...)
                            end)
                    else
                        resolve(self)
                    end
                end
            end

            if self._status == Promise.Status.Started then
                -- The promise is not settled, so queue this.
                table.insert(self._queuedFinally, finallyCallback)
            else
                -- The promise already settled or was cancelled, run the callback now.
                finallyCallback(self._status)
            end
        end)

        return promise
    end

--[=[
	Set a handler that will be called regardless of the promise's fate. The handler is called when the promise is
	resolved, rejected, *or* cancelled.

	Returns a new Promise that:
	- resolves with the same values that this Promise resolves with.
	- rejects with the same values that this Promise rejects with.
	- is cancelled if this Promise is cancelled.

	If the value you return from the handler is a Promise:
	- We wait for the Promise to resolve, but we ultimately discard the resolved value.
	- If the returned Promise rejects, the Promise returned from `finally` will reject with the rejected value from the
	*returned* promise.
	- If the `finally` Promise is cancelled, and you returned a Promise from the handler, we cancel that Promise too.

	Otherwise, the return value from the `finally` handler is entirely discarded.

	:::note Cancellation
	As of Promise v4, `Promise:finally` does not count as a consumer of the parent Promise for cancellation purposes.
	This means that if all of a Promise's consumers are cancelled and the only remaining callbacks are finally handlers,
	the Promise is cancelled and the finally callbacks run then and there.

	Cancellation still propagates through the `finally` Promise though: if you cancel the `finally` Promise, it can cancel
	its parent Promise if it had no other consumers. Likewise, if the parent Promise is cancelled, the `finally` Promise
	will also be cancelled.
	:::

	```lua
	local thing = createSomething()

	doSomethingWith(thing)
		:andThen(function()
			print("It worked!")
			-- do something..
		end)
		:catch(function()
			warn("Oh no it failed!")
		end)
		:finally(function()
			-- either way, destroy thing

			thing:Destroy()
		end)

	```

	@param finallyHandler (status: Status) -> ...any
	@return Promise<...any>
]=]
    function Promise.prototype:finally(finallyHandler)
        assert(finallyHandler == nil or isCallable(finallyHandler), string.format(ERROR_NON_FUNCTION, "Promise:finally"))
        return self:_finally(debug.traceback(nil, 2), finallyHandler)
    end

--[=[
	Same as `andThenCall`, except for `finally`.

	Attaches a `finally` handler to this Promise that calls the given callback with the predefined arguments.

	@param callback (...: any) -> any
	@param ...? any -- Additional arguments which will be passed to `callback`
	@return Promise
]=]
    function Promise.prototype:finallyCall(callback, ...)
        assert(isCallable(callback), string.format(ERROR_NON_FUNCTION, "Promise:finallyCall"))
        local length, values = pack(...)
        return self:_finally(debug.traceback(nil, 2), function()
            return callback(unpack(values, 1, length))
        end)
    end

--[=[
	Attaches a `finally` handler to this Promise that discards the resolved value and returns the given value from it.

	```lua
		promise:finallyReturn("some", "values")
	```

	This is sugar for

	```lua
		promise:finally(function()
			return "some", "values"
		end)
	```

	@param ... any -- Values to return from the function
	@return Promise
]=]
    function Promise.prototype:finallyReturn(...)
        local length, values = pack(...)
        return self:_finally(debug.traceback(nil, 2), function()
            return unpack(values, 1, length)
        end)
    end

--[=[
	Yields the current thread until the given Promise completes. Returns the Promise's status, followed by the values that the promise resolved or rejected with.

	@yields
	@return Status -- The Status representing the fate of the Promise
	@return ...any -- The values the Promise resolved or rejected with.
]=]
    function Promise.prototype:awaitStatus()
        self._unhandledRejection = false

        if self._status == Promise.Status.Started then
            local thread = coroutine.running()

            self
                :finally(function()
                    task.spawn(thread)
                end)
                -- The finally promise can propagate rejections, so we attach a catch handler to prevent the unhandled
                -- rejection warning from appearing
                :catch(
                    function() end
                )

            coroutine.yield()
        end

        if self._status == Promise.Status.Resolved then
            return self._status, unpack(self._values, 1, self._valuesLength)
        elseif self._status == Promise.Status.Rejected then
            return self._status, unpack(self._values, 1, self._valuesLength)
        end

        return self._status
    end

    local function awaitHelper(status, ...)
        return status == Promise.Status.Resolved, ...
    end

--[=[
	Yields the current thread until the given Promise completes. Returns true if the Promise resolved, followed by the values that the promise resolved or rejected with.

	:::caution
	If the Promise gets cancelled, this function will return `false`, which is indistinguishable from a rejection. If you need to differentiate, you should use [[Promise.awaitStatus]] instead.
	:::

	```lua
		local worked, value = getTheValue():await()

	if worked then
		print("got", value)
	else
		warn("it failed")
	end
	```

	@yields
	@return boolean -- `true` if the Promise successfully resolved
	@return ...any -- The values the Promise resolved or rejected with.
]=]
    function Promise.prototype:await()
        return awaitHelper(self:awaitStatus())
    end

    local function expectHelper(status, ...)
        if status ~= Promise.Status.Resolved then
            error((...) == nil and "Expected Promise rejected with no value." or (...), 3)
        end

        return ...
    end

--[=[
	Yields the current thread until the given Promise completes. Returns the values that the promise resolved with.

	```lua
	local worked = pcall(function()
		print("got", getTheValue():expect())
	end)

	if not worked then
		warn("it failed")
	end
	```

	This is essentially sugar for:

	```lua
	select(2, assert(promise:await()))
	```

	**Errors** if the Promise rejects or gets cancelled.

	@error any -- Errors with the rejection value if this Promise rejects or gets cancelled.
	@yields
	@return ...any -- The values the Promise resolved with.
]=]
    function Promise.prototype:expect()
        return expectHelper(self:awaitStatus())
    end

    -- Backwards compatibility
    Promise.prototype.awaitValue = Promise.prototype.expect

--[[
	Intended for use in tests.

	Similar to await(), but instead of yielding if the promise is unresolved,
	_unwrap will throw. This indicates an assumption that a promise has
	resolved.
]]
    function Promise.prototype:_unwrap()
        if self._status == Promise.Status.Started then
            error("Promise has not resolved or rejected.", 2)
        end

        local success = self._status == Promise.Status.Resolved

        return success, unpack(self._values, 1, self._valuesLength)
    end

    function Promise.prototype:_resolve(...)
        if self._status ~= Promise.Status.Started then
            if Promise.is((...)) then
                (...):_consumerCancelled(self)
            end
            return
        end

        -- If the resolved value was a Promise, we chain onto it!
        if Promise.is((...)) then
            -- Without this warning, arguments sometimes mysteriously disappear
            if select("#", ...) > 1 then
                local message = string.format(
[[When returning a Promise from andThen, extra arguments are discarded! See:

%s]],
                    self._source
                )
                warn(message)
            end

            local chainedPromise = ...

            local promise = chainedPromise:andThen(function(...)
                self:_resolve(...)
            end, function(...)
                local maybeRuntimeError = chainedPromise._values[1]

                -- Backwards compatibility < v2
                if chainedPromise._error then
                    maybeRuntimeError = Error.new({
                        error = chainedPromise._error,
                        kind = Error.Kind.ExecutionError,
                        context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
                    })
                end

                if Error.isKind(maybeRuntimeError, Error.Kind.ExecutionError) then
                    return self:_reject(maybeRuntimeError:extend({
                        error = "This Promise was chained to a Promise that errored.",
                        trace = "",
                        context = string.format(
                            "The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n",
                            self._source
                        ),
                    }))
                end

                self:_reject(...)
            end)

            if promise._status == Promise.Status.Cancelled then
                self:cancel()
            elseif promise._status == Promise.Status.Started then
                -- Adopt ourselves into promise for cancellation propagation.
                self._parent = promise
                promise._consumers[self] = true
            end

            return
        end

        self._status = Promise.Status.Resolved
        self._valuesLength, self._values = pack(...)

        -- We assume that these callbacks will not throw errors.
        for _, callback in ipairs(self._queuedResolve) do
            coroutine.wrap(callback)(...)
        end

        self:_finalize()
    end

    function Promise.prototype:_reject(...)
        if self._status ~= Promise.Status.Started then
            return
        end

        self._status = Promise.Status.Rejected
        self._valuesLength, self._values = pack(...)

        -- If there are any rejection handlers, call those!
        if not isEmpty(self._queuedReject) then
            -- We assume that these callbacks will not throw errors.
            for _, callback in ipairs(self._queuedReject) do
                coroutine.wrap(callback)(...)
            end
        else
            -- At this point, no one was able to observe the error.
            -- An error handler might still be attached if the error occurred
            -- synchronously. We'll wait one tick, and if there are still no
            -- observers, then we should put a message in the console.

            local err = tostring((...))

            coroutine.wrap(function()
                Promise._timeEvent:Wait()

                -- Someone observed the error, hooray!
                if not self._unhandledRejection then
                    return
                end

                -- Build a reasonable message
                local message = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", err, self._source)

                for _, callback in ipairs(Promise._unhandledRejectionCallbacks) do
                    task.spawn(callback, self, unpack(self._values, 1, self._valuesLength))
                end

                if Promise.TEST then
                    -- Don't spam output when we're running tests.
                    return
                end

                warn(message)
            end)()
        end

        self:_finalize()
    end

--[[
	Calls any :finally handlers. We need this to be a separate method and
	queue because we must call all of the finally callbacks upon a success,
	failure, *and* cancellation.
]]
    function Promise.prototype:_finalize()
        for _, callback in ipairs(self._queuedFinally) do
            -- Purposefully not passing values to callbacks here, as it could be the
            -- resolved values, or rejected errors. If the developer needs the values,
            -- they should use :andThen or :catch explicitly.
            coroutine.wrap(callback)(self._status)
        end

        self._queuedFinally = nil
        self._queuedReject = nil
        self._queuedResolve = nil

        -- Clear references to other Promises to allow gc
        if not Promise.TEST then
            self._parent = nil
            self._consumers = nil
        end

        task.defer(coroutine.close, self._thread)
    end

--[=[
	Chains a Promise from this one that is resolved if this Promise is already resolved, and rejected if it is not resolved at the time of calling `:now()`. This can be used to ensure your `andThen` handler occurs on the same frame as the root Promise execution.

	```lua
	doSomething()
		:now()
		:andThen(function(value)
			print("Got", value, "synchronously.")
		end)
	```

	If this Promise is still running, Rejected, or Cancelled, the Promise returned from `:now()` will reject with the `rejectionValue` if passed, otherwise with a `Promise.Error(Promise.Error.Kind.NotResolvedInTime)`. This can be checked with [[Error.isKind]].

	@param rejectionValue? any -- The value to reject with if the Promise isn't resolved
	@return Promise
]=]
    function Promise.prototype:now(rejectionValue)
        local traceback = debug.traceback(nil, 2)
        if self._status == Promise.Status.Resolved then
            return self:_andThen(traceback, function(...)
                return ...
            end)
        else
            return Promise.reject(rejectionValue == nil and Error.new({
                kind = Error.Kind.NotResolvedInTime,
                error = "This Promise was not resolved in time for :now()",
                context = ":now() was called at:\n\n" .. traceback,
            }) or rejectionValue)
        end
    end

--[=[
	Repeatedly calls a Promise-returning function up to `times` number of times, until the returned Promise resolves.

	If the amount of retries is exceeded, the function will return the latest rejected Promise.

	```lua
	local function canFail(a, b, c)
		return Promise.new(function(resolve, reject)
			-- do something that can fail

			local failed, thing = doSomethingThatCanFail(a, b, c)

			if failed then
				reject("it failed")
			else
				resolve(thing)
			end
		end)
	end

	local MAX_RETRIES = 10
	local value = Promise.retry(canFail, MAX_RETRIES, "foo", "bar", "baz") -- args to send to canFail
	```

	@since 3.0.0
	@param callback (...: P) -> Promise<T>
	@param times number
	@param ...? P
	@return Promise<T>
]=]
    function Promise.retry(callback, times, ...)
        assert(isCallable(callback), "Parameter #1 to Promise.retry must be a function")
        assert(type(times) == "number", "Parameter #2 to Promise.retry must be a number")

        local args, length = { ... }, select("#", ...)

        return Promise.resolve(callback(...)):catch(function(...)
            if times > 0 then
                return Promise.retry(callback, times - 1, unpack(args, 1, length))
            else
                return Promise.reject(...)
            end
        end)
    end

--[=[
	Repeatedly calls a Promise-returning function up to `times` number of times, waiting `seconds` seconds between each
	retry, until the returned Promise resolves.

	If the amount of retries is exceeded, the function will return the latest rejected Promise.

	@since v3.2.0
	@param callback (...: P) -> Promise<T>
	@param times number
	@param seconds number
	@param ...? P
	@return Promise<T>
]=]
    function Promise.retryWithDelay(callback, times, seconds, ...)
        assert(isCallable(callback), "Parameter #1 to Promise.retry must be a function")
        assert(type(times) == "number", "Parameter #2 (times) to Promise.retry must be a number")
        assert(type(seconds) == "number", "Parameter #3 (seconds) to Promise.retry must be a number")

        local args, length = { ... }, select("#", ...)

        return Promise.resolve(callback(...)):catch(function(...)
            if times > 0 then
                Promise.delay(seconds):await()

                return Promise.retryWithDelay(callback, times - 1, seconds, unpack(args, 1, length))
            else
                return Promise.reject(...)
            end
        end)
    end

--[=[
	Converts an event into a Promise which resolves the next time the event fires.

	The optional `predicate` callback, if passed, will receive the event arguments and should return `true` or `false`, based on if this fired event should resolve the Promise or not. If `true`, the Promise resolves. If `false`, nothing happens and the predicate will be rerun the next time the event fires.

	The Promise will resolve with the event arguments.

	:::tip
	This function will work given any object with a `Connect` method. This includes all Roblox events.
	:::

	```lua
	-- Creates a Promise which only resolves when `somePart` is touched
	-- by a part named `"Something specific"`.
	return Promise.fromEvent(somePart.Touched, function(part)
		return part.Name == "Something specific"
	end)
	```

	@since 3.0.0
	@param event Event -- Any object with a `Connect` method. This includes all Roblox events.
	@param predicate? (...: P) -> boolean -- A function which determines if the Promise should resolve with the given value, or wait for the next event to check again.
	@return Promise<P>
]=]
    function Promise.fromEvent(event, predicate)
        predicate = predicate or function()
            return true
        end

        return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)
            local shouldDisconnect ,connection
=false

            local function disconnect()
                connection:Disconnect()
                connection = nil
            end

            -- We use shouldDisconnect because if the callback given to Connect is called before
            -- Connect returns, connection will still be nil. This happens with events that queue up
            -- events when there's nothing connected, such as RemoteEvents

            connection = event:Connect(function(...)
                local callbackValue = predicate(...)

                if callbackValue == true then
                    resolve(...)

                    if connection then
                        disconnect()
                    else
                        shouldDisconnect = true
                    end
                elseif type(callbackValue) ~= "boolean" then
                    error("Promise.fromEvent predicate should always return a boolean")
                end
            end)

            if shouldDisconnect and connection then
                return disconnect()
            end

            onCancel(disconnect)
        end)
    end

--[=[
	Registers a callback that runs when an unhandled rejection happens. An unhandled rejection happens when a Promise
	is rejected, and the rejection is not observed with `:catch`.

	The callback is called with the actual promise that rejected, followed by the rejection values.

	@since v3.2.0
	@param callback (promise: Promise, ...: any) -- A callback that runs when an unhandled rejection happens.
	@return () -> () -- Function that unregisters the `callback` when called
]=]
    function Promise.onUnhandledRejection(callback)
        table.insert(Promise._unhandledRejectionCallbacks, callback)

        return function()
            local index = table.find(Promise._unhandledRejectionCallbacks, callback)

            if index then
                table.remove(Promise._unhandledRejectionCallbacks, index)
            end
        end
    end

    return Promise
end
end)() end,[25]=function()ImportGlobals(25)return (function(...)return function(Root)
    local TreeCache = {}
    TreeCache.Paths = setmetatable({}, {__mode = "k"})

    local Tree ,WaitForChild ,FindFirstChild = {Delimiter = "/"},game.WaitForChild
,game.FindFirstChild

    local function GetCache(Parent, Path)
        local ParentCache = TreeCache.Paths[Parent]        if not ParentCache then return nil end
        local TargetCache = ParentCache[Path]

        return if (TargetCache ~= nil and TargetCache.Parent == Parent) then TargetCache else nil    end

    local function StoreCache(Parent, Path, Resolved)
        local ParentCache = TreeCache.Paths[Parent]        if not ParentCache then 
            TreeCache.Paths[Parent] = {}
            ParentCache = TreeCache.Paths[Parent]
        end

        ParentCache[Path] = Resolved
    end

    local function ResolvePath(Path, InitialParent, YieldTimeout)
        local Read = GetCache(InitialParent, Path)        if Read then return Read end 

        local Parts ,Resolved = string.split(Path, Tree.Delimiter),InitialParent

        for _, v in Parts do 
            Resolved = FindFirstChild(Resolved, v) or (YieldTimeout and WaitForChild(Resolved, v, YieldTimeout)) or nil            if not Resolved then return nil end
        end

        StoreCache(InitialParent, Path, Resolved)

        return Resolved
    end
    
    function Tree.Find(Parent, Path)
        return ResolvePath(Path, Parent)    end

    function Tree.Await(Parent, Path, YieldTimeout)
        return ResolvePath(Path, Parent, YieldTimeout)    end

    return Tree
end
end)() end,[26]=function()ImportGlobals(26)return (function(...)--!strict

local RunService ,FN_MARKER ,THREAD_MARKER ,GENERIC_OBJECT_CLEANUP_METHODS = game:GetService("RunService")
,newproxy()
,newproxy()
,table.freeze({ "Destroy", "Disconnect", "destroy", "disconnect" })

local function getObjectCleanupFunction(object, cleanupMethod)
    local t = typeof(object)

    if t == "function" then
        return FN_MARKER
    elseif t == "thread" then
        return THREAD_MARKER
    end

    if cleanupMethod then
        return cleanupMethod
    end

    if t == "Instance" then
        return "Destroy"
    elseif t == "RBXScriptConnection" then
        return "Disconnect"
    elseif t == "table" then
        for _, genericCleanupMethod in GENERIC_OBJECT_CLEANUP_METHODS do
            if typeof(object[genericCleanupMethod]) == "function" then
                return genericCleanupMethod
            end
        end
    end

    error(`failed to get cleanup function for object {t}: {object}`, 3)
end

local function assertPromiseLike(object)
    if
        typeof(object) ~= "table"
        or typeof(object.getStatus) ~= "function"
        or typeof(object.finally) ~= "function"
        or typeof(object.cancel) ~= "function"
    then
        error("did not receive a promise as an argument", 3)
    end
end

local function assertSignalLike(object)
    if
        typeof(object) ~= "RBXScriptSignal"
        and (typeof(object) ~= "table" or typeof(object.Connect) ~= "function" or typeof(object.Once) ~= "function")
    then
        error("did not receive a signal as an argument", 3)
    end
end

--[=[
	@class Trove
	A Trove is helpful for tracking any sort of object during
	runtime that needs to get cleaned up at some point.
]=]
local Trove = {}
Trove.__index = Trove

--[=[
	@return Trove
	Constructs a Trove object.

	```lua
	local trove = Trove.new()
	```
]=]
function Trove.new()    local self = setmetatable({}, Trove)

    self._objects = {}
    self._cleaning = false

    return (self ) end

--[=[
	@method Add
	@within Trove
	@param object any -- Object to track
	@param cleanupMethod string? -- Optional cleanup name override
	@return object: any
	Adds an object to the trove. Once the trove is cleaned or
	destroyed, the object will also be cleaned up.

	The following types are accepted (e.g. `typeof(object)`):

	| Type | Cleanup |
	| ---- | ------- |
	| `Instance` | `object:Destroy()` |
	| `RBXScriptConnection` | `object:Disconnect()` |
	| `function` | `object()` |
	| `thread` | `task.cancel(object)` |
	| `table` | `object:Destroy()` _or_ `object:Disconnect()` _or_ `object:destroy()` _or_ `object:disconnect()` |
	| `table` with `cleanupMethod` | `object:<cleanupMethod>()` |

	Returns the object added.

	```lua
	-- Add a part to the trove, then destroy the trove,
	-- which will also destroy the part:
	local part = Instance.new("Part")
	trove:Add(part)
	trove:Destroy()

	-- Add a function to the trove:
	trove:Add(function()
		print("Cleanup!")
	end)
	trove:Destroy()

	-- Standard cleanup from table:
	local tbl = {}
	function tbl:Destroy()
		print("Cleanup")
	end
	trove:Add(tbl)

	-- Custom cleanup from table:
	local tbl = {}
	function tbl:DoSomething()
		print("Do something on cleanup")
	end
	trove:Add(tbl, "DoSomething")
	```
]=]
function Trove.Add(self, object, cleanupMethod)    if self._cleaning then
        error("cannot call trove:Add() while cleaning", 2)
    end

    local cleanup = getObjectCleanupFunction(object, cleanupMethod)
    table.insert(self._objects, { object, cleanup })

    return object
end

--[=[
	@method Clone
	@within Trove
	@return Instance
	Clones the given instance and adds it to the trove. Shorthand for
	`trove:Add(instance:Clone())`.

	```lua
	local clonedPart = trove:Clone(somePart)
	```
]=]
function Trove.Clone(self, instance)    if self._cleaning then
        error("cannot call trove:Clone() while cleaning", 2)
    end

    return self:Add(instance:Clone())
end

--[=[
	@method Construct
	@within Trove
	@param class { new(Args...) -> T } | (Args...) -> T
	@param ... Args...
	@return T
	Constructs a new object from either the
	table or function given.

	If a table is given, the table's `new`
	function will be called with the given
	arguments.

	If a function is given, the function will
	be called with the given arguments.

	The result from either of the two options
	will be added to the trove.

	This is shorthand for `trove:Add(SomeClass.new(...))`
	and `trove:Add(SomeFunction(...))`.

	```lua
	local Signal = require(somewhere.Signal)

	-- All of these are identical:
	local s = trove:Construct(Signal)
	local s = trove:Construct(Signal.new)
	local s = trove:Construct(function() return Signal.new() end)
	local s = trove:Add(Signal.new())

	-- Even Roblox instances can be created:
	local part = trove:Construct(Instance, "Part")
	```
]=]
function Trove.Construct(self, class, ...)
    if self._cleaning then
        error("Cannot call trove:Construct() while cleaning", 2)
    end

    local t ,object =(type(class)
)    if t == "table" then
        object = (class ).new(...)
    elseif t == "function" then
        object = (class )(...)
    end

    return self:Add(object)
end

--[=[
	@method Connect
	@within Trove
	@param signal RBXScriptSignal
	@param fn (...: any) -> ()
	@return RBXScriptConnection
	Connects the function to the signal, adds the connection
	to the trove, and then returns the connection.

	This is shorthand for `trove:Add(signal:Connect(fn))`.

	```lua
	trove:Connect(workspace.ChildAdded, function(instance)
		print(instance.Name .. " added to workspace")
	end)
	```
]=]
function Trove.Connect(
    self,
    signal,
    fn)
    if self._cleaning then
        error("Cannot call trove:Connect() while cleaning", 2)
    end
    assertSignalLike(signal)

    local confirmedSignal = signal 
    return self:Add(confirmedSignal:Connect(fn))
end

--[=[
	@method Once
	@within Trove
	@param signal RBXScriptSignal
	@param fn (...: any) -> ()
	@return RBXScriptConnection
	Connects the function to the signal using the `Once`
	method, adds the connection to the trove, and then
	returns the connection.

	This is shorthand for `trove:Add(signal:Once(fn))`.

	```lua
	trove:Connect(workspace.ChildAdded, function(instance)
		print(instance.Name .. " added to workspace")
	end)
	```
]=]
function Trove.Once(
    self,
    signal,
    fn)
    if self._cleaning then
        error("Cannot call trove:Connect() while cleaning", 2)
    end
    assertSignalLike(signal)

    local confirmedSignal ,conn
= signal     conn = confirmedSignal:Once(function(...)
        fn(...)
        self:Pop(conn)
    end)

    return self:Add(conn)
end

--[=[
	@method BindToRenderStep
	@within Trove
	@param name string
	@param priority number
	@param fn (dt: number) -> ()
	Calls `RunService:BindToRenderStep` and registers a function in the
	trove that will call `RunService:UnbindFromRenderStep` on cleanup.

	```lua
	trove:BindToRenderStep("Test", Enum.RenderPriority.Last.Value, function(dt)
		-- Do something
	end)
	```
]=]
function Trove.BindToRenderStep(self, name, priority, fn)
    if self._cleaning then
        error("cannot call trove:BindToRenderStep() while cleaning", 2)
    end

    RunService:BindToRenderStep(name, priority, fn)

    self:Add(function()
        RunService:UnbindFromRenderStep(name)
    end)
end

--[=[
	@method AddPromise
	@within Trove
	@param promise Promise
	@return Promise
	Gives the promise to the trove, which will cancel the promise if the trove is cleaned up or if the promise
	is removed. The exact promise is returned, thus allowing chaining.

	```lua
	trove:AddPromise(doSomethingThatReturnsAPromise())
		:andThen(function()
			print("Done")
		end)
	-- Will cancel the above promise (assuming it didn't resolve immediately)
	trove:Clean()

	local p = trove:AddPromise(doSomethingThatReturnsAPromise())
	-- Will also cancel the promise
	trove:Remove(p)
	```

	:::caution Promise v4 Only
	This is only compatible with the [roblox-lua-promise](https://eryn.io/roblox-lua-promise/) library, version 4.
	:::
]=]
function Trove.AddPromise(self, promise)
    if self._cleaning then
        error("cannot call trove:AddPromise() while cleaning", 2)
    end
    assertPromiseLike(promise)
    local confirmedPromise = promise 
    if confirmedPromise:getStatus() == "Started" then
        confirmedPromise:finally(function()
            if self._cleaning then
                return
            end
            self:_findAndRemoveFromObjects(confirmedPromise, false)
        end)

        self:Add(confirmedPromise, "cancel")
    end

    return confirmedPromise
end

--[=[
	@method Remove
	@within Trove
	@param object any
	Removes the object from the Trove and cleans it up. To remove without
	cleaning, use the `Pop` method instead.

	```lua
	local part = Instance.new("Part")
	trove:Add(part)
	trove:Remove(part) -- Part is destroyed
	```
]=]
function Trove.Remove(self, object)    if self._cleaning then
        error("cannot call trove:Remove() while cleaning", 2)
    end

    return self:_findAndRemoveFromObjects(object, true)
end

--[=[
	@method Pop
	@within Trove
	@param object any
	Removes the object from the Trove, but does _not_ clean it up. To
	clean up the object on removal, use the `Remove` method instead.

	```lua
	local part = Instance.new("Part")
	trove:Add(part)
	trove:Pop(part)
	trove:Clean() -- Part is NOT destroyed
	```
]=]
function Trove.Pop(self, object)    if self._cleaning then
        error("cannot call trove:Pop() while cleaning", 2)
    end

    return self:_findAndRemoveFromObjects(object, false)
end

--[=[
	@method Extend
	@within Trove
	@return Trove
	Creates and adds another trove to itself. This is just shorthand
	for `trove:Construct(Trove)`. This is useful for contexts where
	the trove object is present, but the class itself isn't.

	:::note
	This does _not_ clone the trove. In other words, the objects in the
	trove are not given to the new constructed trove. This is simply to
	construct a new Trove and add it as an object to track.
	:::

	```lua
	local trove = Trove.new()
	local subTrove = trove:Extend()

	trove:Clean() -- Cleans up the subTrove too
	```
]=]
function Trove.Extend(self)
    if self._cleaning then
        error("cannot call trove:Extend() while cleaning", 2)
    end

    return self:Construct(Trove)
end

--[=[
	@method Clean
	@within Trove
	Cleans up all objects in the trove. This is
	similar to calling `Remove` on each object
	within the trove. The ordering of the objects
	removed is _not_ guaranteed.

	```lua
	trove:Clean()
	```
]=]
function Trove.Clean(self)
    if self._cleaning then
        return
    end

    self._cleaning = true

    for _, obj in self._objects do
        self:_cleanupObject(obj[1], obj[2])
    end

    table.clear(self._objects)
    self._cleaning = false
end

--[=[
	@method WrapClean
	@within Trove
	Returns a function that wraps the trove's `Clean()`
	method. Calling the returned function will clean up
	the trove.

	This is often useful in contexts where functions
	are the primary mode for cleaning up an environment,
	such as in many "observer" patterns.

	```lua
	local cleanup = trove:WrapClean()

	-- Sometime later...
	cleanup()
	```

	```lua
	-- Common observer pattern example:
	someObserver(function()
		local trove = Trove.new()
		-- Foo
		return trove:WrapClean()
	end)
	```
]=]
function Trove.WrapClean(self)
    return function()
        self:Clean()
    end
end

function Trove._findAndRemoveFromObjects(self, object, cleanup)    local objects = self._objects

    for i, obj in objects do
        if obj[1] == object then
            local n = #objects
            objects[i] = objects[n]
            objects[n] = nil

            if cleanup then
                self:_cleanupObject(obj[1], obj[2])
            end

            return true
        end
    end

    return false
end

function Trove._cleanupObject(_self, object, cleanupMethod)
    if cleanupMethod == FN_MARKER then
        task.spawn(object)
    elseif cleanupMethod == THREAD_MARKER then
        pcall(task.cancel, object)
    else
        object[cleanupMethod](object)
    end
end

--[=[
	@method AttachToInstance
	@within Trove
	@param instance Instance
	@return RBXScriptConnection
	Attaches the trove to a Roblox instance. Once this
	instance is removed from the game (parent or ancestor's
	parent set to `nil`), the trove will automatically
	clean up.

	This inverses the ownership of the Trove object, and should
	only be used when necessary. In other words, the attached
	instance dictates when the trove is cleaned up, rather than
	the trove dictating the cleanup of the instance.

	:::caution
	Will throw an error if `instance` is not a descendant
	of the game hierarchy.
	:::

	```lua
	trove:AttachToInstance(somePart)
	trove:Add(function()
		print("Cleaned")
	end)

	-- Destroying the part will cause the trove to clean up, thus "Cleaned" printed:
	somePart:Destroy()
	```
]=]
function Trove.AttachToInstance(self, instance)
    if self._cleaning then
        error("cannot call trove:AttachToInstance() while cleaning", 2)
    elseif not instance:IsDescendantOf(game) then
        error("instance is not a descendant of the game hierarchy", 2)
    end

    return self:Connect(instance.Destroying, function()
        self:Destroy()
    end)
end

--[=[
	@method Destroy
	@within Trove
	Alias for `trove:Clean()`.

	```lua
	trove:Destroy()
	```
]=]
function Trove.Destroy(self)
    self:Clean()
end

return {
    new = Trove.new,
}
end)() end,[27]=function()local wax, script=ImportGlobals(27)return (function(...)return function(Root)
	return Root.new(Root):Extend(Root.Extensions.Children(script))
end
end)() end,[28]=function()ImportGlobals(28)return (function(...)return function(Root)
	local Services = Root.Services	
	local HttpService= Services.HttpService	
	return function()
		return (HttpService:GenerateGUID(false):gsub('-', '')):lower()
	end
end
end)() end,[29]=function()ImportGlobals(29)return (function(...)return function(Root)
    local Services = Root.Services
local Workspace , t , TableUtil , Numbers =Services.Workspace 
, Root:Get('Modules/t'), Root:Get('RBXUtil/TableUtil'), Root:Get('Functions/Numbers')

    -- // Variables
    local CompressAssert ,FormatAssert ,floor ,Time = t.numberMin(0),t.tuple(t.numberMin(0), t.string),math.floor,{}

    Time.Constants = {
        Second = 1,
        Minute = 60,
        Hour = 3600,
        Day = 86_400,
        Month = 2_592_000,
        Year = 31_536_000
    }
    
    local SortedUnits = {}

    for Name, Value in pairs(Time.Constants) do
        table.insert(SortedUnits, {Name = Name, Value = Value})
    end

    table.sort(SortedUnits, function(a, b) return a.Value > b.Value end)

    function Time.now()
        return Workspace:GetServerTimeNow()
    end

    function Time.FormatTime(Unix, Format)
        assert(FormatAssert(Unix, Format))        
        return DateTime.fromUnixTimestamp(Unix):FormatLocalTime(Format, 'en-us')
    end

    function Time.FormatDuration(Duration, Format, Padding)
        assert(FormatAssert(Duration, Format)) -- we can re-use format assertion since they are fundementally same
        
        local Days ,Hours ,Minutes ,Seconds ,Padded = floor(Duration / 86400)
,floor(Duration % 86400 / 3600)
,floor(Duration % 3600  / 60)
,floor(Duration % 60)
,if Padding then "%02d" else "%d"

        return (
            Format
                :gsub('%%d', string.format(Padded, Days))
                :gsub('%%h', string.format(Padded, Hours))
                :gsub('%%m', string.format(Padded, Minutes))
                :gsub('%%s', string.format(Padded, Seconds))
        )
    end

    function Time.CompressTime(Seconds)
        assert(CompressAssert(Seconds))
        Seconds = floor(Seconds)        
        for _, Pair in SortedUnits do 
            local Name ,Value = Pair.Name,Pair.Value

            local Amount = floor(Seconds / Value)            if Amount == 0 then continue end 

            return `{Numbers.Comma(Amount)} {Name .. (Amount > 1 and 's' or '')}`        end

        return '0 Seconds'
    end

    return Time
end
end)() end,[30]=function()ImportGlobals(30)return (function(...)return function(Root)
	-- // Modules
	local t = Root:Get('Modules/t')	
	-- // Variables
    local DecimalRoundAssert ,Numbers = t.tuple(t.number, t.numberConstrained(0, 8)),{}	
	function Numbers.Comma(Number)
		assert(t.integer(Number))		
		local String = tostring(Number)
		local Left, Num, Right = String:match('^([^%d]*%d)(%d*)(.-)$')

		return Left .. Num:reverse():gsub('(%d%d%d)', '%1,'):reverse() .. Right
	end
	
	function Numbers.DecimalRound(Number, Decimals)
		assert(DecimalRoundAssert(Number, Decimals))

		if Number % 1 == 0 then
			return Number
		end

		return string.format(`%.{Decimals}f`, Number)
	end
	
	return Numbers
end
end)() end,[31]=function()ImportGlobals(31)return (function(...)return function(Root)
	-- // Modules
	local t = Root:Get('Modules/t')	
	-- // Variables
    local TruncateAssert ,rep ,Strings = t.tuple(t.string, t.numberMin(0), t.optional(t.string)),string.rep,{}	
	function Strings.Truncate(String, Cutoff, Suffix)
		assert(TruncateAssert(String, Cutoff, Suffix))		
		return String:sub(1, Cutoff) .. (Suffix or '')    end
    
    function Strings.LeadingSpace(Amount)
        assert(t.numberPositive(Amount))        
        return rep(" ", Amount)
    end
	
	return Strings
end
end)() end,[32]=function()ImportGlobals(32)return (function(...)return function(Root)
	local HttpRequest ,Services = (request or (http and http.request) or httprequest)
,Root.Services

	local HttpService= Services.HttpService

	return function(invite_code, clipboard)
		if clipboard then 
			setclipboard("https://www.discord.gg/"..invite_code)
		end

		if (not HttpRequest) then
			return false
		end

		HttpRequest({
			Url = "http://127.0.0.1:6463/rpc?v=1",
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
Origin="https://discord.com"
			},
			Body = HttpService:JSONEncode({
				cmd = "INVITE_BROWSER",
				args = {
					code = invite_code
				},
				nonce = HttpService:GenerateGUID(false)
			})
		})

		return true
	end
end
end)() end,[33]=function()ImportGlobals(33)return (function(...)return function(Root)
	local types = {
		Info = '🔵',
		Warn = '🟠',
		Success = '🟢',
		Error = '🔴'
	}

	local function Message(Type, Text)
		local _time = os.date("*t")
string.format("%s:%s:%s", _time.hour, _time.min, _time.sec)

		print(string.format("%s | [Library]: %s", types[Type], Text))
	end

	return Message
end
end)() end,[34]=function()ImportGlobals(34)return (function(...)return function(Root)
    local Stats = Root.Services.Stats    
    local DataPing = Stats.Network.ServerStatsItem["Data Ping"]    
    return function()
        return DataPing:GetValue() / 1000    end
end
end)() end,[35]=function()ImportGlobals(35)return (function(...)return function(Root)
    local t = Root:Get("Modules/t")    
    -- // Variables
    local AddAssertion ,Hooks = t.tuple(t.string, t['function'], t['function']),{List = {}}    
    function Hooks.Add(Index, Original, Callback)
        assert(AddAssertion(Index, Original, Callback))        
        if Hooks.List[Index] then 
            Hooks.Release(Index)        end
        
        local OriginalEnv = getfenv(Original)
        local NewEnv = setmetatable({
            _STRELIZIA_ReplacementFunction = Callback,
        }, {
            __index = OriginalEnv,
            __newindex = OriginalEnv,
        })
        
        local Old = hookfunction(Original, setfenv(function(...)
            return _STRELIZIA_ReplacementFunction(...)
        end, NewEnv))
        
        Hooks.List[Index] = {Original, Old}        
        return Old 
    end
    
    function Hooks.Release(Index)
        assert(t.string(Index))        
        local Function = Hooks.List[Index]        if (not Function) then
            return false
        end 
        
        hookfunction(Function[1], Function[2])        
        Hooks.List[Index] = nil
        
        return true
    end
    
    function Hooks.Cleanup()
        for Hook in Hooks.List do
            Hooks.Release(Hook)
        end
    end
    
    return Hooks
end
end)() end,[36]=function()ImportGlobals(36)return (function(...)return function(Root)
    local Services = Root.Services    
    local VirtualUser,Players,Workspace= Services.VirtualUser
,Services.Players
,Services.Workspace
    
    -- // Variables
    local LocalPlayer ,NewRandom ,Zero ,AntiAFK = Players.LocalPlayer
,Random.new(),Vector2.zero
,{Connection = nil}    
    function AntiAFK.IsEnabled()
        return AntiAFK.Connection ~= nil
    end
    
    function AntiAFK.Enable()
        if AntiAFK.IsEnabled() then
            return true
        end
        
        AntiAFK.Connection = LocalPlayer.Idled:Connect(function(Time)
            local CurrentCamera = Workspace.CurrentCamera

            VirtualUser:Button2Down(Zero, CurrentCamera.CFrame)
            task.wait(NewRandom:NextNumber(0, 1))
            VirtualUser:Button2Up(Zero, CurrentCamera.CFrame)
        end)
        
        return true
    end
    
    function AntiAFK.Disable()
        if (not AntiAFK.IsEnabled()) then
            return true
        end
        
        AntiAFK.Connection:Disconnect()        AntiAFK.Connection = nil        
        return true
    end
    
    return AntiAFK
end
end)() end,[37]=function()ImportGlobals(37)return (function(...)return function(Root)
    local BinarySearch = {}    
    function BinarySearch.Find(Array, Target, Predicator)
        local Low, High = 1, #Array

        while Low <= High do
            local Mid = math.floor((Low + High) / 2)
            local Value = if Predicator then Predicator(Array[Mid]) else Array[Mid]

            if Value == Target then
                return Mid, Array[Mid]
            elseif Value < Target then
                Low = Mid + 1
            else
                High = Mid - 1
            end
        end

        return nil
    end

    function BinarySearch.Nearest(Array, Target, Predicator)
        local Low, High ,BestDelta ,Best= 1, #Array
,(math.huge
)
        while Low <= High do
            local Mid = math.floor((Low + High) / 2)
            local Value = if Predicator then Predicator(Array[Mid]) else Array[Mid]
            local Delta = math.abs(Value - Target)

            if Delta < BestDelta then
                Best = Mid
                BestDelta = Delta
            end

            if Value == Target then
                break
            elseif Value < Target then
                Low = Mid + 1
            else
                High = Mid - 1
            end
        end

        if Best then return Best, Array[Best] end
        return nil
    end

    return BinarySearch
end
end)() end,[38]=function()ImportGlobals(38)return (function(...)return function(Root)
    local Services = Root.Services local Players, Workspace, RunService=Services.Players, Services.Workspace, Services.RunService    
    local LocalPlayer ,CurrentConnection=(Players.LocalPlayer)    
    local function Set(State)
        local Character = LocalPlayer.Character        if (not Character) then return end
        for _, BasePart in Character:QueryDescendants("BasePart") do 
            BasePart.CanCollide = State        end
    end
    
    local Noclip = {}    
    function Noclip.Noclip()
        if CurrentConnection then
            return
        end
        
        CurrentConnection = RunService.Stepped:Connect(function()
            Set(false)        end)    end
    
    function Noclip.Clip()
        if CurrentConnection then
            CurrentConnection:Disconnect()            CurrentConnection = nil        end
        
        Set(true)    end
    
    return Noclip
end
end)() end,[39]=function()ImportGlobals(39)return (function(...)return function(Root)
local TableUtil , Time , t , char =Root:Get('RBXUtil/TableUtil'), Root:Get('Functions/Time'), Root:Get('Modules/t')
, utf8.char    local TimeConstants = Time.Constants	
	-- // Constants
	local Constants = {
        DiscordInviteCode = 'mkPHtrSyWy',
		Characters = {
			Invisible = 10240,
			BulletPoint = 8226
		},
		Emojis = {
			Unknown = '<:letter_x:1305284794044776622>',
			Person = '<:person:1305298114265219094>',
		},
        LRM_Constants = {
            Premium = LRM_IsUserPremium or false,
            DiscordUserId = LRM_LinkedDiscordID or 0,
            ScriptName = LRM_ScriptName or 'generic',
            TotalExecutions = LRM_TotalExecutions or 1337,
            SecondsLeft = LRM_SecondsLeft or 60,
            UserNote = LRM_UserNote or 'user note',
            ScriptVersion = LRM_ScriptVersion or '0001',
        },
        KeySystemAdProviders = {
            {
                Name = 'Lootlabs',
                KeyLength = TimeConstants.Hour * 12, 
                CompletionTime = TimeConstants.Minute * 2,
                Identifier = "LootLabs-buIsuhTFBCaf"
            },
            {
                Name = 'Linkvertise (premium only)',
                KeyLength = TimeConstants.Hour * 24, 
                CompletionTime = TimeConstants.Minute * 1, 
                Identifier = "Linkvertise-EsllfgSWtQqg",
            },
        },
        ProductionRoleInfo = {
developer={Color = Color3.fromRGB(2, 116, 255)},
contributor={Color = Color3.fromRGB(255, 255, 127)},
generic={Color = Color3.new(1, 1, 1)}
        }
	}
	
	for Index, Character in Constants.Characters do 
		if typeof(Character) ~= 'number' then continue end		
		Constants.Characters[Index] = char(Character)	end
	
    setmetatable(Constants.Emojis, {
        __index = function(self, Key)
    		local Unknown = rawget(self, 'Unknown')    		
            rawset(self, Key, Unknown)
            
            return Unknown
        end
    })
	
	return Constants
end
end)() end,[40]=function()local wax, script, require=ImportGlobals(40)return (function(...)local Vinca = {}Vinca.__index = Vinca
Vinca.Extensions = {
    Children = function(Script)
        local Result = {}
        for _, Child in Script:GetChildren() do
            Result[Child.Name] = Child
        end

        return Result    end,
}

local cloneref = cloneref or function(Service)
    return Service
end

Vinca.Services = setmetatable(
    {},
    {
        __index = function(self, Key)
            local Success, Service = pcall(game.GetService, game, Key)
            if Success and Service then
                Service = cloneref(Service)
                rawset(self, Key, Service)

                return Service
            end

            return nil        end,
    }
)

function Vinca.new(Root)
    local self = setmetatable({
        __vinca = true,
        Loaded = {},
        Loading = {},
        Container = {}, 
    }, Vinca)

    self.Root = Root or self
    return self end

function Vinca.is(Object)
    return Object and typeof(Object) == "table" and rawget(Object, '__vinca')end

function Vinca:Add(Index, Object)
    assert(not self.Container[Index], 'Index already exists')
    self.Container[Index] = Object

    return self 
end

function Vinca:Load(Index)
    if self.Loaded[Index] ~= nil then
        return self.Loaded[Index]
    end

    local Object = self.Container[Index]    assert(Object ~= nil, `Unknown dependency "{Index}"`)    assert(not self.Loading[Index], `Circular dependency at "{Index}"`)
    self.Loading[Index] = true
    -- wax support
    if typeof(Object) == 'table' and Object.ClassName == 'ModuleScript' then
        Object = require(Object)        -- studio support
    elseif typeof(Object) == 'Instance' and Object.ClassName == 'ModuleScript' then
        Object = require(Object)    end

    if typeof(Object) == 'function' then
        Object = Object(self.Root)    end

    self.Loading[Index] = nil    self.Loaded[Index] = Object
    return Object
end

function Vinca:Extend(Objects)
    for Name, Object in Objects do
        self:Add(Name, Object)
    end

    return self
end

function Vinca:Get(Path)
    local Current = self
    for Part in string.gmatch(Path, '[^/]+') do 
        if Vinca.is(Current) then
            Current = Current:Load(Part)
        else
            Current = Current[Part]
        end

        assert(Current ~= nil, `Invalid path "{Path}" at "{Part}"`)
    end

    return Current
end

return Vinca end)() end} -- [RefId] = Closure
,{{1,2,{"Shared"},{{27,2,{"Functions"},{{31,2,{"Strings"}},{35,2,{"Hooks"}},{32,2,{"PromptDiscord"}},{30,2,{"Numbers"}},{34,2,{"GetPing"}},{28,2,{"CreateGUID"}},{33,2,{"OutputMessage"}},{29,2,{"Time"}},{37,2,{"BinarySearch"}},{36,2,{"AntiAFK"}},{38,2,{"Noclip"}}}},{21,2,{"RBXUtil"},{{26,2,{"Trove"}},{25,2,{"Tree"}},{22,2,{"TableUtil"}},{24,2,{"Promise"}},{23,2,{"Signal"}}}},{2,2,{"Modules"},{{7,2,{"t"}},{6,2,{"Color"}},{8,2,{"Interface"},{{9,1,{"List"},{{10,1,{"Obsidian"},{{12,2,{"SaveManager"}},{13,2,{"Tabs"},{{14,2,{"Home"}},{15,2,{"Settings"}}}},{16,2,{"ThemeManager"}},{11,2,{"Main"}}}}}}}},{17,2,{"Places"},{{19,2,{"Kick a Lucky Block"}},{18,2,{"Slime RNG"}}}},{20,2,{"Preference"}},{3,2,{"TaskManager"},{{4,2,{"Task"}},{5,2,{"Lock"}}}}}},{40,2,{"Vinca"}},{39,2,{"Constants"}}}}}
,"0.4.2"
,"strelizia.cc"
,      string,task,setmetatable,error,next,table,unpack,coroutine,script,type,require,pcall,tostring,tonumber,_VERSION

local table_insert ,table_remove ,table_freeze ,coroutine_wrap ,string_sub ,string_match ,string_gmatch = table.insert
,table.remove
,table.freeze or function(t) return t end -- lol
,coroutine.wrap
,string.sub
,string.match
,string.gmatch

-- The Lune runtime has its own `task` impl, but it must be imported by its builtin
-- module path, "@lune/task"
if _VERSION and string_sub(_VERSION, 1, 4) == "Lune" then
    local RequireSuccess, LuneTaskLib = pcall(require, "@lune/task")
    if RequireSuccess and LuneTaskLib then
        task = LuneTaskLib
    end
end

local task_defer = task and task.defer

-- If we're not running on the Roblox engine, we won't have a `task` global
local Defer ,ClassNameIdBindings ,RefBindings ,ScriptClosures ,ScriptClosureRefIds ,StoredModuleValues ,ScriptsToRun ,SharedEnvironment ,RefChildren = task_defer or function(f, ...)
    coroutine_wrap(f)(...)
end
,{
    [1] = "Folder",
    [2] = "ModuleScript",
    [3] = "Script",
    [4] = "LocalScript",
    [5] = "StringValue",
}
,{} -- [RefId] = RealObject
,{}
,{} -- [ScriptClosure] = RefId
,{}
,{}
,{}
,{} -- [Ref] = {ChildrenRef, ...}

-- Implemented instance methods
local InstanceMethods ,InstanceMethodProxies = {
    GetFullName = { {}, function(self)
        local Path ,ObjectPointer = self.Name
,self.Parent

        while ObjectPointer do
            Path = ObjectPointer.Name .. "." .. Path

            -- Move up the DOM (parent will be nil at the end, and this while loop will stop)
            ObjectPointer = ObjectPointer.Parent
        end

        return Path
    end},

    GetChildren = { {}, function(self)
        local ReturnArray = {}

        for Child in next, RefChildren[self] do
            table_insert(ReturnArray, Child)
        end

        return ReturnArray
    end},

    GetDescendants = { {}, function(self)
        local ReturnArray = {}

        for Child in next, RefChildren[self] do
            table_insert(ReturnArray, Child)

            for _, Descendant in next, Child:GetDescendants() do
                table_insert(ReturnArray, Descendant)
            end
        end

        return ReturnArray
    end},

    FindFirstChild = { {"string", "boolean?"}, function(self, name, recursive)
        local Children = RefChildren[self]

        for Child in next, Children do
            if Child.Name == name then
                return Child
            end
        end

        if recursive then
            for Child in next, Children do
                -- Yeah, Roblox follows this behavior- instead of searching the entire base of a
                -- ref first, the engine uses a direct recursive call
                return Child:FindFirstChild(name, true)
            end
        end
    end},

    FindFirstAncestor = { {"string"}, function(self, name)
        local RefPointer = self.Parent
        while RefPointer do
            if RefPointer.Name == name then
                return RefPointer
            end

            RefPointer = RefPointer.Parent
        end
    end},

    -- Just to implement for traversal usage
    WaitForChild = { {"string", "number?"}, function(self, name)
        return self:FindFirstChild(name)
    end},
}
,{}
for MethodName, MethodObject in next, InstanceMethods do
    local Types ,Method ,EvaluatedTypeInfo = MethodObject[1]
,MethodObject[2]
,{}
    for ArgIndex, TypeInfo in next, Types do
        local ExpectedType, IsOptional = string_match(TypeInfo, "^([^%?]+)(%??)")
        EvaluatedTypeInfo[ArgIndex] = {ExpectedType, IsOptional}
    end

    InstanceMethodProxies[MethodName] = function(self, ...)
        if not RefChildren[self] then
            error("Expected ':' not '.' calling member function " .. MethodName, 2)
        end

        local Args = {...}
        for ArgIndex, TypeInfo in next, EvaluatedTypeInfo do
            local RealArg = Args[ArgIndex]
            local RealArgType ,ExpectedType,IsOptional = type(RealArg)
,TypeInfo[1],TypeInfo[2]

            if RealArg == nil and not IsOptional then
                error("Argument " .. RealArg .. " missing or nil", 3)
            end

            if ExpectedType ~= "any" and RealArgType ~= ExpectedType and not (RealArgType == "nil" and IsOptional) then
                error("Argument " .. ArgIndex .. " expects type \"" .. ExpectedType .. "\", got \"" .. RealArgType .. "\"", 2)
            end
        end

        return Method(self, ...)
    end
end

local function CreateRef(className, name, parent)
    -- `name` and `parent` can also be set later by the init script if they're absent

    -- Extras
    local Children ,StringValue_Value
=(setmetatable({}, {__mode = "k"})
)
    -- Err funcs
    local function InvalidMember(member)
        error(member .. " is not a valid (virtual) member of " .. className .. " \"" .. name .. "\"", 3)
    end
    local function ReadOnlyProperty(property)
        error("Unable to assign (virtual) property " .. property .. ". Property is read only", 3)
    end

    local Ref ,RefMetatable = {}
,{}

    RefMetatable.__metatable = false

    RefMetatable.__index = function(_, index)
        if index == "ClassName" then -- First check "properties"
            return className
        elseif index == "Name" then
            return name
        elseif index == "Parent" then
            return parent
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            return StringValue_Value
        else -- Lastly, check "methods"
            local InstanceMethod = InstanceMethodProxies[index]

            if InstanceMethod then
                return InstanceMethod
            end
        end

        -- Next we'll look thru child refs
        for Child in next, Children do
            if Child.Name == index then
                return Child
            end
        end

        -- At this point, no member was found; this is the same err format as Roblox
        InvalidMember(index)
    end

    RefMetatable.__newindex = function(_, index, value)
        -- __newindex is only for props fyi
        if index == "ClassName" then
            ReadOnlyProperty(index)
        elseif index == "Name" then
            name = value
        elseif index == "Parent" then
            -- We'll just ignore the process if it's trying to set itself
            if value == Ref then
                return
            end

            if parent ~= nil then
                -- Remove this ref from the CURRENT parent
                RefChildren[parent][Ref] = nil
            end

            parent = value

            if value ~= nil then
                -- And NOW we're setting the new parent
                RefChildren[value][Ref] = true
            end
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            StringValue_Value = value
        else
            -- Same err as __index when no member is found
            InvalidMember(index)
        end
    end

    RefMetatable.__tostring = function()
        return name
    end

    setmetatable(Ref, RefMetatable)

    RefChildren[Ref] = Children

    if parent ~= nil then
        RefChildren[parent][Ref] = true
    end

    return Ref
end

-- Create real ref DOM from object tree
local function CreateRefFromObject(object, parent)
    local RefId ,ClassNameId ,Properties ,Children = object[1]
,object[2]
,object[3] -- Optional
,object[4] -- Optional

    local ClassName = ClassNameIdBindings[ClassNameId]

    local Name = Properties and table_remove(Properties, 1) or ClassName

    local Ref = CreateRef(ClassName, Name, parent) -- 3rd arg may be nil if this is from root
    RefBindings[RefId] = Ref

    if Properties then
        for PropertyName, PropertyValue in next, Properties do
            Ref[PropertyName] = PropertyValue
        end
    end

    if Children then
        for _, ChildObject in next, Children do
            CreateRefFromObject(ChildObject, Ref)
        end
    end

    return Ref
end

local RealObjectRoot = CreateRef("Folder", "[" .. EnvName .. "]")
for _, Object in next, ObjectTree do
    CreateRefFromObject(Object, RealObjectRoot)
end

-- Now we'll set script closure refs and check if they should be ran as a BaseScript
for RefId, Closure in next, ClosureBindings do
    local Ref = RefBindings[RefId]

    ScriptClosures[Ref] = Closure
    ScriptClosureRefIds[Ref] = RefId

    local ClassName = Ref.ClassName
    if ClassName == "LocalScript" or ClassName == "Script" then
        table_insert(ScriptsToRun, Ref)
    end
end

local function LoadScript(scriptRef)
    local ScriptClassName ,StoredModuleValue = scriptRef.ClassName
,StoredModuleValues[scriptRef]
    if StoredModuleValue and ScriptClassName == "ModuleScript" then
        return unpack(StoredModuleValue)
    end

    local Closure = ScriptClosures[scriptRef]

    local function FormatError(originalErrorMessage)
        originalErrorMessage = tostring(originalErrorMessage)

        local VirtualFullName ,OriginalErrorLine,BaseErrorMessage = scriptRef:GetFullName()
,string_match(originalErrorMessage, "[^:]+:(%d+): (.+)")

        if not OriginalErrorLine or not LineOffsets then
            return VirtualFullName .. ":*: " .. (BaseErrorMessage or originalErrorMessage)
        end

        OriginalErrorLine = tonumber(OriginalErrorLine)

        local RefId = ScriptClosureRefIds[scriptRef]
        local LineOffset = LineOffsets[RefId]

        local RealErrorLine = OriginalErrorLine - LineOffset + 1
        if RealErrorLine < 0 then
            RealErrorLine = "?"
        end

        return VirtualFullName .. ":" .. RealErrorLine .. ": " .. BaseErrorMessage
    end

    -- If it's a BaseScript, we'll just run it directly!
    if ScriptClassName == "LocalScript" or ScriptClassName == "Script" then
        local RunSuccess, ErrorMessage = pcall(Closure)
        if not RunSuccess then
            error(FormatError(ErrorMessage), 0)
        end
    else
        local PCallReturn = {pcall(Closure)}

        local RunSuccess = table_remove(PCallReturn, 1)
        if not RunSuccess then
            local ErrorMessage = table_remove(PCallReturn, 1)
            error(FormatError(ErrorMessage), 0)
        end

        StoredModuleValues[scriptRef] = PCallReturn
        return unpack(PCallReturn)
    end
end

-- We'll assign the actual func from the top of this output for flattening user globals at runtime
-- Returns (in a tuple order): wax, script, require
function ImportGlobals(refId)
    local ScriptRef = RefBindings[refId]

    local function RealCall(f, ...)
        local PCallReturn = {pcall(f, ...)}

        local CallSuccess = table_remove(PCallReturn, 1)
        if not CallSuccess then
            error(PCallReturn[1], 3)
        end

        return unpack(PCallReturn)
    end

    -- `wax.shared` index
    local WaxShared = table_freeze(setmetatable({}, {
        __index = SharedEnvironment,
        __newindex = function(_, index, value)
            SharedEnvironment[index] = value
        end,
        __len = function()
            return #SharedEnvironment
        end,
        __iter = function()
            return next, SharedEnvironment
        end,
    }))

    local Global_wax ,Global_script = table_freeze({
        -- From AOT variable imports
        version = WaxVersion,
        envname = EnvName,

        shared = WaxShared,

        -- "Real" globals instead of the env set ones
        script = script,
        require = require,
    })
,ScriptRef

    local function Global_require(module, ...)
        local ModuleArgType ,ErrorNonModuleScript ,ErrorSelfRequire = type(module)
,"Attempted to call require with a non-ModuleScript"
,"Attempted to call require with self"

        if ModuleArgType == "table" and RefChildren[module]  then
            if module.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif module == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(module)
        elseif ModuleArgType == "string" and string_sub(module, 1, 1) ~= "@" then
            -- The control flow on this SUCKS

            if #module == 0 then
                error("Attempted to call require with empty string", 2)
            end

            local CurrentRefPointer = ScriptRef

            if string_sub(module, 1, 1) == "/" then
                CurrentRefPointer = RealObjectRoot
            elseif string_sub(module, 1, 2) == "./" then
                module = string_sub(module, 3)
            end

            local PreviousPathMatch
            for PathMatch in string_gmatch(module, "([^/]*)/?") do
                local RealIndex = PathMatch
                if PathMatch == ".." then
                    RealIndex = "Parent"
                end

                -- Don't advance dir if it's just another "/" either
                if RealIndex ~= "" then
                    local ResultRef = CurrentRefPointer:FindFirstChild(RealIndex)
                    if not ResultRef then
                        local CurrentRefParent = CurrentRefPointer.Parent
                        if CurrentRefParent then
                            ResultRef = CurrentRefParent:FindFirstChild(RealIndex)
                        end
                    end

                    if ResultRef then
                        CurrentRefPointer = ResultRef
                    elseif PathMatch ~= PreviousPathMatch and PathMatch ~= "init" and PathMatch ~= "init.server" and PathMatch ~= "init.client" then
                        error("Virtual script path \"" .. module .. "\" not found", 2)
                    end
                end

                -- For possible checks next cycle
                PreviousPathMatch = PathMatch
            end

            if CurrentRefPointer.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif CurrentRefPointer == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(CurrentRefPointer)
        end

        return RealCall(require, module, ...)
    end

    -- Now, return flattened globals ready for direct runtime exec
    return Global_wax, Global_script, Global_require
end

for _, ScriptRef in next, ScriptsToRun do
    Defer(LoadScript, ScriptRef)
end

-- AoT adjustment: Load init module (MainModule behavior)
return LoadScript(RealObjectRoot:GetChildren()[1])
