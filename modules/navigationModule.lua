local component = require("component")
local computer = require("computer")
local sides = require("sides")
local robot = component.robot
local nav = component.navigation

local moveModule = nil

local M = {}

local function setMovementModule(movementModule)
    moveModule = movementModule
end

local function moveToWorldCenter()
    if z > 0 then
		print("z positive => Rotating north")
		moveModule.rotate(sides.north)
		print("Started going forward: " .. z)
		moveModule.move(sides.front, z)
	end
	if z < 0 then
		print("z negative => Rotating south")
		moveModule.rotate(sides.south)
		print("Started going forward")
		moveModule.move(sides.front, z)
	end
end
   
-- This function might be changed in the future to avoid using the navigation upgrade
local function getCoords()
    return nav.getPosition()
end

local function getFacing()
    return nav.getFacing()
end

M.setMovementModule = setMovementModule
M.moveToWorldCenter = moveToWorldCenter
M.getCoords = getCoords
M.getFacing = getFacing

return M
