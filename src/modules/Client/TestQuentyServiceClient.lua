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
	self._serviceBag:GetService(require("CharacterControllerClient"))
	self._serviceBag:GetService(require("CoinHudClient"))
	self._serviceBag:GetService(require("CoinServiceClient"))
	self._serviceBag:GetService(require("GameCameraClient"))
	self._serviceBag:GetService(require("LoadingScreenServiceClient"))
	self._serviceBag:GetService(require("MovingPlatformServiceClient"))
	self._serviceBag:GetService(require("PlayerDataClient"))
	self._serviceBag:GetService(require("SoundServiceClient"))
	self._serviceBag:GetService(require("SpikeBlockServiceClient"))
	self._serviceBag:GetService(require("TestQuentyTranslator"))
	self._serviceBag:GetService(require("WinConditionServiceClient"))
end

return TestQuentyServiceClient
