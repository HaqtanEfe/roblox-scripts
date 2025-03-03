--Note to the RoDevs staff: This is an old project, I had. It might have some problems. If you reject it and have the time to give me tips, I would love to try!
--Note 2: This is a script inside ServerScriptService named InventoryManager

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

local inventoryManager = require(game.ReplicatedStorage.Modules.InventoryManager)

local dataStoreService = game:GetService("DataStoreService")
local ds = dataStoreService:GetDataStore("InventoryDS NEW 6")
local Http = game:GetService("HttpService")

local function compareTables(table1, table2)
	for key, value in pairs(table1) do
		if table2[key] ~= value then
			return false
		end
	end
	return true
end

local defaultData = {

	{
		Name = "Basic", --or anything else
		Type = "pc", --or monitor
		Golden = false, --or true
		Count = 1
	},

	{
		Name = "Basic", --or anything else
		Type = "monitor", --or monitor
		Golden = false, --or true
		Count = 1
	}
}

local defaultEquippedData = {
	monitor = {
		Name = "Basic", --or anything else
		Type = "monitor", --or monitor
		Golden = false, --or true
		Count = 1
	},
	pc = {
		Name = "Basic", --or anything else
		Type = "pc", --or monitor
		Golden = false, --or true
		Count = 1
	},
}

game.Players.PlayerAdded:Connect(function(player)
	local inventory = Instance.new("Folder")
	inventory.Name = "inventory"
	inventory.Parent = player
	
	local monitor = Instance.new("Folder")
	monitor.Name = "monitor"
	monitor.Parent = inventory
	
	local pc = Instance.new("Folder")
	pc.Name = "pc"
	pc.Parent = inventory


	local ownersPC = Instance.new("ObjectValue",player)
	ownersPC.Name = "pc"


	local ownersMonitor = Instance.new("ObjectValue",player)
	ownersMonitor.Name = "monitor"
	
	local savedData = ds:GetAsync(player.UserId) or defaultData
	local equipped = ds:GetAsync(player.UserId.." - equipped") or defaultEquippedData

	for i, data in savedData do
		inventoryManager:createItem(player,data)
		if compareTables(data,equipped.monitor) or compareTables(data,equipped.pc) then
			local itemInInventory = inventoryManager.getItemFromData(player,data)
			if compareTables(data,equipped.pc) then
				inventoryManager:equipItem(player,itemInInventory)
			else
				inventoryManager:equipItem(player,itemInInventory)
			end
		end
	end

end)

game.Players.PlayerRemoving:Connect(function(player)
	local dataTable = {}
	
	for i, v in player:FindFirstChild("inventory"):GetDescendants() do
		if v:IsA("NumberValue") then
			local _type = v.Parent.Name
			local _name = v.Name
			local _count = v.Value
			local _golden = v:FindFirstChild("golden").Value
			
			local thisData = {
				Name = _name,
				Type = _type,
				Golden = _golden,
				Count = _count
			}
			
			table.insert(dataTable,thisData)
		end
	end
	
	local equippedData = {
		monitor = {
			
		},
		pc = {
			
		}
	}

	equippedData.pc = inventoryManager.getDataFromItem(player:FindFirstChild("pc").Value)
	equippedData.monitor = inventoryManager.getDataFromItem(player:FindFirstChild("monitor").Value)
	
	ds:SetAsync(player.UserId,dataTable)
	ds:SetAsync(player.UserId.." - equipped",equippedData)
end)



game.ReplicatedStorage.Remotes.Events.equip.OnServerEvent:Connect(function(player, value)
	if typeof(value) == "table" then
		local value = inventoryManager.getItemFromData(player,value)
	end
	if value:IsA("NumberValue") then
		if player:IsAncestorOf(value) then
			local _type = value.Parent.Name
			
			inventoryManager:equipItem(player,value)
		end
	end
end)



game.ReplicatedStorage.Remotes.Events.upgrade.OnServerEvent:Connect(function(player,obj : NumberValue)
	
	if obj.Value < 3 then return end
	
	for i, v in player:FindFirstChild("inventory"):GetDescendants() do
		if v:IsA("NumberValue") then
			local _type = v.Parent.Name
			local _name = v.Name
			local _count = v.Value
			local _golden = v:FindFirstChild("golden").Value

			if _name == obj.Name then
				if _golden == false then
					if v.Value >= 3 then
						local itemData = {
							Name = _name,
							Type = _type,
							Golden = _golden,
							Count = _count
						}
						inventoryManager:removeItem(player,itemData,3)
						
						itemData.Golden = true
						itemData.Count = 1
						
						inventoryManager:createOrAddItem(player,itemData,1)

						local newObj = inventoryManager.getItemFromData(player,itemData)
						inventoryManager:equipItem(player,newObj)
						
						return
					end
				end
			end
		end
	end
end)
