--!strict
--[=[
	@class PlayerDataConstants
]=]

local PlayerDataConstants = {}

PlayerDataConstants.STORE_NAME = "PlayerData"

PlayerDataConstants.TEMPLATE = {
	Coins = 0,
	Inventory = {},
	Settings = {
		MusicEnabled = true,
	},
}

return PlayerDataConstants
