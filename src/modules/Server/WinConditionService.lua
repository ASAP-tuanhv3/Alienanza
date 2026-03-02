--!strict
--[=[
	@class WinConditionService
]=]

local require = require(script.Parent.loader).load(script)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Binder = require("Binder")
local Maid = require("Maid")
local Remoting = require("Remoting")
local ServiceBag = require("ServiceBag")
local WinConditionConstants = require("WinConditionConstants")

local WinConditionService = {}
WinConditionService.ServiceName = "WinConditionService"

export type WinConditionService = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
		_winZoneBinder: any,
		_remoting: any,
		_wonPlayers: { [Player]: boolean },
	},
	{} :: typeof({ __index = WinConditionService })
))

function WinConditionService.Init(self: WinConditionService, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()
	self._wonPlayers = {}

	-- Binder
	self._winZoneBinder = self._serviceBag:GetService(
		Binder.new(WinConditionConstants.TAG, require("WinZone"))
	)

	-- Remoting
	self._remoting = self._maid:Add(
		Remoting.new(ReplicatedStorage, "WinConditionService", Remoting.Realms.SERVER)
	)
	self._remoting:DeclareEvent(WinConditionConstants.REMOTE_EVENT_NAME)
end

function WinConditionService.Start(self: WinConditionService): ()
	self._winZoneBinder:Start()
end

function WinConditionService.HandleWin(self: WinConditionService, player: Player): ()
	if self._wonPlayers[player] then
		return
	end

	self._wonPlayers[player] = true

	self._remoting:FireClient(WinConditionConstants.REMOTE_EVENT_NAME, player, {})
end

function WinConditionService.Destroy(self: WinConditionService): ()
	self._maid:DoCleaning()
end

return WinConditionService
