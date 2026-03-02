--!strict
--[=[
	@class CoinFloat
]=]

local require = require(script.Parent.loader).load(script)

local RunService = game:GetService("RunService")

local BaseObject = require("BaseObject")

local CoinFloat = setmetatable({}, BaseObject)
CoinFloat.ClassName = "CoinFloat"
CoinFloat.__index = CoinFloat

local AMPLITUDE = 1.5
local SPEED = 3

export type CoinFloat = typeof(setmetatable(
	{} :: {
		_obj: Instance,
		_originalCFrame: CFrame,
		_phase: number,
	},
	{} :: typeof({ __index = CoinFloat })
)) & BaseObject.BaseObject

function CoinFloat.new(obj: Instance): CoinFloat
	local self: CoinFloat = setmetatable(BaseObject.new(obj) :: any, CoinFloat)

	local part = if obj:IsA("BasePart") then obj else obj:FindFirstChildWhichIsA("BasePart")
	if not part then
		return self
	end

	local basePart = part :: BasePart
	self._originalCFrame = basePart.CFrame
	self._phase = basePart.Position.Y

	self._maid:GiveTask(RunService.Heartbeat:Connect(function()
		local yOffset = AMPLITUDE * math.sin(tick() * SPEED + self._phase)
		basePart.CFrame = self._originalCFrame + Vector3.new(0, yOffset, 0)
	end))

	return self
end

return CoinFloat
