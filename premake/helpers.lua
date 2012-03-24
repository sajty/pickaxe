--
-- Downloads a file from the internet
--
-- @param source
--    The source file from a webpage
-- @param destination
--    The local destination file
--
function download(source, destination, curl_options)
	--path.translate() will make "/" to "\" in windows
	destination = path.translate(destination)
	if not curl_options then curl_options="" end
	
	if _OPTIONS["redownload"] or not os.isfile(destination) then
		local tmp=dl_dir .. "/tmp.bin"
		os.remove(destination)
		os.remove(tmp)
		print("Downloading " .. source)
		local ret = os.execute("curl -L -o " .. tmp .. " --get " .. curl_options .. " " .. source)
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
-- Merges table1 and table2
--
-- @param table1
--    Table to merge
-- @param table2
--    Table to merge
-- @returns
--    The merged table of table1 and table2.
--
function table.merge(table1, table2)
	for k, v in ipairs(table2) do table.insert(table1, v) end
	return table1
end


-- stack variable used by push_chdir and pop_chdir
dir_stack = {}

function push_chdir(dir)
	table.insert(dir_stack, os.getcwd())
	os.chdir(dir)
end

function pop_chdir()
	os.chdir(dir_stack[#dir_stack])
	table.remove(dir_stack)
end

--
-- Allows copying directories.
-- It uses the premake4 patterns (**=recursive match, *=file match)
-- NOTE: It won't copy empty directories!
-- Example: we have a file: src/test.h
--	os.copydir("src", "include") simple copy, makes include/test.h
--	os.copydir("src", "include", "*.h") makes include/test.h
--	os.copydir(".", "include", "src/*.h") makes include/src/test.h
--	os.copydir(".", "include", "**.h") makes include/src/test.h
--	os.copydir(".", "include", "**.h", true) will force it to include dir, makes include/test.h
--
-- @param src_dir
--    Source directory, which will be copied to dst_dir.
-- @param dst_dir
--    Destination directory.
-- @param filter
--    Optional, defaults to "**". Only filter matches will be copied. It can contain **(recursive) and *(filename).
-- @param single_dst_dir
--    Optional, defaults to false. Allows putting all files to dst_dir without subdirectories.
--    Only useful with recursive (**) filter.
-- @returns
--    True if successful, otherwise nil.
--
function os.copydir(src_dir, dst_dir, filter, single_dst_dir)
	if not os.isdir(src_dir) then error(src_dir .. " is not existing directory!") end
	filter = filter or "**"
	src_dir = src_dir .. "/"
	print('copy "' .. src_dir .. filter .. '" to "' .. dst_dir .. '".')
	dst_dir = dst_dir .. "/"

	push_chdir( src_dir ) -- change current directory to src_dir
		local matches = os.matchfiles(filter)
	pop_chdir() -- change current directory back to root
	
	local counter = 0
	for k, v in ipairs(matches) do
		local target = iif(single_dst_dir, path.getname(v), v)
		--make sure, that directory exists or os.copyfile() fails
		os.mkdir( path.getdirectory(dst_dir .. target))
		if os.copyfile( src_dir .. v, dst_dir .. target) then
			counter = counter + 1
		end
	end
	
	if counter == #matches then
		print( counter .. " files copied.")
		return true
	else
		print( "Error: " .. counter .. "/" .. #matches .. " files copied.")
		return nil
	end
end




lock_path = "../locks/"

function lock_create(name)
	local f = io.open(lock_path .. name, "w+")
	f:close()
end

function lock_delete(name)
	os.remove(lock_path .. name)
end

function lock_check(name)
	return os.isfile(lock_path.. name)
end