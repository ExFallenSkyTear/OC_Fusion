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

function ReactorHandler:setInjectionRate(rate)
   if rate > 98 then rate = 98 end
   if rate < 0 then rate = 0 end

   rate = math.floor(rate + 0.5)
   rate = rate + (((rate % 2) == 0) and 0 or 1)
   
   self.proxy.setInjectionRate(rate)
end

function ReactorHandler:getInjectionRate(rate)
   return self.proxy.getInjectionRate()
end