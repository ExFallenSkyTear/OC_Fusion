require("ReactorHandler")
require("LaserHandler")
require("InductionMatrixHandler")
require("SoundHandler")
require("Utilities")

local component = require("component")
local thread = require("thread")
local terminal = require("term")
local event = require("event")
local unicode = require("unicode")
local sides = require("sides")
local gpu = component.gpu

local reactor = ReactorHandler:new(component.reactor_logic_adapter.address)
local laser = LaserHandler:new(component.laser_amplifier.address)
local inductionMatrix = InductionMatrixHandler:new(component.induction_matrix.address)
local sound = SoundHandler:new()

local backgroundColor = 0x333333
local foregroundColor = 0xffffff
local unselectedTabColor = 0x666666

local originalScreenWidth, originalScreenHeight = gpu.maxResolution()
local screenWidth = originalScreenWidth / 2
local screenHeight = originalScreenHeight / 2
gpu.setResolution(screenWidth, screenHeight)

local exitRequested = false
local currentTab = 0 -- [0]: Overview [1]: Ignition [2]: Fusion [3]: Battery

function main()
  setup()
  
  while (not exitRequested) do    
    clear()
    
    drawExitButton()
    drawTabs()
    
    drawContent()
    
    os.sleep(0.1)
  end
  
  exit()
end

function setup()
  event.listen("touch", touchHandler)

  laser:redstoneRef(component.redstone.address, sides.front)
  laser:setThreshold(laser:getMaxEnergy() * 0.5)
end

function exit()
  event.ignore("touch", touchHandler)
  gpu.setResolution(originalScreenWidth, originalScreenHeight)
  
  sound:playExit()
end

function touchHandler(_, _, x, y)
  if isMouseOver(x, y, 78, 80, 1, 1) then exitRequested = true
  elseif isMouseOver(x, y, 1, 20, 1, 1) then if currentTab ~= 0 then currentTab = 0 sound:playChangeTab() end
  elseif isMouseOver(x, y, 21, 39, 1, 1) then if currentTab ~= 1 then currentTab = 1 sound:playChangeTab() end
  elseif isMouseOver(x, y, 40, 58, 1, 1) then if currentTab ~= 2 then currentTab = 2 sound:playChangeTab() end
  elseif isMouseOver(x, y, 59, 77, 1, 1) then if currentTab ~= 3 then currentTab = 3 sound:playChangeTab() end
  else
    if currentTab == 0 then overviewTouchHandler(x, y)
    elseif currentTab == 1 then ignitionTouchHandler(x, y)
    elseif currentTab == 2 then fusionTouchHandler(x, y)
    elseif currentTab == 3 then batteryTouchHandler(x, y)
    end
  end
end

function overviewTouchHandler(x, y)
end

function ignitionTouchHandler(x, y)
  if isMouseOver(x, y, screenWidth - (1 + 14), screenWidth - 2, screenHeight - 3, screenHeight - 1) then
    if laser:isReady() and reactor:canIgnite() then
      sound:playChangeTab()
      laser:pulse()
    else
      sound:playError()
    end
  end
end

function fusionTouchHandler(x, y)
  if isMouseOver(x, y, 3, screenWidth - 2, 5, 7) then
    local percentage = ((x - 3) / (screenWidth - (3 + 2))) * 98
    
    reactor:setInjectionRate(percentage)
  end
end

function baatteryTouchHandler(x, y)
end

function clear()
  gpu.setForeground(foregroundColor)
  gpu.setBackground(backgroundColor)
  
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
  drawTab(1, 20, (currentTab == 0 and backgroundColor or unselectedTabColor), foregroundColor, "Overview")
  drawTab(21, 19, (currentTab == 1 and backgroundColor or unselectedTabColor), foregroundColor, "Ignition")
  drawTab(40, 19, (currentTab == 2 and backgroundColor or unselectedTabColor), foregroundColor, "Fusion")
  drawTab(59, 19, (currentTab == 3 and backgroundColor or unselectedTabColor), foregroundColor, "Battery")
end

function drawTab(originX, width, bgcolor, fgcolor, text)
  gpu.setForeground(fgcolor)
  gpu.setBackground(bgcolor)
  
  gpu.fill(originX, 1, width, 1, " ")
  
  terminal.setCursor(originX + (width - unicode.len(text)) / 2, 1)
  print(text)
end

function drawContent()
  gpu.setBackground(backgroundColor)

  if currentTab == 0 then drawOverview()
  elseif currentTab == 1 then drawIgnition()
  elseif currentTab == 2 then drawFusion()
  elseif currentTab == 3 then drawBattery()
  end
end

function drawOverview()
  terminal.setCursor(2, 3)
  print(string.format("Ignited: %s", reactor:isIgnited() and "yes" or "no"))
end

function drawIgnition()
  terminal.setCursor(2, 3)
  print(string.format("Laser charge: %.2f%%", laser:getEnergyPercentage() * 100))
  
  local barMaxHeight = screenHeight - 5
  local barHeight = math.floor(barMaxHeight * laser:getEnergyPercentage())
  
  terminal.setCursor(7, 5)
  print("100%")
  
  terminal.setCursor(7, 5 + barMaxHeight - 1)
  print("0%")
  
  gpu.setBackground(0x333333)
  gpu.fill(3, 5, 3, barMaxHeight, " ")
  
  gpu.setBackground((laser:isReady() and reactor:canIgnite()) and 0x33aa33 or 0xaa3333)
  gpu.fill(3, 5 + (barMaxHeight - barHeight), 3, barHeight, " ")
  
  gpu.fill(screenWidth - (1 + 14), screenHeight - (3), 14, 3, " ")
  terminal.setCursor(screenWidth - (1 + 14 - 4), screenHeight - (3 - 1))
  print("Ignite")
end

function drawFusion()
  terminal.setCursor(2, 3)
  print(string.format("Injection rate: %dmb/t", reactor:getInjectionRate()))
  
  local barMaxWidth = screenWidth - 4
  local handlePosition = math.floor((barMaxWidth - 2) * (reactor:getInjectionRate() / 98))
  
  gpu.setBackground(0x333333)
  gpu.fill(3, 6, barMaxWidth, 1, " ")
  
  gpu.setBackground(0x999999)
  gpu.fill(3 + handlePosition, 5, 2, 3, " ")
end

function drawBattery()
end

main()
--local tMain = thread.create(main)
--thread.waitForAll({tMain})