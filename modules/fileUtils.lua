local M = {}

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

M.getNextGuardian = getNextGuardian

return M
