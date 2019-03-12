local component = require("component")
local computer = require("computer")
local sides = require("sides")
local robot = component.robot
local nav = component.navigation

local charger = 1
local solar = 2
local redstone = 3

local energyLevelToCharge = 19000

local function simpleMove(side, amount) -- Move the robot a certain amount of blocks (sides.left, sides.right, ...) without checking energy
	for i = 1,amount,1 do
		robot.move(side)
	end
end

local function checkEnergy() -- Check battery, if robot is low it places a charger
    print("Checking energy...")
	if computer.energy() < energyLevelToCharge then
        print("Placing charger")
		robot.select(charger)
		robot.place(sides.front)
		robot.move(sides.top)
		robot.select(solar)
		robot.place(sides.front)
		simpleMove(sides.bottom, 2)
		robot.select(redstone)
		robot.place(sides.front)
		robot.move(sides.top)
		robot.turn(true)
		robot.move(sides.front)
		robot.turn(false)
		robot.move(sides.front)
        print("Charging...")
		while (computer.energy() < computer.maxEnergy() - 200) do
			os.sleep(1)
            print("Charge level: " .. tostring(computer.energy()) .. "/" .. tostring(computer.maxEnergy() - 200)) -- Print charge progression.
		end
        print("Fully charged.")
		robot.turn(false)
		robot.swing(sides.front)
		robot.move(sides.bottom)
		robot.swing(sides.front)
		simpleMove(sides.top, 2)
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

local function move(side, amount) -- Move the robot a certain amount of blocks (sides.left, sides.right, ...) and perform an energy check
    checkEnergy() -- Perform energy check before moving.
	simpleMove(side, amount)
end

local function getNextGuardian(x) -- Get last visited Guardian from file
	file = io.open("guardianList", "r") -- Read mode.
	if file ~= nil then
		print("Info: Successfully opened file.")
	else
        print("File does not exist. Creating file.")
        file = io.open("guardianList", "w") -- Write mode
        file:write("1") -- Automatically creates the file
        file:close()
        file = io.open("guardianList", "r") -- Read mode.
        
        if file == nil then
            print("FATAL ERROR: Failed to create file.")
            os.exit() -- Abort
        end
    end

	content = file:read("*all")
    if (content == nil or content:len() < 1) then -- empty file
        content = "1";
    end
    
	file:close()

	lastFight = tonumber(content) * 10000 -- Last fights are saved in file as number from 1 to x (to multiply by 10 000 to get the actual guardian position)
	return (lastFight - x)
end

local function init()
    print("Localizing Chaos Guardian")
    print("Subscribe to FuzeIII") -- In case the robot does not survice, "Subscribe to FuzeIII" will be it's last words of wisdom
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