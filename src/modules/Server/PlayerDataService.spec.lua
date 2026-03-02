return function()
	local loader = require(script.Parent.Parent.Parent.node_modules["@quenty"].loader)
	local require = loader.load(script)

	local PlayerDataService = require("PlayerDataService")

	describe("PlayerDataService", function()
		it("should have ServiceName", function()
			expect(PlayerDataService.ServiceName).to.equal("PlayerDataService")
		end)

		it("should have Init method", function()
			expect(PlayerDataService.Init).to.be.a("function")
		end)

		it("should have Start method", function()
			expect(PlayerDataService.Start).to.be.a("function")
		end)

		it("should have PromisePlayerProfile method", function()
			expect(PlayerDataService.PromisePlayerProfile).to.be.a("function")
		end)

		it("should have Destroy method", function()
			expect(PlayerDataService.Destroy).to.be.a("function")
		end)
	end)
end
