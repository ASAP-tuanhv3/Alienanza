--!strict
--[=[
	@class LoadingScreenPane
]=]

local require = require(script.Parent.loader).load(script)

local Players = game:GetService("Players")

local BasicPane = require("BasicPane")
local Blend = require("Blend")
local Maid = require("Maid")
local ValueObject = require("ValueObject")

local LoadingScreenPane = setmetatable({}, BasicPane)
LoadingScreenPane.ClassName = "LoadingScreenPane"
LoadingScreenPane.__index = LoadingScreenPane

export type LoadingScreenPane = typeof(setmetatable(
	{} :: {
		_maid: Maid.Maid,
		_statusText: any,
	},
	{} :: typeof({ __index = LoadingScreenPane })
))

function LoadingScreenPane.new(): LoadingScreenPane
	local self: LoadingScreenPane = setmetatable(BasicPane.new() :: any, LoadingScreenPane)

	self._statusText = self._maid:Add(ValueObject.new("Loading...", "string"))

	self._maid:GiveTask((self:_render()):Subscribe())

	self:Show(true)

	return self
end

function LoadingScreenPane.SetStatusText(self: LoadingScreenPane, text: string): ()
	self._statusText.Value = text
end

function LoadingScreenPane.GetStatusText(self: LoadingScreenPane): string
	return self._statusText.Value
end

function LoadingScreenPane._render(self: LoadingScreenPane)
	local percentVisible = Blend.Spring(
		Blend.Computed(self:ObserveVisible(), function(visible: boolean)
			return if visible then 1 else 0
		end),
		20
	)

	local transparency = Blend.Computed(percentVisible, function(percent: number)
		return 1 - percent
	end)

	local localPlayer = Players.LocalPlayer
	local playerGui = localPlayer and localPlayer:FindFirstChildOfClass("PlayerGui")

	return Blend.New "ScreenGui" {
		Name = "LoadingScreen",
		Parent = playerGui,
		DisplayOrder = 1000,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

		[Blend.Children] = {
			Blend.New "Frame" {
				Name = "Background",
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.fromRGB(20, 20, 30),
				BackgroundTransparency = transparency,
				BorderSizePixel = 0,

				[Blend.Children] = {
					Blend.New "TextLabel" {
						Name = "Title",
						Size = UDim2.new(0.8, 0, 0, 48),
						Position = UDim2.fromScale(0.5, 0.4),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamBold,
						Text = "TestQuenty",
						TextSize = 48,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextTransparency = transparency,
					},

					Blend.New "TextLabel" {
						Name = "StatusText",
						Size = UDim2.new(0.8, 0, 0, 24),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Font = Enum.Font.Gotham,
						Text = self._statusText,
						TextSize = 20,
						TextColor3 = Color3.fromRGB(200, 200, 210),
						TextTransparency = transparency,
					},

					Blend.New "TextLabel" {
						Name = "LoadingIndicator",
						Size = UDim2.new(0, 40, 0, 24),
						Position = UDim2.fromScale(0.5, 0.56),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamBold,
						Text = ". . .",
						TextSize = 24,
						TextColor3 = Color3.fromRGB(150, 150, 170),
						TextTransparency = transparency,
					},
				},
			},
		},
	}
end

return LoadingScreenPane
