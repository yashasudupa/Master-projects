# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa

# Include any dependencies generated for this target.
include src/oipet/CMakeFiles/oipet.dir/depend.make

# Include the progress variables for this target.
include src/oipet/CMakeFiles/oipet.dir/progress.make

# Include the compile flags for this target's objects.
include src/oipet/CMakeFiles/oipet.dir/flags.make

src/oipet/CMakeFiles/oipet.dir/oipet.cpp.o: src/oipet/CMakeFiles/oipet.dir/flags.make
src/oipet/CMakeFiles/oipet.dir/oipet.cpp.o: src/oipet/oipet.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/oipet/CMakeFiles/oipet.dir/oipet.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/oipet && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/oipet.dir/oipet.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/oipet/oipet.cpp

src/oipet/CMakeFiles/oipet.dir/oipet.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/oipet.dir/oipet.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/oipet && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/oipet/oipet.cpp > CMakeFiles/oipet.dir/oipet.cpp.i

src/oipet/CMakeFiles/oipet.dir/oipet.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/oipet.dir/oipet.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/oipet && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/oipet/oipet.cpp -o CMakeFiles/oipet.dir/oipet.cpp.s

src/oipet/CMakeFiles/oipet.dir/oipet.cpp.o.requires:

.PHONY : src/oipet/CMakeFiles/oipet.dir/oipet.cpp.o.requires

src/oipet/CMakeFiles/oipet.dir/oipet.cpp.o.provides: src/oipet/CMakeFiles/oipet.dir/oipet.cpp.o.requires
	$(MAKE) -f src/oipet/CMakeFiles/oipet.dir/build.make src/oipet/CMakeFiles/oipet.dir/oipet.cpp.o.provides.build
.PHONY : src/oipet/CMakeFiles/oipet.dir/oipet.cpp.o.provides

src/oipet/CMakeFiles/oipet.dir/oipet.cpp.o.provides.build: src/oipet/CMakeFiles/oipet.dir/oipet.cpp.o


# Object files for target oipet
oipet_OBJECTS = \
"CMakeFiles/oipet.dir/oipet.cpp.o"

# External object files for target oipet
oipet_EXTERNAL_OBJECTS =

src/oipet/oipet: src/oipet/CMakeFiles/oipet.dir/oipet.cpp.o
src/oipet/oipet: src/oipet/CMakeFiles/oipet.dir/build.make
src/oipet/oipet: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libelm.so
src/oipet/oipet: src/odisplay/libodisplay.so
src/oipet/oipet: src/prog/libotawa.so
src/oipet/oipet: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libelm.so
src/oipet/oipet: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libgel.so
src/oipet/oipet: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libgel_dwarf.so
src/oipet/oipet: src/oipet/CMakeFiles/oipet.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable oipet"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/oipet && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/oipet.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/oipet/CMakeFiles/oipet.dir/build: src/oipet/oipet

.PHONY : src/oipet/CMakeFiles/oipet.dir/build

src/oipet/CMakeFiles/oipet.dir/requires: src/oipet/CMakeFiles/oipet.dir/oipet.cpp.o.requires

.PHONY : src/oipet/CMakeFiles/oipet.dir/requires

src/oipet/CMakeFiles/oipet.dir/clean:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/oipet && $(CMAKE_COMMAND) -P CMakeFiles/oipet.dir/cmake_clean.cmake
.PHONY : src/oipet/CMakeFiles/oipet.dir/clean

src/oipet/CMakeFiles/oipet.dir/depend:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/oipet /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/oipet /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/oipet/CMakeFiles/oipet.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/oipet/CMakeFiles/oipet.dir/depend
