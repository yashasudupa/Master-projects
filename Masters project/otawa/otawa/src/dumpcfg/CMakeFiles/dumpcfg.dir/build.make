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
include src/dumpcfg/CMakeFiles/dumpcfg.dir/depend.make

# Include the progress variables for this target.
include src/dumpcfg/CMakeFiles/dumpcfg.dir/progress.make

# Include the compile flags for this target's objects.
include src/dumpcfg/CMakeFiles/dumpcfg.dir/flags.make

src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o: src/dumpcfg/CMakeFiles/dumpcfg.dir/flags.make
src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o: src/dumpcfg/dumpcfg.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg/dumpcfg.cpp

src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/dumpcfg.dir/dumpcfg.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg/dumpcfg.cpp > CMakeFiles/dumpcfg.dir/dumpcfg.cpp.i

src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/dumpcfg.dir/dumpcfg.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg/dumpcfg.cpp -o CMakeFiles/dumpcfg.dir/dumpcfg.cpp.s

src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o.requires:

.PHONY : src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o.requires

src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o.provides: src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o.requires
	$(MAKE) -f src/dumpcfg/CMakeFiles/dumpcfg.dir/build.make src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o.provides.build
.PHONY : src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o.provides

src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o.provides.build: src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o


src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o: src/dumpcfg/CMakeFiles/dumpcfg.dir/flags.make
src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o: src/dumpcfg/SimpleDisplayer.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg/SimpleDisplayer.cpp

src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg/SimpleDisplayer.cpp > CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.i

src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg/SimpleDisplayer.cpp -o CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.s

src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o.requires:

.PHONY : src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o.requires

src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o.provides: src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o.requires
	$(MAKE) -f src/dumpcfg/CMakeFiles/dumpcfg.dir/build.make src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o.provides.build
.PHONY : src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o.provides

src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o.provides.build: src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o


src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o: src/dumpcfg/CMakeFiles/dumpcfg.dir/flags.make
src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o: src/dumpcfg/DisassemblerDisplayer.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg/DisassemblerDisplayer.cpp

src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg/DisassemblerDisplayer.cpp > CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.i

src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg/DisassemblerDisplayer.cpp -o CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.s

src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o.requires:

.PHONY : src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o.requires

src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o.provides: src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o.requires
	$(MAKE) -f src/dumpcfg/CMakeFiles/dumpcfg.dir/build.make src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o.provides.build
.PHONY : src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o.provides

src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o.provides.build: src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o


src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o: src/dumpcfg/CMakeFiles/dumpcfg.dir/flags.make
src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o: src/dumpcfg/DotDisplayer.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg/DotDisplayer.cpp

src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg/DotDisplayer.cpp > CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.i

src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg/DotDisplayer.cpp -o CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.s

src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o.requires:

.PHONY : src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o.requires

src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o.provides: src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o.requires
	$(MAKE) -f src/dumpcfg/CMakeFiles/dumpcfg.dir/build.make src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o.provides.build
.PHONY : src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o.provides

src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o.provides.build: src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o


# Object files for target dumpcfg
dumpcfg_OBJECTS = \
"CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o" \
"CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o" \
"CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o" \
"CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o"

# External object files for target dumpcfg
dumpcfg_EXTERNAL_OBJECTS =

src/dumpcfg/dumpcfg: src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o
src/dumpcfg/dumpcfg: src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o
src/dumpcfg/dumpcfg: src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o
src/dumpcfg/dumpcfg: src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o
src/dumpcfg/dumpcfg: src/dumpcfg/CMakeFiles/dumpcfg.dir/build.make
src/dumpcfg/dumpcfg: src/prog/libotawa.so
src/dumpcfg/dumpcfg: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libelm.so
src/dumpcfg/dumpcfg: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libgel.so
src/dumpcfg/dumpcfg: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libgel_dwarf.so
src/dumpcfg/dumpcfg: src/dumpcfg/CMakeFiles/dumpcfg.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Linking CXX executable dumpcfg"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/dumpcfg.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/dumpcfg/CMakeFiles/dumpcfg.dir/build: src/dumpcfg/dumpcfg

.PHONY : src/dumpcfg/CMakeFiles/dumpcfg.dir/build

src/dumpcfg/CMakeFiles/dumpcfg.dir/requires: src/dumpcfg/CMakeFiles/dumpcfg.dir/dumpcfg.cpp.o.requires
src/dumpcfg/CMakeFiles/dumpcfg.dir/requires: src/dumpcfg/CMakeFiles/dumpcfg.dir/SimpleDisplayer.cpp.o.requires
src/dumpcfg/CMakeFiles/dumpcfg.dir/requires: src/dumpcfg/CMakeFiles/dumpcfg.dir/DisassemblerDisplayer.cpp.o.requires
src/dumpcfg/CMakeFiles/dumpcfg.dir/requires: src/dumpcfg/CMakeFiles/dumpcfg.dir/DotDisplayer.cpp.o.requires

.PHONY : src/dumpcfg/CMakeFiles/dumpcfg.dir/requires

src/dumpcfg/CMakeFiles/dumpcfg.dir/clean:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg && $(CMAKE_COMMAND) -P CMakeFiles/dumpcfg.dir/cmake_clean.cmake
.PHONY : src/dumpcfg/CMakeFiles/dumpcfg.dir/clean

src/dumpcfg/CMakeFiles/dumpcfg.dir/depend:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/dumpcfg/CMakeFiles/dumpcfg.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/dumpcfg/CMakeFiles/dumpcfg.dir/depend

