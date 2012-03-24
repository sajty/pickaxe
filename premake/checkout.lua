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
	local ret = os.execute(path.translate(dep_dir) .. "\\PortableGit\\bin\\git clone " .. URL .. " " .. destination)
	if ret ~=0 then
		error("Failed cloning git " .. URL)
	end
end

function checkout()
	local username = "sajty"
	os.mkdir("../worldforge")
	push_chdir("../worldforge")
		git_clone("https://github.com/" .. username .. "/varconf.git")
		git_clone("https://github.com/" .. username .. "/skstream.git")
		os.copyfile("skstream/skstream/skstreamconfig.h.windows", "skstream/skstream/skstreamconfig.h")
		git_clone("https://github.com/" .. username .. "/atlas-cpp.git")
		git_clone("https://github.com/" .. username .. "/wfmath.git")
		git_clone("https://github.com/" .. username .. "/mercator.git")
		git_clone("https://github.com/" .. username .. "/eris.git")
		git_clone("https://github.com/" .. username .. "/libwfut.git")
		git_clone("https://github.com/" .. username .. "/ember.git")
		git_clone("https://github.com/" .. username .. "/WebEmber.git")
		git_clone("https://github.com/" .. username .. "/FireBreath.git")
		git_clone("https://github.com/" .. username .. "/ois.git")
	pop_chdir()
end