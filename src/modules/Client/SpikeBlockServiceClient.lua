--!strict
--[=[
	@class SpikeBlockServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Maid = require("Maid")
local Remoting = require("Remoting")
local ServiceBag = require("ServiceBag")
local SpikeBlockConstants = require("SpikeBlockConstants")

local FLASH_INTERVAL = 0.15
local FLASH_TRANSPARENCY = 0.5

local SpikeBlockServiceClient = {}
SpikeBlockServiceClient.ServiceName = "SpikeBlockServiceClient"

export type SpikeBlockServiceClient = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
		_remoting: any,
		_soundServiceClient: any,
	},
	{} :: typeof({ __index = SpikeBlockServiceClient })
))

function SpikeBlockServiceClient.Init(self: SpikeBlockServiceClient, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._soundServiceClient = self._serviceBag:GetService(require("SoundServiceClient"))

	self._remoting = self._maid:Add(
		Remoting.new(ReplicatedStorage, "SpikeBlockService", Remoting.Realms.CLIENT)
	)
end

function SpikeBlockServiceClient.Start(self: SpikeBlockServiceClient): ()
	self._maid:GiveTask(self._remoting:Connect(SpikeBlockConstants.REMOTE_EVENT_NAME, function(data: any)
		self:_onDamaged(data)
	end))
end

function SpikeBlockServiceClient._onDamaged(self: SpikeBlockServiceClient, _data: any): ()
	self._soundServiceClient:PlaySound("SpikeBlockHit")
	self:_startFlashEffect()
end

function SpikeBlockServiceClient._startFlashEffect(self: SpikeBlockServiceClient): ()
	local player = Players.LocalPlayer
	local character = player.Character
	if not character then
		return
	end

	-- Cancel any existing flash
	self._maid._flash = nil

	local flashMaid = Maid.new()
	self._maid._flash = flashMaid

	local originalTransparencies: { [BasePart]: number } = {}
	for _, child in character:GetDescendants() do
		if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
			originalTransparencies[child] = child.Transparency
		end
	end

	local elapsed = 0
	local flashElapsed = 0
	local visible = true

	flashMaid:GiveTask(RunService.Heartbeat:Connect(function(dt: number)
		elapsed += dt
		flashElapsed += dt

		if elapsed >= SpikeBlockConstants.IFRAME_DURATION then
			-- Restore and clean up
			for part, originalTransparency in originalTransparencies do
				if part.Parent then
					part.Transparency = originalTransparency
				end
			end
			self._maid._flash = nil
			return
		end

		if flashElapsed >= FLASH_INTERVAL then
			flashElapsed = 0
			visible = not visible

			for part, originalTransparency in originalTransparencies do
				if part.Parent then
					part.Transparency = if visible then originalTransparency else FLASH_TRANSPARENCY
				end
			end
		end
	end))

	-- Restore transparencies on cleanup
	flashMaid:GiveTask(function()
		for part, originalTransparency in originalTransparencies do
			if part.Parent then
				part.Transparency = originalTransparency
			end
		end
	end)
end

function SpikeBlockServiceClient.Destroy(self: SpikeBlockServiceClient): ()
	self._maid:DoCleaning()
end

return SpikeBlockServiceClient
