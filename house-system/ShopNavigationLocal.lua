--Note to the RoDevs staff: This is an old project, I had. It might have some problems. If you reject it and have the time to give me tips, I would love to try!
--Note 2: This is a script inside StarterGui > ShopNavigation named ShopNavigationLocal

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

local shopSettings = require(game.ReplicatedStorage.Settings.ShopSettings)

local player = game.Players.LocalPlayer
local events = game.ReplicatedStorage.Remotes.Events.Shop

local Market = game:GetService("MarketplaceService")

local TweenService = game:GetService("TweenService")

local cam = workspace.CurrentCamera

local max = {
	X = 4,
	Y = 3,
}

local current = {
	X = 1,
	Y = 1,
}

function updateCamera()
	local targetPart = workspace.ShopInterior.Cams:FindFirstChild(current.Y.."-"..current.X)
	local targetCFrame = targetPart.CFrame
	
	TweenService:Create(cam,TweenInfo.new(1,Enum.EasingStyle.Back,Enum.EasingDirection.Out), { CFrame = targetCFrame}):Play()
end

function updateDetails()
	local targetPart = workspace.ShopInterior.Cams:FindFirstChild(current.Y.."-"..current.X)
	local obj = targetPart.obj.Value
	
	print(obj.Parent.Name)
	
	local data = {
		Name = obj.Name,
		Type = obj.Parent.Name,
		Price = shopSettings[obj.Parent.Name.." Prices"][obj.Name]
	}

	script.Parent.BuyBtn.ImageColor3 = Color3.fromRGB(255,255,255)
	if type(data.Price) == "string" then
		if Market:UserOwnsGamePassAsync(player.UserId,data.Price) then
			print("a	")
			script.Parent.BuyBtn.ImageColor3 = Color3.fromRGB(80,80,80)
		end
		
		data.Price = Market:GetProductInfo(data.Price,Enum.InfoType.GamePass).PriceInRobux.."R"
	end
	
	script.Parent.Info.Text = "<b>Name:</b> "..data.Name.."\n<b>Type:</b> "..data.Type.."\n<b>Price:</b> "..data.Price.."$"
end

function update()
	updateDetails()
	updateCamera()
	print("done")
end

events.openUI.OnClientEvent:Connect(function()
	script.Parent.Enabled = true
	cam.CameraType = Enum.CameraType.Scriptable
	update()
end)
script.Parent.CancelBtn.MouseButton1Click:Connect(function()
	script.Parent.Enabled = false
	cam.CameraType = Enum.CameraType.Custom
	current.X = 1
	current.Y = 1
end)
script.Parent.BuyBtn.MouseButton1Click:Connect(function()
	script.Parent.Enabled = false
	cam.CameraType = Enum.CameraType.Custom
	local targetPart = workspace.ShopInterior.Cams:FindFirstChild(current.Y.."-"..current.X)
	local obj = targetPart.obj.Value
	
	events.buy:FireServer(obj.Name, obj.Parent.Name)
	
	current.X = 1
	current.Y = 1
end)





script.Parent.Right.MouseButton1Click:Connect(function()
	if current.X < max.X then
		current.X += 1
		update()
	end
end)
script.Parent.Left.MouseButton1Click:Connect(function()
	if current.X > 1 then
		current.X -= 1
		update()
	end
end)

script.Parent.Up.MouseButton1Click:Connect(function()
	if current.Y < max.Y then
		current.Y += 1
		update()
	end
end)
script.Parent.Down.MouseButton1Click:Connect(function()
	if current.Y > 1 then
		current.Y -= 1
		update()
	end
end)



