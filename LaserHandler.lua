-- Meta class

Laser = {component = nil,
         proxy = nil,
         redstoneProxy = nil,
         redstoneSide = nil,
         activationThreshold = 0}

-- Base class constructor

function Laser:new(address)
   instance = {}
   setmetatable(instance, self)
   self.__index = self
   
   self.component = require("component")
   self.proxy = self.component.proxy(address)
   
   return instance
end

function Laser:redstoneRef(address, side)
    self.redstoneProxy = self.component.proxy(address)
    self.redstoneSide = side
end

-- Base class methods

function Laser:getAddress()
   return self.proxy.address
end

function Laser:getEnergyPercentage()
    return self.getEnergy() / self.getMaxEnergy()
end

function Laser:getEnergy()
    return self.proxy.getEnergy()
end

function Laser:getMaxEnergy()
    return self.proxy.getMaxEnergy()
end

function Laser:pulse()
    self.redstoneProxy.setOutput(self.redstoneSide, 15)
    self.redstoneProxy.setOutput(self.redstoneSide, 0)
end

function Laser:setThreshold(threshold)
    self.activationThreshold = threshold
end

function Laser:getThreshold()
    return self.activationThreshold
end

function Laser:isReady()
    return self.getEnergy() >= self.getThreshold()
end