-- JackOfAllBlox
-- 26 February 2019

repeat wait() until script.Parent.Parent == game.Players.LocalPlayer.PlayerGui -- Assures object is in PlayerGui 
---------------------------------------------------------------------
-- Services:
local TweenService = game:GetService("TweenService")
local UIP = game:GetService("UserInputService")

-- Variables:
local ShipVal = script.Parent.Ship
local MainModel = ShipVal.Value:FindFirstChild("Main_Model")
local DriveSeat = MainModel.DriveSeat
local MainPart = MainModel.MAIN
local Values = MainModel.Values
local EngineOnVal = Values.EngineOn
local ThrustVal = Values.Thrust
local InWaterVal = Values.InWater
local HornSound = MainPart.Horn
local EngineOn = false
local Steering = false
local Thrust = 0
local Neutral = false
local SteerValue = 0

-- Gui:
local ScreenGui = script.Parent
local EngineTextLabel = ScreenGui["ENGINE INDICATOR"].TextLabel
local ThrottleFrame = ScreenGui.THROTTLE
local ThrottleSlider = ThrottleFrame.SLIDER
local SteeringFrame = ScreenGui.STEERING
local TurnSlider = SteeringFrame.SLIDER

-- Tweens:
local EngineOnTween = TweenService:Create(EngineTextLabel, TweenInfo.new(0.5), {TextColor3 = Color3.fromRGB(38,207,20)})
local EngineYellowTween = TweenService:Create(EngineTextLabel, TweenInfo.new(0.5), {TextColor3 = Color3.fromRGB(255,255,0)})
local EngineOffTween = TweenService:Create(EngineTextLabel, TweenInfo.new(0.5), {TextColor3 = Color3.fromRGB(252,5,31)})
local PortTurnTween = TweenService:Create(TurnSlider,TweenInfo.new(1,Enum.EasingStyle.Linear),{Position = UDim2.new(0.349,0,0.086,0)})
local StarboardTurnTween = TweenService:Create(TurnSlider,TweenInfo.new(1,Enum.EasingStyle.Linear),{Position = UDim2.new(0.649,0,0.086,0)})
local Return0TurnTween = TweenService:Create(TurnSlider,TweenInfo.new(0.5,Enum.EasingStyle.Linear),{Position = UDim2.new(0.494,0,0.086,0)})

-- RemoteEvents
local RemoteEventsFolder = MainModel.RemoteEvents
local ToggleHookEvent = RemoteEventsFolder.ToggleHook
local ToggleEngineEvent = RemoteEventsFolder.ToggleEngine
local SteerEvent = RemoteEventsFolder.Steer
local ThrottleEvent = RemoteEventsFolder.Throttle
local ToggleSoundEvent = RemoteEventsFolder.ToggleSound
local ThrustersEvent = RemoteEventsFolder.Thrusters
---------------------------------------------------------------------

local function InitiateGui() 
	if EngineOnVal.Value == true then
		EngineOn = true
		EngineOnTween:Play()
	end
	Thrust = ThrustVal.Value
	ThrottleSlider.Position = UDim2.new(0.173,0,(0.811-Thrust*0.00714),0)
end

InitiateGui()


---------------------------------------------------------------------

UIP.InputBegan:Connect(function(input,gameProcessedEvent)
	if not gameProcessedEvent then
		if input.KeyCode == Enum.KeyCode.G then
			ToggleHookEvent:FireServer()
		elseif input.KeyCode == Enum.KeyCode.T then
			if not EngineOn and InWaterVal.Value then
				EngineYellowTween:Play()
				ToggleSoundEvent:FireServer(MainPart.StartUp, true)
				local heldDown = true
				local unPressed
				unPressed = input.Changed:Connect(function(property)
					if property == "UserInputState" then
						heldDown = false
						EngineOffTween:Play()
						ToggleSoundEvent:FireServer(MainPart.StartUp, false)
						unPressed:Disconnect()
					end
				end)
				wait(2) -- Hold key down time
				if heldDown and InWaterVal.Value then
					EngineOn = true
					unPressed:Disconnect()
					ToggleSoundEvent:FireServer(MainPart.StartUp, false)
					ToggleEngineEvent:FireServer()
				end
			elseif EngineOn then
				ToggleEngineEvent:FireServer()
			end
		elseif input.KeyCode == Enum.KeyCode.H and EngineOn then
			ToggleSoundEvent:FireServer(HornSound,true)
		elseif input.KeyCode == Enum.KeyCode.E and EngineOn then
			ThrustersEvent:FireServer(-2)
		elseif input.KeyCode == Enum.KeyCode.Q and EngineOn then
			ThrustersEvent:FireServer(2)
		end	
	end
end)

UIP.InputEnded:Connect(function(input,gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.H and EngineOn then
		ToggleSoundEvent:FireServer(HornSound,false)
	elseif input.KeyCode == Enum.KeyCode.E and EngineOn then
		ThrustersEvent:FireServer(0)
	elseif input.KeyCode == Enum.KeyCode.Q and EngineOn then
		ThrustersEvent:FireServer(0)
	end
end)


ToggleEngineEvent.OnClientEvent:Connect(function(Engine)
	EngineOn = Engine
	if EngineOn then
		EngineOnTween:Play()
		Thrust = ThrustVal.Value
	elseif not EngineOn then
		ThrottleSlider.Position = UDim2.new(0.173,0,(0.811-Thrust*0.00714),0)
		EngineOffTween:Play()
		Return0TurnTween:Play()
	end
end)

InWaterVal.Changed:Connect(function(val)
	if not val and EngineOn then
		ToggleEngineEvent:FireServer()
	end
end)


while wait() do
	if EngineOn then
		
		if DriveSeat.Steer == -1 then
			Steering = true
			SteerEvent:FireServer(-1)
			if not(SteerValue == DriveSeat.Steer) then
				Return0TurnTween:Pause()
				StarboardTurnTween:Pause()
				TurnSlider.Position = UDim2.new(0.494,0,0.086,0)
				PortTurnTween:Play()
			end
		elseif DriveSeat.Steer == 1 then
			Steering = true
			SteerEvent:FireServer(1)
			if not(SteerValue == DriveSeat.Steer) then
				Return0TurnTween:Pause()
				PortTurnTween:Pause()
				TurnSlider.Position = UDim2.new(0.494,0,0.086,0)
				StarboardTurnTween:Play()
			end
		elseif DriveSeat.Steer == 0 and Steering then
			Steering = false
			turnTweenRunning = false
			SteerEvent:FireServer(0)
			if not(SteerValue == DriveSeat.Steer) then
				StarboardTurnTween:Pause()
				PortTurnTween:Pause()
				Return0TurnTween:Play()
			end
		end
		SteerValue = DriveSeat.Steer
	
		if DriveSeat.Throttle == 1 and not Neutral then
			if Thrust < 100 then
				Thrust = Thrust + 0.5
				if Thrust == 0 then
					Neutral = true
				end
				ThrottleEvent:FireServer(Thrust)
			end
		elseif DriveSeat.Throttle == -1 and not Neutral then
			if Thrust > -20 then
				Thrust = Thrust - 0.5
				if Thrust == 0 then
					Neutral = true
				end
				ThrottleEvent:FireServer(Thrust)
			end
		elseif DriveSeat.Throttle == 0 and Neutral then
			Neutral = false
		end
		ThrottleSlider.Position = UDim2.new(0.173,0,(0.811-Thrust*0.00714),0)
	end
end









