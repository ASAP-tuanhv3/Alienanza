--!strict
--[=[
	@class PlayerDataService
]=]

local require = require(script.Parent.loader).load(script)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local BindToCloseService = require("BindToCloseService")
local Maid = require("Maid")
local PlayerDataConstants = require("PlayerDataConstants")
local ProfileStore = require("ProfileStore")
local Promise = require("Promise")
local Remoting = require("Remoting")
local RxPlayerUtils = require("RxPlayerUtils")
local ServiceBag = require("ServiceBag")

local PlayerDataService = {}
PlayerDataService.ServiceName = "PlayerDataService"

export type PlayerDataService = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
		_profileStore: any,
		_profiles: { [Player]: any },
		_profilePromises: { [Player]: any },
		_remoting: any,
	},
	{} :: typeof({ __index = PlayerDataService })
))

function PlayerDataService.Init(self: PlayerDataService, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._profiles = {}
	self._profilePromises = {}

	-- Dependencies
	local bindToCloseService = self._serviceBag:GetService(BindToCloseService)

	-- ProfileStore setup
	local store = ProfileStore.New(PlayerDataConstants.STORE_NAME, PlayerDataConstants.TEMPLATE)
	if RunService:IsStudio() then
		self._profileStore = store.Mock
	else
		self._profileStore = store
	end

	-- Remoting
	self._remoting = self._maid:Add(Remoting.new(ReplicatedStorage, "PlayerDataService", Remoting.Realms.SERVER))
	self._remoting:DeclareEvent("DataUpdated")
	self._remoting:Bind("GetData", function(player: Player)
		local profile = self._profiles[player]
		if profile then
			return profile.Data
		end
		return nil
	end)

	-- BindToClose
	self._maid:GiveTask(bindToCloseService:RegisterPromiseOnCloseCallback(function()
		return self:_endAllSessions()
	end))
end

function PlayerDataService.Start(self: PlayerDataService): ()
	self._maid:GiveTask(RxPlayerUtils.observePlayersBrio():Subscribe(function(brio)
		if brio:IsDead() then
			return
		end

		local player = brio:GetValue()
		local maid = brio:ToMaid()

		self:_startSession(maid, player)
	end))
end

function PlayerDataService.PromisePlayerProfile(self: PlayerDataService, player: Player)
	local existing = self._profilePromises[player]
	if existing then
		return existing
	end

	return Promise.rejected("No profile loading for player")
end

function PlayerDataService._startSession(self: PlayerDataService, maid: Maid.Maid, player: Player): ()
	local promise = Promise.new(function(resolve, reject)
		local profile = self._profileStore:StartSessionAsync(tostring(player.UserId), {
			Cancel = function()
				return player.Parent ~= Players
			end,
		})

		if profile then
			resolve(profile)
		else
			reject("Failed to load profile for " .. player.Name)
		end
	end)

	self._profilePromises[player] = promise

	promise:Then(function(profile)
		if player.Parent ~= Players then
			profile:EndSession()
			return
		end

		profile:AddUserId(player.UserId)
		profile:Reconcile()

		self._profiles[player] = profile

		-- Send initial data to client
		self._remoting:FireClient("DataUpdated", player, profile.Data)

		-- Push updates after each save
		local saveConnection = profile.OnAfterSave:Connect(function()
			if player.Parent == Players then
				self._remoting:FireClient("DataUpdated", player, profile.Data)
			end
		end)
		maid:GiveTask(function()
			saveConnection:Disconnect()
		end)

		-- Handle session stolen by another server
		local sessionEndConnection = profile.OnSessionEnd:Connect(function()
			if player.Parent == Players then
				player:Kick("Your data session was ended. Please rejoin.")
			end
		end)
		maid:GiveTask(function()
			sessionEndConnection:Disconnect()
		end)
	end)

	-- Cleanup on player leave
	maid:GiveTask(function()
		self._profilePromises[player] = nil

		local profile = self._profiles[player]
		self._profiles[player] = nil

		if profile and profile:IsActive() then
			profile:EndSession()
		end
	end)
end

function PlayerDataService._endAllSessions(self: PlayerDataService)
	return Promise.new(function(resolve)
		for player, profile in self._profiles do
			if profile:IsActive() then
				profile:EndSession()
			end
			self._profiles[player] = nil
		end
		resolve()
	end)
end

function PlayerDataService.Destroy(self: PlayerDataService): ()
	self._maid:DoCleaning()
end

return PlayerDataService
