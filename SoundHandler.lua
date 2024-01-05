-- Meta class

SoundHandler = {computer = nil}

-- Base class constructor

function SoundHandler:new()
   instance = {}
   setmetatable(instance, self)
   self.__index = self

   self.computer = require("computer")
   
   return instance
end

-- Base class methods

function SoundHandler:playError()
   self.computer.beep(50, 0.2)
end

function SoundHandler:playChangeTab()
   self.computer.beep(1000, 0.1)
end

function SoundHandler:playExit()
   self.computer.beep(200, 0.3)
end

function SoundHandler:playIgnite()
   self.computer.beep(100, 0.9)
   self.computer.beep(2000, 0.1)
end