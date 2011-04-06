--This will allow to build visual studio 2008 and Xcode 4 native project files for Ember!
--This script needs to be runned with premake4: http://industriousone.com/scripting-reference
--for force restart, run: premake4 --redownload --reinstall vs2008
--read "premake4 --help" for more info
newoption {
   trigger     = "redownload",
   description = "will redownload and reinstall everything"
}

newoption {
   trigger     = "reinstall",
   description = "will reinstall everything"
}

if _ACTION == nil then return end
if _ACTION ~= "vs2008" then
	error("Sorry, only visual studio 2008 supported yet!")
end

--load install.lua
require("install")

--start downloading and installing build environment
if not isInstalled() then
	install()
end

--configure project file
solution "WorldForge"
	
	configurations { "Debug", "Release" }
	language "C++"
	os.mkdir("bin")
	targetdir("bin")

	defines { "WIN32","_WIN32","__WIN32", "__WIN32__", "WINDOWS", "_WINDOWS", "_WIN32_WINNT=0x0502", "_CRT_SECURE_NO_WARNINGS", "_CRT_NONSTDC_NO_DEPRECATE" }
	
	configuration "Debug"
		defines { "DEBUG", "_DEBUG" }
		flags { "Symbols" }
	configuration "Release"
		defines { "NDEBUG" }
		flags { "OptimizeSpeed" }
		
	project "sigcpp"
		kind "StaticLib"
		tmpdir="dep/libsigc++-2.2.9/sigc++/"
		files { tmpdir .. "**.h", tmpdir .. "**.cc" }
		files { tmpdir .. "../MSVC_Net2008/**.h", tmpdir .. "../MSVC_Net2008/**.cpp" }
		excludes { tmpdir .. "../**Pax**" }
		includedirs { "dep/libsigc++-2.2.9", tmpdir .. "../MSVC_Net2008" }
		defines { "SIGC_BUILD" }
	project "varconf"
		kind "StaticLib"
		tmpdir="worldforge/varconf/varconf/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		includedirs { "worldforge/varconf", "dep/libsigc++-2.2.9", "dep/libsigc++-2.2.9/MSVC_Net2008" }
		--links { "sigcpp" }
	project "skstream"
		kind "StaticLib"
		tmpdir="worldforge/skstream/skstream/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		defines { "HAVE_GAI_STRERROR" }
		includedirs { "worldforge/skstream" }
		--links { "ws2_32" }
	project "atlas-cpp"
		kind "StaticLib"
		tmpdir="worldforge/atlas-cpp/Atlas/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		excludes {
			--tmpdir .. "Bindings/**",
			tmpdir .. "Codecs/XMLish.cpp",
			tmpdir .. "Message/Layer.*",
			tmpdir .. "Factory.*"
		}
		includedirs {
			"worldforge/atlas-cpp",
			"dep/CEGUI-SDK-0.7.5-vc9/dependencies/include",
			"dep/bzip2/include"
		}
	project "wfmath"
		kind "StaticLib"
		tmpdir="worldforge/wfmath/wfmath/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		excludes { "worldforge/wfmath/wfmath/*_test*" }
		excludes { "worldforge/wfmath/wfmath/unused/*" }
		includedirs { "worldforge/wfmath", tmpdir }
	project "mercator"
		kind "StaticLib"
		tmpdir="worldforge/mercator/Mercator/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		includedirs { "worldforge/mercator", "worldforge/wfmath", tmpdir }
		defines { "PACKAGE" }
		--links { "wfmath" }
	project "eris"
		kind "StaticLib"
		tmpdir="worldforge/eris/Eris/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		excludes { tmpdir .. "UIFactory.*" }
		defines { "PACKAGE" }
		includedirs {
			"worldforge/mercator",
			"worldforge/skstream",
			"worldforge/atlas-cpp",
			"worldforge/eris",
			"worldforge/wfmath",
			"dep/CEGUI-SDK-0.7.5-vc9/dependencies/include",
			"dep/libcurl/include",
			"dep/libsigc++-2.2.9",
			"dep/libsigc++-2.2.9/MSVC_Net2008",
			"dep/dirent"
		}
		--links { "sigcpp" }
	project "libwfut"
		kind "StaticLib"
		tmpdir="worldforge/libwfut/libwfut/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		includedirs {
			"worldforge/libwfut",
			"dep/CEGUI-SDK-0.7.5-vc9/dependencies/include",
			"dep/libcurl/include",
			"dep/libsigc++-2.2.9",
			"dep/libsigc++-2.2.9/MSVC_Net2008",
			"dep/dirent"
		}
		defines { "TIXML_USE_STL" }
--[[
not implemented yet:
	project "EntityMapping"
		kind "StaticLib"
	project "Lua"
		kind "StaticLib"
	project "Caelum"
		kind "StaticLib"
	project "MeshTree"
		kind "StaticLib"
	project "pagedgeometry"
		kind "StaticLib"
	project "EmberPagingSceneManager"
		kind "StaticLib"
	project "EmberOgre"
		kind "StaticLib"
	project "Extensions"
		kind "StaticLib"
	project "Framework"
		kind "StaticLib"
	project "Tasks"
		kind "StaticLib"
	project "Services"
		kind "StaticLib"
	project "lua_EmberServices"
		kind "StaticLib"
	project "ConfigService"
		kind "StaticLib"
	project "InputService"
		kind "StaticLib"
	project "LoggingService"
		kind "StaticLib"
	project "MetaServerService"
		kind "StaticLib"
	project "ScriptingService"
		kind "StaticLib"
	project "ServerService"
		kind "StaticLib"
	project "ServerSettings"
		kind "StaticLib"
	project "SoundService"
		kind "StaticLib"
	project "Time"
		kind "StaticLib"
	project "Wfut"
		kind "StaticLib"
	project "lua_Main"
		kind "StaticLib"
--]]

	ember_includes = {
		"worldforge/varconf",
		"worldforge/wfmath",
		"worldforge/skstream",
		"worldforge/atlas-cpp",
		"worldforge/mercator",
		"worldforge/eris",
		"worldforge/ember/src",
		"worldforge/ember/src/components/ogre/environment/pagedgeometry/include",
		"worldforge/ember/src/components/ogre/ogreopcode/include",
		"worldforge/ember/src/components/ogre/environment/pagedgeometry/include",
		"worldforge/ember/src/components/ogre/environment/caelum/include",
		"dep/libsigc++-2.2.9/MSVC_Net2008",
		"dep/libsigc++-2.2.9",
		"dep/tolua++/tolua++-1.0.93/include",
		"dep/lua/include",
		"dep/CEGUI-SDK-0.7.5-vc9/dependencies/include",
		"dep/CEGUI-SDK-0.7.5-vc9/cegui/include/ScriptingModules/LuaScriptModule/support/tolua++",
		"dep/CEGUI-SDK-0.7.5-vc9/cegui/include",
		"dep/SDL-1.2.14/include",
		"dep/OgreSDK_vc9_v1-7-2/include/OGRE",
		"dep/OgreSDK_vc9_v1-7-2/boost_1_44",
	}

function create_tolua_project(pkgfile)
	local dir = os.getcwd() .. "/" --current working dir
	local tolua = dir .. "dep/tolua++/tolua++" --tolua location
	local name = path.getbasename(pkgfile) --project name
	local outfolder = dir .. "worldforge/ember/src_tolua/"
	local outfile = outfolder .. name .. ".cxx"
	os.mkdir( outfolder )
	
	print("Generating lua_" .. name)
	os.chdir( path.getdirectory( dir .. pkgfile))
		os.execute(tolua .. " -o " .. outfile .. " " .. path.getname(pkgfile))
	os.chdir(dir)
	
	project("lua_" .. name)
		kind "StaticLib"
		files { outfile }
		includedirs { path.getdirectory( dir .. pkgfile) }
		includedirs(ember_includes)
end
	
	create_tolua_project("worldforge/ember/src/bindings/lua/ConnectorDefinitions.pkg")
	create_tolua_project("worldforge/ember/src/components/lua/bindings/lua/Lua.pkg")
	create_tolua_project("worldforge/ember/src/components/ogre/scripting/bindings/lua/EmberOgre.pkg")
	create_tolua_project("worldforge/ember/src/components/ogre/scripting/bindings/lua/helpers/Helpers.pkg")
	create_tolua_project("worldforge/ember/src/components/ogre/scripting/bindings/lua/ogre/Ogre.pkg")
	create_tolua_project("worldforge/ember/src/components/ogre/widgets/adapters/atlas/bindings/lua/AtlasAdapters.pkg")
	create_tolua_project("worldforge/ember/src/framework/bindings/lua/Framework.pkg")
	create_tolua_project("worldforge/ember/src/framework/bindings/lua/atlas/Atlas.pkg")
	create_tolua_project("worldforge/ember/src/framework/bindings/lua/eris/Eris.pkg")
	create_tolua_project("worldforge/ember/src/framework/bindings/lua/varconf/Varconf.pkg")
	project "ember"
		kind "ConsoleApp"
		tmpdir="worldforge/ember/src/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		defines { "PACKAGE", "ICE_NO_DLL" }
		includedirs(ember_includes)
		links {
			"ws2_32",
			"sigcpp",
			"varconf",
			"wfmath",
			"skstream",
			"mercerator",
			"eris"
		}
		
	os.mkdir("prj")
	--loop through all projects and do some post-processing
	local prjs = solution().projects
	for i, prj in ipairs(prjs) do
		project ( prj.name )
			location ( "prj" )
			configuration "Debug"
				targetsuffix("_d")
	end