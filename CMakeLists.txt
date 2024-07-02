cmake_minimum_required(VERSION 3.5)
project(cs16-client)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/")
set(EXTRAS_DIR "${CMAKE_CURRENT_BINARY_DIR}/extras")

include(LibraryNaming)

option(BUILD_CLIENT "Build client library." ON)
option(BUILD_MAINUI "Build menu library." ON)
option(BUILD_SERVER "Build server library." ON)

set(GAME_DIR "cstrike" CACHE STRING "Game directory name.")
set(CLIENT_INSTALL_DIR "cl_dlls" CACHE STRING "Client library location.")
set(SERVER_INSTALL_DIR "dlls" CACHE STRING "Server library location.")

#Compiler flags
if(EMSCRIPTEN)
    message(STATUS "Configuring for Emscripten (WebAssembly)")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -msimd128")
    string(REPLACE "-mmmx" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    string(REPLACE "-msse" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    string(REPLACE "-msse2" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    string(REPLACE "-msse3" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    string(REPLACE "-mssse3" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    string(REPLACE "-msse4.1" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    string(REPLACE "-msse4.2" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    string(REPLACE "-msse4" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    string(REPLACE "-mavx" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    string(REPLACE "-mfpu=neon" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mmmx -msse -msse2 -msse3")
endif()

if(VITA)
    message(STATUS "Building for PS Vita")
    add_compile_options(-fno-use-cxa-atexit)
endif()

if(BUILD_CLIENT)
    add_subdirectory(cl_dll)
endif()

if(BUILD_SERVER)
    if(NOT EMSCRIPTEN)
        add_subdirectory(3rdparty/ReGameDLL_CS)
    endif()
endif()

if(BUILD_MAINUI)
    add_subdirectory(3rdparty/mainui_cpp)

    # Include directory for fontconfig due to emcc not finding it automatically
    target_include_directories(menu PRIVATE "/usr/include/fontconfig")
endif()

include(GenerateExtras)

# Packaging configurations
if(WIN32)
    set(CPACK_GENERATOR "ZIP")
    set(CPACK_PACKAGE_FILE_NAME "CS16Client-${CMAKE_SYSTEM_NAME}-${CMAKE_CXX_COMPILER_ARCHITECTURE_ID}")
else()
    set(CPACK_GENERATOR "TGZ")
    set(CPACK_PACKAGE_FILE_NAME "CS16Client-${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}")
endif()

set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY OFF)

include(CPack)
