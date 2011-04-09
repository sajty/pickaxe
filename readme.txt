+++++++++++++
++ pickaxe ++
+++++++++++++

prerequisites:
	-install visual c++ 2008 SP1 professional
OR
	-install visual C++ 2008 sp1 express:
	http://download.microsoft.com/download/A/5/4/A54BADB6-9C3F-478D-8657-93B3FC9FE62D/vcsetup.exe
	-install windows SDK:
	http://www.microsoft.com/downloads/en/details.aspx?FamilyID=c17ba869-9671-4330-a63e-1fd44e0e2505
included prerequisites:
	-7za: http://downloads.sourceforge.net/sevenzip/7za920.zip
	-curl: http://curl.freeby.pctools.cl/download/curl-7.19.5-win32-nossl.zip
	-premake4: http://sourceforge.net/projects/premake/files/Premake/4.3/premake-4.3-windows.zip/download
usage:
	-run build_vs2008.bat: this will automatically download and install everything needed.
	-start worldforge.sln
command-line usage: read "premake4 --help"
	example: "premake4 --reinstall vs2008"
bugs:
	-if you know any bugs or have suggestions, send a mail to peter.szucs.dev AT gmail DOT com