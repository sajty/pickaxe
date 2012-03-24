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
   description = "will reinstall dependencies"
}

newoption {
   trigger     = "regen-checkout",
   description = "will regenerate checkout"
}

newoption {
   trigger     = "webember",
   description = "will build webember instead of ember"
}

if _ACTION == nil then return end

require("helpers") -- lock_check, lock_create, lock_delete


dl_dir = path.getabsolute("../downloads")
dep_dir = path.getabsolute("../dependencies")
repo_dir = path.getabsolute("../worldforge")
build_dir = path.getabsolute("../build")
include_dir =  path.getabsolute(build_dir .. "/include")
bin_d_dir = path.getabsolute(build_dir .. "/bin_d") -- debug binaries
bin_dir = path.getabsolute(build_dir .. "/bin")

if not lock_check("deps_installed") or _OPTIONS["reinstall"] then
	lock_delete("deps_installed")
		require("dependencies") -- install_dependencies
		install_dependencies()
	lock_create("deps_installed")
end

if not lock_check("checkout_generated") or _OPTIONS["regen-checkout"] then
	lock_delete("checkout_generated")
		require("checkout") -- checkout
		checkout()
	lock_create("checkout_generated")
end

if _OPTIONS["webember"] then
	project_name = "WebEmber"
else
	project_name = "Ember"
end

require("compiler_setup") -- header, footer

--patch repos
os.copydir("files", "..")

header()
require("worldforge")
footer()




