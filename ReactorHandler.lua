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

function ReactorHandler:canIgnite()
  return self.proxy.canIgnite()
end

function ReactorHandler:getIgnitionTemp()
  return self.proxy.getIgnitionTemp()
end

function ReactorHandler:getCaseHeat()
  return self.proxy.getCaseHeat()
end

function ReactorHandler:getMaxCaseHeat()
  return self.proxy.getMaxCaseHeat()
end

function ReactorHandler:getPlasmaHeat()
  return self.proxy.getPlasmaHeat()
end

function ReactorHandler:getMaxPlasmaHeat()
  return self.proxy.getMaxPlasmaHeat()
end

function ReactorHandler:hasFuel()
  return self.proxy.hasFuel()
end

function ReactorHandler:getFuel()
  return self.proxy.getFuel()
end

function ReactorHandler:getTritium()
  return self.proxy.getTritium()
end

function ReactorHandler:getDeuterium()
  return self.proxy.getDeuterium()
end

function ReactorHandler:getProducing()
  return self.proxy.getProducing()
end

function ReactorHandler:getSteam()
  return self.proxy.getSteam()
end

function ReactorHandler:getWater()
  return self.proxy.getWater()
end

function ReactorHandler:getEnergy()
  return self.proxy.getEnergy()
end

function ReactorHandler:getMaxEnergy()
  return self.proxy.getMaxEnergy()
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