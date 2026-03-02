--!strict
--[[
	@class ClientMain

	Boot sequence:
	  1. Show loading screen immediately
	  2. Wait for game to load
	  3. Init and start ServiceBag
	  4. Wait for player data
	  5. Wait for character to spawn
	  6. Fade out loading screen
]]

local ReplicatedFirst = game:GetService("ReplicatedFirst")

local loader = game:GetService("ReplicatedStorage"):WaitForChild("TestQuenty"):WaitForChild("loader")
local require = require(loader).bootstrapGame(loader.Parent)

local LoadingScreenPane = require("LoadingScreenPane")

-- 1. Show loading screen immediately
ReplicatedFirst:RemoveDefaultLoadingScreen()
local loadingScreen = LoadingScreenPane.new()
loadingScreen:SetStatusText("Loading game...")

-- 2. Wait for game to load
if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- 3. Start services
loadingScreen:SetStatusText("Starting services...")
local serviceBag = require("ServiceBag").new()
serviceBag:GetService(require("TestQuentyServiceClient"))
serviceBag:Init()
serviceBag:Start()

-- 4. Wait for player data
local LoadingScreenServiceClient = require("LoadingScreenServiceClient")
local loadingService = serviceBag:GetService(LoadingScreenServiceClient)

loadingScreen:SetStatusText("Waiting for player data...")
loadingService:PromisePlayerData():Wait()

-- 5. Wait for character
loadingScreen:SetStatusText("Spawning character...")
loadingService:PromiseCharacter():Wait()

-- 6. Fade out
loadingScreen:SetStatusText("Finishing up...")
task.wait(0.3)
loadingScreen:Hide()
task.wait(1)
loadingScreen:Destroy()
