--Note to the RoDevs staff: This is an old project, I had. It might have some problems. If you reject it and have the time to give me tips, I would love to try!
--Note 2: This is a script inside ReplicatedStorage > Modules named LocalInventoryManager

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

local Http = game:GetService("HttpService")

local module = {}

local example = {
	itemDetails = {
		Name = "ExampleName", --or anything else
		Type = "pc", --or monitor
		Golden = false, --or true
		Count = 1
	}
}

function module:createOrAddItem(player : Player, itemDetails : {}, modifier : number)
	local name = itemDetails.Name
	local _type = itemDetails.Type
	local golden = itemDetails.Golden
	local count = itemDetails.Count

	local inventory = player:FindFirstChild("inventory")
	local inventorySection = inventory:FindFirstChild(_type)

	local alreadyExists = false

	for i, v in inventorySection:GetChildren() do
		if v.Name == name and v.golden.Value == golden then
			alreadyExists = true
			break
		end
	end

	if alreadyExists then
		return module:addItem(player,itemDetails,modifier)
	end

	--// Creation of the object.
	local numberValue = Instance.new("NumberValue",inventorySection)
	numberValue.Name = name
	numberValue.Value = count


	local goldenValue = Instance.new("BoolValue",numberValue)
	goldenValue.Name = "golden"
	goldenValue.Value = golden

	return true
end

function module:createItem(player : Player,itemDetails : {})
	local name = itemDetails.Name
	local _type = itemDetails.Type
	local golden = itemDetails.Golden
	local count = itemDetails.Count
	
	local inventory = player:FindFirstChild("inventory")
	local inventorySection = inventory:FindFirstChild(_type)
	
	--// Creation of the object.
	local numberValue = Instance.new("NumberValue")
	numberValue.Name = name
	numberValue.Value = count
	
	
	local goldenValue = Instance.new("BoolValue",numberValue)
	goldenValue.Name = "golden"
	goldenValue.Value = golden
	
	numberValue.Parent = inventorySection
	
	return true
end

function module:addItem(player : Player,itemDetails : {}, modifier : number)

	if modifier then --Force modifier to positive if it exists.
		if modifier < 0 then
			modifier *= -1
		end
	else
		modifier = 1
	end

	local name = itemDetails.Name
	local _type = itemDetails.Type
	local golden = itemDetails.Golden
	local count = itemDetails.Count


	local inventory = player:FindFirstChild("inventory")
	local inventorySection = inventory:FindFirstChild(_type)


	--// Creation of the object.
	local target = nil
	for i, numberValue : numberValue in inventorySection:GetChildren() do
		if numberValue.Name == name then
			if numberValue.golden.Value == golden then
				if target == nil then
					target = numberValue
				else
					warn("Multiple items with the same properties are present! Errors possible!")
				end
			end
		end
	end

	if target == nil then
		warn("Err! Didn't find the object. Returning false")
		return false
	end

	target.Value += modifier

	return true
end

function module:removeItem(player : Player,itemDetails : {}, modifier : number)
	
	if modifier then --Force modifier to negative if it exists.
		if modifier > 0 then
			modifier *= -1
		end
	else
		modifier = -1
	end
	
	local name = itemDetails.Name
	local _type = itemDetails.Type
	local golden = itemDetails.Golden
	local count = itemDetails.Count


	local inventory = player:FindFirstChild("inventory")
	local inventorySection = inventory:FindFirstChild(_type)


	--// Creation of the object.
	local target = nil
	for i, numberValue : numberValue in inventorySection:GetChildren() do
		if numberValue.Name == name then
			if numberValue.golden.Value == golden then
				if target == nil then
					target = numberValue
				else
					warn("Multiple items with the same properties are present! Errors possible!")
				end
			end
		end
	end
	
	if target == nil then
		warn("Err! Didn't find the object. Returning false")
		return false
	end

	if modifier*-1 >= count then
		target:Destroy()
	else
		target.Value += modifier
	end

	return true
end



function module:equipItem(player : Player, inventoryObject : NumberValue)
	local name = inventoryObject.Name
	local _type = inventoryObject.Parent.Name
	local golden = inventoryObject.golden.Value
	local count = inventoryObject.Value
	
	local inventory = player:FindFirstChild("inventory")
	local inventorySection = inventory:FindFirstChild(_type)
	
	if count > 0 then
		player:FindFirstChild(_type).Value = inventoryObject

		for i, interior in workspace.Interiors:GetChildren() do
			local setup = interior:FindFirstChild("internals"):FindFirstChild("Setup")
			local Script = setup:FindFirstChildWhichIsA("Script")
			if Script:FindFirstChild("owner").Value == player then
				setup:FindFirstChild("reloadPlayerDetails"):Fire()
			end
		end
	else
		warn("HUGE ERR! SOMETHING WENT TERRIBLY WRONG AND PLAYER HAS LESS THAN 1 OF AN OBJECT!")
		return false
	end
	
	return true
end




function module.getItemFromData(player : Player, itemDetails : {})
	local name = itemDetails.Name
	local _type = itemDetails.Type
	local golden = itemDetails.Golden
	local count = itemDetails.Count

	if player:FindFirstChild("inventory"):FindFirstChild(_type):FindFirstChild(name) then
		--Will try to find
		for i, item in player:FindFirstChild("inventory"):GetDescendants() do
			if item.Name == name and item.Parent.Name == _type and item.golden.Value == golden then
				return item
			end
		end
	else
		warn("Couldn't find it")
		return nil
	end

	return nil
end
function module.getDataFromItem(item : NumberValue)
	local name = item.Name
	local _type = item.Parent.Name
	local golden = item.golden.Value
	local count = item.Value

	return {
		Name = name,
		Type = _type,
		Golden = golden,
		Count = count
	}
end

return module
