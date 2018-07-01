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


### Dependencies

    You need node.js and doran:

    npm install -g doran-cli

        or

    yarn global add doran-cli

    

#### Doran

doran is my Vala package manager

    npm install -g bower
    git clone https://github.com/darkoverlordofdata/doran
    cd doran
    npm install -g .

#### Corange

I'm using Corange as a content pipeline replacement.

You'll need to get and build Corange from https://github.com/orangeduck/Corange
