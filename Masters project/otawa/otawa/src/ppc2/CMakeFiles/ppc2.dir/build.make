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
include src/ppc2/CMakeFiles/ppc2.dir/depend.make

# Include the progress variables for this target.
include src/ppc2/CMakeFiles/ppc2.dir/progress.make

# Include the compile flags for this target's objects.
include src/ppc2/CMakeFiles/ppc2.dir/flags.make

src/ppc2/otawa_kind.h: src/ppc2/otawa_kind.tpl
src/ppc2/otawa_kind.h: src/ppc2/otawa_kind.nmp
src/ppc2/otawa_kind.h: /home/yashas/otawa/linux-x86_64/otawa-core-build/ppc2/ppc.irg
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Generating otawa_kind.h"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2 && ../../../gliss2/gep/gliss-attr /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/../ppc2/ppc.irg -o /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2/otawa_kind.h -a otawa_kind -f -t otawa_kind.tpl -d "return 0;" -e otawa_kind.nmp

src/ppc2/otawa_pred.h: src/ppc2/otawa_pred.tpl
src/ppc2/otawa_pred.h: src/ppc2/otawa_pred.nmp
src/ppc2/otawa_pred.h: /home/yashas/otawa/linux-x86_64/otawa-core-build/ppc2/ppc.irg
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Generating otawa_pred.h"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2 && ../../../gliss2/gep/gliss-attr /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/../ppc2/ppc.irg -o /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2/otawa_pred.h -a otawa_pred -f -t otawa_pred.tpl -d "return 0;" -e otawa_pred.nmp

src/ppc2/otawa_target.h: src/ppc2/otawa_target.tpl
src/ppc2/otawa_target.h: src/ppc2/otawa_target.nmp
src/ppc2/otawa_target.h: /home/yashas/otawa/linux-x86_64/otawa-core-build/ppc2/ppc.irg
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Generating otawa_target.h"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2 && ../../../gliss2/gep/gliss-attr /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/../ppc2/ppc.irg -o /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2/otawa_target.h -a otawa_target -f -t otawa_target.tpl -d "return 0;" -e otawa_target.nmp

src/ppc2/otawa_used_regs.h: src/ppc2/otawa_used_regs.tpl
src/ppc2/otawa_used_regs.h: src/ppc2/otawa_used_regs.nmp
src/ppc2/otawa_used_regs.h: /home/yashas/otawa/linux-x86_64/otawa-core-build/ppc2/ppc.irg
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Generating otawa_used_regs.h"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2 && ../../../gliss2/gep/gliss-attr /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/../ppc2/ppc.irg -o /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2/otawa_used_regs.h -a otawa_used_regs -f -t otawa_used_regs.tpl -d "return 0;" -e otawa_used_regs.nmp

src/ppc2/otawa_sem.h: src/ppc2/otawa_sem.tpl
src/ppc2/otawa_sem.h: src/ppc2/otawa_sem.nmp
src/ppc2/otawa_sem.h: /home/yashas/otawa/linux-x86_64/otawa-core-build/ppc2/ppc.irg
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Generating otawa_sem.h"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2 && ../../../gliss2/gep/gliss-attr /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/../ppc2/ppc.irg -o /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2/otawa_sem.h -a otawa_sem -p -t otawa_sem.tpl -d ";" -e otawa_sem.nmp

src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.o: src/ppc2/CMakeFiles/ppc2.dir/flags.make
src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.o: src/ppc2/ppc.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.o"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2 && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/ppc2.dir/ppc.cpp.o -c /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2/ppc.cpp

src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/ppc2.dir/ppc.cpp.i"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2 && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2/ppc.cpp > CMakeFiles/ppc2.dir/ppc.cpp.i

src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/ppc2.dir/ppc.cpp.s"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2 && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2/ppc.cpp -o CMakeFiles/ppc2.dir/ppc.cpp.s

src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.o.requires:

.PHONY : src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.o.requires

src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.o.provides: src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.o.requires
	$(MAKE) -f src/ppc2/CMakeFiles/ppc2.dir/build.make src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.o.provides.build
.PHONY : src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.o.provides

src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.o.provides.build: src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.o


# Object files for target ppc2
ppc2_OBJECTS = \
"CMakeFiles/ppc2.dir/ppc.cpp.o"

# External object files for target ppc2
ppc2_EXTERNAL_OBJECTS =

src/ppc2/ppc2.so: src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.o
src/ppc2/ppc2.so: src/ppc2/CMakeFiles/ppc2.dir/build.make
src/ppc2/ppc2.so: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libelm.so
src/ppc2/ppc2.so: src/prog/libotawa.so
src/ppc2/ppc2.so: ../ppc2/src/libppc.a
src/ppc2/ppc2.so: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libelm.so
src/ppc2/ppc2.so: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libgel.so
src/ppc2/ppc2.so: /home/yashas/otawa/linux-x86_64/otawa-core/lib/libgel_dwarf.so
src/ppc2/ppc2.so: src/ppc2/CMakeFiles/ppc2.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Linking CXX shared library ppc2.so"
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2 && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ppc2.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/ppc2/CMakeFiles/ppc2.dir/build: src/ppc2/ppc2.so

.PHONY : src/ppc2/CMakeFiles/ppc2.dir/build

src/ppc2/CMakeFiles/ppc2.dir/requires: src/ppc2/CMakeFiles/ppc2.dir/ppc.cpp.o.requires

.PHONY : src/ppc2/CMakeFiles/ppc2.dir/requires

src/ppc2/CMakeFiles/ppc2.dir/clean:
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2 && $(CMAKE_COMMAND) -P CMakeFiles/ppc2.dir/cmake_clean.cmake
.PHONY : src/ppc2/CMakeFiles/ppc2.dir/clean

src/ppc2/CMakeFiles/ppc2.dir/depend: src/ppc2/otawa_kind.h
src/ppc2/CMakeFiles/ppc2.dir/depend: src/ppc2/otawa_pred.h
src/ppc2/CMakeFiles/ppc2.dir/depend: src/ppc2/otawa_target.h
src/ppc2/CMakeFiles/ppc2.dir/depend: src/ppc2/otawa_used_regs.h
src/ppc2/CMakeFiles/ppc2.dir/depend: src/ppc2/otawa_sem.h
	cd /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2 /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2 /home/yashas/otawa/linux-x86_64/otawa-core-build/otawa/src/ppc2/CMakeFiles/ppc2.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/ppc2/CMakeFiles/ppc2.dir/depend

