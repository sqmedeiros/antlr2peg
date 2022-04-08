# Files in this directory
	
- DOT.g4: original ANTLR grammar from <https://github.com/antlr/grammars-v4/blob/master/dot/DOT.g4>

- DOT.lua: naive translation of DOT.g4 to a PEG parser using the antlr2peg translator.

The main aspects of this rewritten are the following ones:
    + Changes the ":" to "<-"
    + Changes the choice operator "|" to "/"
    + In ANTLR, The expression `~[xyz]` is used mainly (only?) in lexical rules to
    create a character set the matches any characher except xyz. In PEGs, the
    equivalent expression is `![xyz] .`
	+ Semantic action 'skip' is being ignored. A semantic action other than 'skip'
	causes a translation failure.
	+ Currently, the keyword 'fragment', used in lexer rules, is being ignored
    
- DOT-manual-rep.lua: a manual rewritten of some rules of DOT.lua. This rewritten
 encompass the minimal changes in the grammar of DOT.lua that are required to pass
 the tests provided with the DOT.g4 grammar.
 
 - DOT-auto.lua: automatic translations performed after running the antlr2peg translator.
