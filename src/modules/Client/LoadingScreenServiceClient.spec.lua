return function()
	local ok, LoadingScreenServiceClient = pcall(function()
		local loader = require(script.Parent.Parent.Parent.node_modules["@quenty"].loader)
		local require = loader.load(script)
		return require("LoadingScreenServiceClient")
	end)

	describe("LoadingScreenServiceClient", function()
		if not ok then
			itSKIP("cannot test client module from server context", function() end)
			return
		end

		it("should have ServiceName", function()
			expect(LoadingScreenServiceClient.ServiceName).to.equal("LoadingScreenServiceClient")
		end)

		it("should have Init method", function()
			expect(LoadingScreenServiceClient.Init).to.be.a("function")
		end)

		it("should have PromisePlayerData method", function()
			expect(LoadingScreenServiceClient.PromisePlayerData).to.be.a("function")
		end)

		it("should have PromiseCharacter method", function()
			expect(LoadingScreenServiceClient.PromiseCharacter).to.be.a("function")
		end)

		it("should have Destroy method", function()
			expect(LoadingScreenServiceClient.Destroy).to.be.a("function")
		end)
	end)
end
