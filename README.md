Using byacc and ragel in tandem
===============================

This is a demonstration of how to use byacc and ragel in tandem to get
a parser/lexer with very little stack and heap usage.

For details, see my blog post at http://knzl.de/parser-generators-embedded/ .

Build requirements:

 * CMake >= 2.8
 * byacc
 * ragel

Then:

```mkdir build ; cd build ; cmake .. && make && ./expr```

Copyright (c) 2014 Sebastian Kienzl<br/>
Licensed under the MIT License, see LICENSE.
