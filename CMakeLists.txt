CMAKE_MINIMUM_REQUIRED(VERSION 3.1)
PROJECT(py_integration)

SET(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/lib")
SET(CMAKE_CXX_COMPILER clang++)
SET(CMAKE_CXX_FLAGS "-Wall -Wpedantic -sanitize=memory -Wthread-safety -O3 -std=c++17")

FIND_PACKAGE(BothPython REQUIRED)
FIND_PACKAGE(Boost REQUIRED)


CONFIGURE_FILE(PythonIntegration.cc.in ../PythonIntegration.cc @ONLY)

ADD_EXECUTABLE(PythonIntegration PythonIntegration.cc)

TARGET_LINK_LIBRARIES(PythonIntegration
    ${CMAKE_DL_LIBS}
    ${Boost_LIBRARIES}
    )
