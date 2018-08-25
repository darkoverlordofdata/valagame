cmake_minimum_required ( VERSION 3.1 )
###################################################################################
#
#   Build demo
#
###################################################################################
project ( demo VERSION 0.0.1 )

#
set ( VERSION 0.0.1 )
set ( RELEASE_NAME ValaGameDemo )

#
# enable features
#
include ( CMakeToolsHelpers OPTIONAL )
list ( APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/vala)
find_package (PkgConfig)
find_package (Vala REQUIRED)

#
#   libraries - sources & packages
#
add_subdirectory ( .lib/artemis )
add_subdirectory ( .lib/system )
add_subdirectory ( .lib/xna.framework )
add_subdirectory ( .lib/zerog )
# add_subdirectory ( .lib/xtiled )
if (EXISTS ${CMAKE_SOURCE_DIR}/data AND NOT DEFINED ZEROG )
    add_subdirectory (data)
    list ( APPEND RESOURCES ${resources_gresource_xml_C_FILE} )
endif ()

#
#   generated code configuration
#
configure_file ( 
    ${CMAKE_SOURCE_DIR}/src/Config.vala.base 
    ${CMAKE_BINARY_DIR}/src/Config.vala 
)
file (RELATIVE_PATH CONFIG_VALA ${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR}/src/Config.vala)

#
#   application source
#
list ( APPEND VALA_SOURCES ${CONFIG_VALA} )
list ( APPEND VALA_SOURCES src/vala/Game.vala )
list ( APPEND VALA_SOURCES src/vala/MetaSprite.vala )
list ( APPEND VALA_SOURCES src/vala/Program.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/AllSystems.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/GoalSpeedSystem.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/LinkIdleStateSystem.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/LinkOnGroundStateSystem.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/LinkOnAirStateSystem.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/LinkRunStateSystem.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/LinkWalkStateSystem.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/MapRenderSystem.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/MapCollisionSystem.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/PlayerInputSystem.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/SpeedSystem.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/SpriteAnimationSystem.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/SpriteBinaryDirectionSystem.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/SpriteRenderSystem.vala )
# list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Systems/SpriteSystem.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/AABBComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/BinaryDirectionComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/EventSenderComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/ContentManagerComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/FSMComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/GoalSpeedComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/LinkIdleStateComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/InputIntentComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/LinkOnAirStateComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/LinkOnGroundStateComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/LinkRunStateComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/LinkWalkSpeedStateComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/LinkWalkStateComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/MapComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/PlayerInputComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/PositionComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/SpriteComponent.vala )
list ( APPEND VALA_SOURCES src/vala/ZeldaPlatformerLibrary/Components/SpeedComponent.vala )
#
#   pkg-config dependencies
#

#
add_definitions ( ${DEPS_CFLAGS} )
link_libraries ( ${DEPS_LIBRARIES} )
link_directories ( ${DEPS_LIBRARY_DIRS} )

#
#   compiler options
#
list ( APPEND VALAC_OPTIONS --disable-warnings --enable-experimental )
list ( APPEND VALAC_OPTIONS --vapidir=${CMAKE_SOURCE_DIR}/src/vapis)


set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w -std=c99 -O3" )

# definitions 
add_definitions( -DGLIB_COMPILATION ) 
add_definitions( -DG_DISABLE_CHECKS ) 
add_definitions( -DGOBJECT_COMPILATION ) 

include_directories(AFTER ${INCLUDES})
#
#   compile vala code
#
include (ValaVersion)
ensure_vala_version (0.26 MINIMUM)
include (ValaPrecompile)
vala_precompile (
    VALA_C ${PROJECT_NAME}
        ${VALA_SOURCES}
    PACKAGES
        ${PACKAGES}
    CUSTOM_VAPIS
        ${CUSTOM_VAPIS}
    OPTIONS
        ${VALAC_OPTIONS}
    )

#
#   compile ccode & link executable
#
add_executable ( ${PROJECT_NAME} ${VALA_C} ${C_SOURCES} ${RESOURCES} )
add_custom_command(TARGET ${PROJECT_NAME} 
                   POST_BUILD COMMAND 
                   ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${PROJECT_NAME}> ../src )
target_link_libraries ( ${PROJECT_NAME}  )
install (TARGETS ${PROJECT_NAME} RUNTIME DESTINATION . )

if (EXISTS ${CMAKE_SOURCE_DIR}/data AND DEFINED ZEROG)
    install ( DIRECTORY ${CMAKE_SOURCE_DIR}/data/assets DESTINATION . )
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} 
            -E 
            copy_directory
            ${CMAKE_SOURCE_DIR}/data/assets 
            $<TARGET_FILE_DIR:${PROJECT_NAME}>/assets 
    )    
elseif (EXISTS ${CMAKE_SOURCE_DIR}/assets)
    install ( DIRECTORY ${CMAKE_SOURCE_DIR}/assets DESTINATION . )
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} 
            -E 
            copy_directory
            ${CMAKE_SOURCE_DIR}/assets 
            $<TARGET_FILE_DIR:${PROJECT_NAME}>/assets 
    )    
endif ()

include (CPack)

# (generated from template: default. Do not modify. )
