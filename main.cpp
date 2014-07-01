/* Copyright (c) 2014 Sebastian Kienzl <seb at knzl.de>
 * Licensed under the MIT License, see LICENSE.
 */
#include <stdio.h>
#include <cmath>
#include "Expr.h"

using namespace std;

static bool var_callback( const std::string& name, float& value )
{
	if( name == "a" ) {
		value = 6.f;
		return true;
	}
	else if( name == "PI" ) {
		value = M_PI;
		return true;
	}
	else {
		return false;
	}
}

static bool func_callback( const std::string& name, const std::vector<float>& args, float& result )
{
	if( name == "sum" ) {
		for( vector<float>::const_iterator i = args.begin(); i != args.end(); ++i ) {
			result += *i;
		}
		return true;
	}
	else if( name == "cos" && args.size() == 1 ) {
		result = cos( args[0] );
		return true;
	}
	else if( name == "one" && args.size() == 0 ) {
		result = 1.f;
		return true;
	}
	else {
		return false;
	}
}

int main()
{
	const char* expr = "sum( cos(PI), cos(-2*PI), one() ) + 3 * ( 2 - 4 )";

	float result;
	string errorMsg;
	
	if( Expr::parse( expr, result, &errorMsg, var_callback, func_callback ) ) {
		printf( "%s = %.2f\n", expr, result );
		return 0;
	}
	else {
		printf( "Error: %s\n", errorMsg.c_str() );
		return 1;
	}
}
