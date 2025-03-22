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

local settings = require(game.ReplicatedStorage.UniformSystemConfig)

local player = game.Players.LocalPlayer
local cam = workspace.CurrentCamera

local btnSound = Instance.new("Sound",script)
btnSound.SoundId = "rbxassetid://"..settings["UI Settings"].ClickSoundId

function updateWeapons()
	local savedData = game.ReplicatedStorage.Remotes.Functions.getPlayerUsedLoadout:InvokeServer()
	
	for category, toolName in savedData do
		local frame = script.Parent:FindFirstChild(category.."Frame")
		frame.ButtonFrame.Btn.Text = toolName
	end
end

function updateChoices(frameName : string)
	local frame = script.Parent:FindFirstChild(frameName)
	frameName = frameName:gsub("1","")
	frameName = frameName:gsub("2","")
	
	for i, v in frame.ButtonFrame.Choices.ScrollingFrame:GetChildren() do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	
	local categoryName = frameName:gsub("Frame","")

	local savedData = game.ReplicatedStorage.Remotes.Functions.getPlayerUsedLoadout:InvokeServer()
	
	for toolName, rankLevel in settings["Weapons Settings"].Weapons[categoryName] do
		
		local unavailable = false
		
		for category2, toolName2 in savedData do
			if toolName2 == toolName then
				unavailable = true
			end
		end
		
		local cloneBtn = script.WeaponBtn:Clone()
		cloneBtn.Text = toolName

		cloneBtn.Parent = frame.ButtonFrame.Choices.ScrollingFrame
		
		cloneBtn.Name = "ZZZZZZZZZZZZZZZZZZZZZZ"
		
		if unavailable == true then

			cloneBtn.Name = "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			
			cloneBtn.Text = toolName.." - EQUIPPED"

			cloneBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
		end
		
		if player:GetRankInGroup(settings["Weapons Settings"].GroupId) >= rankLevel and unavailable == false then
			cloneBtn.Name = toolName
			cloneBtn.BackgroundTransparency = 0.8
			cloneBtn.TextColor3 = Color3.fromRGB(255,255,255)
			
			local f = cloneBtn.MouseButton1Click:Connect(function()
				game.ReplicatedStorage.Remotes.Events.equipTool:FireServer(frame.Name:gsub("Frame",""),toolName)
				wait()
				updateChoices(frame.Name)
			end)

			cloneBtn.Destroying:Connect(function()
				f:Disconnect()
			end)
		elseif player:GetRankInGroup(settings["Weapons Settings"].GroupId) < rankLevel then
			cloneBtn:Destroy()
		end
	end
end

script.Parent.Changed:Connect(function()
	if script.Parent.Enabled == true then
		updateWeapons()
	end
end)

game.ReplicatedStorage.Remotes.Events.reloadChoosedWeapons.OnClientEvent:Connect(function()
	updateWeapons()
end)

for i, v in script.Parent:GetChildren() do
	if v:IsA("Frame") then
		v.ButtonFrame.Btn.MouseButton1Click:Connect(function()

			btnSound:Play()
			
			updateChoices(v.Name)
			
			if v.ButtonFrame.Choices.Visible == true then
				v.ButtonFrame.Choices.Visible = false
			else
				for _, v2 in script.Parent:GetChildren() do
					if v2:IsA("Frame") then
						v2.ButtonFrame.Choices.Visible = false
					end
				end

				v.ButtonFrame.Choices.Visible = true
			end
		end)
	end
end

script.Parent.DoneBtn.MouseButton1Click:Connect(function() 
	script.Parent.Enabled = false
	
	cam.CameraType = Enum.CameraType.Custom
	
	btnSound:Play()
end)
