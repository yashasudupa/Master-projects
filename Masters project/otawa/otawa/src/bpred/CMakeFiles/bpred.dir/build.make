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
include src/bpred/CMakeFiles/bpred.dir/depend.make

# Include the progress variables for this target.
include src/bpred/CMakeFiles/bpred.dir/progress.make

# Include the compile flags for this target's objects.
include src/bpred/CMakeFiles/bpred.dir/flags.make

src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.o: src/bpred/CMakeFiles/bpred.dir/flags.make
src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.o: src/bpred/BBHG.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/bpred.dir/BBHG.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BBHG.cpp

src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bpred.dir/BBHG.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BBHG.cpp > CMakeFiles/bpred.dir/BBHG.cpp.i

src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bpred.dir/BBHG.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BBHG.cpp -o CMakeFiles/bpred.dir/BBHG.cpp.s

src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.o.requires:

.PHONY : src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.o.requires

src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.o.provides: src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.o.requires
	$(MAKE) -f src/bpred/CMakeFiles/bpred.dir/build.make src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.o.provides.build
.PHONY : src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.o.provides

src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.o.provides.build: src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.o


src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.o: src/bpred/CMakeFiles/bpred.dir/flags.make
src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.o: src/bpred/BBHGDrawer.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/bpred.dir/BBHGDrawer.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BBHGDrawer.cpp

src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bpred.dir/BBHGDrawer.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BBHGDrawer.cpp > CMakeFiles/bpred.dir/BBHGDrawer.cpp.i

src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bpred.dir/BBHGDrawer.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BBHGDrawer.cpp -o CMakeFiles/bpred.dir/BBHGDrawer.cpp.s

src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.o.requires:

.PHONY : src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.o.requires

src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.o.provides: src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.o.requires
	$(MAKE) -f src/bpred/CMakeFiles/bpred.dir/build.make src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.o.provides.build
.PHONY : src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.o.provides

src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.o.provides.build: src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.o


src/bpred/CMakeFiles/bpred.dir/BHG.cpp.o: src/bpred/CMakeFiles/bpred.dir/flags.make
src/bpred/CMakeFiles/bpred.dir/BHG.cpp.o: src/bpred/BHG.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object src/bpred/CMakeFiles/bpred.dir/BHG.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/bpred.dir/BHG.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BHG.cpp

src/bpred/CMakeFiles/bpred.dir/BHG.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bpred.dir/BHG.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BHG.cpp > CMakeFiles/bpred.dir/BHG.cpp.i

src/bpred/CMakeFiles/bpred.dir/BHG.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bpred.dir/BHG.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BHG.cpp -o CMakeFiles/bpred.dir/BHG.cpp.s

src/bpred/CMakeFiles/bpred.dir/BHG.cpp.o.requires:

.PHONY : src/bpred/CMakeFiles/bpred.dir/BHG.cpp.o.requires

src/bpred/CMakeFiles/bpred.dir/BHG.cpp.o.provides: src/bpred/CMakeFiles/bpred.dir/BHG.cpp.o.requires
	$(MAKE) -f src/bpred/CMakeFiles/bpred.dir/build.make src/bpred/CMakeFiles/bpred.dir/BHG.cpp.o.provides.build
.PHONY : src/bpred/CMakeFiles/bpred.dir/BHG.cpp.o.provides

src/bpred/CMakeFiles/bpred.dir/BHG.cpp.o.provides.build: src/bpred/CMakeFiles/bpred.dir/BHG.cpp.o


src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.o: src/bpred/CMakeFiles/bpred.dir/flags.make
src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.o: src/bpred/BHGDrawer.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/bpred.dir/BHGDrawer.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BHGDrawer.cpp

src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bpred.dir/BHGDrawer.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BHGDrawer.cpp > CMakeFiles/bpred.dir/BHGDrawer.cpp.i

src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bpred.dir/BHGDrawer.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BHGDrawer.cpp -o CMakeFiles/bpred.dir/BHGDrawer.cpp.s

src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.o.requires:

.PHONY : src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.o.requires

src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.o.provides: src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.o.requires
	$(MAKE) -f src/bpred/CMakeFiles/bpred.dir/build.make src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.o.provides.build
.PHONY : src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.o.provides

src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.o.provides.build: src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.o


src/bpred/CMakeFiles/bpred.dir/BCG.cpp.o: src/bpred/CMakeFiles/bpred.dir/flags.make
src/bpred/CMakeFiles/bpred.dir/BCG.cpp.o: src/bpred/BCG.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object src/bpred/CMakeFiles/bpred.dir/BCG.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/bpred.dir/BCG.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BCG.cpp

src/bpred/CMakeFiles/bpred.dir/BCG.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bpred.dir/BCG.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BCG.cpp > CMakeFiles/bpred.dir/BCG.cpp.i

src/bpred/CMakeFiles/bpred.dir/BCG.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bpred.dir/BCG.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BCG.cpp -o CMakeFiles/bpred.dir/BCG.cpp.s

src/bpred/CMakeFiles/bpred.dir/BCG.cpp.o.requires:

.PHONY : src/bpred/CMakeFiles/bpred.dir/BCG.cpp.o.requires

