# ValaGame

port of MonoGame to Vala



add_custom_command(TARGET ${PROJECT_NAME} 
                   POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${PROJECT_NAME}> ../src)


With the magic of vapi, Corange is folded into the Microsoft.Xna.Framework namespace,
creating a bastard api, for which missing elements are added using Vala. Being a port of Xna, I'm using MSDN naming standards. Much of the existing Xna code that was used was a simple cut and paste into vala. To facilitate this, there is a small compatability layer in the System namespace.

The outer API conforms to the Xna.Framework API where applicable, with additions for Corange. The mid-level API is mostly a wrapper around Corange supplmented with SDL2 and OpenGL, where the MonoGame API wraps SDL2 and OpenGL. As Corange is a SDL2/OpenGL wrapper, so it's sort of the same but different... 

Corange.Xna.Framework?

Microsoft.Xna.Framework (Corange):
    Type
    URI
    AssetHandle
    Sound
    Music
    Folder
    Asset
    Entity
    EntityManager
    Timer
    Loop
    Vector2
    Vector3
    Vector4
    Quaternion
    DualQuaternion
    Matrix2
    Matrix3
    Matrix4
