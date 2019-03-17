local component = require("component")
local computer = require("computer")
local sides = require("sides")
local robot = component.robot
local energyLevelToCharge = 19000
local distToChaos = 3000 -- on my game it's every 3000 blocks

local cx = 0 -- which chaos we are at, if cx was 1 we should go to cx * distToChaos , 131(height of first pillar) , 0
local cz = 0

local towerHeight = 131

local east = 0 --0 = east 1=south 2=west 3=north
local south = 1
local west = 2
local north = 3

local x=0 -- this is what you have to change when you place the bot
local y=0 --
local z=0 -- 
local direction = north --

local checkEnergy

local function moveForward(amount) -- Move the robot a certain amount of blocks forward while updating coords
	local tmp = 0
	for i = 1,amount,1 do
		
		if i-tmp == 50 then 
			tmp = tmp + 50
			checkEnergy() -- we should be checking energy when we move to make sure that we don't run out in long moves
		end
			
		while robot.move(sides.front) == nil do 
			
		print("robot might be stuck, insert whatever you want him to do here")
			robot.swing(sides.front)
		
		end
		if direction == 0 then -- updating his locals coords
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

local function moveUp(amount) -- Move the robot a certain amount of blocks up while updating coords
	local tmp = 0
	for i = 1,amount,1 do
		
		if i-tmp == 50 then 
			tmp = tmp + 50
			checkEnergy() -- we should be checking energy when we move to make sure that we don't run out in long moves
		end
			
		while robot.move(sides.up) == nil do 
			print("robot might be stuck, insert whatever you want him to do here")
			robot.swing(sides.up)
		end
			y = y+1
	end
end

local function moveDown(amount) -- Move the robot a certain amount of blocks down while updating coords
	local tmp = 0
	for i = 1,amount,1 do
		
		if i-tmp == 50 then 
			tmp = tmp + 50
			checkEnergy() -- we should be checking energy when we move to make sure that we don't run out in long moves
		end
			
		while robot.move(0) == nil do 
			print("robot might be stuck, insert whatever you want him to do here")
			robot.swing(sides.down)
		end
			y = y-1
		
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
	
	print("My pos x,y,z,dir: ",x,y,z,direction)
end

local function moveToNextChaos()
	cx = cx+1
	moveTo(cx*distToChaos-100,towerHeight + 30,cz*distToChaos)--we fly safe hight
	moveTo(cx*distToChaos-100,towerHeight,cz*distToChaos) -- and then go to a good y pos
end

local function killATower() -- healer can't be one shot by the draconic staff of power and can't be spam attack
	
	for i = 1,5,1 do
			
		robot.swing(sides.front)
		os.sleep(5)
	
	end
		moveUp(5)

end

local function killAllTower() -- killing all external tower of the island
	
	moveTo(cx*distToChaos-89,towerHeight+5,cz*distToChaos+21)--fly safe remember
	moveTo(cx*distToChaos-89,towerHeight,cz*distToChaos+21)
	rotateTo(east)
	killATower()
	
	
	moveTo(cx*distToChaos-71,towerHeight+5,cz*distToChaos+57)
	moveTo(cx*distToChaos-71,towerHeight,cz*distToChaos+57)
	rotateTo(east)
	killATower()
	
	moveTo(cx*distToChaos-39,towerHeight+5,cz*distToChaos+81)
	moveTo(cx*distToChaos-39,towerHeight,cz*distToChaos+81)
	rotateTo(east)
	killAToxer()
	
	moveTo(cx*distToChaos-2,towerHeight+5,cz*distToChaos+90)
	moveTo(cx*distToChaos-2,towerHeight,cz*distToChaos+90)
	rotateTo(east)
	killATower()
	
	moveTo(cx*distToChaos+37,towerHeight+5,cz*distToChaos+81)
	moveTo(cx*distToChaos+37,towerHeight,cz*distToChaos+81)
	rotateTo(east)
	killATower()
	
	moveTo(cx*distToChaos+68,towerHeight+5,cz*distToChaos+55)
	moveTo(cx*distToChaos+68,towerHeight,cz*distToChaos+55)
	rotateTo(east)
	killATower()
	
	moveTo(cx*distToChaos+85,towerHeight+5,cz*distToChaos+19)
	moveTo(cx*distToChaos+85,towerHeight,cz*distToChaos+19)
	rotateTo(east)
	killATower()
	
	moveTo(cx*distToChaos+85,towerHeight+5,cz*distToChaos-20)
	moveTo(cx*distToChaos+85,towerHeight,cz*distToChaos-20)
	rotateTo(east)
	killATower()
	
	moveTo(cx*distToChaos+70,towerHeight+5,cz*distToChaos-54)
	moveTo(cx*distToChaos+70,towerHeight,cz*distToChaos-54)
	rotateTo(north)
	killATower()
	
	moveTo(cx*distToChaos+38,towerHeight+5,cz*distToChaos-79)
	moveTo(cx*distToChaos+38,towerHeight,cz*distToChaos-79)
	rotateTo(north)
	killATower()
	
	moveTo(cx*distToChaos,towerHeight+5,cz*distToChaos-87)
	moveTo(cx*distToChaos,towerHeight,cz*distToChaos-87)
	rotateTo(north)
	killATower()
	
	moveTo(cx*distToChaos-37,towerHeight+5,cz*distToChaos-80)
	moveTo(cx*distToChaos-37,towerHeight,cz*distToChaos-80)
	rotateTo(west)
	killATower()
	
	moveTo(cx*distToChaos-68,towerHeight+5,cz*distToChaos-55)
	moveTo(cx*distToChaos-68,towerHeight,cz*distToChaos-55)
	rotateTo(west)
	killATower()
	
	moveTo(cx*distToChaos-85,towerHeight+5,cz*distToChaos-18)
	moveTo(cx*distToChaos-85,towerHeight,cz*distToChaos-18)
	rotateTo(west)
	killATower()
	

end

init()
moveToNextChaos()

print("starting tower killing")

killAllTower()


--le code fonctionne mais le problème est que le dragon casse le robot lorsque le robot essaye de casser un healer donc je me suis arreter ici en attendant que tu nous propose une facon de tuer les healers


