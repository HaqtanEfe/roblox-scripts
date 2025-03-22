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

local dataStoreService = game:GetService("DataStoreService")

local reset = 3

local ds = dataStoreService:GetDataStore("LoadoutDataStore"..reset)

local saveData = {}

--default data

local defaultData = {
	["Primary"]    = "Gun1",
	["Secondary"]  = "HandGun1",
	["Tools"]      = "Tool1",
	["Utility1"]   = "Utility1",
	["Utility2"]   = "Utility2",
}

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		wait(3)
		
		local playerData = saveData[player.Name]
		for category, toolName in playerData do
			if category == "Utility1" or category == "Utility2" then category = "Utility" end
			local toolClone = game.ReplicatedStorage.Tools:FindFirstChild(category):FindFirstChild(toolName):Clone()
			toolClone.Parent = player.Backpack
			
			if category == "Primary" then
				char:FindFirstChildWhichIsA("Humanoid",true):EquipTool(toolClone)
			end
		end
	end)
	
	saveData[player.Name] = ds:GetAsync(player.UserId) or defaultData
end)

game.Players.PlayerRemoving:Connect(function(player)
	ds:SetAsync(player.UserId,saveData[player.Name])
	saveData[player.Name] = nil
end)

game.ReplicatedStorage.Remotes.Events.equipTool.OnServerEvent:Connect(function(player,category,toolName)
	print(category,toolName)
	local oldToolName = saveData[player.Name][category]
	saveData[player.Name][category] = toolName

	if player.Backpack:FindFirstChild(oldToolName) then player.Backpack:FindFirstChild(oldToolName):Destroy() end
	if player.Character:FindFirstChild(oldToolName) then player.Character:FindFirstChild(oldToolName):Destroy() end
	
	if category == "Utility1" or category == "Utility2" then category = "Utility" end
	local tool = game.ReplicatedStorage.Tools:FindFirstChild(category):FindFirstChild(toolName):Clone()
	tool.Parent = player.Backpack
	if tool then
		player.Character:FindFirstChildWhichIsA("Humanoid",true):EquipTool(tool)
	end
	
	game.ReplicatedStorage.Remotes.Events.reloadChoosedWeapons:FireClient(player)
end)

game.ReplicatedStorage.Remotes.Functions.getPlayerUsedLoadout.OnServerInvoke = function(player)
	return saveData[player.Name]
end
