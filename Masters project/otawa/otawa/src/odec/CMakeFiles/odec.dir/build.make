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
include src/odec/CMakeFiles/odec.dir/depend.make

# Include the progress variables for this target.
include src/odec/CMakeFiles/odec.dir/progress.make

# Include the compile flags for this target's objects.
include src/odec/CMakeFiles/odec.dir/flags.make

src/odec/CMakeFiles/odec.dir/odec.cpp.o: src/odec/CMakeFiles/odec.dir/flags.make
src/odec/CMakeFiles/odec.dir/odec.cpp.o: src/odec/odec.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/odec/CMakeFiles/odec.dir/odec.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/odec && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/odec.dir/odec.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/odec/odec.cpp

src/odec/CMakeFiles/odec.dir/odec.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/odec.dir/odec.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/odec && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/odec/odec.cpp > CMakeFiles/odec.dir/odec.cpp.i

src/odec/CMakeFiles/odec.dir/odec.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/odec.dir/odec.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/odec && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/odec/odec.cpp -o CMakeFiles/odec.dir/odec.cpp.s

src/odec/CMakeFiles/odec.dir/odec.cpp.o.requires:

.PHONY : src/odec/CMakeFiles/odec.dir/odec.cpp.o.requires

src/odec/CMakeFiles/odec.dir/odec.cpp.o.provides: src/odec/CMakeFiles/odec.dir/odec.cpp.o.requires
	$(MAKE) -f src/odec/CMakeFiles/odec.dir/build.make src/odec/CMakeFiles/odec.dir/odec.cpp.o.provides.build
.PHONY : src/odec/CMakeFiles/odec.dir/odec.cpp.o.provides

src/odec/CMakeFiles/odec.dir/odec.cpp.o.provides.build: src/odec/CMakeFiles/odec.dir/odec.cpp.o


# Object files for target odec
odec_OBJECTS = \
"CMakeFiles/odec.dir/odec.cpp.o"

# External object files for target odec
odec_EXTERNAL_OBJECTS =

src/odec/odec: src/odec/CMakeFiles/odec.dir/odec.cpp.o
src/odec/odec: src/odec/CMakeFiles/odec.dir/build.make
src/odec/odec: src/prog/libotawa.so
src/odec/odec: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libelm.so
src/odec/odec: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libgel.so
src/odec/odec: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libgel_dwarf.so
src/odec/odec: src/odec/CMakeFiles/odec.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable odec"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/odec && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/odec.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/odec/CMakeFiles/odec.dir/build: src/odec/odec

.PHONY : src/odec/CMakeFiles/odec.dir/build

src/odec/CMakeFiles/odec.dir/requires: src/odec/CMakeFiles/odec.dir/odec.cpp.o.requires

.PHONY : src/odec/CMakeFiles/odec.dir/requires

src/odec/CMakeFiles/odec.dir/clean:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/odec && $(CMAKE_COMMAND) -P CMakeFiles/odec.dir/cmake_clean.cmake
.PHONY : src/odec/CMakeFiles/odec.dir/clean

src/odec/CMakeFiles/odec.dir/depend:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/odec /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/odec /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/odec/CMakeFiles/odec.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/odec/CMakeFiles/odec.dir/depend
