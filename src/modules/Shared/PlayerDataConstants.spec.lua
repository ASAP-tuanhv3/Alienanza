return function()
	local loader = require(script.Parent.Parent.Parent.node_modules["@quenty"].loader)
	local require = loader.load(script)

	local PlayerDataConstants = require("PlayerDataConstants")

	describe("PlayerDataConstants", function()
		it("should have a STORE_NAME string", function()
			expect(PlayerDataConstants.STORE_NAME).to.be.a("string")
			expect(#PlayerDataConstants.STORE_NAME > 0).to.equal(true)
		end)

		it("should have a TEMPLATE table", function()
			expect(PlayerDataConstants.TEMPLATE).to.be.a("table")
		end)

		it("should have default Coins in template", function()
			expect(PlayerDataConstants.TEMPLATE.Coins).to.be.a("number")
		end)

		it("should have default Inventory in template", function()
			expect(PlayerDataConstants.TEMPLATE.Inventory).to.be.a("table")
		end)

		it("should have default Settings in template", function()
			expect(PlayerDataConstants.TEMPLATE.Settings).to.be.a("table")
			expect(PlayerDataConstants.TEMPLATE.Settings.MusicEnabled).to.be.a("boolean")
		end)
	end)
end
