return function()
	local loader = require(script.Parent.Parent.Parent.node_modules["@quenty"].loader)
	local require = loader.load(script)

	local CoinConstants = require("CoinConstants")

	describe("CoinConstants", function()
		it("should have a tag name for CollectionService", function()
			expect(CoinConstants.TAG).to.be.a("string")
			expect(#CoinConstants.TAG > 0).to.equal(true)
		end)

		it("should have ascending coin values (bronze < silver < gold)", function()
			local bronze = CoinConstants.VALUES["coin-bronze"]
			local silver = CoinConstants.VALUES["coin-silver"]
			local gold = CoinConstants.VALUES["coin-gold"]
			expect(bronze).to.be.ok()
			expect(silver).to.be.ok()
			expect(gold).to.be.ok()
			expect(bronze < silver).to.equal(true)
			expect(silver < gold).to.equal(true)
		end)

		it("should have a default value for unknown coin types", function()
			expect(CoinConstants.DEFAULT_VALUE).to.be.a("number")
			expect(CoinConstants.DEFAULT_VALUE > 0).to.equal(true)
		end)

		it("should have a remote event name for client communication", function()
			expect(CoinConstants.REMOTE_EVENT_NAME).to.be.a("string")
		end)
	end)
end
