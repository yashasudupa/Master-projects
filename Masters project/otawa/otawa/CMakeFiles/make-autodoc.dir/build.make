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

# Utility rule file for make-autodoc.

# Include the progress variables for this target.
include CMakeFiles/make-autodoc.dir/progress.make

CMakeFiles/make-autodoc: autodoc


autodoc: Doxyfile
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Generating autodoc"
	/usr/bin/doxygen

make-autodoc: CMakeFiles/make-autodoc
make-autodoc: autodoc
make-autodoc: CMakeFiles/make-autodoc.dir/build.make

.PHONY : make-autodoc

# Rule to build all files generated by this target.
CMakeFiles/make-autodoc.dir/build: make-autodoc

.PHONY : CMakeFiles/make-autodoc.dir/build

CMakeFiles/make-autodoc.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/make-autodoc.dir/cmake_clean.cmake
.PHONY : CMakeFiles/make-autodoc.dir/clean

CMakeFiles/make-autodoc.dir/depend:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles/make-autodoc.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/make-autodoc.dir/depend

