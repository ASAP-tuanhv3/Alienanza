--!strict
--[=[
	@class SpikeBlockService
]=]

local require = require(script.Parent.loader).load(script)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Binder = require("Binder")
local Maid = require("Maid")
local Remoting = require("Remoting")
local ServiceBag = require("ServiceBag")
local SpikeBlockConstants = require("SpikeBlockConstants")

local SpikeBlockService = {}
SpikeBlockService.ServiceName = "SpikeBlockService"

export type SpikeBlockService = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
		_spikeBlockBinder: any,
		_remoting: any,
		_iframePlayers: { [Player]: number },
	},
	{} :: typeof({ __index = SpikeBlockService })
))

function SpikeBlockService.Init(self: SpikeBlockService, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()
	self._iframePlayers = {}

	-- Binder
	self._spikeBlockBinder = self._serviceBag:GetService(
		Binder.new(SpikeBlockConstants.TAG, require("SpikeBlock"))
	)

	-- Remoting
	self._remoting = self._maid:Add(
		Remoting.new(ReplicatedStorage, "SpikeBlockService", Remoting.Realms.SERVER)
	)
	self._remoting:DeclareEvent(SpikeBlockConstants.REMOTE_EVENT_NAME)
end

function SpikeBlockService.Start(self: SpikeBlockService): ()
	self._spikeBlockBinder:Start()
end

function SpikeBlockService.HandleSpikeDamage(self: SpikeBlockService, player: Player, humanoid: Humanoid, damage: number): ()
	local now = tick()
	local lastHit = self._iframePlayers[player]

	if lastHit and (now - lastHit) < SpikeBlockConstants.IFRAME_DURATION then
		return
	end

	self._iframePlayers[player] = now
	humanoid:TakeDamage(damage)

	-- Notify client
	self._remoting:FireClient(SpikeBlockConstants.REMOTE_EVENT_NAME, player, {
		damage = damage,
	})
end

function SpikeBlockService.Destroy(self: SpikeBlockService): ()
	self._maid:DoCleaning()
end

return SpikeBlockService
