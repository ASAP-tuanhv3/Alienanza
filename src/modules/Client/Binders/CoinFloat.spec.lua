return function()
	local ok, CoinFloat = pcall(function()
		local loader = require(script.Parent.Parent.Parent.Parent.node_modules["@quenty"].loader)
		local require = loader.load(script)

		return require("CoinFloat")
	end)

	describe("CoinFloat", function()
		if not ok then
			itSKIP("cannot test client module from server context", function() end)
			return
		end

		it("should have ClassName set", function()
			expect(CoinFloat.ClassName).to.equal("CoinFloat")
		end)

		it("should have a new constructor", function()
			expect(CoinFloat.new).to.be.a("function")
		end)
	end)
end
