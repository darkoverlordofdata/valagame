# ValaGame

A sort of a port of MonoGame to Vala: https://darkoverlordofdata.com/valagame/

### Install & Run


#### Desktop
    comment this line in CMakeLists.txt:
    # list ( APPEND VALAC_OPTIONS --define __EMSCRIPTEN__ )

    git clone https://github.com/darkoverlordofdata/valagame
    cd valagame
    doran install
    mkdir build
    cp ./assets build
    ./configure
    cd build
    make
    cd ../src
    ./demo

#### Emscripten
    
    put this line back in CMakeLists.txt:
    list ( APPEND VALAC_OPTIONS --define __EMSCRIPTEN__ )

    git clone https://github.com/darkoverlordofdata/valagame
    cd valagame
    doran install
    mkdir build
    ./configure
    cd build
    make
    (fail - emscripten.h not found)
    cp /usr/include/x86_64-linux-gnu/ffi.h /home/darkoverlordofdata/Documents/GitHub/valagame/.lib/zerog/include/ffi.h
    cp /usr/include/x86_64-linux-gnu/ffitarget.h /home/darkoverlordofdata/Documents/GitHub/valagame/.lib/zerog/include/ffitarget.h
    cd ..
    ./build
    (serve ./docs in browser)

set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w -std=c99 -O3 -fdeclspec" )
cp /usr/include/x86_64-linux-gnu/ffi.h /home/darkoverlordofdata/Documents/GitHub/valagame/.lib/zerog/include/ffi.h
cp /usr/include/x86_64-linux-gnu/ffitarget.h /home/darkoverlordofdata/Documents/GitHub/valagame/.lib/zerog/include/ffitarget.h



### Dependencies

    You need node.js and doran:

    npm install -g doran-cli

        or

    yarn global add doran-cli

    

#### Doran

doran is my Vala package manager: https://github.com/darkoverlordofdata/doran


#### Restart project
After a year off for personal stuff, it appears vala is getting more traction lateley, there has been a lot of work done on it in the past year, no more languish in gnome.

Using vala version 42.5 on Chromebook:
    Y Linux Desktop
    Y Linux Emscripten... 
    ? Windows Desktop...
    ? Windows Emscripten...

Where do I go from here? 

    upgrade 
    - try with 2.56.MAX or jump to 2.57? and on??
    - replace stb with SDL2_image
    - add SDL2_ttf, SDL2_mix

    sanity-check
    - check vapi customizations for design 
