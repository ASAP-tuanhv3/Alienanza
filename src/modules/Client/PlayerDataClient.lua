--!strict
--[=[
	@class PlayerDataClient
]=]

local require = require(script.Parent.loader).load(script)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Maid = require("Maid")
local Remoting = require("Remoting")
local Rx = require("Rx")
local ServiceBag = require("ServiceBag")
local ValueObject = require("ValueObject")

local PlayerDataClient = {}
PlayerDataClient.ServiceName = "PlayerDataClient"

export type PlayerDataClient = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
		_dataValue: any,
		_remoting: any,
	},
	{} :: typeof({ __index = PlayerDataClient })
))

function PlayerDataClient.Init(self: PlayerDataClient, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._dataValue = self._maid:Add(ValueObject.new(nil))

	self._remoting = self._maid:Add(Remoting.new(ReplicatedStorage, "PlayerDataService", Remoting.Realms.CLIENT))
end

function PlayerDataClient.Start(self: PlayerDataClient): ()
	-- Listen for server data updates
	self._maid:GiveTask(self._remoting:Connect("DataUpdated", function(data)
		self._dataValue.Value = data
	end))

	-- Request initial data without blocking Start()
	self._maid:GivePromise(self._remoting:PromiseInvokeServer("GetData"):Then(function(data)
		if data and self._dataValue.Value == nil then
			self._dataValue.Value = data
		end
	end))
end

function PlayerDataClient.ObserveData(self: PlayerDataClient)
	return self._dataValue:Observe():Pipe({
		Rx.where(function(value)
			return value ~= nil
		end),
	})
end

function PlayerDataClient.GetData(self: PlayerDataClient): { [string]: any }?
	return self._dataValue.Value
end

function PlayerDataClient.Destroy(self: PlayerDataClient): ()
	self._maid:DoCleaning()
end

return PlayerDataClient
