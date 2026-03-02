--!strict
--[=[
	@class SoundService
]=]

local require = require(script.Parent.loader).load(script)

local ServiceBag = require("ServiceBag")

local SoundService = {}
SoundService.ServiceName = "SoundService"

export type SoundService = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
	},
	{} :: typeof({ __index = SoundService })
))

function SoundService.Init(self: SoundService, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- Internal
	self._serviceBag:GetService(require("SoundGroupService"))
end

function SoundService.Start(self: SoundService): () end

return SoundService
