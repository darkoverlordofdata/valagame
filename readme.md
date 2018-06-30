# ValaGame

Think Xna ported to Vala, using Corange to replace the Content Pipeline.

### Install & Run

    git clone https://github.com/darkoverlordofdata/valagame
    cd valagame
    doran install
    mkdir build
    ./configure
    cd build
    make
    cd ../src
    ./demo

### Note

    Doran can overwrite the cmake instructions. Make sure these lines are in the CMakeLists.txt (check the backup.txt):
        

        add_custom_command( TARGET ${PROJECT_NAME} 
                        POST_BUILD COMMAND 
                        ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${PROJECT_NAME}> ../src )

        add_definitions( -DGLIB_COMPILATION )
        add_definitions( -DG_DISABLE_CHECKS )
        add_definitions( -DGOBJECT_COMPILATION )


### Dependencies

    You need node.js and bower to run doran

#### Doran

doran is my Vala package manager

    npm install -g bower
    git clone https://github.com/darkoverlordofdata/doran
    cd doran
    npm install -g .

#### Corange

I'm using Corange as a content pipeline replacement.

You'll need to get and build Corange from https://github.com/orangeduck/Corange
