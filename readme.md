# ValaGame

port of MonoGame to Vala


Corange replaces the content pipeline.

Uses glIdentity, glOrtho some other obsolete 2.x stuff. Everyone says not to use them, but then all the examples I find do use them... So until I can figure out how to replace them...

add_custom_command(TARGET ${PROJECT_NAME} 
                   POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${PROJECT_NAME}> ../src)



