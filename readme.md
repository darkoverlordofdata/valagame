# ValaGame

Think Xna ported to Vala, using Corange initialize SDL with OpenGL.

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

#### wip

Corange was removed. I'm integrating back in the GraphicsContext class.

### opengl issues:

    glOrtho
    glFrustum
    glPushMatrix
    glPopMatrix
    glVertex3f
    glTexCoord2f
    glGetTexLevelParameteriv
    glDisableClientState
    glBegin
    glEnd

https://github.com/kripken/emscripten/blob/incoming/system/lib/gl.c#L1543


add to Program.c, OpenGL.c

#include "GLES3/gl3.h"
#include "GLFW/glfw3.h"
