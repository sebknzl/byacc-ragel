/* Copyright (c) 2014 Sebastian Kienzl <seb at knzl.de>
 * Licensed under the MIT License, see LICENSE.
 */
#ifndef INCLUDED_8E440C319CA54AFEA7CB00BBFFE4A6DA
#define INCLUDED_8E440C319CA54AFEA7CB00BBFFE4A6DA

#include <tr1/functional>
#include <string>
#include <vector>

namespace Expr {
	typedef std::tr1::function<bool (const std::string& name, float& value)> VarCallback;
	typedef std::tr1::function<bool (const std::string& name, const std::vector<float>& args, float& result)> FunctionCallback;
	
	bool parse( const char* expression, float& result, std::string* err, VarCallback vcb = 0, FunctionCallback fcb = 0 );
};


#endif

