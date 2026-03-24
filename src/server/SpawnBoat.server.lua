local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Create RemoteEvent from server (ensures it exists before client needs it)
local SpawnBoatEvent = Instance.new("RemoteEvent")
SpawnBoatEvent.Name = "SpawnBoatEvent"
SpawnBoatEvent.Parent = ReplicatedStorage

local BoatTemplate = ReplicatedStorage:WaitForChild("Speed Boat")

-- Tracking: one boat per player
local playerBoats = {}

local function getSpawnPosition()
	return CFrame.new(142.54, 32, 217.864)
end

SpawnBoatEvent.OnServerEvent:Connect(function(player)
	-- Remove previous boat if exists
	if playerBoats[player] and playerBoats[player].Parent then
		playerBoats[player]:Destroy()
	end

	local spawnCF = getSpawnPosition()

	-- Clone boat
	local boat = BoatTemplate:Clone()
	boat.Name = player.Name .. "'s Speed Boat"
	boat.Parent = workspace

	boat:PivotTo(spawnCF)

	playerBoats[player] = boat
end)

-- Clean up boat when player leaves
Players.PlayerRemoving:Connect(function(player)
	if playerBoats[player] and playerBoats[player].Parent then
		playerBoats[player]:Destroy()
	end
	playerBoats[player] = nil
end)
