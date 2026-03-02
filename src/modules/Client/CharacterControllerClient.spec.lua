return function()
	local ok, result = pcall(function()
		local loader = require(script.Parent.Parent.Parent.node_modules["@quenty"].loader)
		local require = loader.load(script)
		return {
			CharacterControllerClient = require("CharacterControllerClient"),
			MovementConstants = require("MovementConstants"),
		}
	end)

	describe("CharacterControllerClient", function()
		if not ok then
			itSKIP("cannot test client module from server context", function() end)
			return
		end

		local CharacterControllerClient = result.CharacterControllerClient
		local MovementConstants = result.MovementConstants

		it("should be a valid service", function()
			expect(CharacterControllerClient).to.be.ok()
			expect(CharacterControllerClient.ServiceName).to.equal("CharacterControllerClient")
		end)

		it("should use movement constants that give platformer feel", function()
			-- Walk speed should be reasonable (16-32 studs/s range)
			expect(MovementConstants.WALK_SPEED >= 16).to.equal(true)
			expect(MovementConstants.WALK_SPEED <= 32).to.equal(true)
			-- Jump height should clear a standard block (10 studs)
			expect(MovementConstants.JUMP_HEIGHT > 10).to.equal(true)
		end)
	end)
end
