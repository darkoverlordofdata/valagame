# ValaGame

A sort of a port of MonoGame to Vala: https://darkoverlordofdata.com/valagame/

### Install & Run

make sure the CMakeList.txt has this line:
set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w -std=c99 -O3 -fdeclspec" )


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
    cd ..
    ./build
    (serve ./docs in browser)



### Dependencies

    You need node.js and doran:

    npm install -g doran-cli

        or

    yarn global add doran-cli

    

#### Doran

doran is my Vala package manager: https://github.com/darkoverlordofdata/doran


#### Restart project
After a year off for personal stuff, it appears vala is getting more traction lateley, there has been a lot of work done on it in the past year, no more languish in gnome.

fixed: 

* finished removing immediate mode opengl
* compiles on Linux (need to verify windows is still working)

Using vala version 42.5 & glib 2.56 on Chromebook:
    Y Linux Desktop
    Y Linux Emscripten => https://darkoverlordofdata.com/valagame/
    ? Windows Desktop...
    ? Windows Emscripten...

Where do I go from here? 

    Replace stb with SDL2_image

    upgrade 
    - replace stb with SDL2_image
    - add SDL2_ttf, SDL2_mix
    - try with 2.56.MAX or jump to 2.57? and on??

    sanity-check
    - check vapi customizations for design 


