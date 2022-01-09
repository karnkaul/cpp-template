cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

enable_language(CXX)

set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)					# don't let OPTION erase non-cache variables
set(CMAKE_CXX_EXTENSIONS OFF CACHE INTERNAL "" FORCE)	# disable compiler extensions
set(CMAKE_POSITION_INDEPENDENT_CODE ON)					# enable PIC
set(CMAKE_DEBUG_POSTFIX "-d")
if("${CMAKE_BUILD_TYPE}" STREQUAL "")
  set(CMAKE_BUILD_TYPE Debug)			# ensure CMAKE_BUILD_TYPE is not empty
endif()

# cmake-utils
include(FetchContent)
set(FETCHCONTENT_QUIET OFF)
FetchContent_Declare(
  cmake-utils
  GIT_REPOSITORY https://github.com/karnkaul/cmake-utils
  GIT_TAG v1.0.1
)
FetchContent_MakeAvailable(cmake-utils)
FetchContent_GetProperties(cmake-utils)

# project parameters
set(project_name cpp-template)
set(${project_name}_version_file app_version.hpp)
set(${project_name}_version "1.0.0")
set(cxx_standard cxx_std_20)

project(${project_name} VERSION "${${project_name}_version}")
set(${project_name}_soversion ${PROJECT_VERSION_MAJOR})
set(is_root_project OFF)	# indicate if this is the top-level project
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  set(is_root_project ON)
  message(STATUS "${PROJECT_NAME} is top level")
endif()

# includes
include(CheckPIESupported)
check_pie_supported()
include(cmake/platform.cmake)	# set up helper cache variables
include("${cmake-utils_SOURCE_DIR}/cmake-utils.cmake")

# git operations
find_package(Git QUIET)
if(GIT_FOUND AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.git")
  git_get_commit_hash(${PROJECT_NAME}_GIT_COMMIT_HASH)	# store commit hash in ${PROJECT_NAME}_GIT_COMIT_HASH
  if(is_root_project)
    option(GIT_UPDATE_SUBMODULES "Init/Update submodules during generation" ${is_root_project})
    if(GIT_UPDATE_SUBMODULES)
      git_update_submodules(WARNING)	# update git submodules and warn on failure
    endif()
  endif()
endif()

add_subdirectory(cmake/interface)	# import interface library

# header text
if(is_root_project)
  set(build_config ${CMAKE_BUILD_TYPE})
  if(CMAKE_CONFIGURATION_TYPES)
    set(build_config "Multi-config")
  endif()
  message(STATUS "[${CMAKE_SYSTEM_PROCESSOR}] [${PLATFORM}] [${CMAKE_GENERATOR}] [${CMAKE_CXX_COMPILER_ID}] [${build_config}]")
endif()

# compile commands
if(is_root_project AND "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
  message(STATUS "Exporting compile commands")
endif()

# executable / library
add_executable(${PROJECT_NAME})
# add_library(${PROJECT_NAME})
# add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
set_property(TARGET ${PROJECT_NAME} PROPERTY VERSION ${${PROJECT_NAME}_version})
set_property(TARGET ${PROJECT_NAME} PROPERTY SOVERSION ${${PROJECT_NAME}_soversion})
set_property(TARGET ${PROJECT_NAME} PROPERTY INTERFACE_${PROJECT_NAME}_MAJOR_VERSION ${${PROJECT_NAME}_soversion})
set_property(TARGET ${PROJECT_NAME} APPEND PROPERTY COMPATIBLE_INTERFACE_STRING ${PROJECT_NAME}_MAJOR_VERSION)

target_include_directories(${PROJECT_NAME} SYSTEM INTERFACE
  "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
  "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>"
  "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)
target_include_directories(${PROJECT_NAME} PRIVATE
  include
  src
  "${CMAKE_CURRENT_BINARY_DIR}/include"
)
target_link_libraries(${PROJECT_NAME}
  PUBLIC
    ${PROJECT_NAME}::interface
  PRIVATE
    ${PROJECT_NAME}::options
)

if(W_MSBUILD)
  set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" PROPERTY VS_STARTUP_PROJECT ${PROJECT_NAME})	# set startup project for VS
endif()

target_sources(${PROJECT_NAME} PRIVATE src/main.cpp)
target_source_group(TARGET ${PROJECT_NAME})

# version
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/${${project_name}_version_file}.in")
  configure_src_bin(
    IN src/${${project_name}_version_file}.in 
    OUT ${project_name}/${${project_name}_version_file}
    TARGET ${project_name}
  )
endif()

install_and_export_target(TARGET ${PROJECT_NAME})
