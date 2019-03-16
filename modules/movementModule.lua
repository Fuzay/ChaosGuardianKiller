local M = {}

local energyLevelToCharge = 19000

local function setReferences(navigationModule, robotReference, computerReference, sidesReference)-- we don't need nav module anymore
    navModule = navigationModule
    robot = robotReference
    computer = computerReference
    sides = sidesReference
end

local x=0 --locals coords you can replace thoses with your's or make a function to initialize them
local y=0
local z=0
local direction = 3 --0 = east 1=south 2=west 3=north robot think he is facing north at start so put it facing north if it matter for you to be align with global axis

local function moveForward(amount) -- Move the robot a certain amount of blocks forward while updating coords
	local tmp = 0
	for i = 1,amount,1 do
		
		if i-tmp == 50 then 
			tmp = tmp + 50
			checkEnergy() -- we should be checking energy when we move to make sure that we don't run out in long moves
		end
			
		if robot.forward() == nil then 
			
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
			
		if robot.up() == nil then 
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
			
		if robot.down() == nil then 
			print("robot is stuck, insert whatever you want him to do here") 
		else
			y = y-1
		end
	end
end

local function rotateRight(amount) --rotate the robot amount time right
	for i = 1,amount,1 do
			
		robot.turnRight()
		
		direction = direction + 1
	
		if direction > 3 then
			direction = direction - 4
		end
	
	end
end

local function rotateLeft(amount)
	for i = 1,amount,1 do
			
		robot.turnLeft()
		
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

local function checkEnergy() -- Check battery, if robot is low it places a charger
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
		robot.swing(sides.front)
		moveDown(1)
		robot.swing(sides.front)
		moveUp(2)
		robot.swing(sides.front)
	end
end




M.setReferences = setReferences -- some of this might be change now
M.simpleMove = simpleMove 
M.move = move
M.rotate = rotate

return M


--Salut Fuze je te donne quelques petites fonctions permetant a ton robot de se déplacer dans l'espace tout en connaisant sa position, j'ai ajouter une fonction permettant d'aller a des coordonées précise (moveTo) cette fonction déplacera le robot aux coordonées en paramètre par rappot à ça référence ici 0 0 0 est la position ou tu le place mais tu peux modifier ça, j'éspère que ça t'aidera, ce code permet aussi de suprimer l'amélioration de navigation qui est asser mauvaise, tu auras quelque modification a faire pour que ça fonctione avec ton code car je ne sais pas comment l'intégrer correctement et que j'ai la flemme de le faire aussi :) cependant mes fonction marchent j'ai test ça :)
-- si tu souhaite me contacter: mon discord: Nicolas61x#1640
