DirectX_SDK = {
	isInstalled = false,
	libdir = "$(DXSDK_DIR)/Lib/x86",
	includedir = "$(DXSDK_DIR)/Include"
}

local function find_DirectX()
	local dxdir = os.getenv("DXSDK_DIR")
	if dxdir and os.isdir(dxdir .. "Lib/x86") and os.isdir(dxdir .. "Include") then
		DirectX_SDK.isInstalled = true
	else
		--This will work on: c:/Program Files/Microsoft DirectX SDK (June 2010)
		matches = os.matchdirs("c:/Program Files/Microsoft DirectX SDK*")
		for i, v in ipairs(matches) do
			if os.isdir(v .. "/Lib/x86") and os.isdir(v .. "/Include") then
				DirectX_SDK.isInstalled = true
				DirectX_SDK.libdir = v .. "/Lib/x86"
				DirectX_SDK.includedir = v .. "/Include"
			end
		end
	end
end

function use_DirectX(liblist)
	--you can only call this from a project block!
	assert(project())
	if not DirectX_SDK.isInstalled then
		print("DirectX SDK not found, but required by " .. project().name)
		os.exit(0)
	end
	includedirs(DirectX_SDK.includedir)
	libdirs(DirectX_SDK.libdir)

	if liblist then
		links(liblist)
	end
end

--directX is only available on windows.
assert(os.is("windows"))
find_DirectX()
