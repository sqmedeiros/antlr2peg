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

## DOT-manual-small-predicate.lua

Adding predicates to the manually rewritten DOT grammar.
This causes a failure, because a single *node_id* can not be matched
as a *node_stmt* anymore, as the predicate below precludes this:
stmt            <-  attr_stmt  /  !(id '=' id  /  node_stmt  /  subgraph) edge_stmt  /  !node_stmt id '=' id  /  node_stmt  /  subgraph

This is a general problem when an alternative matches prefixes of other alternative.
In case of a choice where the alternatives are in the "wrong" order, such as:
a / a b
where L(a / a b) != L(a | a b),
the use of a predicate turns the language of
the PEG equivalent to the one of the CFG, i.e.,
L (!(a b) a / a b) = L(a | a b)

We need to know which alternative matches prefixes of the other one
and put it first guarded by a predicate.

This strategy does not work when both alternatives match
a prefix of the other one, such as below:
a (b | c d) | a (b c | c)

Where L(a (b | c d)) = { "ab", "acd" } and
      L(a (b c | c)) = { "abc", "ac" }

In case both alternatives use same symbol, one possibility is to put it
on evidence:
a (b | c d | b c | c)

and then reorder the alternatives or use predicates:
Reordering: a (bc / cd / b / c)
Predicates: a (!(bc) b / bc / !(cd) c / cd)


 
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
