return function()
	local loader = require(script.Parent.Parent.Parent.node_modules["@quenty"].loader)
	local require = loader.load(script)

	local SpikeBlockConstants = require("SpikeBlockConstants")

	describe("SpikeBlockConstants", function()
		it("should have a TAG string", function()
			expect(SpikeBlockConstants.TAG).to.be.a("string")
			expect(SpikeBlockConstants.TAG).to.equal("SpikeBlock")
		end)

		it("should have a DAMAGE number", function()
			expect(SpikeBlockConstants.DAMAGE).to.be.a("number")
			expect(SpikeBlockConstants.DAMAGE > 0).to.equal(true)
		end)

		it("should have an IFRAME_DURATION number", function()
			expect(SpikeBlockConstants.IFRAME_DURATION).to.be.a("number")
			expect(SpikeBlockConstants.IFRAME_DURATION > 0).to.equal(true)
		end)

		it("should have a REMOTE_EVENT_NAME string", function()
			expect(SpikeBlockConstants.REMOTE_EVENT_NAME).to.be.a("string")
			expect(#SpikeBlockConstants.REMOTE_EVENT_NAME > 0).to.equal(true)
		end)
	end)
end
