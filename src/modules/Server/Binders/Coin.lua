--!strict
--[=[
	@class Coin
]=]

local require = require(script.Parent.loader).load(script)

local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local BaseObject = require("BaseObject")
local CharacterUtils = require("CharacterUtils")
local CoinConstants = require("CoinConstants")

local SPIN_DURATION = 0.5
local SPIN_REVOLUTIONS = 2

local Coin = setmetatable({}, BaseObject)
Coin.ClassName = "Coin"
Coin.__index = Coin

export type Coin = typeof(setmetatable(
	{} :: {
		_obj: Instance,
		_value: number,
		_collected: boolean,
		_coinService: any,
	},
	{} :: typeof({ __index = Coin })
)) & BaseObject.BaseObject

function Coin.new(obj: Instance, serviceBag: any): Coin
	local self: Coin = setmetatable(BaseObject.new(obj) :: any, Coin)

	self._collected = false
	self._value = CoinConstants.VALUES[obj.Name] or CoinConstants.DEFAULT_VALUE
	self._coinService = serviceBag:GetService(require("CoinService"))

	local touchPart = if obj:IsA("BasePart") then obj else obj:FindFirstChildWhichIsA("BasePart")
	if touchPart then
		self._maid:GiveTask((touchPart :: BasePart).Touched:Connect(function(hit: BasePart)
			self:_onTouched(hit)
		end))
	end

	return self
end

function Coin._onTouched(self: Coin, hit: BasePart): ()
	if self._collected then
		return
	end

	local player = CharacterUtils.getPlayerFromCharacter(hit)
	if not player then
		return
	end

	self._collected = true
	local obj = self._obj
	local part = if obj:IsA("BasePart") then obj else obj:FindFirstChildWhichIsA("BasePart")

	self._coinService:HandleCoinCollected(player, self._value, obj:GetPivot().Position)

	-- Remove tag so the client CoinFloat binder detaches and stops overwriting CFrame
	-- This also destroys this Coin binder instance, so we capture what we need above
	CollectionService:RemoveTag(obj, CoinConstants.TAG)

	if not part then
		obj:Destroy()
		return
	end

	local basePart = part :: BasePart
	local startCFrame = basePart.CFrame
	local startSize = basePart.Size
	local elapsed = 0

	local connection = RunService.Heartbeat:Connect(function(dt: number)
		elapsed += dt
		local alpha = math.min(elapsed / SPIN_DURATION, 1)

		local angle = alpha * math.pi * 2 * SPIN_REVOLUTIONS
		local rise = alpha * 2
		local scale = 1 - alpha * 0.9

		basePart.CFrame = startCFrame * CFrame.Angles(0, angle, 0) + Vector3.new(0, rise, 0)
		basePart.Size = startSize * scale
		basePart.Transparency = alpha

		if alpha >= 1 then
			obj:Destroy()
		end
	end)

	-- Clean up connection if obj is destroyed early
	;(obj :: any).Destroying:Once(function()
		connection:Disconnect()
	end)
end

return Coin
