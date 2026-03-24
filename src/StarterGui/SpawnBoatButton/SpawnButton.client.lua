local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local SpawnBoatEvent = ReplicatedStorage:WaitForChild("SpawnBoatEvent")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = script.Parent

-- Create the button on the right side
local button = Instance.new("TextButton")
button.Name = "SpawnBoatBtn"
button.Size = UDim2.new(0, 160, 0, 50)
button.Position = UDim2.new(1, -180, 0.5, -25)
button.AnchorPoint = Vector2.new(0, 0.5)
button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "Spawn Boat"
button.TextSize = 18
button.Font = Enum.Font.GothamBold
button.Parent = screenGui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

-- Stroke for border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 2
stroke.Transparency = 0.5
stroke.Parent = button

-- Cooldown
local cooldown = false

button.MouseButton1Click:Connect(function()
	if cooldown then return end
	cooldown = true

	-- Visual feedback
	button.BackgroundColor3 = Color3.fromRGB(0, 80, 140)
	button.Text = "Spawning..."

	SpawnBoatEvent:FireServer()

	task.wait(3)

	button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
	button.Text = "Spawn Boat"
	cooldown = false
end)

-- Hover effects
button.MouseEnter:Connect(function()
	if not cooldown then
		button.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
	end
end)

button.MouseLeave:Connect(function()
	if not cooldown then
		button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
	end
end)
