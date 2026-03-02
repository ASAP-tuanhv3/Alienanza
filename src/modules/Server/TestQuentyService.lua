--!strict
--[=[
	@class TestQuentyService
]=]

local require = require(script.Parent.loader).load(script)

local ServiceBag = require("ServiceBag")

local TestQuentyService = {}
TestQuentyService.ServiceName = "TestQuentyService"

export type TestQuentyService = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
	},
	{} :: typeof({ __index = TestQuentyService })
))

function TestQuentyService.Init(self: TestQuentyService, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External
	self._serviceBag:GetService(require("CmdrService"))

	-- Internal
	self._serviceBag:GetService(require("CoinService"))
	self._serviceBag:GetService(require("PlayerDataService"))
	self._serviceBag:GetService(require("SoundService"))
	self._serviceBag:GetService(require("TestQuentyTranslator"))
end

return TestQuentyService
