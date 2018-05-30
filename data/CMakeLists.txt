cmake_minimum_required ( VERSION 3.1 )
project ( resources VERSION 0.0.1 )

find_program ( WHERE_GRESOURCE glib-compile-resources )
if ( NOT WHERE_GRESOURCE )
	message (FATAL_ERROR "Error! GLIB-COMPILE-RESOURCES is not installed.")
endif ()

execute_process ( 
	COMMAND glib-compile-resources 
		--sourcedir=${CMAKE_CURRENT_SOURCE_DIR} 
		--generate-source 
		--target=${CMAKE_CURRENT_BINARY_DIR}/resources.gresource.xml.c 
		${CMAKE_CURRENT_SOURCE_DIR}/resources.gresource.xml
)

execute_process ( 
	COMMAND glib-compile-resources 
		--sourcedir=${CMAKE_CURRENT_SOURCE_DIR} 
		--generate-header 
		--target=${CMAKE_CURRENT_BINARY_DIR}/resources.gresource.xml.h 
		${CMAKE_CURRENT_SOURCE_DIR}/resources.gresource.xml
)

add_custom_command (
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/resources.gresource.xml.c
	DEPENDS 
		${CMAKE_CURRENT_SOURCE_DIR}/resources.gresource.xml 
		${CMAKE_CURRENT_SOURCE_DIR}/gamecontrollerdb.txt 

	COMMAND glib-compile-resources 
		--sourcedir=${CMAKE_CURRENT_SOURCE_DIR} 
		--generate-source 
		--target=${CMAKE_CURRENT_BINARY_DIR}/resources.gresource.xml.c 
		${CMAKE_CURRENT_SOURCE_DIR}/resources.gresource.xml

	COMMAND glib-compile-resources 
		--sourcedir=${CMAKE_CURRENT_SOURCE_DIR} 
		--generate-header 
		--target=${CMAKE_CURRENT_BINARY_DIR}/resources.gresource.xml.h 
		${CMAKE_CURRENT_SOURCE_DIR}/resources.gresource.xml
)

# add_custom_target (
# 	resources_gresource_xml 
# 	DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/resources.gresource.xml.c
# )

set (resources_gresource_xml_C_FILE ${CMAKE_CURRENT_BINARY_DIR}/resources.gresource.xml.c PARENT_SCOPE)
set (resources_gresource_xml_H_FILE ${CMAKE_CURRENT_BINARY_DIR}/resources.gresource.xml.h PARENT_SCOPE)
#install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/shmupwarz.desktop DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications/ )
