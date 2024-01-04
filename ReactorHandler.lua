-- Meta class

Reactor = {component = nil,
           proxy = nil}

-- Base class constructor
function Reactor:new(address)
   instance = {}
   setmetatable(instance, self)
   self.__index = self
   
   self.component = require("component")
   self.proxy = self.component.proxy(address)
   
   return instance
end

-- Base class methods

function Reactor:getAddress()
   return self.proxy.address
end

-- Creating an object
--reactor = Reactor:new("xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
--print(reactor:getAddress())