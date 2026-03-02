--!strict
--[[
	@class TestQuentyTranslator
]]

local require = require(script.Parent.loader).load(script)

return require("JSONTranslator").new("TestQuentyTranslator", "en", {
	gameName = "TestQuenty",
})
