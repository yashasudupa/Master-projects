# Install script for directory: /home/yashas/otawa/linux-x86_64/otawa-core-build/lpc2138

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
  if(EXISTS "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/proc/otawa/lpc2138.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/proc/otawa/lpc2138.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/proc/otawa/lpc2138.so"
         RPATH "\$ORIGIN/../../../")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/proc/otawa/lpc2138.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/proc/otawa" TYPE MODULE FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/lpc2138/lpc2138.so")
  if(EXISTS "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/proc/otawa/lpc2138.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/proc/otawa/lpc2138.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/proc/otawa/lpc2138.so"
         OLD_RPATH "::::::::::::::::::"
         NEW_RPATH "\$ORIGIN/../../../")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/proc/otawa/lpc2138.so")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/proc/otawa/lpc2138.eld")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/proc/otawa" TYPE FILE FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/lpc2138/lpc2138.eld")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/yashas/otawa/linux-x86_64/otawa-core/share/Otawa/scripts/lpc2138.osx")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/yashas/otawa/linux-x86_64/otawa-core/share/Otawa/scripts" TYPE FILE FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/lpc2138/lpc2138.osx")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/yashas/otawa/linux-x86_64/otawa-core/share/Otawa/scripts/lpc2138/memory.xml")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/yashas/otawa/linux-x86_64/otawa-core/share/Otawa/scripts/lpc2138" TYPE FILE FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/lpc2138/lpc2138/memory.xml")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/yashas/otawa/linux-x86_64/otawa-core/share/Otawa/scripts/lpc2138/pipeline.xml")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/yashas/otawa/linux-x86_64/otawa-core/share/Otawa/scripts/lpc2138" TYPE FILE FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/lpc2138/lpc2138/pipeline.xml")
endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/yashas/otawa/linux-x86_64/otawa-core-build/lpc2138/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
