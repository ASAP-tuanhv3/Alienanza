--!strict
--[=[
	@class CoinConstants
]=]

local CoinConstants = {
	TAG = "Coin",
	VALUES = {
		["coin-bronze"] = 1,
		["coin-silver"] = 5,
		["coin-gold"] = 10,
	},
	DEFAULT_VALUE = 1,
	REMOTE_EVENT_NAME = "CoinCollected",
}

return CoinConstants
