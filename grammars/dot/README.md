# Files in this directory
	
- DOT.g4: original ANTLR grammar from <https://github.com/antlr/grammars-v4/blob/master/dot/DOT.g4>

- DOT.lua: naive translation of DOT.g4 to a PEG parser using the antlr2peg translator.
The notable changes did by this tranlation are:
    + Changes the ":" to "<-"
    + Changes the choice operator "|" to "/"
    + In ANTLR, The expression `~[xyz]` is used mainly (only?) in lexical rules to
    create a character set the matches any characher except xyz. In PEGs, the
    equivalent expression is `![xyz] .`

    
- 
