-- Meta class

SoundHandler = {}

-- Base class constructo

function SoundHandler:new()
   instance = {}
   setmetatable(instance, self)
   self.__index = self
   
   return instance
end

-- Base class methods

function InductionMatrix:getAddress()
end