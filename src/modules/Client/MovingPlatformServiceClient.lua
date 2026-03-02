--!strict
--[=[
	@class MovingPlatformServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local Binder = require("Binder")
local ServiceBag = require("ServiceBag")
local MovingPlatformConstants = require("MovingPlatformConstants")

local MovingPlatformServiceClient = {}
MovingPlatformServiceClient.ServiceName = "MovingPlatformServiceClient"

export type MovingPlatformServiceClient = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_movingPlatformBinder: any,
	},
	{} :: typeof({ __index = MovingPlatformServiceClient })
))

function MovingPlatformServiceClient.Init(self: MovingPlatformServiceClient, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._movingPlatformBinder = self._serviceBag:GetService(
		Binder.new(MovingPlatformConstants.TAG, require("MovingPlatformClient"))
	)
end

function MovingPlatformServiceClient.Start(self: MovingPlatformServiceClient): ()
	self._movingPlatformBinder:Start()
end

return MovingPlatformServiceClient
