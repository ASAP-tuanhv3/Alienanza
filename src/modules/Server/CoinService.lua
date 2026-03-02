--!strict
--[=[
	@class CoinService
]=]

local require = require(script.Parent.loader).load(script)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Binder = require("Binder")
local CoinConstants = require("CoinConstants")
local Maid = require("Maid")
local PlayerDataService = require("PlayerDataService")
local Remoting = require("Remoting")
local ServiceBag = require("ServiceBag")

local CoinService = {}
CoinService.ServiceName = "CoinService"

export type CoinService = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
		_coinBinder: any,
		_remoting: any,
		_playerDataService: any,
		_playerCoins: { [Player]: number },
	},
	{} :: typeof({ __index = CoinService })
))

function CoinService.Init(self: CoinService, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()
	self._playerCoins = {}

	-- Dependencies
	self._playerDataService = self._serviceBag:GetService(PlayerDataService)

	-- Binder
	self._coinBinder = self._serviceBag:GetService(Binder.new(CoinConstants.TAG, require("Coin")))

	-- Remoting
	self._remoting = self._maid:Add(Remoting.new(ReplicatedStorage, "CoinService", Remoting.Realms.SERVER))
	self._remoting:DeclareEvent(CoinConstants.REMOTE_EVENT_NAME)
end

function CoinService.Start(self: CoinService): ()
	self._coinBinder:Start()
end

function CoinService.HandleCoinCollected(self: CoinService, player: Player, value: number, position: Vector3): ()
	local currentCoins = self._playerCoins[player] or 0
	currentCoins += value
	self._playerCoins[player] = currentCoins

	-- Update player data
	self._playerDataService:PromisePlayerProfile(player):Then(function(profile: any)
		profile.Data.Coins = (profile.Data.Coins or 0) + value
	end)

	-- Notify client
	self._remoting:FireClient(CoinConstants.REMOTE_EVENT_NAME, player, {
		value = value,
		position = position,
		totalCoins = currentCoins,
	})
end

function CoinService.GetCoinBinder(self: CoinService): any
	return self._coinBinder
end

function CoinService.Destroy(self: CoinService): ()
	self._maid:DoCleaning()
end

return CoinService
