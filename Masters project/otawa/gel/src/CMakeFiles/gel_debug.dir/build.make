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
CMAKE_SOURCE_DIR = /home/yashas/otawa/linux-x86_64/otawa-core-build/gel

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/yashas/otawa/linux-x86_64/otawa-core-build/gel

# Include any dependencies generated for this target.
include src/CMakeFiles/gel_debug.dir/depend.make

# Include the progress variables for this target.
include src/CMakeFiles/gel_debug.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/gel_debug.dir/flags.make

src/CMakeFiles/gel_debug.dir/dwarf_line.c.o: src/CMakeFiles/gel_debug.dir/flags.make
src/CMakeFiles/gel_debug.dir/dwarf_line.c.o: src/dwarf_line.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/gel/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object src/CMakeFiles/gel_debug.dir/dwarf_line.c.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/gel_debug.dir/dwarf_line.c.o   -c /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src/dwarf_line.c

src/CMakeFiles/gel_debug.dir/dwarf_line.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/gel_debug.dir/dwarf_line.c.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src/dwarf_line.c > CMakeFiles/gel_debug.dir/dwarf_line.c.i

src/CMakeFiles/gel_debug.dir/dwarf_line.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/gel_debug.dir/dwarf_line.c.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src/dwarf_line.c -o CMakeFiles/gel_debug.dir/dwarf_line.c.s

src/CMakeFiles/gel_debug.dir/dwarf_line.c.o.requires:

.PHONY : src/CMakeFiles/gel_debug.dir/dwarf_line.c.o.requires

src/CMakeFiles/gel_debug.dir/dwarf_line.c.o.provides: src/CMakeFiles/gel_debug.dir/dwarf_line.c.o.requires
	$(MAKE) -f src/CMakeFiles/gel_debug.dir/build.make src/CMakeFiles/gel_debug.dir/dwarf_line.c.o.provides.build
.PHONY : src/CMakeFiles/gel_debug.dir/dwarf_line.c.o.provides

src/CMakeFiles/gel_debug.dir/dwarf_line.c.o.provides.build: src/CMakeFiles/gel_debug.dir/dwarf_line.c.o


src/CMakeFiles/gel_debug.dir/debug_line.c.o: src/CMakeFiles/gel_debug.dir/flags.make
src/CMakeFiles/gel_debug.dir/debug_line.c.o: src/debug_line.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/gel/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object src/CMakeFiles/gel_debug.dir/debug_line.c.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/gel_debug.dir/debug_line.c.o   -c /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src/debug_line.c

src/CMakeFiles/gel_debug.dir/debug_line.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/gel_debug.dir/debug_line.c.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src/debug_line.c > CMakeFiles/gel_debug.dir/debug_line.c.i

src/CMakeFiles/gel_debug.dir/debug_line.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/gel_debug.dir/debug_line.c.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src/debug_line.c -o CMakeFiles/gel_debug.dir/debug_line.c.s

src/CMakeFiles/gel_debug.dir/debug_line.c.o.requires:

.PHONY : src/CMakeFiles/gel_debug.dir/debug_line.c.o.requires

src/CMakeFiles/gel_debug.dir/debug_line.c.o.provides: src/CMakeFiles/gel_debug.dir/debug_line.c.o.requires
	$(MAKE) -f src/CMakeFiles/gel_debug.dir/build.make src/CMakeFiles/gel_debug.dir/debug_line.c.o.provides.build
.PHONY : src/CMakeFiles/gel_debug.dir/debug_line.c.o.provides

src/CMakeFiles/gel_debug.dir/debug_line.c.o.provides.build: src/CMakeFiles/gel_debug.dir/debug_line.c.o


src/CMakeFiles/gel_debug.dir/stabs.c.o: src/CMakeFiles/gel_debug.dir/flags.make
src/CMakeFiles/gel_debug.dir/stabs.c.o: src/stabs.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/gel/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object src/CMakeFiles/gel_debug.dir/stabs.c.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/gel_debug.dir/stabs.c.o   -c /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src/stabs.c

src/CMakeFiles/gel_debug.dir/stabs.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/gel_debug.dir/stabs.c.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src/stabs.c > CMakeFiles/gel_debug.dir/stabs.c.i

src/CMakeFiles/gel_debug.dir/stabs.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/gel_debug.dir/stabs.c.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src/stabs.c -o CMakeFiles/gel_debug.dir/stabs.c.s

src/CMakeFiles/gel_debug.dir/stabs.c.o.requires:

.PHONY : src/CMakeFiles/gel_debug.dir/stabs.c.o.requires

src/CMakeFiles/gel_debug.dir/stabs.c.o.provides: src/CMakeFiles/gel_debug.dir/stabs.c.o.requires
	$(MAKE) -f src/CMakeFiles/gel_debug.dir/build.make src/CMakeFiles/gel_debug.dir/stabs.c.o.provides.build
.PHONY : src/CMakeFiles/gel_debug.dir/stabs.c.o.provides

src/CMakeFiles/gel_debug.dir/stabs.c.o.provides.build: src/CMakeFiles/gel_debug.dir/stabs.c.o


# Object files for target gel_debug
gel_debug_OBJECTS = \
"CMakeFiles/gel_debug.dir/dwarf_line.c.o" \
"CMakeFiles/gel_debug.dir/debug_line.c.o" \
"CMakeFiles/gel_debug.dir/stabs.c.o"

# External object files for target gel_debug
gel_debug_EXTERNAL_OBJECTS =

src/libgel_debug.so: src/CMakeFiles/gel_debug.dir/dwarf_line.c.o
src/libgel_debug.so: src/CMakeFiles/gel_debug.dir/debug_line.c.o
src/libgel_debug.so: src/CMakeFiles/gel_debug.dir/stabs.c.o
src/libgel_debug.so: src/CMakeFiles/gel_debug.dir/build.make
src/libgel_debug.so: src/libgel.so
src/libgel_debug.so: src/CMakeFiles/gel_debug.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/gel/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking C shared library libgel_debug.so"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/gel_debug.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/CMakeFiles/gel_debug.dir/build: src/libgel_debug.so

.PHONY : src/CMakeFiles/gel_debug.dir/build

src/CMakeFiles/gel_debug.dir/requires: src/CMakeFiles/gel_debug.dir/dwarf_line.c.o.requires
src/CMakeFiles/gel_debug.dir/requires: src/CMakeFiles/gel_debug.dir/debug_line.c.o.requires
src/CMakeFiles/gel_debug.dir/requires: src/CMakeFiles/gel_debug.dir/stabs.c.o.requires

.PHONY : src/CMakeFiles/gel_debug.dir/requires

src/CMakeFiles/gel_debug.dir/clean:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src && $(CMAKE_COMMAND) -P CMakeFiles/gel_debug.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/gel_debug.dir/clean

src/CMakeFiles/gel_debug.dir/depend:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/gel && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/yashas/otawa/linux-x86_64/otawa-core-build/gel /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src /home/yashas/otawa/linux-x86_64/otawa-core-build/gel /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src /home/yashas/otawa/linux-x86_64/otawa-core-build/gel/src/CMakeFiles/gel_debug.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/CMakeFiles/gel_debug.dir/depend
