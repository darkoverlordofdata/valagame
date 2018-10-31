## ValaGame

A sort of a port of MonoGame to Vala.
The sort of refers to:

    No support for DirectX or iOS.
    Web support via emscripten
    Not using modern opengl*

ValaGame is primarily intended for use in emscripten. All design considerations favor emscripten. It works good on desktop (I consider that my preview mode), and should also run on arm - the predecessor did, but this is not yet tested.    
    
* I blame the tutorials. I've discovered LearnOpenGL.com and I'm trying to re-learn.


### emscripten:

switched to new rendering from the learnopengl.com demo. it does not yet map the atlas correctly, but it messes up in emscripten! So all I have to do is fix the atlas mapping, and puul out the sprite batch.



