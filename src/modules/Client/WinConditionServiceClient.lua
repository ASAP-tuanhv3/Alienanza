--!strict
--[=[
	@class WinConditionServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Maid = require("Maid")
local Remoting = require("Remoting")
local ServiceBag = require("ServiceBag")
local WinConditionConstants = require("WinConditionConstants")

local WinConditionServiceClient = {}
WinConditionServiceClient.ServiceName = "WinConditionServiceClient"

export type WinConditionServiceClient = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
		_remoting: any,
		_coinHudClient: any,
	},
	{} :: typeof({ __index = WinConditionServiceClient })
))

function WinConditionServiceClient.Init(self: WinConditionServiceClient, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._coinHudClient = self._serviceBag:GetService(require("CoinHudClient"))

	self._remoting = self._maid:Add(
		Remoting.new(ReplicatedStorage, "WinConditionService", Remoting.Realms.CLIENT)
	)
end

function WinConditionServiceClient.Start(self: WinConditionServiceClient): ()
	self._maid:GiveTask(self._remoting:Connect(WinConditionConstants.REMOTE_EVENT_NAME, function(_data: any)
		self:_onWin()
	end))
end

function WinConditionServiceClient._onWin(self: WinConditionServiceClient): ()
	self:_showVictoryScreen()
end

function WinConditionServiceClient._showVictoryScreen(self: WinConditionServiceClient): ()
	local player = Players.LocalPlayer
	if not player then
		return
	end

	local coinCount = self._coinHudClient._coinCount or 0

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "VictoryScreen"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 100

	local background = Instance.new("Frame")
	background.Name = "Background"
	background.Size = UDim2.fromScale(1, 1)
	background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	background.BackgroundTransparency = 1
	background.Parent = screenGui

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.AnchorPoint = Vector2.new(0.5, 0.5)
	title.Position = UDim2.fromScale(0.5, 0.35)
	title.Size = UDim2.fromOffset(600, 80)
	title.BackgroundTransparency = 1
	title.Text = "Victory!"
	title.TextColor3 = Color3.fromRGB(255, 215, 0)
	title.TextSize = 64
	title.Font = Enum.Font.GothamBold
	title.TextTransparency = 1
	title.Parent = background

	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
	subtitle.Position = UDim2.fromScale(0.5, 0.45)
	subtitle.Size = UDim2.fromOffset(600, 40)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = "You conquered the Climbing Level!"
	subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	subtitle.TextSize = 28
	subtitle.Font = Enum.Font.Gotham
	subtitle.TextTransparency = 1
	subtitle.Parent = background

	local coinLabel = Instance.new("TextLabel")
	coinLabel.Name = "CoinCount"
	coinLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	coinLabel.Position = UDim2.fromScale(0.5, 0.55)
	coinLabel.Size = UDim2.fromOffset(400, 40)
	coinLabel.BackgroundTransparency = 1
	coinLabel.Text = "Coins collected: " .. tostring(coinCount)
	coinLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	coinLabel.TextSize = 24
	coinLabel.Font = Enum.Font.GothamBold
	coinLabel.TextTransparency = 1
	coinLabel.Parent = background

	screenGui.Parent = player.PlayerGui
	self._maid._victoryScreen = screenGui

	-- Fade in animation
	local TweenService = game:GetService("TweenService")
	local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	TweenService:Create(background, fadeInfo, { BackgroundTransparency = 0.4 }):Play()
	TweenService:Create(title, fadeInfo, { TextTransparency = 0 }):Play()
	TweenService:Create(subtitle, fadeInfo, { TextTransparency = 0 }):Play()
	TweenService:Create(coinLabel, fadeInfo, { TextTransparency = 0 }):Play()
end

function WinConditionServiceClient.Destroy(self: WinConditionServiceClient): ()
	self._maid:DoCleaning()
end

return WinConditionServiceClient
