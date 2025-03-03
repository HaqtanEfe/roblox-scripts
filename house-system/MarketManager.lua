--Note to the RoDevs staff: This is an old project, I had. It might have some problems. If you reject it and have the time to give me tips, I would love to try!
--Note 2: This is a script inside ServerScriptService named MarketManager

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

local Market = game:GetService("MarketplaceService")

local settings = require(game.ReplicatedStorage.Settings.ShopSettings)

local products = {
	[2154337339] = 10_000,
	[2154337335] = 50_000,
	[2154337338] = 100_000,
	[2154337336] = 500_000,
	[2154337333] = 1_000_000,
}

Market.PromptProductPurchaseFinished:Connect(function(userId,prodId,wasPurchased)
	if not wasPurchased then return end
	if not userId then return end
	if not prodId then return end
	
	local player = game.Players:GetPlayerByUserId(userId)
	
	local give = products[prodId]
	player:FindFirstChild("leaderstats").Coins.Value += give
end)

Market.PromptGamePassPurchaseFinished:Connect(function(player,gamepassId,wasPurchased)
	if not wasPurchased then return end
	if not player then return end
	if not gamepassId then return end

	for monitorName, price in settings["monitor Prices"] do
		if type(price) == "string" then
			if tonumber(price) == gamepassId then
				
				if not player:FindFirstChild("inventory"):FindFirstChild("monitor"):FindFirstChild(monitorName) then
					inventoryManager:createItem(player,{
						Name = monitorName,
						Type = "monitor",
						Golden = false,
						Count = 1
					})
				else
					inventoryManager:addItem(player,{
						Name = monitorName,
						Type = "monitor",
						Golden = false
					},1)
				end
			end
		end
	end

	for pcName, price in settings["pc Prices"] do
		if type(price) == "string" then
			if tonumber(price) == gamepassId then

				if not player:FindFirstChild("inventory"):FindFirstChild("pc"):FindFirstChild(pcName) then
					inventoryManager:createItem(player,{
						Name = pcName,
						Type = "pc",
						Golden = false,
						Count = 1
					})
				else
					inventoryManager:addItem(player,{
						Name = pcName,
						Type = "pc",
						Golden = false,
					},1)
				end
			end
		end
	end
	
	if gamepassId == tonumber("951848019") then
		player:FindFirstChild("leaderstats").Coins.Value += 1_000_000
	end
end)
