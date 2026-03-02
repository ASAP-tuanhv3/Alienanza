--!strict
--[=[
	@class SpikeBlock
]=]

local require = require(script.Parent.loader).load(script)

local BaseObject = require("BaseObject")
local CharacterUtils = require("CharacterUtils")
local SpikeBlockConstants = require("SpikeBlockConstants")

local SpikeBlock = setmetatable({}, BaseObject)
SpikeBlock.ClassName = "SpikeBlock"
SpikeBlock.__index = SpikeBlock

export type SpikeBlock = typeof(setmetatable(
	{} :: {
		_obj: Instance,
		_spikeBlockService: any,
	},
	{} :: typeof({ __index = SpikeBlock })
)) & BaseObject.BaseObject

function SpikeBlock.new(obj: Instance, serviceBag: any): SpikeBlock
	local self: SpikeBlock = setmetatable(BaseObject.new(obj) :: any, SpikeBlock)

	self._spikeBlockService = serviceBag:GetService(require("SpikeBlockService"))

	local touchPart = if obj:IsA("BasePart") then obj else obj:FindFirstChildWhichIsA("BasePart")
	if touchPart then
		self._maid:GiveTask((touchPart :: BasePart).Touched:Connect(function(hit: BasePart)
			self:_onTouched(hit)
		end))
	end

	return self
end

function SpikeBlock._onTouched(self: SpikeBlock, hit: BasePart): ()
	local player = CharacterUtils.getPlayerFromCharacter(hit)
	if not player then
		return
	end

	local character = player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end

	self._spikeBlockService:HandleSpikeDamage(player, humanoid, SpikeBlockConstants.DAMAGE)
end

return SpikeBlock
