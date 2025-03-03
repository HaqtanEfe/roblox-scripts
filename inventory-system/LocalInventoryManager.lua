--Note to the RoDevs staff: This is an old project, I had. It might have some problems. If you reject it and have the time to give me tips, I would love to try!
--Note 2: This is a script inside StarterGui > InventoryUI named LocalInventoryManager

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
wait(1)

local Http = game:GetService("HttpService")

local equipColor = Color3.fromRGB(85, 255, 127)

local player = game.Players.LocalPlayer

local canvas = script.Parent.Canvas
local background = canvas.Container.Background

local searchBox = background.Frame.TextBox

local inventoryManager = require(game.ReplicatedStorage.Modules.InventoryManager)

local incomeSettings = require(game.ReplicatedStorage.Settings.EarningSettings)

local lastEquippedSlot = nil



function createSlot(inventoryItem : NumberValue)
	local data = inventoryManager.getDataFromItem(inventoryItem)
	
	local slot = script.Slot:Clone()
	slot.Name = 999_999_999_999_999 - incomeSettings[data.Type.."Earnings"][data.Name]
	
	slot.Slot_Name.Text = data.Name
	
	if not slot:FindFirstChild("ViewportFrame"):FindFirstChild("Camera") then
		local cam = Instance.new("Camera",slot.ViewportFrame)
		cam.CFrame = CFrame.new(0,1,3)
		cam.Focus = CFrame.new(0,0,0)
		cam.FieldOfView = 70
		
		slot.ViewportFrame.CurrentCamera = cam
	end
	
	local itemClone
	
	if data.Type == "pc" then
		itemClone = game.ReplicatedStorage:FindFirstChild("PCs"):FindFirstChild(data.Name):Clone()
	else
		itemClone = game.ReplicatedStorage:FindFirstChild("Monitors"):FindFirstChild(data.Name):Clone()
	end
	itemClone.Name = data.Type
	itemClone.Parent = slot.ViewportFrame
	
	if data.Golden then
		for i, v : BasePart in itemClone:GetChildren() do
			v.Color = Color3.fromRGB(255, 255, 127)
		end
	end
	
	
	slot.Parent = background.InventorySlots
	
	local details = Instance.new("StringValue")
	details.Name = "details"
	details.Value = Http:JSONEncode(data)
	details.Parent = slot
	
	if data.Golden then
		slot.GoldenFrame.Visible = true
	end
	
	if data.Count > 1 then
		slot.Number.Visible = true
		slot.Number.TextLabel.Text = data.Count
	end
	
	
	if player:FindFirstChild(data.Type).Value == inventoryItem then
		slot.Slot_Bg.ImageColor3 = equipColor
	end
	
	local equipFunction
	equipFunction = slot.MouseButton1Click:Connect(function()
		lastEquippedSlot = slot
		canvas.Container.UpgradeButton.Visible = false
		if data.Count >= 3 then
			canvas.Container.UpgradeButton.Visible = true
		end
		game.ReplicatedStorage.Remotes.Events.equip:FireServer(inventoryItem)
	end)
	local changedFunction = inventoryItem.Changed:Connect(update)
	slot.Destroying:Connect(function()
		equipFunction:Disconnect()
		changedFunction:Disconnect()
	end)
end





function update()
	for i, v in background.InventorySlots:GetChildren() do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	
	
	for i, item in player:FindFirstChild("inventory"):GetDescendants() do
		if item.Parent.Name == "pc" or item.Parent.Name == "monitor" then
			createSlot(item)
		end
	end
	
	lastEquippedSlot = nil
	canvas.Container.UpgradeButton.Visible = false
end

player:WaitForChild("inventory").DescendantAdded:Connect(update)
player:WaitForChild("inventory").DescendantRemoving:Connect(update)
player:FindFirstChild("pc").Changed:Connect(update)
player:FindFirstChild("monitor").Changed:Connect(update)

function updateSearchResults(searchString : string)
	searchString = searchString:lower()
	
	for i, v in background.InventorySlots:GetChildren() do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	
	
	for i, item in player:FindFirstChild("inventory"):GetDescendants() do
		if item.Name:lower():gsub(searchString,""):len() ~= item.Name:len() then
			if item.Parent.Name == "pc" or item.Parent.Name == "monitor" then
				createSlot(item)
			end
		end
	end
	
	lastEquippedSlot = nil
	canvas.Container.UpgradeButton.Visible = false
end

searchBox.Changed:Connect(function()
	if searchBox.Text == "" then
		update()
	else
		updateSearchResults(searchBox.Text)
	end
end)








canvas.Container.UpgradeButton.MouseButton1Click:Connect(function()
	if lastEquippedSlot then
		
		local jsonData = lastEquippedSlot.details.Value
		local data = Http:JSONDecode(jsonData)
		
		if data.Count < 3 then return end
		
		local inventoryItem = inventoryManager.getItemFromData(player,data)
		
		game.ReplicatedStorage.Remotes.Events.upgrade:FireServer(inventoryItem)
	end
end)

update()
