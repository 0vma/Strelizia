local thread = {
    __cache = {}, 
    close = function(self, n: string)
        if self.__cache[n] then
            pcall(coroutine.close, self.__cache[n].f)

            for _, con in pairs(self.__cache[n].connections) do
                if typeof(con) == "RBXScriptConnection" then
                    pcall(con.Disconnect, con) 
                elseif typeof(con) == "function" then 
                    pcall(con) -- // clean up function
                end 
            end 
        
            self.__cache[n] = nil
        end
    end,
    new = function(self, n: string, f: "function")
        self:close(n)

        self.__cache[n] = {f = task.spawn(f), connections = {}}

        return self.__cache[n]
    end,
    conn = function(self, thread: string, connection: any)
        if not self.__cache[thread] then
            warn("failed to create an connection, failed to find the specific thread")
            return false
        end
        
        table.insert(self.__cache[thread]['connections'], connection)

        return connection
    end,
    isalive = function(self, n: string)
        return (self.__cache[n] and true or false)
    end,
    closeall = function(self)
        for _, thread in pairs(self.__cache) do
            self:close(_)
        end
    end
}


return thread
