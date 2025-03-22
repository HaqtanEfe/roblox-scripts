local settings = {
	["UI Settings"] = {
		["ClickSoundId"] = 6042053626,
		-- # ClickSoundId is the id of the sound that will play when a player presses a button.
	},
	["NPC Settings"] = {
		["Location"] = workspace["Uniform & Weapon System"]:WaitForChild("NPC"),
		-- # LOCATION identifies the location of the npc that allows players to change weapons / uniforms.
		-- # The npc needs to have a proximity prompt named "ProximityPrompt" inside of its humanoid root part.


		["NPC_Message"] = "HELLO THIS IS A TEXT YOU CAN CHANGE!",
		-- # This is the message that will appear when the player triggers the proximity prompt.
			["NPC_Message - ReadTime"] = 2,
			-- # Number of seconds that will past while the npc is typing the message.

		["TriggerDistance"] = 10, -- Default: 10
		-- # Distance for the proximity prompt to cancel.
	},

	["Weapons Settings"] = {
		["CameraLocation"] = workspace["Uniform & Weapon System"]:WaitForChild("NPCCameraPart"), 
		-- # The part that the camera's position and rotation will be set to when the player clicks "Weapons".

		["GroupId"] = 1,
		-- # GROUPID is the group id for the weapons.
		-- ## If you want to make some of the weapons only work if a user has a specific rank in a group
		-- use this.


		["Weapons"] = {
			["Primary"] = {
				-- # Primary guns are the main guns that the player carries.
				-- ## If you want to only allow a weapon for specific ranks in the group, type the rank
				-- next to the gun name. For example:
				-- ["Gun"] = 10,
				-- ## The example above will only allow players that have the rank 10 or above in the group
				-- ## If you want to allow everyone regardless if they are in the group or not, you can type 0

				["Gun1"] = 0,
				["Gun2"] = 1,
				["Gun3"] = 255,
			},
			["Secondary"] = {
				-- # Secondary guns are the handheld guns that the player carries.
				-- ## If you want to only allow a weapon for specific ranks in the group, type the rank
				-- next to the gun name. For example:
				-- ["Gun"] = 10,
				-- ## The example above will only allow players that have the rank 10 or above in the group
				-- ## If you want to allow everyone regardless if they are in the group or not, you can type 0

				["HandGun1"] = 0,
				["HandGun2"] = 1,
				["HandGun3"] = 255,
			},
			["Tools"] = {
				-- # Tools are the tools that the player carries.
				-- ## If you want to only allow a weapon for specific ranks in the group, type the rank
				-- next to the gun name. For example:
				-- ["Gun"] = 10,
				-- ## The example above will only allow players that have the rank 10 or above in the group
				-- ## If you want to allow everyone regardless if they are in the group or not, you can type 0

				["Tool1"] = 0,
				["Tool2"] = 1,
				["Tool3"] = 255,
			},
			["Utility"] = {
				-- # Utilities are the utilies that the player carries such as grenades.
				-- ## If you want to only allow a weapon for specific ranks in the group, type the rank
				-- next to the gun name. For example:
				-- ["Gun"] = 10,
				-- ## The example above will only allow players that have the rank 10 or above in the group
				-- ## If you want to allow everyone regardless if they are in the group or not, you can type 0

				["Utility1"] = 0,
				["Utility2"] = 0,
				["Utility3"] = 1,
				["Utility4"] = 255,
			},
		},
	},

	["Uniform Settings"] = {
		["CameraLocation"] = workspace["Uniform & Weapon System"]:WaitForChild("UniformCameraPart"), 
		-- # The part that the camera's position and rotation will be set to when the player clicks "Uniform".

		["GroupId"] = 1,
		-- # GROUPID is the group id for the uniforms.
		-- ## If you want to make some of the uniforms only work if a user has a specific rank in a group
		-- use this.
		
		["Uniforms"] = {
			["Cufftitle"] = {},
			["FacialCosmetics"] = {},
			["Hair"] = {},
			["HelmetCosmetics"] = {},
			["Helmets"] = {
				["21st Jäger Camo Helmet"] = 0,
				["51st Aufklärers Helmet"] = 0,
				["AF NCO Cap"] = 0,
				["Army Helmet"] = 0,
				["Basic Helmet"] = 0,
				["Camo M38 Goggles"] = 0,
				["Camo M38 Grass Sniper"] = 0,
				["Camo M38 Grass"] = 0,
				["Camo M38"] = 0,
				["Helmet 2"] = 0,
				["M38"] = 0
			},
			["SoftCaps"] = {
				["1st RR NCO  CC CAMO"] = 0,
				["1st RR NCO  CC"] = 0,
				["1st RR WO Cap"] = 0,
				["AF Junior Officer Cap"] = 0,
				["Airforce CC"] = 0,
				["Cap1"] = 0,
				["Enlisted Side Cap"] = 0,
				["FJ Roundle Beret"] = 0,
				["RR M43 Camo cap"] = 0,
				["RR M43 cap"] = 0,
				["RR NCO Cap"] = 0,
				["WG NCO"] = 0,
				["WG Officer"] = 0
			},
			["Uniform"] = {

				--# NOTE: "Civil" is a special uniform. It doesn't change the players shirt or pants.
				["Civil"]   = 0,
				["Army"]    = 0,
				["Manager"] = 0,
				["Cadet"] = 0,
				["Conscript"] = 0,
			},
			["Webbings"] = {}
		}
	},
}

return settings
