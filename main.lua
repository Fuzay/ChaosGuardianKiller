local component = require("component")
local computer = require("computer")
local sides = require("sides")
local robot = component.robot
local nav = component.navigation

print("Importing modules...")

-- Import modules
local fileUtils = require("modules.fileUtils")
local combatModule = require("modules.combatModule")
local navModule = require("modules.navigationModule")
local moveModule = require("modules.movementModule")

navModule.setMovementModule(moveModule)
moveModule.setReferences(navModule, robot, computer, sides)

-- move, simpleMove, rotate, checkEnergy are now inside the "movementModule"

local function checkModules()
    if fileUtils == nil then
        print("Module 'fileUtils' could not be loaded. Please ensure that all modules are present inside 'home/modules/'")
        os.exit()
    end
    if combatModule == nil then
        print("Module 'combatModule' could not be loaded. Please ensure that all modules are present inside 'home/modules/'")
        os.exit()
    end
    if navModule == nil then
        print("Module 'navigationModule' could not be loaded. Please ensure that all modules are present inside 'home/modules/'")
        os.exit()
    end
    if moveModule == nil then
        print("Module 'movementModule' could not be loaded. Please ensure that all modules are present inside 'home/modules/'")
    end
end

local function init()
    checkModules()
    print("Localizing Chaos Guardian")
    print("Subscribe to FuzeIII") -- In case the robot does not survive, "Subscribe to FuzeIII" will be its last words of wisdom
	x,y,z = navModule.getCoords()
	navModule.moveToWorldCenter()
	moveModule.rotate(sides.east)

	moveModule.move(sides.front, fileUtils.getNextGuardian(x))
end

init()