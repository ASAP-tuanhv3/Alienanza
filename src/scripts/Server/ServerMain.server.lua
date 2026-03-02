--!strict
--[[
	@class ServerMain
]]
local ServerScriptService = game:GetService("ServerScriptService")

local loader = ServerScriptService.TestQuenty:FindFirstChild("LoaderUtils", true).Parent
local require = require(loader).bootstrapGame(ServerScriptService.TestQuenty)

local serviceBag = require("ServiceBag").new()
serviceBag:GetService(require("TestQuentyService"))
serviceBag:Init()
serviceBag:Start()
