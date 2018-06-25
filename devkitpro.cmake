set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR powerpc)
set(WIIU TRUE) # To be used for multiplatform projects

# DevkitPro Paths are broken on windows, so we have to fix those
macro(msys_to_cmake_path MsysPath ResultingPath)
	if(WIN32)
		string(REGEX REPLACE "^/([a-zA-Z])/" "\\1:/" ${ResultingPath} "${MsysPath}")
	else()
		set(${ResultingPath} "${MsysPath}")
	endif()
endmacro()

msys_to_cmake_path("$ENV{DEVKITPRO}" DEVKITPRO)
if(NOT IS_DIRECTORY ${DEVKITPRO})
    message(FATAL_ERROR "Please set DEVKITPRO in your environment")
endif()

msys_to_cmake_path("$ENV{DEVKITPPC}" DEVKITPPC)
if(NOT IS_DIRECTORY ${DEVKITPPC})
    message(FATAL_ERROR "Please set DEVKITPPC in your environment")
endif()

# Prefix detection only works with compiler id "GNU"
# CMake will look for prefixed g++, cpp, ld, etc. automatically
if(WIN32)
    set(CMAKE_C_COMPILER "${DEVKITPPC}/bin/powerpc-eabi-gcc.exe")
    set(CMAKE_CXX_COMPILER "${DEVKITPPC}/bin/powerpc-eabi-g++.exe")
    set(CMAKE_AR "${DEVKITPPC}/bin/powerpc-eabi-gcc-ar.exe" CACHE STRING "")
    set(CMAKE_RANLIB "${DEVKITPPC}/bin/powerpc-eabi-gcc-ranlib.exe" CACHE STRING "")
else()
    set(CMAKE_C_COMPILER "${DEVKITPPC}/bin/powerpc-eabi-gcc")
    set(CMAKE_CXX_COMPILER "${DEVKITPPC}/bin/powerpc-eabi-g++")
    set(CMAKE_AR "${DEVKITPPC}/bin/powerpc-eabi-gcc-ar" CACHE STRING "")
    set(CMAKE_RANLIB "${DEVKITPPC}/bin/powerpc-eabi-gcc-ranlib" CACHE STRING "")
endif()

set(WITH_PORTLIBS ON CACHE BOOL "use portlibs ?")

if(WITH_PORTLIBS)
    set(CMAKE_FIND_ROOT_PATH ${DEVKITPPC} ${DEVKITPRO} ${DEVKITPRO}/portlibs/ppc)
else()
    set(CMAKE_FIND_ROOT_PATH ${DEVKITPPC} ${DEVKITPRO})
endif()

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

SET(BUILD_SHARED_LIBS OFF CACHE INTERNAL "Shared libs not available" )

add_definitions( -DHAVE_POW -DHAVE_MMAP=0 -DWIIU -D__POWERPC__ -D__ppc__ -D__INT32_TYPE__=int -DMSB_FIRST -DWORDS_BIGENDIAN=1)

set(ARCH "-I${CORE_DIR}/libretro-common  -ffunction-sections -fdata-sections -Wl --gc-sections -Os -s  -mwup -mcpu=750 -meabi -mhard-float")
set(CMAKE_C_FLAGS "${ARCH}" CACHE STRING "C flags")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -fno-stack-protector  -fno-exceptions   -fno-rtti  -fvtable-gc -fno-merge-constants" CACHE STRING "C++ flags")

set(CMAKE_INSTALL_PREFIX ${DEVKITPRO}/portlibs/ppc
    CACHE PATH "Install libraries in the portlibs dir")
