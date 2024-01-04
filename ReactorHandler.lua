-- Meta class

ReactorHandler = {component = nil,
                  proxy = nil}

-- Base class constructor

function ReactorHandler:new(address)
   instance = {}
   setmetatable(instance, self)
   self.__index = self
   
   self.component = require("component")
   self.proxy = self.component.proxy(address)
   
   return instance
end

-- Base class methods

function ReactorHandler:getAddress()
   return self.proxy.address
end

function ReactorHandler:isIgnited()
   return self.proxy.isIgnited()
end