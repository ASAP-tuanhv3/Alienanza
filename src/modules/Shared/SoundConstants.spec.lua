return function()
	local loader = require(script.Parent.Parent.Parent.node_modules["@quenty"].loader)
	local require = loader.load(script)

	local SoundConstants = require("SoundConstants")

	describe("SoundConstants", function()
		describe("Groups", function()
			it("should have SFX group", function()
				expect(SoundConstants.Groups.SFX).to.be.a("string")
			end)

			it("should have MUSIC group", function()
				expect(SoundConstants.Groups.MUSIC).to.be.a("string")
			end)
		end)

		describe("Sounds", function()
			it("should have UIClick entry", function()
				expect(SoundConstants.Sounds.UIClick).to.be.ok()
			end)

			it("should have UIHover entry", function()
				expect(SoundConstants.Sounds.UIHover).to.be.ok()
			end)

			it("should have MainTheme entry", function()
				expect(SoundConstants.Sounds.MainTheme).to.be.ok()
			end)

			it("should have Waterfall entry", function()
				expect(SoundConstants.Sounds.Waterfall).to.be.ok()
			end)

			it("should have Wind entry", function()
				expect(SoundConstants.Sounds.Wind).to.be.ok()
			end)

			it("should have valid SoundId on every entry", function()
				for _, entry in SoundConstants.Sounds do
					expect(entry.SoundId).to.be.a("string")
					expect(string.match(entry.SoundId, "^rbxassetid://")).to.be.ok()
				end
			end)

			it("should have valid Group on every entry", function()
				for _, entry in SoundConstants.Sounds do
					expect(entry.Group).to.be.a("string")
					expect(#entry.Group > 0).to.equal(true)
				end
			end)

			it("should have numeric Volume when present", function()
				local uiHover = SoundConstants.Sounds.UIHover
				expect(rawget(uiHover :: any, "Volume")).to.be.a("number")
			end)

			it("should have boolean Looped when present", function()
				local mainTheme = SoundConstants.Sounds.MainTheme
				expect(rawget(mainTheme :: any, "Looped")).to.be.a("boolean")
			end)
		end)
	end)
end
