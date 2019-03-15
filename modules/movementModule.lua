local M = {}

local energyLevelToCharge = 19000

local function setReferences(navigationModule, robotReference, computerReference, sidesReference)
    navModule = navigationModule
    robot = robotReference
    computer = computerReference
    sides = sidesReference
end


local function simpleMove(side, amount) -- Move the robot a certain amount of blocks (sides.left, sides.right, ...) without checking energy
	for i = 1,amount,1 do
		robot.move(side)
	end
end

local charger = 1
local solar = 2
local redstone = 3

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

local function move(side, amount) -- Move the robot a certain amount of blocks (sides.left, sides.right, ...) and perform an energy check
    checkEnergy() -- Perform energy check before moving.
	simpleMove(side, amount)
end

local function rotate(direction) -- Rotate the robot to the given direction (sides.north, side.south, ...)
	facing = tonumber(navModule.getFacing())
	print("Current facing:" .. facing)
	while facing ~= direction do
		robot.turn(true)
		facing = tonumber(navModule.getFacing())
		print("Current facing:" .. facing .. " direction: " .. direction)
	end
end

M.setReferences = setReferences
M.simpleMove = simpleMove
M.move = move
M.rotate = rotate

return M