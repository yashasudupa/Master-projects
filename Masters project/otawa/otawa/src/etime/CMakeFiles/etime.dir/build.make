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
include src/etime/CMakeFiles/etime.dir/depend.make

# Include the progress variables for this target.
include src/etime/CMakeFiles/etime.dir/progress.make

# Include the compile flags for this target's objects.
include src/etime/CMakeFiles/etime.dir/flags.make

src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.o: src/etime/CMakeFiles/etime.dir/flags.make
src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.o: src/etime/StandardEventBuilder.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/etime.dir/StandardEventBuilder.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime/StandardEventBuilder.cpp

src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/etime.dir/StandardEventBuilder.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime/StandardEventBuilder.cpp > CMakeFiles/etime.dir/StandardEventBuilder.cpp.i

src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/etime.dir/StandardEventBuilder.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime/StandardEventBuilder.cpp -o CMakeFiles/etime.dir/StandardEventBuilder.cpp.s

src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.o.requires:

.PHONY : src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.o.requires

src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.o.provides: src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.o.requires
	$(MAKE) -f src/etime/CMakeFiles/etime.dir/build.make src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.o.provides.build
.PHONY : src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.o.provides

src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.o.provides.build: src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.o


src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o: src/etime/CMakeFiles/etime.dir/flags.make
src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o: src/etime/EdgeTimeBuilder.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime/EdgeTimeBuilder.cpp

src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime/EdgeTimeBuilder.cpp > CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.i

src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime/EdgeTimeBuilder.cpp -o CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.s

src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o.requires:

.PHONY : src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o.requires

src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o.provides: src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o.requires
	$(MAKE) -f src/etime/CMakeFiles/etime.dir/build.make src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o.provides.build
.PHONY : src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o.provides

src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o.provides.build: src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o


src/etime/CMakeFiles/etime.dir/hook.cpp.o: src/etime/CMakeFiles/etime.dir/flags.make
src/etime/CMakeFiles/etime.dir/hook.cpp.o: src/etime/hook.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object src/etime/CMakeFiles/etime.dir/hook.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/etime.dir/hook.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime/hook.cpp

src/etime/CMakeFiles/etime.dir/hook.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/etime.dir/hook.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime/hook.cpp > CMakeFiles/etime.dir/hook.cpp.i

src/etime/CMakeFiles/etime.dir/hook.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/etime.dir/hook.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime/hook.cpp -o CMakeFiles/etime.dir/hook.cpp.s

src/etime/CMakeFiles/etime.dir/hook.cpp.o.requires:

.PHONY : src/etime/CMakeFiles/etime.dir/hook.cpp.o.requires

src/etime/CMakeFiles/etime.dir/hook.cpp.o.provides: src/etime/CMakeFiles/etime.dir/hook.cpp.o.requires
	$(MAKE) -f src/etime/CMakeFiles/etime.dir/build.make src/etime/CMakeFiles/etime.dir/hook.cpp.o.provides.build
.PHONY : src/etime/CMakeFiles/etime.dir/hook.cpp.o.provides

src/etime/CMakeFiles/etime.dir/hook.cpp.o.provides.build: src/etime/CMakeFiles/etime.dir/hook.cpp.o


# Object files for target etime
etime_OBJECTS = \
"CMakeFiles/etime.dir/StandardEventBuilder.cpp.o" \
"CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o" \
"CMakeFiles/etime.dir/hook.cpp.o"

# External object files for target etime
etime_EXTERNAL_OBJECTS =

src/etime/etime.so: src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.o
src/etime/etime.so: src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o
src/etime/etime.so: src/etime/CMakeFiles/etime.dir/hook.cpp.o
src/etime/etime.so: src/etime/CMakeFiles/etime.dir/build.make
src/etime/etime.so: src/branch/branch.so
src/etime/etime.so: src/dcache/dcache.so
src/etime/etime.so: src/prog/libotawa.so
src/etime/etime.so: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libgel.so
src/etime/etime.so: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libgel_dwarf.so
src/etime/etime.so: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libelm.so
src/etime/etime.so: src/etime/CMakeFiles/etime.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking CXX shared library etime.so"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/etime.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/etime/CMakeFiles/etime.dir/build: src/etime/etime.so

.PHONY : src/etime/CMakeFiles/etime.dir/build

src/etime/CMakeFiles/etime.dir/requires: src/etime/CMakeFiles/etime.dir/StandardEventBuilder.cpp.o.requires
src/etime/CMakeFiles/etime.dir/requires: src/etime/CMakeFiles/etime.dir/EdgeTimeBuilder.cpp.o.requires
src/etime/CMakeFiles/etime.dir/requires: src/etime/CMakeFiles/etime.dir/hook.cpp.o.requires

.PHONY : src/etime/CMakeFiles/etime.dir/requires

src/etime/CMakeFiles/etime.dir/clean:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime && $(CMAKE_COMMAND) -P CMakeFiles/etime.dir/cmake_clean.cmake
.PHONY : src/etime/CMakeFiles/etime.dir/clean

src/etime/CMakeFiles/etime.dir/depend:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/etime/CMakeFiles/etime.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/etime/CMakeFiles/etime.dir/depend

