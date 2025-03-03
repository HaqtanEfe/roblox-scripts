--Note to the RoDevs staff: This is an old project, I had. It might have some problems. If you reject it and have the time to give me tips, I would love to try!
--Note 2: This is a script inside ServerScriptService named HouseInteriorManager

--[[
 ___   ___  ____  ____  ____  ____  ____  ____     ____  _  _
/ __) / __)(  _ \(_  _)(  _ \(_  _)( ___)(  _ \   (  _ \( \/ )
\__ \( (__  )   / _)(_  )___/  )(   )__)  )(_) )   ) _ < \  /
(___/ \___)(_)\_)(____)(__)   (__) (____)(____/   (____/ (__) 
 _   _    _    ___ _____  _    _   _ _____ _____ _____ 
| | | |  / \  / _ \_   _|/ \  | \ | | ____|  ___| ____|
| |_| | / _ \| | | || | / _ \ |  \| |  _| | |_  |  _|  
|  _  |/ ___ \ |_| || |/ ___ \| |\  | |___|  _| | |___ 
|_| |_/_/   \_\__\_\|_/_/   \_\_| \_|_____|_|   |_____|

Contact me for any questions or errors.

Contact Details:
	Discord: haqtanefe
	Email: business@haktanefe.com
]]

local events = game.ReplicatedStorage.Bindables.Events

local n = 2000

events.houseClaimed.Event:Connect(function(player : Player)
	local playersHouse = nil
	for i, v in workspace.Houses:GetChildren() do
		if v:IsA("Model") then
			if v:FindFirstChild("owner").Value == player then
				playersHouse = v
				continue
			end
		end
	end
	
	print(playersHouse.Name)	

	if playersHouse == nil then warn("HUGE ERROR! PLAYERS HOUSE WASNT FIND! KICKING PLAYER AND ASKING FOR REPORT!") player:Kick("You have been kicked because you experienced a bug. Please report the bug with the following code on our discord server. Code: ERR_NO_HOUSE") return end
	
	local houseName = playersHouse:FindFirstChild("houseName").Value
	
	local interior = game.ReplicatedStorage.Interiors:FindFirstChild(houseName):Clone()
	interior.Parent = workspace.Interiors
	interior.Name = player.Name
	
	if interior:IsA("Model") then
		interior:MoveTo(Vector3.new(0, -50, 0))
	end
	
	local setup = game.ReplicatedStorage.Setup:Clone()
	setup.ClaimableIncomeGiver.owner.Value = player
	
	wait()
	
	setup.ClaimableIncomeGiver.Enabled = true
	setup.Parent = interior:FindFirstChild("internals")
	
	local s, r = pcall(function()
		local setupPart = interior:FindFirstChild("SetupPart")
		setup:PivotTo(setupPart:GetPivot())
		setupPart:Destroy()
	end)
	
	if not s then
		warn("BIG ERROR! PLAYERS HOUSE DOESNT INCLUDE SETUP PART! KICKING PLAYER AND ASKING FOR REPORT")
		warn(r)
		player:Kick("You have been kicked because you experienced a bug. Please report the bug in our discord server with the following code. Code: ERR_NO_SETUPPART")
	end
	
	wait(.5)
	
	setup.reloadPlayerDetails:Fire()
	
	local exitFunction
	exitFunction = interior:FindFirstChild("Teleport").Touched:Connect(function(hit)
		local char = hit.Parent
		if game.Players:GetPlayerFromCharacter(char) then
			local player = game.Players:GetPlayerFromCharacter(char)
			char = player.Character
			char:MoveTo(playersHouse.TpTo.Position)
		end
	end)
	
	interior.Destroying:Connect(function()
		exitFunction:Disconnect()
	end)
	
	print("Succesfully setup player's house.")
end)
