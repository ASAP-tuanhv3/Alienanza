--!strict
--[=[
	@class LoadingScreenServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local Players = game:GetService("Players")

local CharacterPromiseUtils = require("CharacterPromiseUtils")
local Maid = require("Maid")
local PlayerDataClient = require("PlayerDataClient")
local Rx = require("Rx")
local ServiceBag = require("ServiceBag")

local LoadingScreenServiceClient = {}
LoadingScreenServiceClient.ServiceName = "LoadingScreenServiceClient"

export type LoadingScreenServiceClient = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
		_playerDataClient: any,
	},
	{} :: typeof({ __index = LoadingScreenServiceClient })
))

function LoadingScreenServiceClient.Init(self: LoadingScreenServiceClient, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._playerDataClient = self._serviceBag:GetService(PlayerDataClient)
end

function LoadingScreenServiceClient.PromisePlayerData(self: LoadingScreenServiceClient)
	if self._playerDataClient:GetData() then
		local Promise = require("Promise")
		return Promise.resolved(self._playerDataClient:GetData())
	end

	return Rx.toPromise(self._playerDataClient:ObserveData())
end

function LoadingScreenServiceClient.PromiseCharacter(self: LoadingScreenServiceClient)
	local localPlayer = Players.LocalPlayer
	assert(localPlayer, "No LocalPlayer")

	return CharacterPromiseUtils.promiseCharacter(localPlayer)
end

function LoadingScreenServiceClient.Destroy(self: LoadingScreenServiceClient): ()
	self._maid:DoCleaning()
end

return LoadingScreenServiceClient
