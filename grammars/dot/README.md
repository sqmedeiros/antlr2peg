# Files in this directory
	
## DOT.g4

Original ANTLR grammar from <https://github.com/antlr/grammars-v4/blob/master/dot/DOT.g4>

## DOT.lua

Naive translation of DOT.g4 to a PEG parser using the antlr2peg translator.

The main aspects of this rewritten are the following ones:
    + Changes the ":" to "<-"
    + Changes the choice operator "|" to "/"
    + In ANTLR, The expression `~[xyz]` is used mainly (only?) in lexical rules to
    create a character set the matches any characher except xyz. In PEGs, the
    equivalent expression is `![xyz] .`
	+ Semantic action 'skip' is being ignored. A semantic action other than 'skip'
	causes a translation failure.
	+ Currently, the keyword 'fragment', used in lexer rules, is being ignored
    
## DOT-manual-small.lua

A manual rewritten of some rules of DOT.lua.

This rewritten encompass the minimal changes in the grammar of DOT.lua that
are required to pass the tests provided with the DOT.g4 grammar.
 

## DOT-auto.lua

Automatic translations performed by pegparser.cfg2peg over
the grammar given by antlr2peg, i.e., it is a rewritten using the grammar
of DOT.lua as basis

The main aspects of this translation are:
    + Added a predicate to guard against the matching of non-disjoint alternatives
    in a choice. See the following examples below:
       1. 'a' | 'b'  ->  'a' / 'b' (disjoint alternatives)
       2. 'a' / 'c' / 'a' 'b'  ->  !('a' 'b') 'a' / 'c' / 'a' 'b' (alternatives 'a' and 'a' 'c' are non-disjoint)

    + Converts lazy repetitions (*?, +?, ??) in lexical rules.
