--!strict
--[=[
	@class SoundEmitter
]=]

local require = require(script.Parent.loader).load(script)

local BaseObject = require("BaseObject")
local SoundConstants = require("SoundConstants")
local SoundUtils = require("SoundUtils")

local SoundEmitter = setmetatable({}, BaseObject)
SoundEmitter.ClassName = "SoundEmitter"
SoundEmitter.__index = SoundEmitter

export type SoundEmitter = typeof(setmetatable(
	{} :: {
		_obj: Instance,
	},
	{} :: typeof({ __index = SoundEmitter })
)) & BaseObject.BaseObject

function SoundEmitter.new(obj: Instance): SoundEmitter
	local self: SoundEmitter = setmetatable(BaseObject.new(obj) :: any, SoundEmitter)

	local soundName = obj:GetAttribute("SoundName")
	if type(soundName) ~= "string" or soundName == "" then
		warn(string.format("[SoundEmitter] Missing SoundName attribute on %s", obj:GetFullName()))
		return self
	end

	local entry = (SoundConstants.Sounds :: any)[soundName] :: SoundConstants.SoundEntry?
	if not entry then
		warn(string.format("[SoundEmitter] Unknown sound: %s on %s", soundName, obj:GetFullName()))
		return self
	end

	local volumeOverride = obj:GetAttribute("Volume")
	local loopedOverride = obj:GetAttribute("Looped")

	local entryVolume = rawget(entry :: any, "Volume")
	local entryLooped = rawget(entry :: any, "Looped")

	local volume = if type(volumeOverride) == "number" then volumeOverride else (entryVolume or 0.5)
	local looped = if type(loopedOverride) == "boolean"
		then loopedOverride
		else (if entryLooped ~= nil then entryLooped else true)

	local playbackSpeed = rawget(entry :: any, "PlaybackSpeed")

	local soundOptions: { [string]: any } = {
		SoundId = entry.SoundId,
		Volume = volume,
	}
	if playbackSpeed then
		soundOptions.PlaybackSpeed = playbackSpeed
	end
	local sound = SoundUtils.createSoundFromId(soundOptions)
	sound.Looped = looped :: boolean
	sound.Parent = obj

	self._maid:GiveTask(sound)

	sound:Play()

	return self
end

return SoundEmitter
