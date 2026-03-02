--!strict
--[=[
	@class TestQuentyServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local ServiceBag = require("ServiceBag")

local TestQuentyServiceClient = {}
TestQuentyServiceClient.ServiceName = "TestQuentyServiceClient"

export type TestQuentyServiceClient = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
	},
	{} :: typeof({ __index = TestQuentyServiceClient })
))

function TestQuentyServiceClient.Init(self: TestQuentyServiceClient, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External
	self._serviceBag:GetService(require("CmdrServiceClient"))

	-- Internal
	self._serviceBag:GetService(require("LoadingScreenServiceClient"))
	self._serviceBag:GetService(require("PlayerDataClient"))
	self._serviceBag:GetService(require("SoundServiceClient"))
	self._serviceBag:GetService(require("TestQuentyTranslator"))
end

return TestQuentyServiceClient
