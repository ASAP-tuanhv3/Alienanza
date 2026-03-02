--!strict
--[=[
	@class MovingPlatformClient
]=]

local require = require(script.Parent.loader).load(script)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local BaseObject = require("BaseObject")
local MovingPlatformConstants = require("MovingPlatformConstants")

local RAYCAST_DISTANCE = 5

local MovingPlatformClient = setmetatable({}, BaseObject)
MovingPlatformClient.ClassName = "MovingPlatformClient"
MovingPlatformClient.__index = MovingPlatformClient

export type MovingPlatformClient = typeof(setmetatable(
	{} :: {
		_obj: Instance,
		_lastCFrame: CFrame?,
	},
	{} :: typeof({ __index = MovingPlatformClient })
)) & BaseObject.BaseObject

function MovingPlatformClient.new(obj: Instance): MovingPlatformClient
	local self: MovingPlatformClient = setmetatable(BaseObject.new(obj) :: any, MovingPlatformClient)

	local part = if obj:IsA("BasePart") then obj else obj:FindFirstChildWhichIsA("BasePart")
	if not part then
		return self
	end

	local basePart = part :: BasePart
	self._lastCFrame = basePart.CFrame

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	self._maid:GiveTask(RunService.Heartbeat:Connect(function()
		local player = Players.LocalPlayer
		local character = player.Character
		if not character then
			self._lastCFrame = basePart.CFrame
			return
		end

		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart?
		if not humanoidRootPart then
			self._lastCFrame = basePart.CFrame
			return
		end

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid:GetState() == Enum.HumanoidStateType.Freefall then
			self._lastCFrame = basePart.CFrame
			return
		end

		-- Raycast down from character to see if standing on this platform
		raycastParams.FilterDescendantsInstances = { character }
		local origin = humanoidRootPart.Position
		local result = workspace:Raycast(origin, Vector3.new(0, -RAYCAST_DISTANCE, 0), raycastParams)

		local currentCFrame = basePart.CFrame
		local lastCFrame = self._lastCFrame

		if result and self:_isPartOfPlatform(result.Instance) and lastCFrame then
			-- Apply delta CFrame to character
			local delta = currentCFrame * lastCFrame:Inverse()
			humanoidRootPart.CFrame = delta * humanoidRootPart.CFrame
		end

		self._lastCFrame = currentCFrame
	end))

	return self
end

function MovingPlatformClient._isPartOfPlatform(self: MovingPlatformClient, hitPart: Instance): boolean
	local obj = self._obj
	if hitPart == obj then
		return true
	end
	if hitPart:IsDescendantOf(obj) then
		return true
	end
	return false
end

return MovingPlatformClient
