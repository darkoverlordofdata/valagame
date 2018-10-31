REM
REM Emscripten build 
REM
emcc ^
    -w ^
    -O2 ^
    -std=c99 ^
    -fdeclspec ^
    -o www/index.html ^
    -s WASM=1 ^
    -s EMULATE_FUNCTION_POINTER_CASTS=1 ^
    -s USE_WEBGL2=1 ^
    -s USE_SDL=2 ^
    -s FULL_ES3=1 ^
    -s USE_GLFW=3 ^
    --embed-file assets/shaders/sprite.frag ^
    --embed-file assets/shaders/sprite.vs ^
    --embed-file assets/images/assets.atlas ^
    --preload-file assets/d16a.bmp ^
    --preload-file assets/images/assets.png ^
    --preload-file assets/images/assets2.png ^
    --use-preload-plugins ^
    -D__EMSCRIPTEN__ ^
    -DGLIB_COMPILATION ^
    -DG_DISABLE_CHECKS ^
    -DGOBJECT_COMPILATION ^
    -I./include ^
    -I./.lib/zerog/include ^
    -I./.lib/xna.framework/include ^
    -IC:/Users/darko/Documents/GitHub/glib ^
    -IC:/Users/darko/Documents/GitHub/glib/glib ^
    -IC:/Users/darko/Documents/GitHub/glib/gobject ^
    -IC:/msys64/mingw64/lib/libffi-3.2.1/include ^
    @files