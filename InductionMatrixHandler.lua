-- Meta class

InductionMatrixHandler = {component = nil,
                          proxy = nil}

-- Base class constructor

function InductionMatrixHandler:new(address)
  instance = {}
  setmetatable(instance, self)
  self.__index = self
  
  self.component = require("component")
  self.proxy = self.component.proxy(address)
  
  return instance
end

-- Base class methods

function InductionMatrixHandler:getAddress()
  return self.proxy.address
end

function InductionMatrixHandler:getEnergy()
  return self.proxy.getEnergy()
end

function InductionMatrixHandler:getMaxEnergy()
  return self.proxy.getMaxEnergy()
end

function InductionMatrixHandler:getInput()
  return self.proxy.getInput()
end

function InductionMatrixHandler:getOutput()
  return self.proxy.getOutput()
end

function InductionMatrixHandler:getTransferCap()
  return self.proxy.getTransferCap()
end