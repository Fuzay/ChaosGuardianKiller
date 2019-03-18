local component = require("component")
local computer = require("computer")
local sides = require("sides")
local robot = component.robot
local computer = require("computer")

local distToChaos = 3000
local towerHeight = 131

local cx = 0
local cz = 0

local east = 0 --0 = east 1=south 2=west 3=north
local south = 1
local west = 2
local north = 3

local x=2776
local y=117
local z=-4
local direction = west

move = require("modules.move")
chaos = require("modules.combat")



local function checkModules()
    
    if move == nil then
        print("Module 'movementModule' could not be loaded. Please ensure that all modules are present inside 'home/modules/'")
		os.exit()
    end
	if chaos == nil then
        print("Module 'movementModule' could not be loaded. Please ensure that all modules are present inside 'home/modules/'")
		os.exit()
    end
end


local function init()
    checkModules()
	move.init(x,y,z,direction,robot,computer,sides)
	chaos.init(distToChaos,towerHeight)
	print("Localizing Chaos Guardian")
    print("Subscribe to FuzeIII") -- In case the robot does not survive, "Subscribe to FuzeIII" will be its last words of wisdom
	
	print("My pos x,y,z,dir: ",move.x(),move.y(),move.z(),move.direction())
end



init()
cx,cz = move.ToNextChaos(cx,cz,towerHeight,distToChaos)

print("starting tower killing")

chaos.killAllTower(cx,cz)


os.exit()


