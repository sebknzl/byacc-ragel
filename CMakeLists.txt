# Copyright (c) 2014 Sebastian Kienzl <seb at knzl.de>
# Licensed under the MIT License, see LICENSE.

cmake_minimum_required( VERSION 2.8 )

find_program( BYACC_EXECUTABLE NAMES byacc DOC "path to the byacc executable" )
mark_as_advanced( BYACC_EXECUTABLE )

find_program( RAGEL_EXECUTABLE NAMES ragel DOC "path to the ragel executable" )
mark_as_advanced( RAGEL_EXECUTABLE )

set( GRAMMAR_INPUT ${CMAKE_CURRENT_SOURCE_DIR}/parser.y )
set( GRAMMAR_OUTPUT_C parser.cpp )
set( GRAMMAR_OUTPUT ${GRAMMAR_OUTPUT_C} parser.h )

add_custom_command( 
	OUTPUT ${GRAMMAR_OUTPUT}
	COMMAND ${BYACC_EXECUTABLE} -d -p expr_ -o ${GRAMMAR_OUTPUT_C} ${GRAMMAR_INPUT}
	DEPENDS ${GRAMMAR_INPUT}
)

set( LEXER_INPUT ${CMAKE_CURRENT_SOURCE_DIR}/Lexer.rl )
set( LEXER_OUTPUT Lexer.cpp )

add_custom_command(
	OUTPUT ${LEXER_OUTPUT}
	COMMAND ${RAGEL_EXECUTABLE} ${LEXER_INPUT} -o ${LEXER_OUTPUT}
	DEPENDS ${LEXER_INPUT}
)

include_directories( . ${CMAKE_CURRENT_BINARY_DIR} )
add_executable( expr main.cpp ${LEXER_OUTPUT} ${GRAMMAR_OUTPUT} Expr.cpp )

