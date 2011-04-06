
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
--    the git URL
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
	--if reinstall variable is defined, remove lock
	if _OPTIONS["redownload"] or _OPTIONS["reinstall"] then
		os.remove("dep/installed.lock")
	end
	
	--this file is generated, on the end of the install().
	--if this file exists, the installation is already done.
	return os.isfile("dep/installed.lock")
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
	
	tmp = "dl/bzip2-1.0.5-bin.zip"
	download("http://gnuwin32.sourceforge.net/downlinks/bzip2-bin-zip.php", tmp)
	extract(tmp, "dep/bzip2")
	
	tmp = "dl/SDL-devel-1.2.14-VC8.zip"
	download("http://www.libsdl.org/release/SDL-devel-1.2.14-VC8.zip", tmp)
	extract(tmp, "dep")
	
	tmp = "dl/PortableGit-1.7.4-preview20110204.7z"
	download("http://msysgit.googlecode.com/files/PortableGit-1.7.4-preview20110204.7z", tmp)
	extract(tmp, "dep/PortableGit")
	
	tmp = "dl/pthreads-w32-2-8-0-release.exe"
	download("ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-2-8-0-release.exe", tmp)
	extract(tmp, "dep/pthreads-w32")

	tmp = "dl/libcurl-7.19.3-win32-ssl-msvc.zip"
	download("ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-2-8-0-release.exe", tmp)
	extract(tmp, "dep/libcurl")
	
	tmp = "dl/dirent-1.10.zip"
	download("http://www.softagalleria.net/download/dirent/dirent-1.10.zip", tmp)
	extract(tmp, "dep/dirent")
	
	tmp = "dl/lua5_1_4_Win32_vc9_lib.zip"
	download("http://sourceforge.net/projects/luabinaries/files/5.1.4/Windows%20Libraries/lua5_1_4_Win32_vc9_lib.zip/download", tmp)
	extract(tmp, "dep/lua")
	
	tmp = "dl/tolua++.zip"
	download("http://www.codereactor.net/files/tolua++.zip", tmp)
	extract(tmp, "dep/tolua++")
	
	tmp = "dl/tolua++-1.0.93.tar.bz2"
	download("http://www.codenix.com/~tolua/tolua++-1.0.93.tar.bz2", tmp)
	extract(tmp, "dep/tolua++")
	extract("dep/tolua++/tolua++-1.0.93.tar", "dep/tolua++")
	
	tmp = "dl/postgresql-9.0.3-1-windows-binaries.zip"
	download("http://get.enterprisedb.com/postgresql/postgresql-9.0.3-1-windows-binaries.zip", tmp)
	extract(tmp, "dep")
	
	tmp="dl/libsigc++-2.2.9.tar.gz"
	download("http://caesar.acc.umu.se/pub/GNOME/sources/libsigc++/2.2/libsigc++-2.2.9.tar.gz", tmp)
	extract(tmp, "dep")
	extract("dep/libsigc++-2.2.9.tar", "dep")
	
	tmp = "dl/OpenAL11CoreSDK.zip"
	download("http://connect.creativelabs.com/openal/Downloads/OpenAL11CoreSDK.zip", tmp)
	extract(tmp, "dep")
	
	tmp = "dl/cwRsync_4.0.4_Installer.zip"
	download("http://sourceforge.net/projects/sereds/files/cwRsync/4.0.4/cwRsync_4.0.4_Installer.zip/download", tmp)
	extract(tmp, "dep")
	
	tmp = "dl/python-2.7.1.msi"
	download("http://www.python.org/ftp/python/2.7.1/python-2.7.1.msi", tmp)
	--extract with msiexec:
	os.mkdir("dep/python")
	local cmd = 'msiexec /a "' .. path.translate(path.getabsolute(tmp)) .. '" /qb TARGETDIR="' .. path.translate(path.getabsolute("dep\\python")) .. '"'
	--print(cmd)
	os.execute(cmd)
	
	tmp = "dl\\Cg-2.2_February2010_Setup.exe"
	download("http://developer.download.nvidia.com/cg/Cg_2.2/Cg-2.2_February2010_Setup.exe", tmp)
	
	--run installers, I can't extract these automatically :(
	print("Please install CG!")
	os.execute(tmp)
	
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
	git_clone("https://github.com/worldforge/atlas-cpp.git")
	git_clone("https://github.com/worldforge/wfmath.git")
	git_clone("https://github.com/worldforge/mercator.git")
	git_clone("https://github.com/worldforge/eris.git")
	git_clone("https://github.com/worldforge/libwfut.git")
	git_clone("https://github.com/worldforge/ember.git")
	os.chdir("..")
	
	--get media
	local rsync = "c:\\Program Files\\cwRsync\\bin\\rsync.exe"
	rsync= iif(os.isfile(rsync), rsync, "rsync")
	
	os.mkdir("bin")
	os.mkdir("bin/media")
	os.execute('"' .. rsync .. '" -rtvzu amber.worldforge.org::media-dev bin/media')	
	
	--touch lock file, which will be checked by isInstalled() function
	local f = io.open("dep/installed.lock", "w+")
	f:write("If you delete this file, premake4 will reinstall everything")
	f:close()
end
