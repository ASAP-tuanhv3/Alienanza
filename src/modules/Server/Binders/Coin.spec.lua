return function()
	local loader = require(script.Parent.Parent.Parent.Parent.node_modules["@quenty"].loader)
	local require = loader.load(script)

	local CollectionService = game:GetService("CollectionService")
	local CoinConstants = require("CoinConstants")

	describe("Coin binder", function()
		it("should have coins tagged in workspace", function()
			local tagged = CollectionService:GetTagged(CoinConstants.TAG)
			expect(#tagged > 0).to.equal(true)
		end)

		it("should have coin names matching CoinConstants.VALUES keys", function()
			local tagged = CollectionService:GetTagged(CoinConstants.TAG)
			for _, coin in tagged do
				local value = CoinConstants.VALUES[coin.Name]
				if not value then
					value = CoinConstants.DEFAULT_VALUE
				end
				expect(value).to.be.a("number")
				expect(value > 0).to.equal(true)
			end
		end)

		it("should have coins that are non-collidable", function()
			local tagged = CollectionService:GetTagged(CoinConstants.TAG)
			for _, coin in tagged do
				local part = if coin:IsA("BasePart") then coin else coin:FindFirstChildWhichIsA("BasePart")
				if part then
					expect((part :: BasePart).CanCollide).to.equal(false)
				end
			end
		end)
	end)
end
