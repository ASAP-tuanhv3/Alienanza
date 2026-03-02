return function()
	local ok, LoadingScreenPane = pcall(function()
		local loader = require(script.Parent.Parent.Parent.Parent.node_modules["@quenty"].loader)
		local require = loader.load(script)
		return require("LoadingScreenPane")
	end)

	describe("LoadingScreenPane", function()
		if not ok then
			itSKIP("cannot test client module from server context", function() end)
			return
		end

		it("should have ClassName", function()
			expect(LoadingScreenPane.ClassName).to.equal("LoadingScreenPane")
		end)

		it("should have new constructor", function()
			expect(LoadingScreenPane.new).to.be.a("function")
		end)

		it("should have SetStatusText method", function()
			expect(LoadingScreenPane.SetStatusText).to.be.a("function")
		end)

		it("should have GetStatusText method", function()
			expect(LoadingScreenPane.GetStatusText).to.be.a("function")
		end)
	end)
end
