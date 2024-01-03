-- Meta class
Reactor = {address = ""}

-- Base class method new

function Reactor:new(address)
   instance = {}
   setmetatable(instance, self)
   self.__index = self
   
   self.address = address or ""
   
   return instance
end

-- Base class method printArea

function Reactor:getAddress()
   return self.address
end

-- Creating an object
--reactor = Reactor:new("xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
--print(reactor:getAddress())