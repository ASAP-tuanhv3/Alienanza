--!strict
--[=[
	@class MovingPlatformService
]=]

local require = require(script.Parent.loader).load(script)

local Binder = require("Binder")
local ServiceBag = require("ServiceBag")
local MovingPlatformConstants = require("MovingPlatformConstants")

local MovingPlatformService = {}
MovingPlatformService.ServiceName = "MovingPlatformService"

export type MovingPlatformService = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_movingPlatformBinder: any,
	},
	{} :: typeof({ __index = MovingPlatformService })
))

function MovingPlatformService.Init(self: MovingPlatformService, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._movingPlatformBinder = self._serviceBag:GetService(
		Binder.new(MovingPlatformConstants.TAG, require("MovingPlatform"))
	)
end

function MovingPlatformService.Start(self: MovingPlatformService): ()
	self._movingPlatformBinder:Start()
end

return MovingPlatformService
