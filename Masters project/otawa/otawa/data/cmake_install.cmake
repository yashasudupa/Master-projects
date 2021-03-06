# Install script for directory: /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/data

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/yashas/otawa/linux-x86_64/otawa-core")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/Otawa/" TYPE DIRECTORY FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/data/caches" REGEX "/CVS$" EXCLUDE REGEX "/Makefile[^/]*$" EXCLUDE REGEX "/\\.cvsignore$" EXCLUDE)
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/Otawa/" TYPE DIRECTORY FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/data/makefiles" REGEX "/CVS$" EXCLUDE REGEX "/Makefile[^/]*$" EXCLUDE REGEX "/\\.cvsignore$" EXCLUDE)
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/Otawa/" TYPE DIRECTORY FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/data/procs" REGEX "/CVS$" EXCLUDE REGEX "/Makefile[^/]*$" EXCLUDE REGEX "/\\.cvsignore$" EXCLUDE)
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/Otawa/" TYPE DIRECTORY FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/data/scripts" REGEX "/CVS$" EXCLUDE REGEX "/Makefile[^/]*$" EXCLUDE REGEX "/\\.cvsignore$" EXCLUDE)
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/Otawa/" TYPE DIRECTORY FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/data/dtd" REGEX "/CVS$" EXCLUDE REGEX "/Makefile[^/]*$" EXCLUDE REGEX "/\\.cvsignore$" EXCLUDE)
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/Otawa/" TYPE DIRECTORY FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/data/cmake" REGEX "/CVS$" EXCLUDE REGEX "/Makefile[^/]*$" EXCLUDE REGEX "/\\.cvsignore$" EXCLUDE)
endif()

