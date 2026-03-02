return function()
	local ok, PlayerDataClient = pcall(function()
		local loader = require(script.Parent.Parent.Parent.node_modules["@quenty"].loader)
		local require = loader.load(script)
		return require("PlayerDataClient")
	end)

	describe("PlayerDataClient", function()
		if not ok then
			itSKIP("cannot test client module from server context", function() end)
			return
		end

		it("should have ServiceName", function()
			expect(PlayerDataClient.ServiceName).to.equal("PlayerDataClient")
		end)

		it("should have Init method", function()
			expect(PlayerDataClient.Init).to.be.a("function")
		end)

		it("should have Start method", function()
			expect(PlayerDataClient.Start).to.be.a("function")
		end)

		it("should have ObserveData method", function()
			expect(PlayerDataClient.ObserveData).to.be.a("function")
		end)

		it("should have GetData method", function()
			expect(PlayerDataClient.GetData).to.be.a("function")
		end)

		it("should have Destroy method", function()
			expect(PlayerDataClient.Destroy).to.be.a("function")
		end)
	end)
end
