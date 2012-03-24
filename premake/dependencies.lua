
require("helpers")

if _ACTION == "vs2008" then
		OgreSDK_dir="OgreSDK_vc9_v1-7-2"
		CeguiSDK_dir="CEGUI-SDK-0.7.5-vc9"
else
		OgreSDK_dir="OgreSDK_vc10_v1-7-2"
		CeguiSDK_dir="CEGUI-SDK-0.7.5-vc10"
end

function build_binaries()
--DLLs
	os.mkdir(bin_dir)
	os.mkdir(bin_d_dir)
	--[[
	os.copyfile(dep_dir .. "/SDL-1.2.14/lib/SDL.dll", bin_dir .. "/SDL.dll")
	os.copyfile(dep_dir .. "/SDL-1.2.14/lib/SDL.dll", bin_d_dir .. "/SDL.dll")
	os.copyfile(dep_dir .. "/freealut-1.1.0-bin/lib/alut.dll", bin_dir .. "/alut.dll")
	os.copyfile(dep_dir .. "/freealut-1.1.0-bin/lib/alut.dll", bin_d_dir .. "/alut.dll")
	os.copydir(dep_dir .. "/libcurl/src/DLL-Release", bin_dir, "*.dll")
	os.copydir(dep_dir .. "/libcurl/src/DLL-Debug", bin_d_dir, "*.dll")
	os.copyfile(dep_dir .. "/libcurl/libeay32.dll", bin_d_dir .. "/libeay32.dll")
	os.copyfile(dep_dir .. "/libcurl/libeay32.dll", bin_dir .. "/libeay32.dll")
	os.copyfile(dep_dir .. "/libcurl/ssleay32.dll", bin_d_dir .. "/ssleay32.dll")
	os.copyfile(dep_dir .. "/libcurl/ssleay32.dll", bin_dir .. "/ssleay32.dll")
	--]]
--Ogre DLLs
	os.copyfile(dep_dir .. "/" .. OgreSDK_dir .. "/bin/release/cg.dll", bin_dir .. "/cg.dll")
	os.copyfile(dep_dir .. "/" .. OgreSDK_dir .. "/bin/debug/cg.dll", bin_d_dir .. "/cg.dll")
	local ogre_dlls = {"OgreMain", "Plugin_CgProgramManager", "Plugin_ParticleFX", "RenderSystem_Direct3D9", "RenderSystem_GL"}
	for k, v in ipairs( ogre_dlls ) do
		os.copyfile(dep_dir .. "/" .. OgreSDK_dir .. "/bin/release/" .. v .. ".dll", bin_dir .. "/" .. v .. ".dll")
		os.copyfile(dep_dir .. "/" .. OgreSDK_dir .. "/bin/debug/" .. v .. "_d.dll", bin_d_dir .. "/" .. v .. "_d.dll")
	end
	
--cegui DLLs
	os.copyfile(dep_dir .. "/" .. CeguiSDK_dir .. "/dependencies/bin/lua.dll", bin_dir .. "/lua.dll")
	os.copyfile(dep_dir .. "/" .. CeguiSDK_dir .. "/dependencies/bin/lua_d.dll", bin_d_dir .. "/lua_d.dll")
	local cegui_dlls = {"CEGUIBase", "CEGUIExpatParser", "CEGUIFalagardWRBase", "CEGUILuaScriptModule", "CEGUIOgreRenderer", "tolua++"}
	for k, v in ipairs( cegui_dlls ) do
		os.copyfile(dep_dir .. "/" .. CeguiSDK_dir .. "/bin/" .. v .. ".dll", bin_dir .. "/" .. v .. ".dll")
		os.copyfile(dep_dir .. "/" .. CeguiSDK_dir .. "/bin/" .. v .. "_d.dll", bin_d_dir .. "/" .. v .. "_d.dll")
		os.copyfile(dep_dir .. "/" .. CeguiSDK_dir .. "/bin/" .. v .. "_d.dll", bin_d_dir .. "/" .. v .. "_d.pdb") --symbol files
	end
	
--copy cegui media
--	os.copydir(dep_dir .. "/" .. CeguiSDK_dir .. "/datafiles", build_dir .. "/share/CEGUI")
end

