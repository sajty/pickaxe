
--
-- Downloads a file from the internet
--
-- @param source
--    The source file from a webpage
-- @param destination
--    The local destination file
--
function download(source, destination)
	--path.translate() will make "/" to "\" in windows
	destination = path.translate(destination)
	
	if _OPTIONS["redownload"] or not os.isfile(destination) then
		local tmp="dl/tmp.bin"
		os.remove(destination)
		os.remove(tmp)
		print("Downloading " .. source)
		local ret = os.execute("curl -L -o " .. tmp .. " " .. source)
		if ret ~=0 then
			os.remove(tmp)
			error("Failed to download file")
		end
		os.rename(tmp,destination)
		os.remove(tmp)
	end
end

--
-- Extracts an archive
--
-- @param source
--    The archive file
-- @param destination
--    The directory to extract archive
--
function extract(source, destination)
	--path.translate() will make "/" to "\" in windows
	source = path.translate(source)
	destination = path.translate(destination)
	
	if os.isfile(source) then
		os.mkdir(destination)
		local ret = os.execute("7za x -y -o" .. destination .. " " .. source)
		if ret ~= 0 then
			error("Failed extracting " .. source .. " to " .. destination)
		end
	else
		error("Missing file: " .. source)
	end
end

--
-- Allows to clone a git repository
--
-- @param URL
--    The git URL
-- @param destination
--    Optional, allows to specify location for git clone
--
function git_clone(URL, destination)
	if destination then
		--path.translate() will make "/" to "\" in windows
		destination = path.translate(destination)
		os.mkdir(destination)
	else
		destination = ""
	end
	local ret = os.execute("..\\dep\\PortableGit\\bin\\git clone " .. URL .. " " .. destination)
	if ret ~=0 then
		error("Failed cloning git " .. URL)
	end
end

--
-- Checks, if dependencies are already installed.
--
-- @returns
--    True, if dependencies are installed
--
function isInstalled()
	-- if reinstall option is defined, remove lock
	if _OPTIONS["redownload"] or _OPTIONS["reinstall"] then
		os.remove("dep/installed.lock")
	end
	
	-- this file is generated, on the end of the install().
	-- if this file exists, the installation is already done.
	return os.isfile("dep/installed.lock")
end


