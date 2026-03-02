return function()
	local CollectionService = game:GetService("CollectionService")

	local loader = require(script.Parent.Parent.Parent.node_modules["@quenty"].loader)
	local require = loader.load(script)

	local CoinConstants = require("CoinConstants")

	describe("CoinService", function()
		it("should have coins in the arena tagged with Coin", function()
			local coins = CollectionService:GetTagged(CoinConstants.TAG)
			expect(#coins).to.equal(9)
		end)

		it("should have correct coin type distribution", function()
			local coins = CollectionService:GetTagged(CoinConstants.TAG)
			local counts = { bronze = 0, silver = 0, gold = 0 }
			for _, coin in coins do
				if coin.Name == "coin-bronze" then
					counts.bronze += 1
				elseif coin.Name == "coin-silver" then
					counts.silver += 1
				elseif coin.Name == "coin-gold" then
					counts.gold += 1
				end
			end
			expect(counts.bronze).to.equal(6)
			expect(counts.silver).to.equal(1)
			expect(counts.gold).to.equal(2)
		end)

		it("should have all coins anchored and non-collidable", function()
			local coins = CollectionService:GetTagged(CoinConstants.TAG)
			for _, coin in coins do
				local part = if coin:IsA("BasePart") then coin else coin:FindFirstChildWhichIsA("BasePart")
				if part then
					expect((part :: BasePart).Anchored).to.equal(true)
					expect((part :: BasePart).CanCollide).to.equal(false)
				end
			end
		end)
	end)
end
