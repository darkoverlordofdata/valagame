# ValaGame

port of MonoGame to Vala


Most of the existing Xna code can simply be cut and pasted into vala. To facilitate this, there is a small compatability layer in the System namespace. But there are over 700 files in the framework. And I don't understand how most the the opengl part works. So as a shortcut, I'm merging in Corange to handle the heavy lifting, while most of my code is api and ui, all using MSDN naming standards. There are about 90 or so csharp file ported over so far, of which about 90% is cut & paste. Some modifications are required by language differences - vala doesn't have overloads. Most of the re-writen code is around sprite handling.



add_custom_command(TARGET ${PROJECT_NAME} 
                   POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${PROJECT_NAME}> ../src)

