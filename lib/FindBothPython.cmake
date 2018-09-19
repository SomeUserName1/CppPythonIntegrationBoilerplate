
######################################################################################
# Python extension builder
######################################################################################
foreach(Python_BUILD_VERSION 2 3)
  # Unfortunately, we can't use the cache because it treats 2 and 3 the same, so
  # we wouldn't be able to compile against both.
  foreach (_python_var
          PYTHONINTERP_FOUND PYTHON_EXECUTABLE PYTHON_VERSION_STRING
          PYTHON_VERSION_MAJOR PYTHON_VERSION_MINOR PYTHON_VERSION_PATCH)
    unset(${_python_var})
    unset(${_python_var} CACHE)
  endforeach (_python_var)
  foreach (_python_var
          PYTHONLIBS_FOUND PYTHONLIBS_VERSION_STRING PYTHON_DEBUG_LIBRARIES
          PYTHON_INCLUDE_DIR PYTHON_INCLUDE_DIRS PYTHON_INCLUDE_PATH PYTHON_LIBRARIES
          PYTHON_LIBRARY PYTHON_LIBRARY_DEBUG)
    unset(${_python_var})
    unset(${_python_var} CACHE)
  endforeach (_python_var)

  set(Python_ADDITIONAL_VERSIONS ${Python_BUILD_VERSION})
  find_package(PythonInterp)
  set(PYTHON${Python_BUILD_VERSION}INTERP_FOUND ${PYTHONINTERP_FOUND})
  set(PYTHON${Python_BUILD_VERSION}_EXECUTABLE ${PYTHON_EXECUTABLE})
  set(PYTHON${Python_BUILD_VERSION}_VERSION_STRING ${PYTHON_VERSION_STRING})
  set(PYTHON${Python_BUILD_VERSION}_VERSION_MAJOR ${PYTHON_VERSION_MAJOR})
  set(PYTHON${Python_BUILD_VERSION}_VERSION_MINOR ${PYTHON_VERSION_MINOR})
  set(PYTHON${Python_BUILD_VERSION}_VERSION_PATCH ${PYTHON_VERSION_PATCH})
  find_package(PythonLibs)
  set(PYTHON${Python_BUILD_VERSION}LIBS_FOUND ${PYTHONLIBS_FOUND})
  set(PYTHON${Python_BUILD_VERSION}LIBS_VERSION_STRING ${PYTHONLIBS_VERSION_STRING})
  set(PYTHON${Python_BUILD_VERSION}_DEBUG_LIBRARIES ${PYTHON_DEBUG_LIBRARIES})
  set(PYTHON${Python_BUILD_VERSION}_INCLUDE_PATH ${PYTHON_INCLUDE_PATH})
  set(PYTHON${Python_BUILD_VERSION}_INCLUDE_DIRS ${PYTHON_INCLUDE_DIRS})
  set(PYTHON${Python_BUILD_VERSION}_LIBRARIES ${PYTHON_LIBRARIES})

  if (NOT ${PYTHON${Python_BUILD_VERSION}_VERSION_STRING} EQUAL ${PYTHON${Python_BUILD_VERSION}LIBS_VERSION_STRING})
    message(FATAL_ERROR
            "Unable to find consistent Python ${Python_BUILD_VERSION} libraries. "
            "Python interpreter is ${PYTHON${Python_BUILD_VERSION}_VERSION_STRING}, "
            "but libraries are ${PYTHON${Python_BUILD_VERSION}LIBS_VERSION_STRING}.")
  endif ()

  # Figure out installation path
  execute_process(COMMAND
          ${PYTHON${Python_BUILD_VERSION}_EXECUTABLE}
          -c "import sysconfig as sc; print(sc.get_path('platlib'))"
          OUTPUT_VARIABLE PYTHON${Python_BUILD_VERSION}_SITE_PACKAGES OUTPUT_STRIP_TRAILING_WHITESPACE)
endforeach()