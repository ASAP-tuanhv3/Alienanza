--!strict
--[=[
	@class SoundConstants
]=]

local require = require(script.Parent.loader).load(script)

local Table = require("Table")
local WellKnownSoundGroups = require("WellKnownSoundGroups")

export type SoundGroup = string

export type SoundEntry = {
	SoundId: string,
	Group: SoundGroup,
	Volume: number?,
	Looped: boolean?,
}

local SoundConstants = {}

SoundConstants.Groups = Table.readonly({
	SFX = WellKnownSoundGroups.SFX,
	MUSIC = WellKnownSoundGroups.MUSIC,
})

SoundConstants.Sounds = Table.readonly({
	-- SFX
	UIClick = Table.readonly({
		SoundId = "rbxassetid://6895079853",
		Group = WellKnownSoundGroups.SFX,
	} :: SoundEntry),

	UIHover = Table.readonly({
		SoundId = "rbxassetid://6895079853",
		Group = WellKnownSoundGroups.SFX,
		Volume = 0.15,
	} :: SoundEntry),

	-- Music
	MainTheme = Table.readonly({
		SoundId = "rbxassetid://140348392510911",
		Group = WellKnownSoundGroups.MUSIC,
		Looped = true,
		Volume = 0.1,
	} :: SoundEntry),

	-- Ambient (using SFX group)
	Waterfall = Table.readonly({
		SoundId = "rbxassetid://6564308842",
		Group = WellKnownSoundGroups.SFX,
		Looped = true,
		Volume = 0.5,
	} :: SoundEntry),

	Wind = Table.readonly({
		SoundId = "rbxassetid://9114488610",
		Group = WellKnownSoundGroups.SFX,
		Looped = true,
		Volume = 0.3,
	} :: SoundEntry),

	CoinCollect = Table.readonly({
		SoundId = "rbxassetid://135483737426662",
		Group = WellKnownSoundGroups.SFX,
		Volume = 0.5,
	} :: SoundEntry),

	SpikeBlockHit = Table.readonly({
		SoundId = "rbxassetid://135663378635164",
		Group = WellKnownSoundGroups.SFX,
		Volume = 0.6,
	} :: SoundEntry),
})

return SoundConstants
