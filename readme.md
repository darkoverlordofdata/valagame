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

#### Project is dead

Not working in current version of vala because delegate targets have changed...
This was started because vala looked dead and unchanging. Gnome even tweeted out a psa not to use vala anymore.

Now it is picking up steam again and changing. Problem is, vala has no spec, just undocumented features with current behaviour. I can't keep up with that.

This is not a complaint, I'm, glad to see new life in Vala. In actuality, this protoype worked too well, and I was tempted to stay with it, but that turns in the 'ball of wax' anti-pattern. 
