--!strict
--[=[
	@class CoinHudClient
]=]

local require = require(script.Parent.loader).load(script)

local Players = game:GetService("Players")

local Maid = require("Maid")
local ServiceBag = require("ServiceBag")

local CoinHudClient = {}
CoinHudClient.ServiceName = "CoinHudClient"

export type CoinHudClient = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
		_coinLabel: TextLabel?,
		_coinCount: number,
	},
	{} :: typeof({ __index = CoinHudClient })
))

function CoinHudClient.Init(self: CoinHudClient, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()
	self._coinCount = 0
end

function CoinHudClient.Start(self: CoinHudClient): ()
	self:_createGui()
end

function CoinHudClient.SetCoinCount(self: CoinHudClient, count: number): ()
	self._coinCount = count
	if self._coinLabel then
		self._coinLabel.Text = tostring(count)
	end
end

function CoinHudClient._createGui(self: CoinHudClient): ()
	local player = Players.LocalPlayer
	if not player then
		return
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CoinHud"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 10

	local frame = Instance.new("Frame")
	frame.Name = "CoinFrame"
	frame.AnchorPoint = Vector2.new(0, 0)
	frame.Position = UDim2.fromOffset(20, 80)
	frame.Size = UDim2.fromOffset(160, 50)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.5
	frame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame

	local icon = Instance.new("TextLabel")
	icon.Name = "CoinIcon"
	icon.AnchorPoint = Vector2.new(0, 0.5)
	icon.Position = UDim2.new(0, 10, 0.5, 0)
	icon.Size = UDim2.fromOffset(30, 30)
	icon.BackgroundTransparency = 1
	icon.Text = "O"
	icon.TextColor3 = Color3.fromRGB(255, 215, 0)
	icon.TextSize = 28
	icon.Font = Enum.Font.GothamBold
	icon.Parent = frame

	local label = Instance.new("TextLabel")
	label.Name = "CoinCount"
	label.AnchorPoint = Vector2.new(0, 0.5)
	label.Position = UDim2.new(0, 50, 0.5, 0)
	label.Size = UDim2.new(1, -60, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = tostring(self._coinCount)
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 24
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	self._coinLabel = label
	screenGui.Parent = player.PlayerGui
	self._maid:GiveTask(screenGui)
end

function CoinHudClient.Destroy(self: CoinHudClient): ()
	self._maid:DoCleaning()
end

return CoinHudClient
