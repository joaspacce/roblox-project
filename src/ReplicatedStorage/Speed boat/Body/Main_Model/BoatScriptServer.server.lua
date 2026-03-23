-- JackOfAllBlox
-- 24 February 2019

--[[
	NOTES:
--]]
--CONFIGS BY NeatBosun, BOSUN SHIPBUILDING INC. ------------

maxSpeed = 70				--Max speed the boat can go

upRaise = 2				--Recommended between 1 and 3 degrees for small boats
							--Less than 1 for big boats.

turnInclineAngle = 1 	--Recommended between 1 and 10 degrees for small boats
							--Less than 1 for big boats.

turnSpeed = 0.015			--How fast it turns, depending on the size, 
							--usually between 0.01 - 0.05 for small boats,
							--less than 0.01 for big boats

THRUSTERS_ENABLED = true	--Thursters true or false

-- DO NOT EDIT BELOW: --------------------------------------

--Bosun math

speedDiv = 66/maxSpeed
elevationAngle = 66/upRaise
turnAngleDiv = 66 / turnInclineAngle

-- Variables:
local boat = script.Parent.Parent
local Animations = boat.Parent.Animations
local MainModel = boat.Main_Model
local MainPart = MainModel.MAIN
local PartsModel = boat.Parts
local GearShiftSound = MainPart.GearShift
local Values = MainModel.Values
local EngineOnVal = Values.EngineOn
local ThrustVal = Values.Thrust
local InWaterVal = Values.InWater
local BoatControlActivated = true

local EngineOn = false
local ReducingSpeed = false
local Thrust = 0
local TurnAngle = 0
local neutral = false
local SideThrusterSpeed = 0

-- Remote Events:
local RemoteEventsFolder = MainModel.RemoteEvents
local ToggleHookEvent = RemoteEventsFolder.ToggleHook
local ToggleEngineEvent = RemoteEventsFolder.ToggleEngine
local SteerEvent = RemoteEventsFolder.Steer
local ThrottleEvent = RemoteEventsFolder.Throttle
local ToggleSoundEvent = RemoteEventsFolder.ToggleSound
local ThrustersEvent = RemoteEventsFolder.Thrusters

-- Body Movers:
MainPart.BodyPosition.MaxForce = Vector3.new(0,math.huge,0)
MainPart.BodyPosition.Position = Vector3.new(0,MainPart.Position.Y,0)
MainPart.BodyGyro.CFrame = MainPart.CFrame
MainPart.BodyGyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
MainPart.BodyVelocity.MaxForce = Vector3.new(math.huge,0,math.huge)
--------------------------------------

local function weldBetween(a, b, weldName)
	local weld = Instance.new("Weld", a)
	weld.Name = weldName
	weld.C0 = a.CFrame:inverse() * b.CFrame
	weld.Part0 = a
	weld.Part1 = b
end


ToggleEngineEvent.OnServerEvent:Connect(function(plr) -- Toggle Engine
	if not EngineOn and BoatControlActivated then
		EngineOn = true
		EngineOnVal.Value = true
		ToggleEngineEvent:FireClient(plr, EngineOn)
		MainPart.Main:Play()
	elseif EngineOn then
		ReducingSpeed = true
		EngineOn = false
		EngineOnVal.Value = false
		ToggleEngineEvent:FireClient(plr, EngineOn)
		if MainPart.Horn.isPlaying then
			MainPart.Horn:Pause()
		end
		MainPart.Main:Pause()
		for i = Thrust, 1, -1 do
			Thrust = Thrust - 1
			ThrustVal.Value = Thrust
			local x,y,z = MainPart.BodyGyro.CFrame:ToOrientation()
			if not(x == 0) then
				MainPart.BodyGyro.CFrame = CFrame.fromOrientation((math.abs(x)/x)*(math.rad(Thrust/10)),y,math.rad(Thrust/25))
			else
				MainPart.BodyGyro.CFrame = CFrame.fromOrientation(x,y,math.rad(Thrust/elevationAngle))
			end
			if EngineOn then
				break
			end
				wait(.05)
		end
		MainPart.BodyVelocity.Velocity = Vector3.new(0,0,0)
	end
	ReducingSpeed = false
end)


SteerEvent.OnServerEvent:Connect(function(plr, steer)
	if steer == 1 and EngineOn then
		if not ReducingSpeed then
			if Thrust >= 0 then
				TurnAngle = -turnSpeed
			elseif Thrust < 0 then
				TurnAngle = turnSpeed	
			end
		end
		local rot = CFrame.fromEulerAnglesXYZ(0,TurnAngle,0)
		MainPart.BodyGyro.CFrame = (rot*(MainPart.BodyGyro.CFrame-MainPart.BodyGyro.CFrame.p))+MainPart.BodyGyro.CFrame.p
		local x,y,z = MainPart.BodyGyro.CFrame:ToOrientation()
		MainPart.BodyGyro.CFrame = CFrame.fromOrientation(math.rad(Thrust/turnAngleDiv),y,z)
	elseif steer == -1 and EngineOn then
		if not ReducingSpeed then
			if Thrust >= 0 then
				TurnAngle = turnSpeed
			elseif Thrust < 0 then
				TurnAngle = -turnSpeed
			end
		end
		local rot = CFrame.fromEulerAnglesXYZ(0,TurnAngle,0)
		MainPart.BodyGyro.CFrame = (rot*(MainPart.BodyGyro.CFrame-MainPart.BodyGyro.CFrame.p))+MainPart.BodyGyro.CFrame.p
		local x,y,z = MainPart.BodyGyro.CFrame:ToOrientation()
		MainPart.BodyGyro.CFrame = CFrame.fromOrientation(math.rad(-Thrust/turnAngleDiv),y,z)
	elseif steer == 0 and EngineOn then
		TurnAngle = 0
		local x,y,z = MainPart.BodyGyro.CFrame:ToOrientation()
		MainPart.BodyGyro.CFrame = CFrame.fromOrientation(0,y,z)
	end
end)

ThrottleEvent.OnServerEvent:Connect(function(plr, throttle)
	if neutral then
		neutral = false
		GearShiftSound:Play()
	end
	if throttle == 0 then
		neutral = true
	end
	Thrust = throttle
	local x,y,z = MainPart.BodyGyro.CFrame:ToOrientation()
	MainPart.BodyGyro.CFrame = CFrame.fromOrientation(x,y,math.rad(Thrust/100))
	ThrustVal.Value = Thrust
end)

ToggleSoundEvent.OnServerEvent:Connect(function(plr,sound,val)
	if val then
		sound:Play()
	elseif not val then
		sound:Pause()
	end
end)

ThrustersEvent.OnServerEvent:Connect(function(plr,speed)
	if EngineOn and THRUSTERS_ENABLED then
		SideThrusterSpeed = speed
	end
end)

																																																																											print("Aerotech\nCreators: JackOfAllBlox, JagdKommandant\nEdited by: NeatBosun, Bosun Shipbuilding Inc.\nDiscord: nU8Mm3G")
while wait() do
	if EngineOn or ReducingSpeed then
		MainPart.BodyVelocity.Velocity = (MainPart.CFrame.rightVector * (Thrust/speedDiv)) + (MainPart.CFrame.lookVector * SideThrusterSpeed)
		MainPart.Main.PlaybackSpeed =  1+ math.abs(Thrust/150)
	end
end


