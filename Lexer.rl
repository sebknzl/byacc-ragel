/* Copyright (c) 2014 Sebastian Kienzl <seb at knzl.de>
 * Licensed under the MIT License, see LICENSE.
 */
#include <limits.h>
#include "Lexer.h"
#include "parser_int.h"

using namespace std;

%%{
  machine ExprLexer;
}%%

%% write data;

%%{
	number = digit+;
	float = number '.' digit* ( [Ee] [\+\-]? number )?;
	
	ident = alpha ( alnum | '_' )*;
	
	chartoks = [\-\+\*\(\)/,];
	
	main := |*
		number    => { ret = NUMBER; yylval->v = atoi( TOK().c_str() ); fbreak; };
		float     => { ret = NUMBER; yylval->v = atof( TOK().c_str() ); fbreak; };
		
		chartoks  => { yylval->c = *ts; ret = *ts; fbreak; };
		ident     => { ret = IDENT; yylval->ident = addIdent(); fbreak; };

		( "--" | "++" ) => { fbreak; };    		# not allowed, should signal error
		
		0;

		space;
	*|;
}%%

namespace Expr {

Lexer::Lexer( const char* str ) {
%% write init;
	this->str = str;
	p = str;
	pe = eof = str + strlen(str) + 1; // incl zero
}

const char* Lexer::addIdent() {
	identifiers.push_back( TOK() );
	return identifiers[ identifiers.size() - 1 ].c_str();
}

int Lexer::lex( YYSTYPE* yylval ) {
	int ret = INT_MAX;

	using namespace Expr;

	yylval->v = .0f;

%% write exec;

	if( p == eof ) {
		ret = 0;
	}

	return ret;
}

};

int expr_lex( YYSTYPE* yylval, ExprParseContext* ctx ) {
	return ctx->lexer->lex( yylval );
}
