require("ReactorHandler")
require("LaserHandler")
require("InductionMatrixHandler")
require("SoundHandler")

local component = require("component")
local thread = require("thread")
local terminal = require("term")
local event = require("event")
local unicode = require("unicode")
local computer = require("computer")
local laserRedstone = component.redstone
local sides = require("sides")
local gpu = component.gpu

local inductionMatrix = component.induction_matrix
local reactor = component.reactor_logic_adapter
local laser = component.laser_amplifier

local backgroundColor = 0x444444
local foregroundColor = 0xffffff

local originalScreenWidth, originalScreenHeight = gpu.maxResolution()
local screenWidth = originalScreenWidth / 2
local screenHeight = originalScreenHeight / 2
gpu.setResolution(screenWidth, screenHeight)

local exitRequested = false
local currentTab = 0 -- [0]: Overview [1]: Ignition [2]: Fusion

--local drawBufferID = gpu.allocateBuffer(screenWidth, screenHeight)
--gpu.setActiveBuffer(drawBufferID)

function main()
  setup()
  
  while (not exitRequested) do    
    clear()
    
    drawExitButton()
    drawTabs()
    
    drawContent()
    
    os.sleep(0.2)
  end
  
  exit()
end

function setup()
  event.listen("touch", touchHandler)
end

function exit()
  event.ignore("touch", touchHandler)
  gpu.setResolution(originalScreenWidth, originalScreenHeight)
  
  computer.beep(200, 0.3)
end

function touchHandler(_, _, x, y)
  if x > 77 and y == 1 then exitRequested = true
  elseif 1 <= x and x <= 20 and y == 1 then currentTab = 0 computer.beep(1000, 0.1)
  elseif 21 <= x and x <= 40 and y == 1 then currentTab = 1 computer.beep(1000, 0.1)
  elseif 41 <= x and x <= 60 and y == 1 then currentTab = 2 computer.beep(1000, 0.1)
  elseif currentTab == 0 and y > 1 then overviewTouchHandler(x, y)
  elseif currentTab == 1 and y > 1 then ignitionTouchHandler(x, y)
  elseif currentTab == 2 and y > 1 then fusionTouchHandler(x, y)
  end
end

function overviewTouchHandler(x, y)
end

function ignitionTouchHandler(x, y)
  if screenWidth - (1 + 14) <= x and x < screenWidth - 1 and screenHeight - 3 <= y and y < screenHeight then
    if (laser.getEnergy() / laser.getMaxEnergy()) >= 0.5 then
      computer.beep(100, 0.9)
      computer.beep(2000, 0.1)
      laserRedstone.setOutput(sides.front, 15)
      laserRedstone.setOutput(sides.front, 0)
    else
      computer.beep(50, 0.2)
    end
  end
end

function fusionTouchHandler(x, y)
  if 3 <= x and x <= screenWidth - 2 and 5 <= y and y <= 7 then
    local percentage = (x - 3) / (screenWidth - (3 + 2))
    local injectionRate = math.floor(98 * percentage)
    injectionRate = injectionRate + (((injectionRate % 2) == 0) and 0 or 1)
    
    reactor.setInjectionRate(injectionRate)
    computer.beep(200 + 800 * percentage, 0.1)
  end
end

function clear()
  gpu.setForeground(foregroundColor)
  
  if currentTab == 0 then gpu.setBackground(0x0000ff)
  elseif currentTab == 1 then gpu.setBackground(0xff0000)
  elseif currentTab == 2 then gpu.setBackground(0xff00ff)
  end
  
  terminal.clear()
end

function drawExitButton()
  gpu.setForeground(0xffffff)
  gpu.setBackground(0xff0000)
  
  gpu.fill(78, 1, 3, 1, " ")
  
  terminal.setCursor(79, 1)
  print("X")
end

function drawTabs()
  drawTab(1, 20, (currentTab == 0 and 0x0000ff or 0x666666), 0xffffff, "Overview")
  drawTab(21, 20, (currentTab == 1 and 0xff0000 or 0x666666), 0xffffff, "Ignition")
  drawTab(41, 20, (currentTab == 2 and 0xff00ff or 0x666666), 0xffffff, "Fusion")
end

function drawTab(originX, width, bgcolor, fgcolor, text)
  gpu.setForeground(fgcolor)
  gpu.setBackground(bgcolor)
  
  gpu.fill(originX, 1, width, 1, " ")
  
  terminal.setCursor(originX + (width - unicode.len(text)) / 2, 1)
  print(text)
end

function drawContent()
  if currentTab == 0 then drawOverview()
  elseif currentTab == 1 then drawIgnition()
  elseif currentTab == 2 then drawFusion()
  end
end

function drawOverview()
  gpu.setBackground(0x0000ff)
  
  terminal.setCursor(2, 3)
  print(string.format("Ignited: %s", reactor.isIgnited() and "yes" or "no"))
end

function drawIgnition()
  gpu.setBackground(0xff0000)
  
  terminal.setCursor(2, 3)
  print(string.format("Laser charge: %.2f%%", laser.getEnergy() / laser.getMaxEnergy() * 100))
  
  local barMaxHeight = screenHeight - 5
  local barHeight = math.floor(barMaxHeight * (laser.getEnergy() / laser.getMaxEnergy()))
  
  terminal.setCursor(7, 5)
  print("100%")
  
  terminal.setCursor(7, 5 + barMaxHeight - 1)
  print("0%")
  
  gpu.setBackground(0x333333)
  gpu.fill(3, 5, 3, barMaxHeight, " ")
  
  gpu.setBackground((laser.getEnergy() / laser.getMaxEnergy()) >= 0.5 and 0x33aa33 or 0xaa3333)
  gpu.fill(3, 5 + (barMaxHeight - barHeight), 3, barHeight, " ")
  
  gpu.fill(screenWidth - (1 + 14), screenHeight - (3), 14, 3, " ")
  terminal.setCursor(screenWidth - (1 + 14 - 4), screenHeight - (3 - 1))
  print("Ignite")
end

function drawFusion()
  gpu.setBackground(0xff00ff)
  
  terminal.setCursor(2, 3)
  print(string.format("Injection rate: %dmb/t", reactor.getInjectionRate()))
  
  local barMaxWidth = screenWidth - 4
  local handlePosition = math.floor((barMaxWidth - 2) * (reactor.getInjectionRate() / 98))
  
  gpu.setBackground(0x333333)
  gpu.fill(3, 6, barMaxWidth, 1, " ")
  
  gpu.setBackground(0x999999)
  gpu.fill(3 + handlePosition, 5, 2, 3, " ")
end

main()
--local tMain = thread.create(main)
--thread.waitForAll({tMain})