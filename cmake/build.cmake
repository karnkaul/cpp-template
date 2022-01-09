cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

if("${BUILD_DIR}" STREQUAL "")
  set(BUILD_DIR build)
endif()
if("${INSTALL_DIR}" STREQUAL "")
  set(INSTALL_DIR install)
endif()
if("${BUILD_CONFIG}" STREQUAL "")
  set(BUILD_CONFIG Release)
endif()
if("${CONFIGURE}" STREQUAL "")
  set(CONFIGURE ON)
endif()
if("${BUILD}" STREQUAL "")
  set(BUILD ON)
endif()
if("${INSTALL}" STREQUAL "")
  set(INSTALL ON)
endif()

if(CONFIGURE)
  message(STATUS "Configuring ${BUILD_DIR}/${BUILD_CONFIG}...")
  execute_process(
    COMMAND ${CMAKE_COMMAND} -S . -B ${BUILD_DIR}/${BUILD_CONFIG} -DCMAKE_BUILD_TYPE=${BUILD_CONFIG} --preset=ninja-clang
    COMMAND_ERROR_IS_FATAL ANY
  )
endif()

if(BUILD)
  message(STATUS "Building ${BUILD_DIR}/${BUILD_CONFIG}...")
  execute_process(
    COMMAND ${CMAKE_COMMAND} --build ${BUILD_DIR}/${BUILD_CONFIG}
    COMMAND_ERROR_IS_FATAL ANY
  )
endif()

if(INSTALL)
  message(STATUS "Installing ${BUILD_DIR}/${BUILD_CONFIG} to ${BUILD_DIR}/${INSTALL_DIR}...")
  execute_process(
    COMMAND ${CMAKE_COMMAND} --install ${BUILD_DIR}/${BUILD_CONFIG} --prefix ${BUILD_DIR}/${INSTALL_DIR}
    COMMAND_ERROR_IS_FATAL ANY
  )
endif()