src/bpred/CMakeFiles/bpred.dir/BCG.cpp.o.provides: src/bpred/CMakeFiles/bpred.dir/BCG.cpp.o.requires
	$(MAKE) -f src/bpred/CMakeFiles/bpred.dir/build.make src/bpred/CMakeFiles/bpred.dir/BCG.cpp.o.provides.build
.PHONY : src/bpred/CMakeFiles/bpred.dir/BCG.cpp.o.provides

src/bpred/CMakeFiles/bpred.dir/BCG.cpp.o.provides.build: src/bpred/CMakeFiles/bpred.dir/BCG.cpp.o


src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.o: src/bpred/CMakeFiles/bpred.dir/flags.make
src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.o: src/bpred/BCGDrawer.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/bpred.dir/BCGDrawer.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BCGDrawer.cpp

src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bpred.dir/BCGDrawer.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BCGDrawer.cpp > CMakeFiles/bpred.dir/BCGDrawer.cpp.i

src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bpred.dir/BCGDrawer.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BCGDrawer.cpp -o CMakeFiles/bpred.dir/BCGDrawer.cpp.s

src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.o.requires:

.PHONY : src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.o.requires

src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.o.provides: src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.o.requires
	$(MAKE) -f src/bpred/CMakeFiles/bpred.dir/build.make src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.o.provides.build
.PHONY : src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.o.provides

src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.o.provides.build: src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.o


src/bpred/CMakeFiles/bpred.dir/BSets.cpp.o: src/bpred/CMakeFiles/bpred.dir/flags.make
src/bpred/CMakeFiles/bpred.dir/BSets.cpp.o: src/bpred/BSets.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building CXX object src/bpred/CMakeFiles/bpred.dir/BSets.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/bpred.dir/BSets.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BSets.cpp

src/bpred/CMakeFiles/bpred.dir/BSets.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bpred.dir/BSets.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BSets.cpp > CMakeFiles/bpred.dir/BSets.cpp.i

src/bpred/CMakeFiles/bpred.dir/BSets.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bpred.dir/BSets.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BSets.cpp -o CMakeFiles/bpred.dir/BSets.cpp.s

src/bpred/CMakeFiles/bpred.dir/BSets.cpp.o.requires:

.PHONY : src/bpred/CMakeFiles/bpred.dir/BSets.cpp.o.requires

src/bpred/CMakeFiles/bpred.dir/BSets.cpp.o.provides: src/bpred/CMakeFiles/bpred.dir/BSets.cpp.o.requires
	$(MAKE) -f src/bpred/CMakeFiles/bpred.dir/build.make src/bpred/CMakeFiles/bpred.dir/BSets.cpp.o.provides.build
.PHONY : src/bpred/CMakeFiles/bpred.dir/BSets.cpp.o.provides

src/bpred/CMakeFiles/bpred.dir/BSets.cpp.o.provides.build: src/bpred/CMakeFiles/bpred.dir/BSets.cpp.o


src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o: src/bpred/CMakeFiles/bpred.dir/flags.make
src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o: src/bpred/BPredProcessor_NoConflict.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Building CXX object src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_NoConflict.cpp

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_NoConflict.cpp > CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.i

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_NoConflict.cpp -o CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.s

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o.requires:

.PHONY : src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o.requires

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o.provides: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o.requires
	$(MAKE) -f src/bpred/CMakeFiles/bpred.dir/build.make src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o.provides.build
.PHONY : src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o.provides

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o.provides.build: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o


src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o: src/bpred/CMakeFiles/bpred.dir/flags.make
src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o: src/bpred/BPredProcessor_Bimodal.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Building CXX object src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_Bimodal.cpp

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_Bimodal.cpp > CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.i

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_Bimodal.cpp -o CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.s

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o.requires:

.PHONY : src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o.requires

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o.provides: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o.requires
	$(MAKE) -f src/bpred/CMakeFiles/bpred.dir/build.make src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o.provides.build
.PHONY : src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o.provides

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o.provides.build: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o


src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o: src/bpred/CMakeFiles/bpred.dir/flags.make
src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o: src/bpred/BPredProcessor_Global1B.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_10) "Building CXX object src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_Global1B.cpp

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_Global1B.cpp > CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.i

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_Global1B.cpp -o CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.s

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o.requires:

.PHONY : src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o.requires

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o.provides: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o.requires
	$(MAKE) -f src/bpred/CMakeFiles/bpred.dir/build.make src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o.provides.build
.PHONY : src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o.provides

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o.provides.build: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o


src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o: src/bpred/CMakeFiles/bpred.dir/flags.make
src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o: src/bpred/BPredProcessor_Global2B.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_11) "Building CXX object src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_Global2B.cpp

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_Global2B.cpp > CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.i

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_Global2B.cpp -o CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.s

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o.requires:

.PHONY : src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o.requires

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o.provides: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o.requires
	$(MAKE) -f src/bpred/CMakeFiles/bpred.dir/build.make src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o.provides.build
.PHONY : src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o.provides

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o.provides.build: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o


