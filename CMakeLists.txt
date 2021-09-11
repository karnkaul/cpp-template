cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

enable_language(CXX)

set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)					# don't let OPTION erase non-cache variables
set(CMAKE_CXX_EXTENSIONS OFF CACHE INTERNAL "" FORCE)	# disable compiler extensions
set(CMAKE_POSITION_INDEPENDENT_CODE ON)					# enable PIC
set(CMAKE_DEBUG_POSTFIX "-d")
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)			# ensure CMAKE_BUILD_TYPE is not empty
endif()

# project parameters
set(project_name cpp-template)
set(project_version "0.1.0.0")
set(project_version_name cpp_template_version) # name of variable in generated header
set(cxx_standard cxx_std_17)

project(${project_name} VERSION "${project_version}")
set(is_root_project OFF)	# indicate if this is the top-level project
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  set(is_root_project ON)
  message(STATUS "${PROJECT_NAME} is top level")
endif()

# includes
include(CheckPIESupported)
check_pie_supported()
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
include(cmake/platform.cmake)	# set up helper cache variables
include(cmake/utils.cmake)		# functions for git operations etc

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
set(build_config ${CMAKE_BUILD_TYPE})
if(CMAKE_CONFIGURATION_TYPES)
	set(build_config "Multi-config")
endif()
message(STATUS "[${CMAKE_SYSTEM_PROCESSOR}] [${PLATFORM}] [${CMAKE_GENERATOR}] [${CMAKE_CXX_COMPILER_ID}] [${build_config}]")

# compile commands
if(is_root_project AND "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
	set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
	message(STATUS "Exporting compile commands")
endif()

# version
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/src/version.hpp.in" "${CMAKE_CURRENT_BINARY_DIR}/generated/version.hpp")

# executable
add_executable(${PROJECT_NAME})
target_sources(${PROJECT_NAME} PRIVATE src/main.cpp)
target_source_group(${PROJECT_NAME})
target_include_directories(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_BINARY_DIR}/generated")
target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}::options)					# apply interface library options

if(W_MSBUILD)
	set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" PROPERTY VS_STARTUP_PROJECT ${PROJECT_NAME})	# set startup project for VS
endif()
