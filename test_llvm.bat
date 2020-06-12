@echo off

:: Handle command line arguments
IF not EXIST %2 (
	echo ERROR: Couldn't find LLVM build directory at %2 
	EXIT /B 1
)

:: Update path so that the correct DIA SDK is used (needed for lit testing)
set PATH=C:\BuildTools\DIA SDK\bin\amd64;%PATH%

:: Run tests and exclude symlink test because Docker is goofy
python "%2\bin\llvm-lit.py" -j6 --filter "^((?!build-id-link-dir\.test).)*$"  "%1\llvm\test"

if not %ERRORLEVEL%==0 (
	echo ERROR: Tests failed. See stdout for more details.
	EXIT /B 1
)
