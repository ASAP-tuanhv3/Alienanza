--!strict
--[=[
	@class WinZone
]=]

local require = require(script.Parent.loader).load(script)

local BaseObject = require("BaseObject")
local CharacterUtils = require("CharacterUtils")

local WinZone = setmetatable({}, BaseObject)
WinZone.ClassName = "WinZone"
WinZone.__index = WinZone

export type WinZone = typeof(setmetatable(
	{} :: {
		_obj: Instance,
		_winConditionService: any,
	},
	{} :: typeof({ __index = WinZone })
)) & BaseObject.BaseObject

function WinZone.new(obj: Instance, serviceBag: any): WinZone
	local self: WinZone = setmetatable(BaseObject.new(obj) :: any, WinZone)

	self._winConditionService = serviceBag:GetService(require("WinConditionService"))

	local touchPart = if obj:IsA("BasePart") then obj else obj:FindFirstChildWhichIsA("BasePart")
	if touchPart then
		self._maid:GiveTask((touchPart :: BasePart).Touched:Connect(function(hit: BasePart)
			self:_onTouched(hit)
		end))
	end

	return self
end

function WinZone._onTouched(self: WinZone, hit: BasePart): ()
	local player = CharacterUtils.getPlayerFromCharacter(hit)
	if not player then
		return
	end

	self._winConditionService:HandleWin(player)
end

return WinZone
