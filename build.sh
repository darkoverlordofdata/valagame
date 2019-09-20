#!/usr/bin/env bash

emcc \
    -w \
    -O2 \
    -std=c99 \
    -fdeclspec \
    -o docs/index.html \
    -s WASM=1 \
    -s EMULATE_FUNCTION_POINTER_CASTS=1 \
    -s USE_WEBGL2=1 \
    -s USE_SDL=2 \
    -s FULL_ES3=1 \
    -s USE_GLFW=3 \
    --embed-file assets/shaders/sprite.frag \
    --embed-file assets/shaders/sprite.vs \
    --embed-file assets/images/assets.atlas \
    --embed-file assets/assets.atlas \
    --preload-file assets/d16a.bmp \
    --preload-file assets/images/spritesheet.png \
    --preload-file assets/images/assets.png \
    --preload-file assets/images/assets2.png \
    --preload-file assets/images/background.png \
    --preload-file assets/images/bang.png \
    --preload-file assets/images/bullet.png \
    --preload-file assets/images/enemy1.png \
    --preload-file assets/images/enemy2.png \
    --preload-file assets/images/enemy3.png \
    --preload-file assets/images/explosion.png \
    --preload-file assets/images/particle.png \
    --preload-file assets/images/player.png \
    --preload-file assets/images/star.png \
    --use-preload-plugins \
    -D__EMSCRIPTEN__ \
    -DGLIB_COMPILATION \
    -DG_DISABLE_CHECKS \
    -DGOBJECT_COMPILATION \
    -I./include \
    -I./.lib/zerog/include \
    -I./.lib/xna.framework/include \
    -I/home/darkoverlordofdata/Documents/GitHub/glib-2.56.2 \
    -I/home/darkoverlordofdata/Documents/GitHub/glib-2.56.2/glib \
    -I/home/darkoverlordofdata/Documents/GitHub/glib-2.56.2/gobject \
    @files

    # -IC:/msys64/mingw64/lib/libffi-3.2.1/include \
