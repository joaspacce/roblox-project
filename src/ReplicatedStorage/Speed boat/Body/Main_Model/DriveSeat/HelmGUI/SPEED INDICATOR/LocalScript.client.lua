-- JackOfAllBlox
-- 1 March 2019
repeat wait() until script.Parent.Parent.Parent.Name == "PlayerGui"

local SpeedLabel = script.Parent.TextLabel
local ShipVal = script.Parent.Parent:WaitForChild("Ship")
local MainModel = ShipVal.Value:FindFirstChild("Main_Model")
local Values = MainModel.Values
local MainPart = MainModel.MAIN
local EngineOnVal = Values.EngineOn

while wait(0.1) do
	if SpeedLabel and MainPart then
		local speed = math.ceil((math.floor((MainPart.Velocity).magnitude))/3) * 2	
		SpeedLabel.Text = speed.." KNOTS"
	end
end

