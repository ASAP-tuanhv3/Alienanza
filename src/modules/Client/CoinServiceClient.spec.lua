return function()
	local ok, CoinServiceClient = pcall(function()
		local loader = require(script.Parent.Parent.Parent.node_modules["@quenty"].loader)
		local require = loader.load(script)
		return require("CoinServiceClient")
	end)

	describe("CoinServiceClient", function()
		if not ok then
			itSKIP("cannot test client module from server context", function() end)
			return
		end

		it("should be a valid service", function()
			expect(CoinServiceClient).to.be.ok()
			expect(CoinServiceClient.ServiceName).to.equal("CoinServiceClient")
		end)
	end)
end
