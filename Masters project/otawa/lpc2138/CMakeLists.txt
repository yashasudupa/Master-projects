CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

# configuration
set(SCRIPT	"lpc2138")
set(FILES	"memory.xml" "pipeline.xml")
set(MODULES	-p lpc2138.eld)
set(SOURCES
	mam/AbsMAMBlockBuilder.cpp
	mam/CATMAMBuilder.cpp
	mam/MAMBlock.cpp
	mam/MAMBlockSet.cpp
	mam/MAMProblem.cpp
	exegraph/ARM7ParamExeGraph.cpp
	exegraph/ARM7ParamExeGraphBBTime.cpp
	exegraph/SimulationTrace.cpp
	exegraph/ParamExeGraph.cpp
	exegraph/ParamExeGraphBBTime.cpp
	exegraph/SimulationTrace.cpp
	hook.cpp
)

# deprecated code
#exegraph/exegraph_ExeGraph.cpp
#exegraph/exegraph_ExeGraphBBTime.cpp


# script
project(${SCRIPT})


# look for OTAWA
if(NOT OTAWA_CONFIG)
	find_program(OTAWA_CONFIG otawa-config DOC "path to otawa-config")
	if(NOT OTAWA_CONFIG)
		message(FATAL_ERROR "ERROR: otawa-config is required !")
	endif()
endif()
message(STATUS "otawa-config at ${OTAWA_CONFIG}")

if(PREFIX)
	set(CMAKE_INSTALL_PREFIX ${PREFIX})
else()
	execute_process(COMMAND "${OTAWA_CONFIG}" --prefix OUTPUT_VARIABLE CMAKE_INSTALL_PREFIX OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()
execute_process(COMMAND "${OTAWA_CONFIG}" --cflags ${MODULES} OUTPUT_VARIABLE OTAWA_CFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND "${OTAWA_CONFIG}" --libs ${MODULES}  OUTPUT_VARIABLE OTAWA_LDFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
message(STATUS "CMAKE_INSTALL_PREFIX = ${CMAKE_INSTALL_PREFIX}")


# plugin definition
set(CMAKE_INSTALL_RPATH "\\$ORIGIN/../../../")
include_directories(${CMAKE_SOURCE_DIR})

#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OTAWA_CFLAGS}")
add_library(${SCRIPT} MODULE ${SOURCES})
set_property(TARGET ${SCRIPT} PROPERTY PREFIX "")
set_property(TARGET ${SCRIPT} PROPERTY COMPILE_FLAGS ${OTAWA_CFLAGS})
target_link_libraries(${SCRIPT} "${TARGET_LIB}" "${OTAWA_LDFLAGS}")


# installation
set(MODULE_PATH "${CMAKE_INSTALL_PREFIX}/lib/otawa/proc/otawa")
set(SCRIPT_PATH "${CMAKE_INSTALL_PREFIX}/share/Otawa/scripts/")

install(TARGETS ${SCRIPT} LIBRARY DESTINATION ${MODULE_PATH})
install(FILES ${SCRIPT}.eld DESTINATION ${MODULE_PATH})
install(FILES ${SCRIPT}.osx DESTINATION ${SCRIPT_PATH})
foreach(FILE ${FILES})
	install(FILES ${SCRIPT}/${FILE} DESTINATION ${SCRIPT_PATH}/${SCRIPT})
endforeach()

