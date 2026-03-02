--!strict
--[=[
	@class MovingPlatform
]=]

local require = require(script.Parent.loader).load(script)

local TweenService = game:GetService("TweenService")

local BaseObject = require("BaseObject")
local MovingPlatformConstants = require("MovingPlatformConstants")

local MovingPlatform = setmetatable({}, BaseObject)
MovingPlatform.ClassName = "MovingPlatform"
MovingPlatform.__index = MovingPlatform

export type MovingPlatform = typeof(setmetatable(
	{} :: {
		_obj: Instance,
		_part: BasePart?,
		_waypoints: { CFrame },
		_speed: number,
		_pauseDuration: number,
		_currentIndex: number,
	},
	{} :: typeof({ __index = MovingPlatform })
)) & BaseObject.BaseObject

function MovingPlatform.new(obj: Instance, _serviceBag: any): MovingPlatform
	local self: MovingPlatform = setmetatable(BaseObject.new(obj) :: any, MovingPlatform)

	self._speed = (obj :: any):GetAttribute("Speed") or MovingPlatformConstants.SPEED
	self._pauseDuration = (obj :: any):GetAttribute("PauseDuration") or MovingPlatformConstants.PAUSE_DURATION
	self._currentIndex = 1
	self._waypoints = {}

	local part = if obj:IsA("BasePart") then obj :: BasePart else obj:FindFirstChildWhichIsA("BasePart") :: BasePart?
	self._part = part

	if not part then
		return self
	end

	part.Anchored = true

	-- Collect waypoints: start position is implicit waypoint 0
	local startCFrame = part.CFrame
	local rotation = startCFrame - startCFrame.Position
	table.insert(self._waypoints, startCFrame)

	local waypointIndex = 1
	while true do
		local waypoint: Vector3? = (obj :: any):GetAttribute("Waypoint" .. waypointIndex)
		if not waypoint then
			break
		end
		table.insert(self._waypoints, CFrame.new(waypoint :: Vector3) * rotation)
		waypointIndex += 1
	end

	if #self._waypoints > 1 then
		self:_moveToNext()
	end

	return self
end

function MovingPlatform._moveToNext(self: MovingPlatform): ()
	local part = self._part
	if not part or not self._obj.Parent then
		return
	end

	local targetCFrame = self._waypoints[self._currentIndex + 1]
	if not targetCFrame then
		-- Loop back to start
		self._currentIndex = 0
		targetCFrame = self._waypoints[1]
	end

	local distance = (targetCFrame.Position - part.Position).Magnitude

	if distance < 0.01 then
		self._currentIndex += 1
		if self._currentIndex >= #self._waypoints then
			self._currentIndex = 0
		end
		self:_moveToNext()
		return
	end

	local duration = distance / self._speed

	local tweenInfo = TweenInfo.new(
		duration,
		MovingPlatformConstants.EASING_STYLE,
		MovingPlatformConstants.EASING_DIRECTION
	)

	local tween = TweenService:Create(part, tweenInfo, {
		CFrame = targetCFrame,
	})

	self._maid._tween = tween

	tween.Completed:Once(function()
		self._currentIndex += 1
		if self._currentIndex >= #self._waypoints then
			self._currentIndex = 0
		end

		if self._pauseDuration > 0 then
			self._maid._pauseThread = task.delay(self._pauseDuration, function()
				self:_moveToNext()
			end)
		else
			self:_moveToNext()
		end
	end)

	tween:Play()
end

return MovingPlatform
