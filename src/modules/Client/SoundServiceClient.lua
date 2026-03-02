--!strict
--[=[
	@class SoundServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local SoundService = game:GetService("SoundService")

local Binder = require("Binder")
local Maid = require("Maid")
local ServiceBag = require("ServiceBag")
local SoundConstants = require("SoundConstants")
local SoundEmitter = require("SoundEmitter")
local SoundGroupPathUtils = require("SoundGroupPathUtils")
local SoundUtils = require("SoundUtils")

local SoundServiceClient = {}
SoundServiceClient.ServiceName = "SoundServiceClient"

export type SoundServiceClient = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
		_currentMusic: Sound?,
		_currentMusicName: string?,
	},
	{} :: typeof({ __index = SoundServiceClient })
))

function SoundServiceClient.Init(self: SoundServiceClient, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	-- External
	self._serviceBag:GetService(require("SoundGroupServiceClient"))

	-- Binders
	self._serviceBag:GetService(Binder.new("SoundEmitter", SoundEmitter) :: any)

	self._currentMusic = nil
	self._currentMusicName = nil
end

function SoundServiceClient.Start(self: SoundServiceClient): () end

--[=[
	Plays a one-shot sound effect by name. The sound is automatically
	cleaned up after playback completes.

	@param soundName string
]=]
function SoundServiceClient.PlaySound(self: SoundServiceClient, soundName: string): ()
	local entry = (SoundConstants.Sounds :: any)[soundName] :: SoundConstants.SoundEntry?
	if not entry then
		warn(string.format("[SoundServiceClient] Unknown sound: %s", soundName))
		return
	end

	local soundOptions: { [string]: any } = {
		SoundId = entry.SoundId,
		Volume = rawget(entry :: any, "Volume") or 0.5,
	}
	local playbackSpeed = rawget(entry :: any, "PlaybackSpeed")
	if playbackSpeed then
		soundOptions.PlaybackSpeed = playbackSpeed
	end
	local sound = SoundUtils.playFromId(soundOptions)

	local soundGroup = SoundGroupPathUtils.findSoundGroup(entry.Group)
	if soundGroup then
		sound.SoundGroup = soundGroup
	end
end

--[=[
	Starts playing looping background music by name. Only one music
	track plays at a time — calling this stops any current music.

	@param musicName string
]=]
function SoundServiceClient.PlayMusic(self: SoundServiceClient, musicName: string): ()
	if self._currentMusicName == musicName then
		return
	end

	self:StopMusic()

	local entry = (SoundConstants.Sounds :: any)[musicName] :: SoundConstants.SoundEntry?
	if not entry then
		warn(string.format("[SoundServiceClient] Unknown music: %s", musicName))
		return
	end

	local soundOptions: { [string]: any } = {
		SoundId = entry.SoundId,
		Volume = rawget(entry :: any, "Volume") or 0.5,
	}
	local playbackSpeed = rawget(entry :: any, "PlaybackSpeed")
	if playbackSpeed then
		soundOptions.PlaybackSpeed = playbackSpeed
	end
	local sound = SoundUtils.createSoundFromId(soundOptions)
	sound.Looped = true

	local soundGroup = SoundGroupPathUtils.findSoundGroup(entry.Group)
	if soundGroup then
		sound.SoundGroup = soundGroup
	end

	sound.Parent = SoundService
	sound:Play()

	self._maid._currentMusic = sound
	self._currentMusic = sound
	self._currentMusicName = musicName
end

--[=[
	Stops the currently playing background music.
]=]
function SoundServiceClient.StopMusic(self: SoundServiceClient): ()
	self._maid._currentMusic = nil
	self._currentMusic = nil
	self._currentMusicName = nil
end

function SoundServiceClient.Destroy(self: SoundServiceClient): ()
	self._maid:DoCleaning()
end

return SoundServiceClient
