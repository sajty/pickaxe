function install_firebreath()
	os.mkdir(repo_dir .. "/FireBreath/build")
	push_chdir(repo_dir .. "/FireBreath/build")
		os.execute('cmake -DFB_PROJECTS_DIR="../WebEmber/plugin" -DBUILD_EXAMPLES=false -G"Visual Studio 9 2008" ..')
	pop_chdir()
end

if _OPTIONS["webember"] then
	install_firebreath();
end

function build_media()
--get media
	local media_dir = build_dir .. "/share/ember/media"
	os.mkdir(media_dir)
	local rsync = dep_dir .. "/rsync/rsync.exe"
	rsync= iif(os.isfile(rsync), '"' .. rsync .. '"', "rsync")
	push_chdir(media_dir)
		cmd = path.translate(rsync) .. " -rtvzu amber.worldforge.org::media-dev ."
		--print(cmd)
		os.execute(cmd)
	pop_chdir()
	
--create build/share/ember/media/shared/
	local components = repo_dir .. "/ember/src/components/"
	local shared = media_dir .. "/shared/"
	os.copydir(components .. "ogre/authoring/entityrecipes", shared .. "entityrecipes", "**.entityrecipe")
	os.copydir(components .. "cegui/datafiles", shared .. "gui/cegui/datafiles")
	os.copydir(components .. "ogre/widgets", shared .. "gui/cegui/datafiles/layouts", "**.layout")
	os.copydir(components .. "cegui/datafiles", shared .. "gui", "**.xsd", true) -- copy to single dir
	os.copydir(components .. "ogre/widgets", shared .. "gui", "**.xsd", true) -- copy to single dir and overwrite
	os.copyfile(components .. "cegui/datafiles/configs/cegui.config", shared .. "gui/cegui/datafiles/configs/cegui.config")
	os.copydir(components .. "ogre/data", shared .. "data")
	os.copydir(components .. "ogre/widgets", shared .. "scripting/lua", "**.lua")
	os.copydir(components .. "ogre/sounddefinitions", shared .. "sounddefinitions")
	
--create build/etc/ember
	os.copyfile(repo_dir .. "/ember/ember.conf", build_dir .. "/etc/ember/ember.conf")
	os.copydir(repo_dir .. "/ember/src/components/ogre", build_dir .. "/etc/ember", "**.cfg",true)
	
end

build_media()

