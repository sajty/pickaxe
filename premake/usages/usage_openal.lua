OpenAL_SDK = {
	isInstalled = false,
	libdir = "",
	includedir = ""
}

function find_OpenAL()
	if os.get() == "windows" then
		local aldir = os.getenv("OPENAL_DIR")
		if aldir then
			OpenAL_SDK.isInstalled = true
			OpenAL_SDK.libdir = aldir .. "/libs/Win32"
			OpenAL_SDK.includedir = aldir .. "/include"
		else
			--This will work on: c:/Program Files/OpenAL 1.1 SDK
			matches = os.matchdirs("c:/Program Files/OpenAL * SDK")
			for i, v in ipairs(matches) do
				if os.isdir(v .. "/libs/Win32") and os.isdir(v .. "/include") then
					OpenAL_SDK.isInstalled = true
					OpenAL_SDK.libdir = v .. "/libs/Win32"
					OpenAL_SDK.includedir = v .. "/include"
				end
			end
		end
	else
		OpenAL_SDK.isInstalled = true
	end
end

function use_OpenAL()
	--you can only call this from a project block!
	assert(project())
	if not OpenAL_SDK.isInstalled then error("OpenAL SDK not found, but required by " .. project().name) end
	if os.is("windows") then
		includedirs { OpenAL_SDK.includedir }
		libdirs { OpenAL_SDK.libdir }
		links { "OpenAL32" }
		if string.startswith(_ACTION, "vs20") then
			if static_runtime then
				libdirs { OpenAL_SDK.libdir .. "/EFX-Util_MT" }
			else
				libdirs { OpenAL_SDK.libdir .. "/EFX-Util_MTDLL" }
			end
			links { "EFX-Util" }
		end
	else
		links { "openal" }
	end
end

find_OpenAL()