src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o: src/bpred/CMakeFiles/bpred.dir/flags.make
src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o: src/bpred/BPredProcessor_stats.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_12) "Building CXX object src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_stats.cpp

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_stats.cpp > CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.i

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor_stats.cpp -o CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.s

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o.requires:

.PHONY : src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o.requires

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o.provides: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o.requires
	$(MAKE) -f src/bpred/CMakeFiles/bpred.dir/build.make src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o.provides.build
.PHONY : src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o.provides

src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o.provides.build: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o


src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.o: src/bpred/CMakeFiles/bpred.dir/flags.make
src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.o: src/bpred/BPredProcessor.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_13) "Building CXX object src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/bpred.dir/BPredProcessor.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor.cpp

src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bpred.dir/BPredProcessor.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor.cpp > CMakeFiles/bpred.dir/BPredProcessor.cpp.i

src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bpred.dir/BPredProcessor.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/BPredProcessor.cpp -o CMakeFiles/bpred.dir/BPredProcessor.cpp.s

src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.o.requires:

.PHONY : src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.o.requires

src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.o.provides: src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.o.requires
	$(MAKE) -f src/bpred/CMakeFiles/bpred.dir/build.make src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.o.provides.build
.PHONY : src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.o.provides

src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.o.provides.build: src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.o


# Object files for target bpred
bpred_OBJECTS = \
"CMakeFiles/bpred.dir/BBHG.cpp.o" \
"CMakeFiles/bpred.dir/BBHGDrawer.cpp.o" \
"CMakeFiles/bpred.dir/BHG.cpp.o" \
"CMakeFiles/bpred.dir/BHGDrawer.cpp.o" \
"CMakeFiles/bpred.dir/BCG.cpp.o" \
"CMakeFiles/bpred.dir/BCGDrawer.cpp.o" \
"CMakeFiles/bpred.dir/BSets.cpp.o" \
"CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o" \
"CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o" \
"CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o" \
"CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o" \
"CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o" \
"CMakeFiles/bpred.dir/BPredProcessor.cpp.o"

# External object files for target bpred
bpred_EXTERNAL_OBJECTS =

src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.o
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.o
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/BHG.cpp.o
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.o
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/BCG.cpp.o
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.o
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/BSets.cpp.o
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.o
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/build.make
src/bpred/bpred.so: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libelm.so
src/bpred/bpred.so: src/odisplay/libodisplay.so
src/bpred/bpred.so: src/prog/libotawa.so
src/bpred/bpred.so: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libelm.so
src/bpred/bpred.so: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libgel.so
src/bpred/bpred.so: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libgel_dwarf.so
src/bpred/bpred.so: src/bpred/CMakeFiles/bpred.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_14) "Linking CXX shared library bpred.so"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/bpred.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/bpred/CMakeFiles/bpred.dir/build: src/bpred/bpred.so

.PHONY : src/bpred/CMakeFiles/bpred.dir/build

src/bpred/CMakeFiles/bpred.dir/requires: src/bpred/CMakeFiles/bpred.dir/BBHG.cpp.o.requires
src/bpred/CMakeFiles/bpred.dir/requires: src/bpred/CMakeFiles/bpred.dir/BBHGDrawer.cpp.o.requires
src/bpred/CMakeFiles/bpred.dir/requires: src/bpred/CMakeFiles/bpred.dir/BHG.cpp.o.requires
src/bpred/CMakeFiles/bpred.dir/requires: src/bpred/CMakeFiles/bpred.dir/BHGDrawer.cpp.o.requires
src/bpred/CMakeFiles/bpred.dir/requires: src/bpred/CMakeFiles/bpred.dir/BCG.cpp.o.requires
src/bpred/CMakeFiles/bpred.dir/requires: src/bpred/CMakeFiles/bpred.dir/BCGDrawer.cpp.o.requires
src/bpred/CMakeFiles/bpred.dir/requires: src/bpred/CMakeFiles/bpred.dir/BSets.cpp.o.requires
src/bpred/CMakeFiles/bpred.dir/requires: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_NoConflict.cpp.o.requires
src/bpred/CMakeFiles/bpred.dir/requires: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Bimodal.cpp.o.requires
src/bpred/CMakeFiles/bpred.dir/requires: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global1B.cpp.o.requires
src/bpred/CMakeFiles/bpred.dir/requires: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_Global2B.cpp.o.requires
src/bpred/CMakeFiles/bpred.dir/requires: src/bpred/CMakeFiles/bpred.dir/BPredProcessor_stats.cpp.o.requires
src/bpred/CMakeFiles/bpred.dir/requires: src/bpred/CMakeFiles/bpred.dir/BPredProcessor.cpp.o.requires

.PHONY : src/bpred/CMakeFiles/bpred.dir/requires

src/bpred/CMakeFiles/bpred.dir/clean:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred && $(CMAKE_COMMAND) -P CMakeFiles/bpred.dir/cmake_clean.cmake
.PHONY : src/bpred/CMakeFiles/bpred.dir/clean

src/bpred/CMakeFiles/bpred.dir/depend:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/bpred/CMakeFiles/bpred.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/bpred/CMakeFiles/bpred.dir/depend

