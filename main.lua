local component = require("component")
local computer = require("computer")
local sides = require("sides")
local robot = component.robot

local distToChaos = 3000 -- distance between each chaos guardian
local towerHeight = 131 -- height of the healer

local cx = 0 -- witch chaos we are in x and z
local cz = 0

local east = 0 --0 = east 1=south 2=west 3=north
local south = 1
local west = 2
local north = 3


---- starting position of the bot NEED TO BE SET BEFORE LAUNCHING THE CODE
local x=2776
local y=117
local z=-4
local direction = west
-----


-- Calling modules
-- PLEASE ENSURE THAT YOUR MODULES ARE NAMED IN THE SAME WAY AS ON GITHUB.
-- Like movementModule and not move,nav,combat,etc.
move = require("modules.movementModule")
chaos = require("modules.combatModule")



local function checkModules()-- checks if all files are presents
    
    if move == nil then
        print("Module 'movementModule' could not be loaded. Please ensure that all modules are present inside 'home/modules/'")
		os.exit()
    end
	if chaos == nil then
        print("Module 'movementModule' could not be loaded. Please ensure that all modules are present inside 'home/modules/'")
		os.exit()
    end
end


local function init()-- initialize all modules
    checkModules()
	move.init(x,y,z,direction,robot,computer,sides)
	chaos.init(distToChaos,towerHeight)
	print("Localizing Chaos Guardian")
    print("Subscribe to FuzeIII") -- In case the robot does not survive, "Subscribe to FuzeIII" will be its last words of wisdom
	
	print("My pos x,y,z,dir: ",move.x(),move.y(),move.z(),move.direction())
end



init()
while true do
	cx,cz = move.ToNextChaos(cx,cz,towerHeight,distToChaos) -- moving to the first island using parameters at the top

	print("starting tower killing")

	if chaos.killAllTower(cx,cz) == false then
		print("No Chaos guardian, Moving on to the next one")
	end
end

os.exit()
