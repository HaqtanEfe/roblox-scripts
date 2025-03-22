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

local reset = 1

local ds = dataStoreService:GetDataStore("UniformDatastore"..reset)

local saveData = {}

local civilUniforms  = {}

--default data

local defaultData = {
	["Uniform"]            = "Army",
	["SoftCaps"]           = "None",
	["Helmets"]            = "None",
	["Webbings"]           = "None",
	["Cufftitle"]          = "None",
	["HelmetCosmetics"]    = "None",
	["FacialCosmetics"]    = "None",
	["Hair"]               = "None",
}

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		wait(3)
		
		civilUniforms[player.Name] = {
			Pants  = char:FindFirstChildWhichIsA("Pants").PantsTemplate,
			Shirt  = char:FindFirstChildWhichIsA("Shirt").ShirtTemplate,
		}
		
		local playerData = saveData[player.Name]
		
		local folder = Instance.new("Folder",game.ReplicatedStorage.NoneAccesories)
		folder.Name = player.Name
		
		for i, accesory : Accessory in char:GetChildren() do
			if accesory:IsA("Accessory") then
				local type = accesory.AccessoryType
				local typeName = type.Name
				
				if not folder:FindFirstChild(typeName) then
					local f = Instance.new("Folder",folder)
					f.Name = typeName
				end
				
				accesory:Clone().Parent = folder:FindFirstChild(typeName)
			end
		end
		
		for category, name in playerData do
			if category == "Uniform" then
				--Use uniform
				if name ~= "Civil" then
					local folder = game.ReplicatedStorage.Uniforms.Uniform:FindFirstChild(name)
					local shirt = folder:FindFirstChildWhichIsA("Shirt"):Clone()
					local pants = folder:FindFirstChildWhichIsA("Pants"):Clone()

					if folder:FindFirstChildWhichIsA("Accessory") then
						local a = 0
						for i, v in folder:GetChildren() do
							if v:IsA("Accessory") then
								local clone = v:Clone()
								clone.Name = "OutfitAccesorry"..a
								clone.Parent = char
								char:FindFirstChildWhichIsA("Humanoid"):AddAccessory(clone)
								
							end
						end
					end
					
					char:FindFirstChildWhichIsA("Shirt"):Destroy()
					shirt.Parent = char
					
					char:FindFirstChildWhichIsA("Pants"):Destroy()
					pants.Parent = char
				else
					local shirt = Instance.new("Shirt")
					shirt.ShirtTemplate = civilUniforms[player.Name]["Shirt"]
					local pants = Instance.new("Pants")
					pants.PantsTemplate = civilUniforms[player.Name]["Pants"]
					
					char:FindFirstChildWhichIsA("Shirt"):Destroy()
					shirt.Parent = char

					char:FindFirstChildWhichIsA("Pants"):Destroy()
					pants.Parent = char
				end
			else
				if name ~= "None" then
					
				end
			end
		end
	end)
	
	saveData[player.Name] = ds:GetAsync(player.UserId) or defaultData
end)

game.Players.PlayerRemoving:Connect(function(player)
	ds:SetAsync(player.UserId,saveData[player.Name])
	saveData[player.Name] = nil
end)

game.ReplicatedStorage.Remotes.Events.equipAccesory.OnServerEvent:Connect(function(player,category,name)
	print(name)

	local char = player.Character
	if name == "None" then

		if char:FindFirstChild(category) then
			char:FindFirstChild(category):Destroy()
		end
		
		--for i, v in char:GetChildren() do
		--	if v:IsA("Accessory") then
		--		v:Destroy()
		--	end
		--end
		
		--[[
		for i, v in game.ReplicatedStorage.NoneAccesories:FindFirstChild(player.Name):GetDescendants() do
			if v:IsA("Accessory") then
				local accesory = v:Clone()
				accesory.Parent = char
				char:FindFirstChildWhichIsA("Humanoid"):AddAccessory(accesory)
			end
		end
		]]
		
		saveData[player.Name][category] = "None"
		return
	end
	local accesory = game.ReplicatedStorage.Uniforms:FindFirstChild(category):FindFirstChild(name):Clone()
	
	if char:FindFirstChild(category) then
		char:FindFirstChild(category):Destroy()
	end
	
	if category == "Helmets" or category == "SoftCaps" then
		saveData[player.Name]["Helmets"] = "None"
		saveData[player.Name]["SoftCaps"] = "None"
		for i, v in char:GetChildren() do
			if v:IsA("Accessory") then
				if v.AccessoryType == Enum.AccessoryType.Hat then
					v:Destroy()
				end
			end
		end
	end
	
	accesory.Name = category
	char:FindFirstChildWhichIsA("Humanoid"):AddAccessory(accesory)
	saveData[player.Name][category] = name
	
	print("done")
	
	game.ReplicatedStorage.Remotes.Events.updateCharacterClone:FireClient(player)
end)

game.ReplicatedStorage.Remotes.Events.equipUniform.OnServerEvent:Connect(function(player,name)
	print(name)
	
	local char = player.Character

	if name ~= "Civil" then
		local folder = game.ReplicatedStorage.Uniforms.Uniform:FindFirstChild(name)
		local shirt = folder:FindFirstChildWhichIsA("Shirt"):Clone()
		local pants = folder:FindFirstChildWhichIsA("Pants"):Clone()

		for i, v in char:GetChildren() do
			if v.Name:split("OutfitAccesorry")[2] then
				v:Destroy()
			end
		end

		if folder:FindFirstChildWhichIsA("Accessory") then
			local a = 0
			for i, v in folder:GetChildren() do
				if v:IsA("Accessory") then
					local clone = v:Clone()
					clone.Name = "OutfitAccesorry"..a
					clone.Parent = char
					char:FindFirstChildWhichIsA("Humanoid"):AddAccessory(clone)

				end
			end
		end

		char:FindFirstChildWhichIsA("Shirt"):Destroy()
		shirt.Parent = char

		char:FindFirstChildWhichIsA("Pants"):Destroy()
		pants.Parent = char
	else
		local shirt = Instance.new("Shirt")
		shirt.ShirtTemplate = civilUniforms[player.Name]["Shirt"]
		local pants = Instance.new("Pants")
		pants.PantsTemplate = civilUniforms[player.Name]["Pants"]

		for i, v in char:GetChildren() do
			if v.Name:split("OutfitAccesorry")[2] then
				v:Destroy()
			end
		end

		char:FindFirstChildWhichIsA("Shirt"):Destroy()
		shirt.Parent = char

		char:FindFirstChildWhichIsA("Pants"):Destroy()
		pants.Parent = char
	end
	
	saveData[player.Name]["Uniform"] = name
	game.ReplicatedStorage.Remotes.Events.updateCharacterClone:FireClient(player)
end)

game.ReplicatedStorage.Remotes.Functions.getPlayerUsedUniform.OnServerInvoke = function(player)
	return saveData[player.Name]
end
