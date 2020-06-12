@echo off

:: Handle command line arguments
IF not EXIST %1 (
	echo ERROR: Couldn't find LLVM directory at %1 
	EXIT /B 1
)

IF EXIST %2 (
	echo Found build folder at %2. Will attempt to overwrite files
) ELSE (
	mkdir %2
)

:: Attempt to use cmake to generate the build files
cd %2
cmake -G "Ninja" -DLLVM_BUILD_LLVM_C_DYLIB=OFF -DLLVM_OPTIMIZED_TABLEGEN=ON -DLLVM_PARALLEL_LINK_JOBS=2 -DLLVM_ENABLE_PROJECTS=clang "%1\llvm\"

if not %ERRORLEVEL%==0 (
	echo ERROR: Problems generating build files with Cmake. See output for error files.
	EXIT /B 1
)

:: Actualy build LLVM using the ninja build system (this will inherently use the VS toolchain)
ninja -j6

if not %ERRORLEVEL%==0 (
	echo ERROR: Problems building the compiler. See stdout for more details.
	EXIT /B 1
)