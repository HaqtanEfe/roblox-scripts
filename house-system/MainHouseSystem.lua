--Note to the RoDevs staff: This is an old project, I had. It might have some problems. If you reject it and have the time to give me tips, I would love to try!
  --Note 2: This is a script inside workspace > Houses named MainHouseSystem

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

local functionsList = {}

local houseDeletingEventsFolder = Instance.new("Folder",game.ReplicatedStorage.Bindables.Events)
houseDeletingEventsFolder.Name = "houseDeletingEventsFolder"

game.Players.PlayerRemoving:Connect(function(player)
	if houseDeletingEventsFolder:FindFirstChild(player.Name) then
		houseDeletingEventsFolder:FindFirstChild(player.Name):Fire()
	end
end)

for i, house : Model in script.Parent:GetChildren() do
	if house:IsA("Model") then 
		local door = house:FindFirstChild("Door")
		local textLabel = nil
		if house:FindFirstChild("Label") then
			textLabel = house:FindFirstChild("Label"):FindFirstChild("SurfaceGui"):FindFirstChildWhichIsA("TextLabel")
		else
			textLabel = house:FindFirstChild("Mailbox"):FindFirstChild("BillboardGui"):FindFirstChildWhichIsA("TextLabel")
		end
		local teleport = house:FindFirstChild("TP")

		local owner = Instance.new("ObjectValue",house)
		owner.Name = "owner"

		local houseName = Instance.new("StringValue",house)
		houseName.Name = "houseName"
		houseName.Value = house.Name



		-- House claimed
		door.Door.ClickDetector.MouseClick:Connect(function(player : Player)
			if owner.Value == nil then
				for i, v in script.Parent:GetChildren() do
					if not v:IsA("Model") then continue end
					if v:FindFirstChild("owner").Value == player then
						return
					end
				end
				owner.Value = player
				textLabel.Text = player.Name.."'s House"
				house.Name = player.Name

				game.ReplicatedStorage.Bindables.Events.houseClaimed:Fire(player)


				-- Owner left
				if owner.Value:IsA("Player") then
					local r = Instance.new("BindableEvent",houseDeletingEventsFolder)
					r.Name = owner.Value.Name
					r.Event:Connect(function()
						print("removing")
						owner.Value = nil
						textLabel.Text = "Nobody's House"

						if door:IsA("Model") then
							door.PrimaryPart.CFrame = door:FindFirstChild("Closed").CFrame
						end

						house.Name = "unclaimed"

						local interior = workspace.Interiors:FindFirstChild(player.Name)
						if interior then
							interior:Destroy()
						end

						r:Destroy()
						print("removed")
					end)
				else
					player:Kick("You have been kicked because you experienced a bug. Please report it on our discord server with the following code. Code: ERR_PLR_DSNT_EXST")

					owner.Value = nil
					textLabel.Text = "Nobody's House"

					if door:IsA("Model") then
						door.PrimaryPart.CFrame = door:FindFirstChild("Closed").CFrame
					end

					house.Name = "unclaimed"

					local interior = workspace.Interiors:FindFirstChild(player.Name)
					if interior then
						interior:Destroy()
					end
				end
			end
		end)


		-- Teleport
		if teleport:IsA("BasePart") then
			teleport.Touched:Connect(function(hit)
				local char = hit.Parent
				if game.Players:GetPlayerFromCharacter(char) then
					local player = game.Players:GetPlayerFromCharacter(char)
					if owner.Value == player then
						char:PivotTo(workspace.Interiors:FindFirstChild(player.Name).TpTo:GetPivot())
					end
				end
			end)
		end
	end
end
