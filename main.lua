local component = require("component")
local computer = require("computer")
local sides = require("sides")
local robot = component.robot
local energyLevelToCharge = 19000


local x=0
local y=0
local z=0
local direction = 3

local checkEnergy

local function moveForward(amount) -- Move the robot a certain amount of blocks forward while updating coords
	local tmp = 0
	for i = 1,amount,1 do
		
		if i-tmp == 50 then 
			tmp = tmp + 50
			checkEnergy() -- we should be checking energy when we move to make sure that we don't run out in long moves
		end
			
		if robot.move(sides.front) == nil then 
			
		print("robot is stuck, insert whatever you want him to do here") 
		
		else if direction == 0 then -- updating his locals coords
				x = x+1
			else if direction == 1 then
					z = z+1
					else if direction == 2 then
						x = x-1
						else if direction == 3 then
							z = z-1
							
						end
					end
				end
			end
		end
	end
end

local function moveUp(amount) -- Move the robot a certain amount of blocks up while updating coords
	local tmp = 0
	for i = 1,amount,1 do
		
		if i-tmp == 50 then 
			tmp = tmp + 50
			checkEnergy() -- we should be checking energy when we move to make sure that we don't run out in long moves
		end
			
		if robot.move(sides.up) == nil then 
			print("robot is stuck, insert whatever you want him to do here")
		else
			y = y+1
		end
	end
end

local function moveDown(amount) -- Move the robot a certain amount of blocks down while updating coords
	local tmp = 0
	for i = 1,amount,1 do
		
		if i-tmp == 50 then 
			tmp = tmp + 50
			checkEnergy() -- we should be checking energy when we move to make sure that we don't run out in long moves
		end
			
		if robot.move(0) == nil then 
			print("robot is stuck, insert whatever you want him to do here") 
		else
			y = y-1
		end
	end
end

local function rotateRight(amount) --rotate the robot amount time right
	for i = 1,amount,1 do
			
		robot.turn(true)
		
		direction = direction + 1
	
		if direction > 3 then
			direction = direction - 4
		end
	
	end
end

local function rotateLeft(amount)
	for i = 1,amount,1 do
			
		robot.turn(false)
		
		direction = direction - 1
		
		if direction < 0 then
			direction = direction + 4
		end
	
	end
end

local function rotateTo(dir)--rotate to a dir, please put a dir between 0 and 3  0 = east 1=south 2=west 3=north
	while dir ~= direction do
		rotateRight(1)
	end
end

local function moveTo(pX,pY,pZ)--move robot to local coords pX pY pZ
	
	print("moving to:",pX,pY,pZ)
	print("actual coords:",x,y,z)
	
	if pX>x then 
		rotateTo(0)
		moveForward(pX-x)
	else if pX<x then
			rotateTo(2)
			moveForward(x-pX)
		end
	end
	
	if pY>y then
		moveUp(pY-y)
	else if pY<y then
			moveDown(y-pY)
		end
	end
	
	if pZ>z then 
		rotateTo(1)
		moveForward(pZ-z)
	else if pZ<z then
			rotateTo(3)
			moveForward(z-pZ)
		end
	end
		
end

local charger = 1
local solar = 2
local redstone = 3

checkEnergy = function () -- Check battery, if robot is low it places a charger
    print("Checking energy...")
	if computer.energy() < energyLevelToCharge then
        print("Placing charger")
		robot.select(charger)
		robot.place(sides.front)
		moveUp(1)
		robot.select(solar)
		robot.place(sides.front)
		moveDown(2)
		robot.select(redstone)
		robot.place(sides.front)
		moveUp(1)
		rotateRight(1)
		moveForward(1)
		rotateLeft(1)
		moveForward(1)
        print("Charging...")
		while (computer.energy() < computer.maxEnergy() - 200) do
			os.sleep(1)
            print("Charge level: " .. tostring(computer.energy()) .. "/" .. tostring(computer.maxEnergy() - 200)) -- Print charge progression.
		end
        print("Fully charged.")
		rotateLeft(1)
		robot.select(charger)
		robot.swing(sides.front)
		moveDown(1)
		robot.select(redstone)
		robot.swing(sides.front)
		moveUp(2)
		robot.select(solar)
		robot.swing(sides.front)
		moveDown(1)
		rotateLeft(1)
		moveForward(1)
		rotateRight(1)
		moveForward(1)
		rotateRight(1)
	end
end

local function init()
    
	print("Localizing Chaos Guardian")
    print("Subscribe to FuzeIII") -- In case the robot does not survive, "Subscribe to FuzeIII" will be its last words of wisdom
	
	
	moveTo(50,5,5)
	
	print("My pos x,y,z,dir: ",x,y,z,direction)
end

init()
