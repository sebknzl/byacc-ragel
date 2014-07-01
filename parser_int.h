/* Copyright (c) 2014 Sebastian Kienzl <seb at knzl.de>
 * Licensed under the MIT License, see LICENSE.
 */
#ifndef INCLUDED_E3AA0157785A4E46AB6B991E6DF58801
#define INCLUDED_E3AA0157785A4E46AB6B991E6DF58801

#include <string>
#include <vector>
#include "Lexer.h"
#include "Expr.h"

struct ExprParseContext {
	ExprParseContext() : result(0), lexer(0), vcb(0), fcb(0), error(0) {}
	float result;
	Expr::Lexer* lexer;
	Expr::VarCallback vcb;
	Expr::FunctionCallback fcb;
	std::string* error;
	std::vector<float> functionArgs;
};

int expr_parse( ExprParseContext* ctx );

#endif
