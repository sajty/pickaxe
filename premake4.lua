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
			tmpdir .. "Bindings/**",
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
		
--Ember starts here!

	ember_src = "worldforge/ember/src/"
	
	--libraries to link Ember
	ember_links = {
		"ws2_32",
		"sigcpp",
		"varconf",
		"wfmath",
		"skstream",
		"mercerator",
		"eris"
	}
	
	--include directories
	ember_includes = {
		"worldforge/ember/src_tolua",
		ember_src,
		ember_src .. "components/ogre/environment/caelum/include",
		ember_src .. "components/ogre/environment/pagedgeometry/include",
		"worldforge/varconf",
		"worldforge/wfmath",
		"worldforge/skstream",
		"worldforge/atlas-cpp",
		"worldforge/mercator",
		"worldforge/eris",
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
		"dep/libcurl/include",
	}
	
	--preprocessor definitions
	ember_defines = {
		"HAVE_CONFIG_H",
		'PREFIX="."',
		'EMBER_SYSCONFDIR="."',
		'EMBER_DATADIR="./media"',
	}
	
	--excluded files
	ember_excludes = {
		ember_src .. "components/carpenter/**",
		ember_src .. "components/ogre/jesus/**",
		ember_src .. "components/ogre/ogreopcode/**",
		ember_src .. "components/ogre/environment/hydrax/**",
		ember_src .. "components/ogre/environment/HydraxWater.*",
		ember_src .. "components/ogre/environment/IngameEventsWidget.*",
		ember_src .. "components/ogre/environment/JesusEdit.*",
		ember_src .. "components/ogre/environment/Opcode*",
		ember_src .. "framework/ServiceManager.*",
		ember_src .. "framework/ConfigBoundLogObserver.*",
		ember_src .. "main/macosx/**",
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
	local dir = os.getcwd() .. "/" --current working dir
	local tolua = dir .. "dep/tolua++/tolua++" --tolua location
	local name = path.getbasename(pkgfile) --project name
	local outfolder = dir .. "worldforge/ember/src_tolua/"
	local outfile = outfolder .. name .. ".cxx"
	
	print("Generating lua_" .. name)
	os.mkdir( outfolder )	
	os.chdir( path.getdirectory( dir .. pkgfile))
		os.execute(tolua .. " -o " .. outfile .. " " .. path.getname(pkgfile))
	os.chdir(dir)
	
	table.insert(ember_links, "lua_" .. name)
	project("lua_" .. name)
		kind "StaticLib"
		files { outfile }
		local tmp = path.getdirectory( dir .. pkgfile) .. "/required.h"
		if os.isfile( tmp ) then
			ember_subproject_files { tmp }
		end
		includedirs { path.getdirectory( dir .. pkgfile) }
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
		ember_subproject_files { ember_src .. "bindings/lua/OgreUtils.*" }

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
	ember_subproject("Caelum", ember_src .. "components/ogre/environment/caelum")
	project "Caelum"
		defines { "CAELUM_LIB" }
		kind "SharedLib"
		
	ember_subproject("MeshTree", ember_src .. "components/ogre/environment/meshtree")
	ember_subproject("pagedgeometry", ember_src .. "components/ogre/environment/pagedgeometry")
	ember_subproject("EmberPagingSceneManager", ember_src .. "components/ogre/SceneManagers/EmberPagingSceneManager")
	--defines { "OGRE_PCZPLUGIN_EXPORTS", "Plugin_PCZSceneManager_EXPORTS" }
	ember_subproject("EmberOgre", ember_src .. "components/ogre")
	ember_subproject("Tasks", ember_src .. "framework/tasks")
	ember_subproject("Framework", ember_src .. "framework")
	ember_subproject("ConfigService", ember_src .. "services/config")
	ember_subproject("InputService", ember_src .. "services/input")
	ember_subproject("LoggingService", ember_src .. "services/logging")
	ember_subproject("MetaserverService", ember_src .. "services/metaserver")
	ember_subproject("ScriptingService", ember_src .. "services/scripting")
	ember_subproject("ServerService", ember_src .. "services/server")
	ember_subproject("ServerSettings", ember_src .. "services/serversettings")
	ember_subproject("SoundService", ember_src .. "services/sound")
	ember_subproject("Time", ember_src .. "services/time")
	ember_subproject("Wfut", ember_src .. "services/wfut")
	ember_subproject("Services", ember_src .. "services")
	
	project "Ember"
		kind "ConsoleApp"
		files { ember_src .. "**.h", ember_src .. "**.cpp", ember_src .. "**.c" }
		files { ember_src .. "main/win32/OgreWin32Resources.rc" }
		excludes ( ember_excludes )
		includedirs(ember_includes)
		defines(ember_defines)
		links(ember_links)
	
--Footer
	os.mkdir("prj")
	--loop through all projects and do some post-processing
	local prjs = solution().projects
	for i, prj in ipairs(prjs) do
		project ( prj.name )
			location ( "prj" )
			configuration "Debug"
				targetsuffix("_d")
	end