--configure project files
solution(project_name)
	project(project_name)
		--first project is the startup project
	project "sigcpp"
		kind "SharedLib"
		tmpdir=dep_dir .. "/libsigc++-2.2.9/sigc++/"
		files { tmpdir .. "**.h", tmpdir .. "**.cc" }
	if _ACTION == "vs2008" then
		files { tmpdir .. "../MSVC_Net2008/**.h", tmpdir .. "../MSVC_Net2008/**.cpp" }
	else
		files { tmpdir .. "../MSVC_Net2010/**.h", tmpdir .. "../MSVC_Net2010/**.cpp" }
	end
		excludes { tmpdir .. "../**Pax**" }
		includedirs { include_dir .. "/sigc++",include_dir }
		defines { "SIGC_BUILD" }
		
	project "curl"
		kind "SharedLib"
		tmpdir=dep_dir .. "/curl-7.25.0/lib/"
		files { tmpdir .. "**.h", tmpdir .. "**.c" }
		excludes { tmpdir .. "nw*.c", tmpdir .. "amigaos.c" }
		includedirs { include_dir }
		defines { "BUILDING_LIBCURL" }
		links { "ws2_32", "wldap32", "oldnames" }
	project "freealut"
		kind "SharedLib"
		tmpdir=dep_dir .. "/freealut-1.1.0-src/src/"
		files { tmpdir .. "**.h", tmpdir .. "**.c" }
		includedirs { include_dir }
		defines {
			"ALUT_EXPORTS",
			"ALUT_BUILD_LIBRARY",
			"HAVE__STAT",
			"HAVE_BASETSD_H",
			"HAVE_SLEEP",
			"HAVE_WINDOWS_H"
		}
		links { "odbc32", "odbccp32" }
		require("usages/usage_openal")
		use_OpenAL()
	project "ois"
		kind "StaticLib"
		tmpdir=repo_dir .. "/ois/"
		files { tmpdir .. "/include/*.h", tmpdir .. "/src/*.cpp" }
		defines { "OIS_NONCLIENT_BUILD" }
		
		if os.is("windows") then
			require("usages/usage_directx")
			use_DirectX({"dinput8", "dxguid"})
		end
		
		includedirs {
			tmpdir .. "/src",
			tmpdir .. "/includes",
		}
		configuration "windows"
			files { tmpdir .. "/src/win32/*.cpp" }
		configuration { "not vs*", "windows" }
			links { "ole32", "oleaut32"}
		configuration "linux"
			includedirs { "/usr/X11R6/include" }
			files { tmpdir .. "/src/linux/*.cpp" }
		configuration "macosx"
			files { tmpdir .. "/src/mac/*.cpp" }
		
	project "varconf"
		kind "StaticLib"
		tmpdir=repo_dir .. "/varconf/varconf/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		includedirs { repo_dir .. "/varconf", include_dir .. "" }
		--links { "sigcpp" }
		defines { "HAVE_CONFIG_H", "BUILDING_VARCONF_DSO" }
		
	project "skstream"
		kind "StaticLib"
		tmpdir=repo_dir .. "/skstream/skstream/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		defines { "HAVE_GAI_STRERROR" }
		includedirs { repo_dir .. "/skstream" }
		--links { "ws2_32" }
		defines { "HAVE_CONFIG_H" }
		
	project "atlas-cpp"
		kind "StaticLib"
		tmpdir=repo_dir .. "/atlas-cpp/Atlas/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		excludes {
			tmpdir .. "Bindings/**",
			tmpdir .. "Codecs/XMLish.cpp",
			tmpdir .. "Message/Layer.*",
			tmpdir .. "Factory.*"
		}
		includedirs {
			repo_dir .. "/atlas-cpp",
			include_dir .. "/zlib",
		}
		defines { "HAVE_CONFIG_H" }
		
	project "wfmath"
		kind "StaticLib"
		tmpdir=repo_dir .. "/wfmath/wfmath/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		excludes { repo_dir .. "/wfmath/wfmath/*_test*" }
		excludes { repo_dir .. "/wfmath/wfmath/unused/*" }
		includedirs { repo_dir .. "/wfmath", tmpdir }
		defines { "HAVE_CONFIG_H" }
		
	project "mercator"
		kind "StaticLib"
		tmpdir=repo_dir .. "/mercator/Mercator/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		includedirs { repo_dir .. "/mercator", repo_dir .. "/wfmath", tmpdir }
		--links { "wfmath" }
		defines { "HAVE_CONFIG_H" }
		
	project "eris"
		kind "StaticLib"
		tmpdir=repo_dir .. "/eris/Eris/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		excludes { tmpdir .. "UIFactory.*" }
		includedirs {
			repo_dir .. "/eris",
			repo_dir .. "/mercator",
			repo_dir .. "/skstream",
			repo_dir .. "/atlas-cpp",
			repo_dir .. "/wfmath",
			--dep_dir .. "/CEGUI-SDK-0.7.5-vc10/dependencies/include",
			include_dir .. "",
		}
		defines { "HAVE_CONFIG_H" }
		--links { "sigcpp" }
		
	project "libwfut"
		kind "StaticLib"
		tmpdir=repo_dir .. "/libwfut/libwfut/"
		files { tmpdir .. "**.h", tmpdir .. "**.cpp", tmpdir .. "**.c" }
		includedirs {
			repo_dir .. "/libwfut",
			include_dir .. "/zlib",
			include_dir .. "",
		}
		defines { "TIXML_USE_STL", "HAVE_CONFIG_H" }
		
--Ember starts here!

	ember_src = repo_dir .. "/ember/src/"
	debug_ember_links = {
		"OgreMain_d",
		"lua_d",
		"CEGUIBase_d",
		"CEGUILuaScriptModule_d",
		"CEGUIOgreRenderer_d",
		"tolua++_d"
	}
	release_ember_links = {
		"OgreMain",
		"lua",
		"CEGUIBase",
		"CEGUILuaScriptModule",
		"CEGUIOgreRenderer",
		"tolua++"
	}
	if _ACTION == "vs2008" then
		table.insert(debug_ember_links,"libboost_thread-vc90-mt-gd-1_44")
		table.insert(release_ember_links,"libboost_thread-vc90-mt-1_44")
	else
		table.insert(debug_ember_links,"libboost_thread-vc100-mt-gd-1_44")
		table.insert(release_ember_links,"libboost_thread-vc100-mt-1_44")
	end
	
	--libraries to link Ember
	ember_links = {
		"ws2_32",
		"sigcpp",
		"varconf",
		"wfmath",
		"libwfut",
		"atlas-cpp",
		"skstream",
		"mercator",
		"eris",
		"ois",
		"shlwapi",
		"zlib",
		"curl",
		"freealut",
		"SDL",
		"SDLmain"
	}
	
	if _ACTION == "vs2008" then
		OgreSDK_dir="OgreSDK_vc9_v1-7-2"
		CeguiSDK_dir="CEGUI-SDK-0.7.5-vc9"
	else
		OgreSDK_dir="OgreSDK_vc10_v1-7-2"
		CeguiSDK_dir="CEGUI-SDK-0.7.5-vc10"
	end
	debug_ember_libdirs = {
		dep_dir .. "/" .. OgreSDK_dir .. "/lib/debug",
	}
	release_ember_libdirs = {
		dep_dir .. "/" .. OgreSDK_dir .. "/lib/release",
	}
	ember_libdirs = {
		dep_dir .. "/" .. OgreSDK_dir .. "/boost_1_44/lib",
		dep_dir .. "/SDL-1.2.14/lib",
		dep_dir .. "/freealut-1.1.0-bin/lib",
		dep_dir .. "/" .. CeguiSDK_dir .. "/lib",
		dep_dir .. "/" .. CeguiSDK_dir .. "/dependencies/lib/dynamic",
	}
	
	require("usages/usage_openal")
	
	--include directories
	ember_includes = {
		ember_src,
		ember_src .. "components/ogre/environment/caelum/include",
		ember_src .. "components/ogre/environment/pagedgeometry/include",
		ember_src .. "components/ogre/SceneManagers/EmberPagingSceneManager/include",
		ember_src .. "components/ogre",
		repo_dir .. "/varconf",
		repo_dir .. "/wfmath",
		repo_dir .. "/skstream",
		repo_dir .. "/atlas-cpp",
		repo_dir .. "/mercator",
		repo_dir .. "/eris",
		repo_dir .. "/libwfut",
		repo_dir .. "/ois/includes", 
		include_dir .. "/tolua++",
		include_dir .. "/lua",
		include_dir .. "/zlib",
		include_dir .. "/cegui",
		include_dir .. "/SDL",
		include_dir .. "/OGRE",
		include_dir .. "/boost",
		include_dir,
		OpenAL_SDK.includedir
	}
	
	--preprocessor definitions
	ember_defines = {
		"HAVE_CONFIG_H",
		'PREFIX="."',
		'EMBER_SYSCONFDIR="/"',
		'EMBER_DATADIR="/"',
		"BOOST_THREAD_USE_LIB",
		"EMBER_LOG_SHOW_ORIGIN",
		"WITHOUT_SCRAP",
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
		local tolua = dep_dir .. "/" .. CeguiSDK_dir .. "/bin/tolua++cegui_Static.exe" --tolua location
		local name = path.getbasename(pkgfile) --project name
		local outfolder = repo_dir .. "/ember/src_tolua/"
		local outfile = outfolder .. name .. ".cxx"
		print("Generating src_tolua/" .. name .. ".cxx...")
		
		os.copyfile(pkgfile,pkgfile .. "~")
		
		local f = io.open(pkgfile)
		local s = f:read("*a")
		f:close()
		
			s = string.gsub(s, "$pfile(.-)\n", "$pfile%1\n\n")
			
		local f = io.open(pkgfile, "w+")
		f:write(s)
		f:close()
		
		os.mkdir( outfolder )
		push_chdir( path.getdirectory( pkgfile))--change current directory to pkg file
			local cmd = path.translate(tolua .. " " .. path.getname(pkgfile) .. " > " .. outfile )
			--print( cmd )
			os.execute( cmd )
		pop_chdir()--change current directory back to root
		
		os.copyfile(pkgfile .. "~",pkgfile)
		local f = io.open(outfile)
		local s = f:read("*a")
		f:close()
		
			if s:find("** tolua internal error") ~= nil then error("tolua++ compilation failed!") end
			s = s:gsub("const,", "const ")
			s = s:gsub("tolua_outside", "")
			s = s:gsub("tolua(+)(+).h", "components/lua/tolua++.h")
			s = s:gsub("%(const Ember::Input::MouseButton%)", "(const Ember::Input::MouseButton)(int)")
			s = s:gsub("%(const Ember::Log::MessageImportance%)", "(const Ember::Log::MessageImportance)(int)")
			
		local f = io.open(outfile, "w+")
		f:write(s)
		f:close()
		
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
		ember_subproject_files { ember_src .. "bindings/lua/TypeResolving.*" }
		
	ember_tolua_project(ember_src .. "components/lua/bindings/lua/Lua.pkg")
	ember_tolua_project(ember_src .. "components/ogre/scripting/bindings/lua/EmberOgre.pkg")
	ember_tolua_project(ember_src .. "components/ogre/scripting/bindings/lua/helpers/Helpers.pkg")
		ember_subproject_files { ember_src .. "components/ogre/scripting/bindings/lua/helpers/OgreUtils.*" }

	ember_tolua_project(ember_src .. "components/ogre/scripting/bindings/lua/ogre/Ogre.pkg")
	ember_tolua_project(ember_src .. "components/ogre/widgets/adapters/bindings/lua/Adapters.pkg")
	ember_tolua_project(ember_src .. "components/ogre/widgets/adapters/atlas/bindings/lua/AtlasAdapters.pkg")
	ember_tolua_project(ember_src .. "components/ogre/widgets/representations/bindings/lua/Representations.pkg")
	ember_tolua_project(ember_src .. "domain/bindings/lua/Domain.pkg")
	ember_tolua_project(ember_src .. "framework/bindings/lua/Framework.pkg")
	ember_tolua_project(ember_src .. "framework/bindings/lua/atlas/Atlas.pkg")
	ember_tolua_project(ember_src .. "framework/bindings/lua/eris/Eris.pkg")
	ember_tolua_project(ember_src .. "framework/bindings/lua/varconf/Varconf.pkg")
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
		libdirs(ember_libdirs)
		configuration "Debug"
			links("OgreMain_d")
			libdirs(debug_ember_libdirs)
		configuration "Release*"
			links("OgreMain")
			libdirs(release_ember_libdirs)
	ember_subproject("Caelum", ember_src .. "components/ogre/environment/caelum")
		kind "SharedLib"

--services
	ember_subproject("ConfigService", ember_src .. "services/config")
	ember_subproject("LoggingService", ember_src .. "services/logging")
	ember_subproject("MetaserverService", ember_src .. "services/metaserver")
	ember_subproject("ScriptingService", ember_src .. "services/scripting")
	ember_subproject("ServerService", ember_src .. "services/server")
	ember_subproject("ServerSettings", ember_src .. "services/serversettings")
	ember_subproject("SoundService", ember_src .. "services/sound")
	ember_subproject("Wfut", ember_src .. "services/wfut")
	ember_subproject("InputService", ember_src .. "services/input")
	ember_subproject("Services", ember_src .. "services")
		
--EmberPagingSceneManager
	project "EmberPagingSceneManager"
		defines { "_PRECOMPILED_HEADERS" }
		buildoptions { "-Zm200" }
		pchheader(ember_src .. "components/ogre/SceneManagers/EmberPagingSceneManager/include/OgrePagingLandScapePrecompiledHeaders.h")
		pchsource(ember_src .. "components/ogre/SceneManagers/EmberPagingSceneManager/src/OgrePagingLandScapePrecompiledHeaders.cpp")
	ember_subproject("EmberPagingSceneManager", ember_src .. "components/ogre/SceneManagers/EmberPagingSceneManager")
	
--EmberOgre
	project "EmberOgre"
		buildoptions { "-Zm200", '/FI "EmberOgrePrecompiled.h"' }
		pchheader(ember_src .. "components/ogre/EmberOgrePrecompiled.h")
		pchsource(ember_src .. "components/ogre/EmberOgrePrecompiled.cpp")
	ember_subproject("EmberOgre", ember_src .. "components/ogre")
		
--Ember/WebEmber
	project(project_name)
		files { ember_src .. "**.h", ember_src .. "**.cpp", ember_src .. "**.c" }
		files { ember_src .. "main/win32/OgreWin32Resources.rc" }

	if project_name == "WebEmber" then
		kind "SharedLib"
		excludes { ember_src .. "main/Ember.cpp" }
	else
		kind "WindowedApp"
		flags "WinMain"
		excludes { ember_src .. "extensions/webember/*" }
	end
		excludes ( ember_excludes )
		includedirs(ember_includes)
		defines(ember_defines)
		links(ember_links)
		libdirs(ember_libdirs)
		
		require("usages/usage_openal")
		use_OpenAL()
		
		configuration "Debug"
			links( debug_ember_links )
			libdirs( debug_ember_libdirs )
		configuration "Release*"
			links( release_ember_links )
			libdirs( release_ember_libdirs )