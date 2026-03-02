--!strict
--[=[
	@class CoinServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CoinConstants = require("CoinConstants")
local Maid = require("Maid")
local Remoting = require("Remoting")
local ServiceBag = require("ServiceBag")

local CoinServiceClient = {}
CoinServiceClient.ServiceName = "CoinServiceClient"

export type CoinServiceClient = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
		_remoting: any,
		_soundServiceClient: any,
		_coinHudClient: any,
	},
	{} :: typeof({ __index = CoinServiceClient })
))

function CoinServiceClient.Init(self: CoinServiceClient, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._soundServiceClient = self._serviceBag:GetService(require("SoundServiceClient"))
	self._coinHudClient = self._serviceBag:GetService(require("CoinHudClient"))

	self._remoting = self._maid:Add(Remoting.new(ReplicatedStorage, "CoinService", Remoting.Realms.CLIENT))
end

function CoinServiceClient.Start(self: CoinServiceClient): ()
	self._maid:GiveTask(self._remoting:Connect(CoinConstants.REMOTE_EVENT_NAME, function(data: any)
		self:_onCoinCollected(data)
	end))
end

function CoinServiceClient._onCoinCollected(self: CoinServiceClient, data: any): ()
	-- Play sound
	self._soundServiceClient:PlaySound("CoinCollect")

	-- Update HUD
	self._coinHudClient:SetCoinCount(data.totalCoins)

	-- Spawn particle at collection position
	if data.position then
		self:_spawnParticle(data.position)
	end
end

function CoinServiceClient._spawnParticle(_self: CoinServiceClient, position: Vector3): ()
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Size = Vector3.new(1, 1, 1)
	part.Position = position
	part.Parent = workspace

	local emitter = Instance.new("ParticleEmitter")
	emitter.Color = ColorSequence.new(Color3.fromRGB(255, 215, 0))
	emitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })
	emitter.Lifetime = NumberRange.new(0.3, 0.5)
	emitter.Speed = NumberRange.new(5, 10)
	emitter.SpreadAngle = Vector2.new(360, 360)
	emitter.Rate = 0
	emitter.Parent = part

	emitter:Emit(15)

	task.delay(1, function()
		part:Destroy()
	end)
end

function CoinServiceClient.Destroy(self: CoinServiceClient): ()
	self._maid:DoCleaning()
end

return CoinServiceClient
