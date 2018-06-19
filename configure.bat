cd build

cmake -G "MSYS Makefiles" -D CMAKE_C_COMPILER=c:/msys64/mingw64/bin/clang.exe -D CMAKE_CXX_COMPILER=c:/msys64/mingw64/bin/clang++.exe ..
REM cmake -G "MSYS Makefiles" -D CMAKE_C_COMPILER=c:/msys64/mingw64/bin/gcc.exe -D CMAKE_CXX_COMPILER=c:/msys64/mingw64/bin/g++.exe ..

