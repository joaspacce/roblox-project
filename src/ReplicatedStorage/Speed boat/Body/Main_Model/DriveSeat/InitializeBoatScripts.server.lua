-- JackOfAllBlox
-- 24 February 2019

--[[
	NOTES:
		-Duplicates GUI into PlayerGui when player occupies seat. When player exits seat, 
		GUI is removed. Also sets Ship value in GUI in order for player to be able to
		reference ship.	
--]]

-- DO NOT EDIT BELOW:

local boatControlGui = script.Parent:WaitForChild("HelmGUI")																																																																																																																						local credit = script.Parent:WaitForChild("AerotechCredit")
local seat = script.Parent

seat.ChildAdded:Connect(function(child)
	if child.Name == "SeatWeld" then
		local char = child.Part1.Parent
		local plr = game:GetService("Players"):GetPlayerFromCharacter(char) 
		if not (plr.PlayerGui:FindFirstChild("HelmGUI")) then
			local mainGuiClone = boatControlGui:Clone()
			mainGuiClone.Parent = plr.PlayerGui
			local shipVal = mainGuiClone:WaitForChild("Ship")
			shipVal.Value = script.Parent.Parent.Parent																																																																																																																								credit:Clone().Parent = plr.PlayerGui 
		end
	end
end)

seat.ChildRemoved:Connect(function(child)
	if child.Name == "SeatWeld" then
		local char = child.Part1.Parent
		local plr = game:GetService("Players"):GetPlayerFromCharacter(char)
		if plr.PlayerGui:FindFirstChild(boatControlGui.Name) then
			plr.PlayerGui:FindFirstChild(boatControlGui.Name):Destroy()
		end
		if plr.PlayerGui:FindFirstChild(credit.Name) then
			plr.PlayerGui:FindFirstChild(credit.Name):Destroy()
		end
	end
end)
