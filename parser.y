/* Copyright (c) 2014 Sebastian Kienzl <seb at knzl.de>
 * Licensed under the MIT License, see LICENSE.
 */
%{

#include "Expr.h"
#include "parser_int.h"

#define SETERROR(MSG) { if( ctx->error ) *ctx->error = MSG; }

%}

%pure-parser
%parse-param { ExprParseContext* ctx }
%lex-param   { ExprParseContext* ctx }

%union {
	int c;
	float v;
	const char* ident; // lexer takes care of freeing
}

%token <v> NUMBER
%token <ident> IDENT

// low precedence
%left '+' '-'
%left '*' '/'
%nonassoc UPLUS UMINUS
// high precedence

%type <v> exp terminal

%%

main: 
	| exp { ctx->result = $1; }
;

exp:  exp '+' exp            { $$ = $1 + $3; }
	| exp '-' exp            { $$ = $1 - $3; }
	| exp '*' exp            { $$ = $1 * $3; }
	| exp '/' exp            { $$ = $1 / $3; }
	| '-' exp %prec UMINUS   { $$ = -$2; }
	| '+' exp %prec UPLUS    { $$ = $2; }
	| '(' exp ')'            { $$ = $2; }
	| IDENT '(' explist ')'  { bool err = !ctx->fcb || !ctx->fcb( $1, ctx->functionArgs, $$ ); ctx->functionArgs.clear(); if( err ) { SETERROR( std::string( "Error calling function " ) + $1 ); YYERROR; }; }	
	| terminal               { $$ = $1; }
;

terminal: NUMBER             { $$ = $1; };
	| IDENT                  { if( !ctx->vcb || !ctx->vcb( $1, $$ ) ) { SETERROR( std::string( "Error looking up identifier " ) + $1 ); YYERROR; }; }
;


/*
	Function calls can be nested (as in f(g(h()))) and thus an extra arg-list would have to
	be kept in YYSTYPE to be passed to the actual function call above.
	
	We work around this with a dirty, non-portable (across yaccs) trick:
	
	* First, the explist below is right recursive, so when the action-code is executed,
	  all args will be on byacc's stack.
	* Then, search the stack for occurence of '(', this is where the arg list starts
	* Then, push all the (already reduced to exps) args into functionArgs
	* Increment is 2, because there's always a ',' inbetween
	
	This relies on the lexer putting the value of single-char tokens into YYSTYPE.c
*/
explist: /* rule for empty args, nothing to do */
	| explist_item
		{
			int i;
			/* go down the stack and find where the list starts (at '(') */
			for( i = 1; yystack.l_mark[-i].c != '('; i += 2 );
			/* push the values into the functionArgs vector in the right order */
			for( --i; i >= 0 ; i -= 2 ) {
				ctx->functionArgs.push_back( yystack.l_mark[-i].v );
			}
		}
	| explist_item ',' explist
;

explist_item: exp

%%

void expr_error( ExprParseContext* ctx, const char* s ) {
	SETERROR( s );
}

int expr_lex( YYSTYPE* yylval, ExprParseContext* ctx );