function build_includes()
	--os.copydir( dep_dir .. "/" .. CeguiSDK_dir .. "/cegui/include" , include_dir .. "/cegui")
	--os.copydir( dep_dir .. "/" .. CeguiSDK_dir .. "/dependencies/include" , include_dir .. "/lua", "lua*")
	--os.copyfile( dep_dir .. "/" .. CeguiSDK_dir .. "/dependencies/include/lauxlib.h", include_dir .. "/lua/lauxlib.h")
	--os.copydir( dep_dir .. "/" .. CeguiSDK_dir .. "/dependencies/include" , include_dir .. "/zlib", "z*.h")
	--os.copydir( dep_dir .. "/" .. OgreSDK_dir .. "/include" , include_dir .. "")
	--os.copydir( dep_dir .. "/" .. OgreSDK_dir .. "/boost_1_44/boost", include_dir .. "/boost" )
	
	
	os.copydir( dep_dir .. "/" .. CeguiSDK_dir .. "/cegui/include" , include_dir .. "/cegui")
	os.copydir( dep_dir .. "/" .. CeguiSDK_dir .. "/dependencies/include" , include_dir .. "/lua", "lua*")
	os.copyfile( dep_dir .. "/" .. CeguiSDK_dir .. "/dependencies/include/lauxlib.h", include_dir .. "/lua/lauxlib.h")
	os.copydir( dep_dir .. "/" .. CeguiSDK_dir .. "/dependencies/include" , include_dir .. "/zlib", "z*.h")
	os.copyfile( dep_dir .. "/" .. CeguiSDK_dir .. "/cegui/include/ScriptingModules/LuaScriptModule/support/tolua++/tolua++.h", include_dir .. "/tolua++.h" )
	os.copydir( dep_dir .. "/" .. OgreSDK_dir .. "/include" , include_dir .. "")
	os.copydir( dep_dir .. "/" .. OgreSDK_dir .. "/boost_1_44/boost", include_dir .. "/boost" )
	
	os.copydir( dep_dir .. "/curl-7.25.0/include", include_dir, "**.h" )
	
	--os.copydir( dep_dir .. "/libcurl/include/curl", include_dir .. "/curl", "**.h" )
	--os.copydir( dep_dir .. "/SDL-1.2.14/include", include_dir .. "/SDL" )
	os.copydir( dep_dir .. "/libsigc++-2.2.9/sigc++", include_dir .. "/sigc++", "**.h" )
	os.copydir( dep_dir .. "/libsigc++-2.2.9/MSVC_Net2008", include_dir, "**.h" )
	--os.copydir( dep_dir .. "/tolua++/tolua++-1.0.93/include", include_dir .. "/tolua++")
	os.copydir( dep_dir .. "/freealut-1.1.0-src/include", include_dir, "**.h")
	
	if os.isfile("c:/Program Files/OpenAL 1.1 SDK/include/al.h") then
		os.copydir( "c:/Program Files/OpenAL 1.1 SDK/include", include_dir .. "/al" )
	end
end

--
-- Downloads and installs everything, needed to compile Ember
--
function install_dependencies()
	
	os.mkdir(dl_dir)
	os.mkdir(dep_dir)
	
	tmp = dl_dir .. "/rsync-3.0.8.tar.lzma"
	download("http://sajty.elementfx.com/rsync-3.0.8.tar.lzma", tmp, "-A \"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322)\"")
	extract(tmp, dep_dir .. "/rsync")
	extract(dep_dir .. "/rsync/rsync-3.0.8.tar", dep_dir .. "/rsync")	
	
	local tmp = dl_dir .. "/PortableGit-1.7.9-preview20120201.7z"
	download("http://msysgit.googlecode.com/files/PortableGit-1.7.9-preview20120201.7z", tmp)
	extract(tmp, dep_dir .. "/PortableGit")
	
	tmp = dl_dir .. "/" .. OgreSDK_dir .. ".exe"
	download("http://downloads.sourceforge.net/ogre/" .. OgreSDK_dir .. ".exe", tmp)
	extract(tmp, dep_dir)
	
	tmp = dl_dir .. "/" .. CeguiSDK_dir .. ".zip"
	download("http://prdownloads.sourceforge.net/crayzedsgui/" .. CeguiSDK_dir .. ".zip?download", tmp)
	extract(tmp, dep_dir)
	
	--tmp = dl_dir .. "/SDL-devel-1.2.14-VC8.zip"
	--download("http://www.libsdl.org/release/SDL-devel-1.2.14-VC8.zip", tmp)
	--extract(tmp, dep_dir)

	--tmp = dl_dir .. "/libcurl-7.19.3-win32-ssl-msvc.zip"
	--download("http://curl.linux-mirror.org/download/libcurl-7.19.3-win32-ssl-msvc.zip", tmp)
	--extract(tmp, dep_dir .. "/libcurl")
	--[[
	tmp = dl_dir .. "/tolua++.zip"
	download("http://www.codereactor.net/files/tolua++.zip", tmp)
	extract(tmp, dep_dir .. "/tolua++")
	
	tmp = dl_dir .. "/tolua++-1.0.93.tar.bz2"
	download("http://www.codenix.com/~tolua/tolua++-1.0.93.tar.bz2", tmp)
	extract(tmp, dep_dir .. "/tolua++")
	extract(dep_dir .. "/tolua++/tolua++-1.0.93.tar", dep_dir .. "/tolua++")
	--]]
	tmp=dl_dir .. "/libsigc++-2.2.9.tar.gz"
	download("http://caesar.acc.umu.se/pub/GNOME/sources/libsigc++/2.2/libsigc++-2.2.9.tar.gz", tmp)
	extract(tmp, dep_dir)
	extract(dep_dir .. "/libsigc++-2.2.9.tar", dep_dir)
		
	tmp = dl_dir .. "/freealut-1.1.0-src.zip"
	download("http://connect.creativelabs.com/openal/Downloads/ALUT/freealut-1.1.0-src.zip", tmp)
	extract(tmp, dep_dir)
	
	tmp = dl_dir .. "/curl-7.25.0.zip"
	download("http://curl.haxx.se/download/curl-7.25.0.zip", tmp)
	extract(tmp, dep_dir)
	
	require("usages/usage_openal")
	if OpenAL_SDK.isInstalled == false then
		tmp = dl_dir .. "/OpenAL11CoreSDK.zip"
		download("http://connect.creativelabs.com/openal/Downloads/OpenAL11CoreSDK.zip", tmp)
		extract(tmp, dep_dir)
		
		print("Please install OpenAL!")
		print("WARNING: you need to install openAL to the default location or set $(OPENAL_DIR)")
		os.execute(path.translate(dep_dir) .. "\\OpenAL11CoreSDK.exe")
		
		find_OpenAL()
		
		if OpenAL_SDK.isInstalled == false then
			print("WARNING: You don't have installed OpenAL to the default locaion.")
			print("You need to set $(OPENAL_DIR) environment variable manually!")
		end
	end
	build_binaries()
	build_includes()
end