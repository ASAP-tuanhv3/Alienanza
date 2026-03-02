--!strict
--[=[
	@class CharacterControllerClient
]=]

local require = require(script.Parent.loader).load(script)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Maid = require("Maid")
local MovementConstants = require("MovementConstants")
local ServiceBag = require("ServiceBag")

local CharacterControllerClient = {}
CharacterControllerClient.ServiceName = "CharacterControllerClient"

export type CharacterControllerClient = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
	},
	{} :: typeof({ __index = CharacterControllerClient })
))

function CharacterControllerClient.Init(self: CharacterControllerClient, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()
end

function CharacterControllerClient.Start(self: CharacterControllerClient): ()
	local player = Players.LocalPlayer
	if not player then
		return
	end

	-- Handle current character
	if player.Character then
		self:_setupCharacter(player.Character)
	end

	-- Handle future characters
	self._maid:GiveTask(player.CharacterAdded:Connect(function(character: Model)
		self:_setupCharacter(character)
	end))
end

function CharacterControllerClient._setupCharacter(self: CharacterControllerClient, character: Model): ()
	-- Clean up previous character bindings
	self._maid._character = nil

	local charMaid = Maid.new()
	self._maid._character = charMaid

	local humanoid = character:WaitForChild("Humanoid", 5) :: Humanoid?
	if not humanoid then
		return
	end

	local rootPart = character:WaitForChild("HumanoidRootPart", 5) :: BasePart?
	if not rootPart then
		return
	end

	-- Base humanoid settings
	humanoid.WalkSpeed = MovementConstants.WALK_SPEED
	humanoid.UseJumpPower = false
	humanoid.JumpHeight = MovementConstants.JUMP_HEIGHT

	-- State tracking
	local isSprinting = false
	local isGrounded = true
	local hasJumped = false
	local leftGroundTime = 0
	local jumpCutApplied = false

	local function getBaseSpeed(): number
		return if isSprinting then MovementConstants.RUN_SPEED else MovementConstants.WALK_SPEED
	end

	local function updateWalkSpeed(): ()
		local baseSpeed = getBaseSpeed()
		if isGrounded then
			humanoid.WalkSpeed = baseSpeed
		else
			humanoid.WalkSpeed = baseSpeed * MovementConstants.AIR_CONTROL
		end
	end

	-- Sprint input
	charMaid:GiveTask(UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
		if gameProcessed then
			return
		end
		if input.KeyCode == Enum.KeyCode.LeftShift then
			isSprinting = true
			updateWalkSpeed()
		end
	end))

	charMaid:GiveTask(UserInputService.InputEnded:Connect(function(input: InputObject)
		if input.KeyCode == Enum.KeyCode.LeftShift then
			isSprinting = false
			updateWalkSpeed()
		end
	end))

	-- Humanoid state tracking for coyote time and air control
	charMaid:GiveTask(humanoid.StateChanged:Connect(function(_old: Enum.HumanoidStateType, new: Enum.HumanoidStateType)
		if new == Enum.HumanoidStateType.Freefall then
			if not hasJumped then
				-- Walked off edge — start coyote timer
				leftGroundTime = tick()
			end
			isGrounded = false
			jumpCutApplied = false
			updateWalkSpeed()
		elseif new == Enum.HumanoidStateType.Landed or new == Enum.HumanoidStateType.Running then
			isGrounded = true
			hasJumped = false
			jumpCutApplied = false
			updateWalkSpeed()
		elseif new == Enum.HumanoidStateType.Jumping then
			hasJumped = true
			isGrounded = false
			jumpCutApplied = false
			updateWalkSpeed()
		end
	end))

	-- Coyote time: allow jump shortly after leaving ground
	charMaid:GiveTask(humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
		if humanoid.Jump and not isGrounded and not hasJumped then
			local timeSinceLeft = tick() - leftGroundTime
			if timeSinceLeft < MovementConstants.COYOTE_TIME then
				hasJumped = true
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end))

	-- Variable jump height: cut velocity when space is released
	charMaid:GiveTask(RunService.RenderStepped:Connect(function()
		if not isGrounded and not jumpCutApplied and hasJumped and rootPart then
			if not UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				local velocity = rootPart.AssemblyLinearVelocity
				if velocity.Y > 0 then
					rootPart.AssemblyLinearVelocity =
						Vector3.new(velocity.X, velocity.Y * MovementConstants.VARIABLE_JUMP_CUT, velocity.Z)
					jumpCutApplied = true
				end
			end
		end
	end))
end

function CharacterControllerClient.Destroy(self: CharacterControllerClient): ()
	self._maid:DoCleaning()
end

return CharacterControllerClient
