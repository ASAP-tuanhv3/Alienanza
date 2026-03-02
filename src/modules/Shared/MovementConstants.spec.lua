return function()
	local loader = require(script.Parent.Parent.Parent.node_modules["@quenty"].loader)
	local require = loader.load(script)

	local MovementConstants = require("MovementConstants")

	describe("MovementConstants", function()
		it("should have walk speed slower than run speed", function()
			expect(MovementConstants.WALK_SPEED).to.be.a("number")
			expect(MovementConstants.RUN_SPEED).to.be.a("number")
			expect(MovementConstants.WALK_SPEED < MovementConstants.RUN_SPEED).to.equal(true)
		end)

		it("should have a positive jump height", function()
			expect(MovementConstants.JUMP_HEIGHT > 0).to.equal(true)
		end)

		it("should have coyote time between 0 and 1 second", function()
			expect(MovementConstants.COYOTE_TIME > 0).to.equal(true)
			expect(MovementConstants.COYOTE_TIME < 1).to.equal(true)
		end)

		it("should have air control factor between 0 and 1", function()
			expect(MovementConstants.AIR_CONTROL > 0).to.equal(true)
			expect(MovementConstants.AIR_CONTROL <= 1).to.equal(true)
		end)

		it("should have variable jump cut below 1 to reduce jump height", function()
			expect(MovementConstants.VARIABLE_JUMP_CUT > 0).to.equal(true)
			expect(MovementConstants.VARIABLE_JUMP_CUT < 1).to.equal(true)
		end)

		it("should have camera distance for third-person view", function()
			expect(MovementConstants.CAMERA_DISTANCE > 0).to.equal(true)
		end)
	end)
end
