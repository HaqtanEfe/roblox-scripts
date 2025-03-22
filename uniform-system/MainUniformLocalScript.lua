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

function updateTheCharacterClone()
	if workspace.charClones:FindFirstChild(player.Name) then
		workspace.charClones:FindFirstChild(player.Name):Destroy()
	end
	local char = player.Character
	char.Archivable = true
	
	local clone = char:Clone()
	clone.Name = player.Name
	clone.Parent = workspace.charClones
	clone:PivotTo(workspace["Uniform & Weapon System"].PlayerCharacterTeleportPart:GetPivot())
	
	char.Archivable = false
end

function updateUniforms()
	local savedData = game.ReplicatedStorage.Remotes.Functions.getPlayerUsedUniform:InvokeServer()
	print("Saved data", savedData)
	
	for category, toolName in savedData do
		local frame = script.Parent:FindFirstChild(category.."Frame")
		frame.ButtonFrame.Btn.Text = toolName
	end
end

function updateChoices(frameName : string)
	local frame = script.Parent:FindFirstChild(frameName)
	
	for i, v in frame.ButtonFrame.Choices.ScrollingFrame:GetChildren() do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	
	local categoryName = frameName:gsub("Frame","")

	local savedData = game.ReplicatedStorage.Remotes.Functions.getPlayerUsedUniform:InvokeServer()
	
	local i = 0
	for _, v in settings["Uniform Settings"].Uniforms[categoryName] do
		i+=1
	end
	local size = i*0.15
	if size	> 1 then
		frame:FindFirstChild("ButtonFrame"):FindFirstChild("Choices"):FindFirstChild("ScrollingFrame").CanvasSize = UDim2.new(0,0,math.ceil(size),0)
	else
		frame:FindFirstChild("ButtonFrame"):FindFirstChild("Choices"):FindFirstChild("ScrollingFrame").CanvasSize = UDim2.new(0,0,1,0)
	end
	local eachFrameSize = 0.15/math.ceil(size)
	
	for name, rankLevel in settings["Uniform Settings"].Uniforms[categoryName] do
		local unavailable = false
		
		for category2, toolName2 in savedData do
			if category2 == categoryName and toolName2 == name then
				unavailable = true
			end
		end
		
		local cloneBtn = script.WeaponBtn:Clone()
		cloneBtn.Text = name
		
		cloneBtn.Size = UDim2.new(1,0,eachFrameSize,0)

		cloneBtn.Parent = frame.ButtonFrame.Choices.ScrollingFrame
		
		cloneBtn.Name = "ZZZZZZZZZZZZZZZZZZZZZZ"
		
		if unavailable == true then

			cloneBtn.Name = "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			
			cloneBtn.Text = name.." - EQUIPPED"

			cloneBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
		end
		
		if player:GetRankInGroup(settings["Uniform Settings"].GroupId) >= rankLevel and unavailable == false then
			cloneBtn.Name = name
			cloneBtn.BackgroundTransparency = 0.8
			cloneBtn.TextColor3 = Color3.fromRGB(255,255,255)
			
			local f = cloneBtn.MouseButton1Click:Connect(function()
				if categoryName == "Uniform" then
					game.ReplicatedStorage.Remotes.Events.equipUniform:FireServer(name)
					wait()
					updateChoices(frame.Name)
					updateUniforms()
				else
					game.ReplicatedStorage.Remotes.Events.equipAccesory:FireServer(categoryName,name)
					wait()
					updateChoices(frame.Name)
					updateUniforms()
				end
			end)
			
			cloneBtn.Destroying:Connect(function()
				f:Disconnect()
			end)
		elseif player:GetRankInGroup(settings["Uniform Settings"].GroupId) < rankLevel then
			cloneBtn:Destroy()
		end
	end
end

script.Parent.Changed:Connect(function()
	if script.Parent.Enabled == true then
		updateUniforms()
		updateTheCharacterClone()
	end
end)

game.ReplicatedStorage.Remotes.Events.reloadChoosedUniforms.OnClientEvent:Connect(function()
	updateUniforms()
end)

for i, v in script.Parent:GetChildren() do
	if v:IsA("Frame") then
		v.ButtonFrame.Btn.MouseButton1Click:Connect(function()
			
			player.Character:FindFirstChildWhichIsA("Humanoid"):UnequipTools()
			
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

game.ReplicatedStorage.Remotes.Events.updateCharacterClone.OnClientEvent:Connect(updateTheCharacterClone)
