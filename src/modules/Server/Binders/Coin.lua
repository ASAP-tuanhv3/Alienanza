--!strict
--[=[
	@class Coin
]=]

local require = require(script.Parent.loader).load(script)

local BaseObject = require("BaseObject")
local CharacterUtils = require("CharacterUtils")
local CoinConstants = require("CoinConstants")

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
	self._coinService:HandleCoinCollected(player, self._value, self._obj:GetPivot().Position)
	self._obj:Destroy()
end

return Coin
