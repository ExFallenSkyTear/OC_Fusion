local shell = require("shell")

local baseName = "https://raw.githubusercontent.com/ExFallenSkyTear/OC_Fusion/main/"

shell.execute("wget -f " .. baseName .. "Fusion.lua")
shell.execute("wget -f " .. baseName .. "ReactorHandler.lua")
shell.execute("wget -f " .. baseName .. "LaserHandler.lua")
shell.execute("wget -f " .. baseName .. "InductionMatrixHandler.lua")
shell.execute("wget -f " .. baseName .. "SoundHandler.lua")
shell.execute("wget -f " .. baseName .. "update.lua")