# Install script for directory: /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/arm2

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
  if(EXISTS "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/loader/arm.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/loader/arm.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/loader/arm.so"
         RPATH "$ORIGIN/../../")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/loader/arm.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/loader" TYPE SHARED_LIBRARY FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/arm2/arm.so")
  if(EXISTS "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/loader/arm.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/loader/arm.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/loader/arm.so"
         OLD_RPATH "/home/yashas/otawa/linux-x86_64/otawa-core/lib:/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/prog:"
         NEW_RPATH "$ORIGIN/../../")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/loader/arm.so")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/loader/elf_40.eld")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/loader" TYPE FILE FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/arm2/elf_40.eld")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/proc/otawa/arm.eld")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/yashas/otawa/linux-x86_64/otawa-core/lib/otawa/proc/otawa" TYPE FILE FILES "/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/arm2/arm.eld")
endif()

