local component = require("component")
local computer = require("computer")
local sides = require("sides")
local robot = component.robot
local nav = component.navigation

local charger = 1
local solar = 2
local redstone = 3

local energyLevelToCharge = 19000

local function checkEnergy() -- Check battery, if robot is low it places a charger
	if computer.energy() < energyLevelToCharge then
		robot.select(charger)
		robot.place(sides.front)
		robot.move(sides.top)
		robot.select(solar)
		robot.place(sides.front)
		robot.move(sides.bottom)
		robot.move(sides.bottom)
		robot.select(redstone)
		robot.place(sides.front)
		robot.move(sides.top)
		robot.turn(true)
		robot.move(sides.front)
		robot.turn(false)
		robot.move(sides.front)
		while (computer.energy() < computer.maxEnergy() - 200) do
			os.sleep(1)
		end
		robot.turn(false)
		robot.swing(sides.front)
		robot.move(sides.bottom)
		robot.swing(sides.front)
		robot.move(sides.top)
		robot.move(sides.top)
		robot.swing(sides.front)
	end
end

local function rotate(direction) -- Rotate the robot to the given direction (sides.north, side.south, ...)
	facing = tonumber(nav.getFacing())
	print("Current facing:" .. facing)
	while facing ~= direction do
		robot.turn(true)
		facing = tonumber(nav.getFacing())
		print("Current facing:" .. facing .. " direction: " .. direction)
	end
end

local function move(side, ammount) -- Move the robot a certain ammount of blocks (sides.left, sides.right, ...)
	for i = 0,ammount,1 do
		checkEnergy()
		robot.move(side)
	end
end

local function getNextGuardian(x) -- Get last visited Guardian from file
	file = io.open("guardianList", "r")
	if file ~= nul then
		file:write("1")
	end

	content = file:read("*all")
	file:close()

	lastFight = tonumber(content) * 10000 -- Last fights are saved in file as number from 1 to x (to multiply by 10 000 to get the actual guardian position)
	return (lastFight - x)
end

local function init()
	x,y,z = nav.getPosition()
	if z > 0 then
		print("z positive => Rotating north")
		rotate(sides.north)
		print("Started going forward: " .. z)
		move(sides.front, z)
	end
	if z < 0 then
		print("z negative => Rotating south")
		rotate(sides.south)
		print("Started going forward")
		move(sides.front, z)
	end
	rotate(sides.east)

	move(sides.front, getNextGuardian(x))
end

init()