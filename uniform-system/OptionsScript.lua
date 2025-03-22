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

-- # VARIABLES

local player = game.Players.LocalPlayer

local cam = workspace.CurrentCamera

local options = script.Parent.Options

local btnSound = Instance.new("Sound",script)
btnSound.SoundId = "rbxassetid://"..settings["UI Settings"].ClickSoundId

-- # UNIFORM BUTTON



-- # WEAPONS BUTTON

function oneByOneLetters()
	local sentence = settings["NPC Settings"].NPC_Message 
	local result = ""
	
	local i = #sentence:split("")
	
	for _,v in ipairs((sentence):split("")) do 
		result = result..v..""
		script.Parent.Options.Frame.TextLabel.Text = result
		task.wait(settings["NPC Settings"]["NPC_Message - ReadTime"]/i)
	end
end

options.weaponsBtn.MouseButton1Click:Connect(function()
	script.Parent.Enabled = false
	script.Parent.Parent.WeaponUI.Enabled = true
	
	cam.CameraType = Enum.CameraType.Scriptable
	cam.CFrame = settings["Weapons Settings"].CameraLocation.CFrame
	
	btnSound:Play()
end)

-- # UNIFORM BUTTON

options.uniformBtn.MouseButton1Click:Connect(function()
	
	script.Parent.Enabled = false
	script.Parent.Parent.UniformsUI.Enabled = true
	
	cam.CameraType = Enum.CameraType.Scriptable
	cam.CFrame = settings["Uniform Settings"].CameraLocation.CFrame
	
	btnSound:Play()
end)

-- # BYE BUTTON

options.byeBtn.MouseButton1Click:Connect(function()
	
	script.Parent.Enabled = false

	btnSound:Play()
end)

--# Enable

settings["NPC Settings"].Location.HumanoidRootPart:FindFirstChildWhichIsA("ProximityPrompt").Triggered:Connect(function(player)
	if player == game.Players.LocalPlayer then
		if script.Parent.Parent.WeaponUI.Enabled == false then
			script.Parent.Enabled = true

			script.Parent.Options.Frame.TextLabel.Text = ""
			oneByOneLetters()
		end
	end
end)
