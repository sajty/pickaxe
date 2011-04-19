--This will allow to build visual studio 2008 and Xcode 4 native project files for Ember!
--This script needs to be used with premake4: http://industriousone.com/scripting-reference
--for force restart, use: premake4 --redownload --reinstall vs2008
--read "premake4 --help" for all options


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
	
build_media()

--copy contents of "./files" folder to the root. This will copy config.h files
os.copypattern("files", "**",  ".")

--configure project files
solution "WorldForge"
	configurations { "Debug", "Release" }
	language "C++"
	os.mkdir("build/local/bin")
	targetdir("build/local/bin")
	buildoptions { "/W0" }
	defines { "TOLUA_API=", "WIN32","_WIN32","__WIN32", "__WIN32__", "WINDOWS", "_WINDOWS", "_WIN32_WINNT=0x0502", "_CRT_SECURE_NO_WARNINGS", "_CRT_NONSTDC_NO_DEPRECATE" }

	configuration "Debug"
		defines { "DEBUG", "_DEBUG" }
		flags { "Symbols" }
	configuration "Release"
		defines { "NDEBUG" }
		flags { "OptimizeSpeed" }
		
	project "Ember"
		--first project is the startup project
	project "toluapp"
		kind "StaticLib"
		tmpdir="dep/tolua++/tolua++-1.0.93/src/lib"
		files { tmpdir .. "**.h", tmpdir .. "**.c" }
		includedirs { "dep/CEGUI-SDK-0.7.5-vc9/dependencies/include" , "dep/tolua++/tolua++-1.0.93/include"}
	project "sigcpp"
		kind "SharedLib"
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
		defines { "HAVE_CONFIG_H" }
	project "skstream"
		kind "StaticLib"
		tmpdir="worldforge/skstream/skstream/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		defines { "HAVE_GAI_STRERROR" }
		includedirs { "worldforge/skstream" }
		--links { "ws2_32" }
		defines { "HAVE_CONFIG_H" }
	project "atlas-cpp"
		kind "StaticLib"
		tmpdir="worldforge/atlas-cpp/Atlas/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		excludes {
			tmpdir .. "Bindings/**",
			tmpdir .. "Codecs/XMLish.cpp",
			tmpdir .. "Message/Layer.*",
			tmpdir .. "Factory.*"
		}
		includedirs {
			"worldforge/atlas-cpp",
			"dep/CEGUI-SDK-0.7.5-vc9/dependencies/include",
		}
		defines { "HAVE_CONFIG_H" }
	project "wfmath"
		kind "StaticLib"
		tmpdir="worldforge/wfmath/wfmath/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		excludes { "worldforge/wfmath/wfmath/*_test*" }
		excludes { "worldforge/wfmath/wfmath/unused/*" }
		includedirs { "worldforge/wfmath", tmpdir }
		defines { "HAVE_CONFIG_H" }
	project "mercator"
		kind "StaticLib"
		tmpdir="worldforge/mercator/Mercator/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		includedirs { "worldforge/mercator", "worldforge/wfmath", tmpdir }
		--links { "wfmath" }
		defines { "HAVE_CONFIG_H" }
	project "eris"
		kind "StaticLib"
		tmpdir="worldforge/eris/Eris/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		excludes { tmpdir .. "UIFactory.*" }
		includedirs {
			"worldforge/eris",
			"worldforge/mercator",
			"worldforge/skstream",
			"worldforge/atlas-cpp",
			"worldforge/wfmath",
			"dep/CEGUI-SDK-0.7.5-vc9/dependencies/include",
			"dep/libcurl/include",
			"dep/libsigc++-2.2.9",
			"dep/libsigc++-2.2.9/MSVC_Net2008",
			"dep/dirent"
		}
		defines { "HAVE_CONFIG_H" }
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
		defines { "TIXML_USE_STL", "HAVE_CONFIG_H" }
		
--Ember starts here!

	ember_src = "worldforge/ember/src/"
	
	--libraries to link Ember
	ember_links = {
		"libboost_thread-vc90-mt-gd-1_44",
		"OgreMain_d",
		"ws2_32",
		"toluapp",
		"sigcpp",
		"varconf",
		"wfmath",
		"libwfut",
		"atlas-cpp",
		"skstream",
		"mercator",
		"eris",
		"shlwapi",
		"SDL",
		"SDLmain",
		"OpenAL32",
		"zlib",
		"curllib",
		"alut",
		"lua_d",
		"CEGUIBase_d",
		"CEGUILuaScriptModule_d",
		"CEGUIOgreRenderer_d",
	}
	ember_libdirs = {
		"dep/OgreSDK_vc9_v1-7-2/boost_1_44/lib",
		"dep/SDL-1.2.14/lib",
		"c:/Program Files/OpenAL 1.1 SDK/libs/Win32",
		"dep/freealut-1.1.0-bin/lib",
		"dep/libcurl/lib/Debug",
		"dep/CEGUI-SDK-0.7.5-vc9/dependencies/lib/dynamic",
		"dep/CEGUI-SDK-0.7.5-vc9/lib",
		"dep/OgreSDK_vc9_v1-7-2/lib/debug",
	}
	--include directories
	ember_includes = {
		ember_src,
		ember_src .. "components/ogre/environment/caelum/include",
		ember_src .. "components/ogre/environment/pagedgeometry/include",
		ember_src .. "components/ogre/SceneManagers/EmberPagingSceneManager/include",
		ember_src .. "components/ogre",
		"worldforge/varconf",
		"worldforge/wfmath",
		"worldforge/skstream",
		"worldforge/atlas-cpp",
		"worldforge/mercator",
		"worldforge/eris",
		"worldforge/libwfut",
		"dep/libsigc++-2.2.9/MSVC_Net2008",
		"dep/libsigc++-2.2.9",
		"dep/tolua++/tolua++-1.0.93/include",
		"dep/CEGUI-SDK-0.7.5-vc9/dependencies/include",
		--"dep/CEGUI-SDK-0.7.5-vc9/cegui/include/ScriptingModules/LuaScriptModule/support/tolua++",
		"dep/CEGUI-SDK-0.7.5-vc9/cegui/include",
		"dep/SDL-1.2.14/include",
		"dep/OgreSDK_vc9_v1-7-2/include/OGRE",
		"dep/OgreSDK_vc9_v1-7-2/boost_1_44",
		"dep/libcurl/include",
		"$(OPENAL_DIR)/include",
		"c:\\Program Files\\OpenAL 1.1 SDK\\include",
		"dep/freealut-1.1.0-bin/include"
		
	}
	
	--preprocessor definitions
	ember_defines = {
		"HAVE_CONFIG_H",
		'PREFIX="./PREFIX"',
		'EMBER_SYSCONFDIR="/SYSCONFDIR"',
		'EMBER_DATADIR="/media/DATADIR"',
		"BOOST_THREAD_USE_LIB",
		"EMBER_LOG_SHOW_ORIGIN",
	}
	
	--excluded files
	ember_excludes = {
		ember_src .. "components/carpenter/**",
		ember_src .. "components/ogre/jesus/**",
		ember_src .. "components/ogre/ogreopcode/**",
		ember_src .. "components/ogre/environment/hydrax/**",
		ember_src .. "components/ogre/environment/HydraxWater.*",
		ember_src .. "components/ogre/widgets/IngameEventsWidget.*",
		ember_src .. "components/ogre/widgets/JesusEdit.*",
		ember_src .. "components/ogre/environment/Opcode*",
		ember_src .. "components/ogre/Opcode*",
		ember_src .. "components/ogre/opcode*",
		ember_src .. "framework/ServiceManager.*",
		ember_src .. "main/macosx/**",
		ember_src .. "components/ogre/SceneManagers/EmberPagingSceneManager/src/OgrePagingLandScapeIntersectionSceneQuery.cpp",
	}
	--this will add files to subproject and automatically exclude from ember main project
	function ember_subproject_files(myfiles)
		files(myfiles)
		excludes ( ember_excludes )
		for k,v in ipairs(myfiles) do table.insert(ember_excludes, v) end
	end
	--will create a staticlib with all files in given folder
	function ember_subproject(name, dir)
		table.insert(ember_links, name)
		project(name)
			kind "StaticLib"
			ember_subproject_files { dir .. "/**.h", dir .. "/**.cpp", dir .. "/**.c" }
			includedirs(ember_includes)
			defines(ember_defines)
		
	end

	--this will generate a tolua binding
	function ember_tolua_project(pkgfile)
		local dir = path.rebase(".",path.getabsolute("."), path.getdirectory(pkgfile)) .. "/" --root dir from pkgfile's directory
		local tolua = "dep/tolua++/tolua++" --tolua location
		local name = path.getbasename(pkgfile) --project name
		local outfolder = "worldforge/ember/src_tolua/"
		local outfile = outfolder .. name .. ".cxx"
		
		print("Generating src_tolua/" .. name .. ".cxx...")
		os.mkdir( outfolder )
		os.chdir( path.getdirectory( pkgfile))--change current directory to pkg file
			local cmd = path.translate(dir .. tolua .. " -o " .. dir .. outfile .. " " .. path.getname(pkgfile) )
			--print( cmd )
			os.execute( cmd )
		os.chdir(dir)--change current directory back to root
		
		table.insert(ember_links, "lua_" .. name)--link project to ember
		project("lua_" .. name)
			kind "StaticLib"
			files { outfile }
			local tmp = path.getdirectory(pkgfile) .. "/required.h"
			if os.isfile( tmp ) then
				ember_subproject_files { tmp }
			end
			includedirs { path.getdirectory( pkgfile) }
			includedirs(ember_includes)
			defines(ember_defines)
		
	end
	
	ember_tolua_project(ember_src .. "bindings/lua/ConnectorDefinitions.pkg")
	project "lua_ConnectorDefinitions" --extend with extra files
		ember_subproject_files { ember_src .. "bindings/lua/TypeResolving.*" }
		
	ember_tolua_project(ember_src .. "components/lua/bindings/lua/Lua.pkg")
	ember_tolua_project(ember_src .. "components/ogre/scripting/bindings/lua/EmberOgre.pkg")
	ember_tolua_project(ember_src .. "components/ogre/scripting/bindings/lua/helpers/Helpers.pkg")
	project "lua_Helpers"
		ember_subproject_files { ember_src .. "components/ogre/scripting/bindings/lua/helpers/OgreUtils.*" }

	ember_tolua_project(ember_src .. "components/ogre/scripting/bindings/lua/ogre/Ogre.pkg")
	ember_tolua_project(ember_src .. "components/ogre/widgets/adapters/atlas/bindings/lua/AtlasAdapters.pkg")
	ember_tolua_project(ember_src .. "framework/bindings/lua/Framework.pkg")
	ember_tolua_project(ember_src .. "framework/bindings/lua/atlas/Atlas.pkg")
	ember_tolua_project(ember_src .. "framework/bindings/lua/eris/Eris.pkg")
	ember_tolua_project(ember_src .. "framework/bindings/lua/varconf/Varconf.pkg")
	ember_tolua_project(ember_src .. "main/bindings/lua/Application.pkg")
	ember_tolua_project(ember_src .. "services/bindings/lua/EmberServices.pkg")
	
	ember_subproject("EntityMapping", ember_src .. "components/entitymapping")
	ember_subproject("Lua", ember_src .. "components/lua")
	ember_subproject("MeshTree", ember_src .. "components/ogre/environment/meshtree")
	ember_subproject("pagedgeometry", ember_src .. "components/ogre/environment/pagedgeometry")
	ember_subproject("Tasks", ember_src .. "framework/tasks")
	ember_subproject("Framework", ember_src .. "framework")
	

	
--Caelum
	project "Caelum"
		defines { "CAELUM_LIB", "CAELUM_USE_PRECOMPILED" }
		pchheader(ember_src .. "components/ogre/environment/caelum/include/CaelumPrecompiled.h")
		pchsource(ember_src .. "components/ogre/environment/caelum/src/CaelumPrecompiled.cpp")
		buildoptions { "-Zm200", "/wd4305", "/wd4244" }
		links("OgreMain_d")
		libdirs(ember_libdirs)
	ember_subproject("Caelum", ember_src .. "components/ogre/environment/caelum")
	project "Caelum"
		kind "SharedLib"

--services
	ember_subproject("ConfigService", ember_src .. "services/config")
	
	ember_subproject("LoggingService", ember_src .. "services/logging")
	ember_subproject("MetaserverService", ember_src .. "services/metaserver")
	ember_subproject("ScriptingService", ember_src .. "services/scripting")
	ember_subproject("ServerService", ember_src .. "services/server")
	ember_subproject("ServerSettings", ember_src .. "services/serversettings")
	ember_subproject("SoundService", ember_src .. "services/sound")
	ember_subproject("Time", ember_src .. "services/time")
	ember_subproject("Wfut", ember_src .. "services/wfut")
	ember_subproject("InputService", ember_src .. "services/input")
	project "InputService"
		defines { "WITHOUT_SCRAP" }	
	ember_subproject("Services", ember_src .. "services")
		
--EmberPagingSceneManager
	project "EmberPagingSceneManager"
		defines { "_PRECOMPILED_HEADERS" }
		buildoptions { "-Zm200" }
		pchheader(ember_src .. "components/ogre/SceneManagers/EmberPagingSceneManager/include/OgrePagingLandScapePrecompiledHeaders.h")
		pchsource(ember_src .. "components/ogre/SceneManagers/EmberPagingSceneManager/src/OgrePagingLandScapePrecompiledHeaders.cpp")
		--libdirs(ember_libdirs)
		--for i=1,#ember_links do
		--	print(ember_links[i])
		--	if ember_links[i] == "InputService" then
		--		table.remove(ember_links, i)
		--	end
		--end
		
		--links ( ember_links )
		--links { "EmberOgre" }
		--configuration "Debug"
		--	libdirs { "dep/OgreSDK_vc9_v1-7-2/lib/debug" }
		--	links { "OgreMain_d", "libboost_thread-vc90-mt-gd-1_44" }
		--configuration "Release"
		--	libdirs { "dep/OgreSDK_vc9_v1-7-2/lib/release" }
		--	links { "OgreMain", "libboost_thread-vc90-mt-1_44" }
	ember_subproject("EmberPagingSceneManager", ember_src .. "components/ogre/SceneManagers/EmberPagingSceneManager")
	--project "EmberPagingSceneManager"
	--	kind "SharedLib"
	
--EmberOgre
	project "EmberOgre"
		buildoptions { "-Zm200", '/FI "EmberOgrePrecompiled.h"' }
		pchheader(ember_src .. "components/ogre/EmberOgrePrecompiled.h")
		pchsource(ember_src .. "components/ogre/EmberOgrePrecompiled.cpp")
	ember_subproject("EmberOgre", ember_src .. "components/ogre")
		
--Ember
	project "Ember"
		kind "WindowedApp"
		flags "WinMain"
		files { ember_src .. "**.h", ember_src .. "**.cpp", ember_src .. "**.c" }
		files { ember_src .. "main/win32/OgreWin32Resources.rc" }
		excludes ( ember_excludes )
		includedirs(ember_includes)
		defines(ember_defines)
		links(ember_links)
		libdirs(ember_libdirs)
	
--Footer
	os.mkdir("prj")
	--loop through all projects and do some post-processing
	local prjs = solution().projects
	for i, prj in ipairs(prjs) do
		project ( prj.name )
			location ( "prj" )
			configuration "Debug"
				targetsuffix("_d")
			configuration { "Debug", "SharedLib or WindowedApp or ConsoleApp" }
				linkoptions { "/NOD" } --no default lib
				links { "msvcrtd", "msvcprtd" } --force link runtime
			configuration { "Release", "SharedLib or WindowedApp or ConsoleApp" }
				linkoptions { "/NOD" } --no default lib
				links { "msvcrt", "msvcprt" } --force link runtime
	end