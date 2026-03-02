return function()
	local loader = require(script.Parent.Parent.Parent.node_modules["@quenty"].loader)
	local require = loader.load(script)

	local SoundService = require("SoundService")

	describe("SoundService", function()
		it("should have ServiceName", function()
			expect(SoundService.ServiceName).to.equal("SoundService")
		end)

		it("should have Init method", function()
			expect(SoundService.Init).to.be.a("function")
		end)

		it("should have Start method", function()
			expect(SoundService.Start).to.be.a("function")
		end)
	end)
end
