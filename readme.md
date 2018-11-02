# ValaGame

A sort of a port of MonoGame to Vala: https://darkoverlordofdata.com/valagame/

### Install & Run

#### Emscripten
    
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


#### Desktop
    comment this line in CMakeLists.txt:
    # list ( APPEND VALAC_OPTIONS --define __EMSCRIPTEN__ )

    git clone https://github.com/darkoverlordofdata/valagame
    cd valagame
    doran install
    mkdir build
    ./configure
    cd build
    make
    cd ../src
    ./demo



### Dependencies

    You need node.js and doran:

    npm install -g doran-cli

        or

    yarn global add doran-cli

    

#### Doran

doran is my Vala package manager: https://github.com/darkoverlordofdata/doran

