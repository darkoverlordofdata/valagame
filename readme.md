# ValaGame

port of MonoGame to Vala


Corange replaces the content pipeline.

Uses glIdentity, glOrtho some other obsolete 2.x stuff. Everyone says not to use them, but then all the examples I find do use them... So until I can figure out how to replace them...

add_custom_command(TARGET ${PROJECT_NAME} 
                   POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${PROJECT_NAME}> ../src)

add_definitions( -DGLIB_COMPILATION -DG_DISABLE_CHECKS -DGOBJECT_COMPILATION )


### Missing with Zerog:

    1 - g_key_file - ini files
    2 - str.replace needs regex
    3 - GraphicsDevice - lock/unlock
    4 - g_strsplit GamePad