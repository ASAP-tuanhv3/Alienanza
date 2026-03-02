--!strict
--[=[
	@class GameCameraClient
]=]

local require = require(script.Parent.loader).load(script)

local Players = game:GetService("Players")

local Maid = require("Maid")
local MovementConstants = require("MovementConstants")
local ServiceBag = require("ServiceBag")

local GameCameraClient = {}
GameCameraClient.ServiceName = "GameCameraClient"

export type GameCameraClient = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
	},
	{} :: typeof({ __index = GameCameraClient })
))

function GameCameraClient.Init(self: GameCameraClient, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()
end

function GameCameraClient.Start(self: GameCameraClient): ()
	local player = Players.LocalPlayer
	if not player then
		return
	end

	-- Lock camera zoom distance
	player.CameraMinZoomDistance = MovementConstants.CAMERA_DISTANCE
	player.CameraMaxZoomDistance = MovementConstants.CAMERA_DISTANCE

	-- Handle current character
	if player.Character then
		self:_setupCamera(player.Character)
	end

	-- Handle future characters
	self._maid:GiveTask(player.CharacterAdded:Connect(function(character: Model)
		self:_setupCamera(character)
	end))
end

function GameCameraClient._setupCamera(_self: GameCameraClient, character: Model): ()
	local humanoid = character:WaitForChild("Humanoid", 5) :: Humanoid?
	if not humanoid then
		return
	end

	-- Offset camera slightly above head for better third-person view
	humanoid.CameraOffset = Vector3.new(0, 3, 0)
end

function GameCameraClient.Destroy(self: GameCameraClient): ()
	self._maid:DoCleaning()
end

return GameCameraClient
