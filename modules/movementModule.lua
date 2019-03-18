local move = {}

local energyLevelToCharge = 19000
local x = 0
local y = 0
local z = 0
local direction = 0

local robot = nil
local computer = nil
local sides = nil

move.checkEnergy = nil

function move.init(X,Y,Z,Dir,Robot,Computer,Sides)
	
	x=X
	y=Y
	z=Z
	direction=Dir
	robot = Robot
	computer = Computer
	sides = Sides
	
	return true

end

function move.x()
	return x
end

function move.y()
	return y
end

function move.z()
	return z
end

function move.direction()
	return direction
end

function move.Forward(amount) -- Move the robot a certain amount of blocks forward while updating coords
	local tmp = 0
	for i = 1,amount,1 do
		
		if i-tmp == 50 then 
			tmp = tmp + 50
			move.checkEnergy() -- we should be checking energy when we move to make sure that we don't run out in long moves
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

function move.Up(amount) -- Move the robot a certain amount of blocks up while updating coords
	local tmp = 0
	for i = 1,amount,1 do
		
		if i-tmp == 50 then 
			tmp = tmp + 50
			move.checkEnergy() -- we should be checking energy when we move to make sure that we don't run out in long moves
		end
			
		while robot.move(sides.up) == nil do 
			print("robot might be stuck, insert whatever you want him to do here")
			robot.swing(sides.up)
		end
			y = y+1
	end
end

function move.Down(amount) -- Move the robot a certain amount of blocks down while updating coords
	local tmp = 0
	for i = 1,amount,1 do
		
		if i-tmp == 50 then 
			tmp = tmp + 50
			move.checkEnergy() -- we should be checking energy when we move to make sure that we don't run out in long moves
		end
			
		while robot.move(0) == nil do 
			print("robot might be stuck, insert whatever you want him to do here")
			robot.swing(sides.down)
		end
			y = y-1
		
	end
end

function move.turnRight(amount) --rotate the robot amount time right
	for i = 1,amount,1 do
			
		robot.turn(true)
		
		direction = direction + 1
	
		if direction > 3 then
			direction = direction - 4
		end
	
	end
end

function move.turnLeft(amount)
	for i = 1,amount,1 do
			
		robot.turn(false)
		
		direction = direction - 1
		
		if direction < 0 then
			direction = direction + 4
		end
	
	end
end

function move.rotateTo(dir)--rotate to a dir, please put a dir between 0 and 3  0 = east 1=south 2=west 3=north
	while dir ~= direction do
		move.turnRight(1)
	end
end

function move.To(pX,pY,pZ)--move robot to local coords pX pY pZ
	
	print("moving to:",pX,pY,pZ)
	print("actual coords:",x,y,z)
	
	if pX>x then 
		move.rotateTo(0)
		move.Forward(pX-x)
	else if pX<x then
			move.rotateTo(2)
			move.Forward(x-pX)
		end
	end
	
	if pY>y then
		move.Up(pY-y)
	else if pY<y then
			move.Down(y-pY)
		end
	end
	
	if pZ>z then 
		move.rotateTo(1)
		move.Forward(pZ-z)
	else if pZ<z then
			move.rotateTo(3)
			move.Forward(z-pZ)
		end
	end
		
end


function move.ToNextChaos(cx,cz,towerHeight,distToChaos)
	cx = cx+1
	move.To(x,towerHeight + 30,z)--we fly safe hight
	move.To(cx*distToChaos-100,towerHeight + 30,cz*distToChaos)
	move.To(cx*distToChaos-100,towerHeight,cz*distToChaos) -- and then go to a good y pos
	return cx,cz
end

local charger = 1
local solar = 2
local redstone = 3

move.checkEnergy = function () -- Check battery, if robot is low it places a charger
    print("Checking energy...")
	if computer.energy() < energyLevelToCharge then
        print("Placing charger")
		robot.select(charger)
		robot.place(sides.front)
		move.Up(1)
		robot.select(solar)
		robot.place(sides.front)
		move.Down(2)
		robot.select(redstone)
		robot.place(sides.front)
		move.Up(1)
		move.turnRight(1)
		move.Forward(1)
		move.turnLeft(1)
		move.Forward(1)
        print("Charging...")
		while (computer.energy() < computer.maxEnergy() - 200) do
			os.sleep(1)
            print("Charge level: " .. tostring(computer.energy()) .. "/" .. tostring(computer.maxEnergy() - 200)) -- Print charge progression.
		end
        print("Fully charged.")
		move.turnLeft(1)
		robot.select(charger)
		robot.swing(sides.front)
		move.Down(1)
		robot.select(redstone)
		robot.swing(sides.front)
		move.Up(2)
		robot.select(solar)
		robot.swing(sides.front)
		move.Down(1)
		move.turnLeft(1)
		move.Forward(1)
		move.turnRight(1)
		move.Forward(1)
		move.turnRight(1)
	end
end

return move
