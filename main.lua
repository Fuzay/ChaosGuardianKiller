local component = require("component")
local computer = require("computer")
local sides = require("sides")
local robot = component.robot
local computer = require("computer")
local distToChaos = 3000
local towerHeight = 131
local cx = 0
local cz = 0
local east = 0
local south = 1
local west = 2
local north = 3
local x = 2776
local y = 117
local z = -4
local direction = west
move = require("modules.movementModule")
chaos = require("modules.combatModule")

local function checkModules()
    if move == nil then
	os.exit()
    end
	
    if chaos == nil then
	os.exit()
    end
end

local function init()
    checkModules()
	move.init(x, y, z, direction, robot, computer, sides)
	chaos.init(distToChaos, towerHeight)
	print("Search for Guardian Chaos in progress....")
    print("Robot died.")
	
	print("X: ", move.x() , "Y: ", move.y(), "Z: ", move.z(), "Facing: ", move.direction())
end

init()
cx, cz = move.ToNextChaos(cx, cz, towerHeight, distToChaos)
print("The protections of Chaos Guardian are soon removed.")
chaos.killAllTower(cx, cz)
os.exit()
