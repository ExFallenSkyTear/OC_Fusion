require("Utilities")
-- Meta class

LaserHandler = {component = nil,
                proxy = nil,
                redstoneProxy = nil,
                redstoneSide = nil,
                activationThreshold = 0}

-- Base class constructor

function LaserHandler:new(address)
  instance = {}
  setmetatable(instance, self)
  self.__index = self
  
  self.component = require("component")
  self.proxy = self.component.proxy(address)
  
  return instance
end

function LaserHandler:redstoneRef(address, side)
  self.redstoneProxy = self.component.proxy(address)
  self.redstoneSide = side
end

-- Base class methods

function LaserHandler:getAddress()
  return self.proxy.address
end

function LaserHandler:getEnergyPercentage()
  return self:getEnergy() / self:getMaxEnergy()
end

function LaserHandler:getEnergy()
  return self.proxy.getEnergy()
end

function LaserHandler:getMaxEnergy()
  return self.proxy.getMaxEnergy()
end

function LaserHandler:pulse()
  self.redstoneProxy.setOutput(self.redstoneSide, 15)
  self.redstoneProxy.setOutput(self.redstoneSide, 0)
end

function LaserHandler:setThreshold(threshold)
  self.activationThreshold = threshold
end

function LaserHandler:getThreshold()
  return self.activationThreshold
end

function LaserHandler:isReady()
  return self:getEnergy() >= self:getThreshold()
end