--
-- Allows to copy files with a given pattern match.
-- It uses the premake4 patterns (**=recursive match, *=file match)
-- NOTE: It won't copy empty directories!
-- Example: we have a file: src/test.h
--        os.copypattern("src", "*.h", "include") makes include/test.h
--	os.copypattern(".", "src/*.h", "include") makes include/src/test.h
--	os.copypattern(".", "**.h", "include") makes include/src/test.h
--	os.copypattern(".", "**.h", "include", true) will force it to include. makes include/test.h
--
-- @param src_dir
--    Source directory, which will be copied to dst_dir.
-- @param pattern
--    The pattern, to filter the copy.
-- @param dst_dir
--    Destination directory to copy files.
-- @param single_dst_dir
--    Optional, allows to put all matches to dst_dir without subdirectories.
--    Only usefull in recursive (**) pattern.
--
function os.copypattern(src_dir, pattern, dst_dir, single_dst_dir)
	src_dir = src_dir .. "/"
	print('copy "' .. src_dir .. pattern .. '" to "' .. dst_dir .. '".')
	dst_dir = dst_dir .. "/"
	local dir_matches
	local dir = path.rebase(".",path.getabsolute("."), src_dir) .. "/" -- root dir from src_dir
	os.chdir( src_dir ) -- change current directory to src_dir
		if not single_dst_dir then
			dir_matches = os.matchdirs(pattern)
		end
		local matches = os.matchfiles(pattern)
	os.chdir( dir ) -- change current directory back to root
	
	local counter = 0
	if single_dst_dir or not pattern:find("**") then
		os.mkdir( path.getdirectory(dst_dir))
		for k, v in ipairs(matches) do
			if os.copyfile( src_dir .. v, dst_dir .. path.getname(v)) then
				counter = counter + 1
			end
		end
	else
		for k, v in ipairs(matches) do
			--make sure, that directory exists or os.copyfile() fails
			os.mkdir( path.getdirectory(dst_dir .. v))
			if os.copyfile( src_dir .. v, dst_dir .. v) then
				counter = counter + 1
			end
		end
	end
	if counter == #matches then
		print( counter .. " files copied.")
	else
		print( "Error: " .. counter .. "/" .. #matches .. " files copied.")
	end
end

function build_media()
--get media
	os.mkdir("build/local/share/ember/media")
	local rsync = "c:\\Program Files\\cwRsync\\bin\\rsync.exe"
	rsync= iif(os.isfile(rsync), '"' .. rsync .. '"', "rsync")
	os.execute(rsync .. " -rtvzu amber.worldforge.org::media-dev build/local/share/ember/media")
	
--create build/local/share/ember/media/shared/
	local components = "worldforge/ember/src/components/"
	local shared = "build/local/share/ember/media/shared/"
	os.copypattern(components .. "ogre/authoring/entityrecipes", "**.entityrecipe", shared .. "entityrecipes")
	os.copypattern(components .. "cegui/datafiles", "**", shared .. "gui/cegui/datafiles")
	os.copypattern(components .. "ogre/widgets", "**.layout", shared .. "gui/cegui/datafiles/layouts")
	os.copypattern(components .. "cegui/datafiles", "**.xsd", shared .. "gui", true) -- copy to single dir
	os.copypattern(components .. "ogre/widgets", "**.xsd", shared .. "gui", true) -- copy to single dir and overwrite
	os.copyfile(components .. "cegui/datafiles/configs/cegui.config", shared .. "gui/cegui/datafiles/configs/cegui.config")
	os.copypattern(components .. "ogre/modeldefinitions", "**", shared .. "modeldefinitions")
	os.copypattern(components .. "ogre/widgets", "**.lua", shared .. "scripting/lua")
	os.copypattern(components .. "ogre/sounddefinitions", "**", shared .. "sounddefinitions")
	
--create build/local/etc/ember
	os.copyfile("worldforge/ember/ember.conf", "build/local/etc/ember/ember.conf")
	os.copypattern("worldforge/ember/src/components/ogre", "**.cfg", "build/local/etc/ember",true)
	
--cegui
	os.copypattern("dep/CEGUI-SDK-0.7.5-vc9/datafiles", "**", "build/local/share/CEGUI")
end

--
-- Downloads and installs everything, needed to compile Ember
--
function install()
	os.mkdir("dl")
	os.mkdir("dep")

	local tmp = "dl/PortableGit-1.7.4-preview20110204.7z"
	download("http://msysgit.googlecode.com/files/PortableGit-1.7.4-preview20110204.7z", tmp)
	extract(tmp, "dep/PortableGit")
	
	tmp = "dl/OgreSDK_vc9_v1-7-2.exe"
	download("http://sourceforge.net/projects/ogre/files/ogre/1.7/OgreSDK_vc9_v1-7-2.exe/download", tmp)
	extract(tmp, "dep")
	
	tmp = "dl/CEGUI-SDK-0.7.5-vc9.zip"
	download("http://sourceforge.net/projects/crayzedsgui/files/CEGUI%20Mk-2/0.7.5/CEGUI-SDK-0.7.5-vc9.zip/download", tmp)
	extract(tmp, "dep")
	
	tmp = "dl/SDL-devel-1.2.14-VC8.zip"
	download("http://www.libsdl.org/release/SDL-devel-1.2.14-VC8.zip", tmp)
	extract(tmp, "dep")

	tmp = "dl/libcurl-7.19.3-win32-ssl-msvc.zip"
	download("http://curl.linux-mirror.org/download/libcurl-7.19.3-win32-ssl-msvc.zip", tmp)
	extract(tmp, "dep/libcurl")
	
	tmp = "dl/dirent-1.10.zip"
	download("http://www.softagalleria.net/download/dirent/dirent-1.10.zip", tmp)
	extract(tmp, "dep/dirent")
	
	tmp = "dl/tolua++.zip"
	download("http://www.codereactor.net/files/tolua++.zip", tmp)
	extract(tmp, "dep/tolua++")
	
	tmp = "dl/tolua++-1.0.93.tar.bz2"
	download("http://www.codenix.com/~tolua/tolua++-1.0.93.tar.bz2", tmp)
	extract(tmp, "dep/tolua++")
	extract("dep/tolua++/tolua++-1.0.93.tar", "dep/tolua++")
	
	tmp="dl/libsigc++-2.2.9.tar.gz"
	download("http://caesar.acc.umu.se/pub/GNOME/sources/libsigc++/2.2/libsigc++-2.2.9.tar.gz", tmp)
	extract(tmp, "dep")
	extract("dep/libsigc++-2.2.9.tar", "dep")
	
	tmp = "dl/freealut-1.1.0-bin.zip"
	download("http://connect.creativelabs.com/openal/Downloads/ALUT/freealut-1.1.0-bin.zip", tmp)
	extract(tmp, "dep")
	
	tmp = "dl/OpenAL11CoreSDK.zip"
	download("http://connect.creativelabs.com/openal/Downloads/OpenAL11CoreSDK.zip", tmp)
	extract(tmp, "dep")
	
	tmp = "dl/cwRsync_4.0.4_Installer.zip"
	download("http://sourceforge.net/projects/sereds/files/cwRsync/4.0.4/cwRsync_4.0.4_Installer.zip/download", tmp)
	extract(tmp, "dep")
	
	print("Please install OpenAL!")
	print("WARNING: you need to install openAL to the default location or set $(OPENAL_DIR)")
	os.execute("dep\\OpenAL11CoreSDK.exe")
	
	if not os.isfile("c:\\Program Files\\OpenAL 1.1 SDK\\libs\\Win32\\OpenAL32.lib") then
		print("WARNING: You don't have installed OpenAL to the default locaion.")
		print("You need to set $(OPENAL_DIR) environment variable!")
	end
	
	print("Please install rsync!")
	print("WARNING: you need to install rsync to the default location or set $(PATH)")
	os.execute("dep\\cwRsync_4.0.4_Installer.exe")
	
	
	os.mkdir("worldforge")
	os.chdir("worldforge")
	git_clone("https://github.com/worldforge/varconf.git")
	git_clone("https://github.com/worldforge/skstream.git")
	os.copyfile("skstream/skstream/skstreamconfig.h.windows", "skstream/skstream/skstreamconfig.h")
	git_clone("https://github.com/sajty/atlas-cpp.git")
	git_clone("https://github.com/sajty/wfmath.git")
	git_clone("https://github.com/sajty/mercator.git")
	git_clone("https://github.com/sajty/eris.git")
	git_clone("https://github.com/sajty/libwfut.git")
	git_clone("https://github.com/sajty/ember.git")
	os.chdir("..")

--DLLs
	local bin_dir = "build/local/bin"
	os.copyfile("dep/SDL-1.2.14/lib/SDL.dll", bin_dir .. "/SDL.dll")
	os.copyfile("dep/freealut-1.1.0-bin/lib/alut.dll", bin_dir .. "/alut.dll")
	os.copypattern("dep/libcurl/src/DLL-Debug", "*.dll", bin_dir)
	
--Ogre DLLs
	os.copyfile("dep/OgreSDK_vc9_v1-7-2/bin/debug/cg.dll", bin_dir .. "/cg.dll")
	local cegui_dlls = {"OgreMain", "Plugin_CgProgramManager", "Plugin_ParticleFX", "RenderSystem_Direct3D9", "RenderSystem_GL"}
	for k, v in ipairs( cegui_dlls ) do
		os.copyfile("dep/OgreSDK_vc9_v1-7-2/bin/debug/" .. v .. "_d.dll", bin_dir .. "/" .. v .. "_d.dll")
	end
	
--cegui DLLs
	os.copyfile("dep/CEGUI-SDK-0.7.5-vc9/dependencies/bin/lua_d.dll", bin_dir .. "/lua_d.dll")
	local cegui_dlls = {"CEGUIBase", "CEGUIExpatParser", "CEGUIFalagardWRBase", "CEGUILuaScriptModule", "CEGUIOgreRenderer", "tolua++"}
	for k, v in ipairs( cegui_dlls ) do
		os.copyfile("dep/CEGUI-SDK-0.7.5-vc9/bin/" .. v .. "_d.dll", bin_dir .. "/" .. v .. "_d.dll")
	end
	
--touch lock file, which will be checked by isInstalled() function
	local f = io.open("dep/installed.lock", "w+")
	f:write("If you delete this file, premake4 will reinstall everything")
	f:close()
end
