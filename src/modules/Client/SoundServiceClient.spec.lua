return function()
	-- Client modules cannot be loaded from server context (Nevermore loader blocks it).
	-- Use pcall to gracefully skip when running tests from the server.
	local ok, SoundServiceClient = pcall(function()
		return require(script.Parent.SoundServiceClient)
	end)

	describe("SoundServiceClient", function()
		if not ok then
			itSKIP("cannot test client module from server context", function() end)
			return
		end

		it("should have ServiceName", function()
			expect(SoundServiceClient.ServiceName).to.equal("SoundServiceClient")
		end)

		it("should have Init method", function()
			expect(SoundServiceClient.Init).to.be.a("function")
		end)

		it("should have Start method", function()
			expect(SoundServiceClient.Start).to.be.a("function")
		end)

		it("should have PlaySound method", function()
			expect(SoundServiceClient.PlaySound).to.be.a("function")
		end)

		it("should have PlayMusic method", function()
			expect(SoundServiceClient.PlayMusic).to.be.a("function")
		end)

		it("should have StopMusic method", function()
			expect(SoundServiceClient.StopMusic).to.be.a("function")
		end)

		it("should have Destroy method", function()
			expect(SoundServiceClient.Destroy).to.be.a("function")
		end)
	end)
end
