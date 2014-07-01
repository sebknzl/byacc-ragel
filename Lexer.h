/* Copyright (c) 2014 Sebastian Kienzl <seb at knzl.de>
 * Licensed under the MIT License, see LICENSE.
 */
#ifndef INCLUDED_A135A8F00D02432E8D1EEF673E2F323A
#define INCLUDED_A135A8F00D02432E8D1EEF673E2F323A

#include <string>
#include <vector>
#include "parser.h"
#include "Expr.h"

namespace Expr {

class Lexer {
public:
	Lexer( const char* );
	
	int lex( YYSTYPE* );
	
private:

	const char* str;
	const char* p;
	const char* pe;
	const char* eof;
	
	int cs, act;
	const char* ts;
	const char* te;
	
	std::string tempString;
	inline std::string& TOK() { tempString.assign( ts, te-ts ); return tempString; }

	std::vector<std::string> identifiers;
	const char* addIdent();
};

};

#endif
