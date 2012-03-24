function header()
	solution(project_name)
		configurations { "Debug", "Release" }
		language "C++"
		buildoptions { "/W0" }
		location ( ".." )
		if project_name == "WebEmber" then
			defines { "BUILD_WEBEMBER" }
		end
		
		defines {
			"WIN32", "_WIN32", "__WIN32", "__WIN32__", "WINDOWS",
			"_WINDOWS", "_WIN32_WINNT=0x0502", "_CRT_SECURE_NO_WARNINGS",
			"_CRT_NONSTDC_NO_DEPRECATE", "NOMINMAX",
			"VARCONF_API="
		}
		
		configuration "Debug"
			--defines { "USE_VLD" }
			--includedirs { "$(VLD_DIR)/vld/include" }
			--libdirs { "$(VLD_DIR)/vld/lib/Win32" }
			--links { "vld" }
			defines { "DEBUG", "_DEBUG" }
			flags { "Symbols" }
			os.mkdir(build_dir .. "/" .. bin_d_dir)
			targetdir(build_dir .. "/" .. bin_d_dir)
			if debugdir then debugdir(build_dir .. "/" .. bin_d_dir) end
			
		configuration "Release*"
			defines { "NDEBUG" }
			flags {
				"OptimizeSpeed",
				"EnableSSE2",
				"FloatFast",
				"NoEditAndContinue",
				"NoMinimalRebuild",
				"NoFramePointer",
				--"NoIncrementalLink",
			}
			buildoptions { "/Ob2", "/Oi", "/Ot", "/GL" }
			os.mkdir(build_dir .. "/" .. bin_dir)
			targetdir(build_dir .. "/" .. bin_dir)
			if debugdir then debugdir(build_dir .. "/" .. bin_dir) end
end
function footer()
	os.mkdir("../projects")
	--loop through all projects and do some post-processing
	local prjs = solution().projects
	for i, prj in ipairs(prjs) do
		project ( prj.name )
			location ( "../projects/" .. project_name )
			configuration "Debug"
				targetsuffix("_d")
			configuration { "Debug", "SharedLib or WindowedApp or ConsoleApp" }
				linkoptions { "/NOD" } --no default lib
				links { "msvcrtd", "msvcprtd" } --force link runtime
			configuration { "Release*", "SharedLib or WindowedApp or ConsoleApp" }
				linkoptions { "/NOD" } --no default lib
				links { "msvcrt", "msvcprt" } --force link runtime
			configuration { "vs*", "Release" }
				linkoptions { "/LTCG" }
			configuration { "vs*", "ReleaseP*", "StaticLib" }
				linkoptions { "/LTCG" }
			configuration { "vs*", "ReleasePGI", "SharedLib or WindowedApp" }
				linkoptions { "/LTCG:PGINSTRUMENT" }
				links { "pgort" }
			configuration { "vs*", "ReleasePGO", "SharedLib or WindowedApp" }
				linkoptions { "/LTCG:PGOPTIMIZE" }
	end
end
