/* Copyright (c) 2014 Sebastian Kienzl <seb at knzl.de>
 * Licensed under the MIT License, see LICENSE.
 */
#include "Expr.h"
#include "Lexer.h"
#include "parser_int.h"

namespace Expr {

bool parse( const char* expression, float& result, std::string* err, VarCallback vcb, FunctionCallback fcb )
{
	Lexer lexer( expression );

	ExprParseContext ctx;
	ctx.lexer = &lexer;
	ctx.vcb = vcb;
	ctx.fcb = fcb;
	ctx.error = err;
	
	int success = expr_parse( &ctx );
	
	if( success != 0 ) {
		return false;
	}
	else {
		result = ctx.result;
		return true;		
	}
}

};
