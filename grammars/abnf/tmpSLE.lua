local Parser = require 'pegparser.parser'
local Pretty = require 'pegparser.pretty'
local Util = require'pegparser.util'
local Cfg2Peg = require'pegparser.cfg2peg'
local Coder = require'pegparser.coder'

local s = [===[
rulelist   <-   rule_* EOF 
rule_   <-   ID '=' '/'? elements 
elements   <-   alternation 
alternation   <-   concatenation ('/' concatenation )* 
concatenation   <-   repetition+ 
repetition   <-   repeat? element 
repeat   <-   INT   /  (INT? '*' INT? ) 
element   <-   ID   /  group   /  option   /  STRING   /  NumberValue   /  ProseValue 
group   <-   '(' alternation ')' 
option   <-   '[' alternation ']' 
NumberValue   <-   '%' (BinaryValue  /  DecimalValue  /  HexValue)
fragment BinaryValue   <-   'b' BIT+ (('.' BIT+)+  /  ('-' BIT+))?
fragment DecimalValue   <-   'd' DIGIT+ (('.' DIGIT+)+  /  ('-' DIGIT+))?
fragment HexValue   <-   'x' HEX_DIGIT+ (('.' HEX_DIGIT+)+  /  ('-' HEX_DIGIT+))?
ProseValue   <-   '<' ((!'>' .))* '>'
ID   <-   LETTER (LETTER  /  DIGIT  /  '-')*
INT   <-   [0-9]+
COMMENT   <-   ';' (!('\n'  /  '\r') .)* '\r'? '\n'
WS   <-   (' '  /  '\t'  /  '\r'  /  '\n')
STRING   <-   ('%s'  /  '%i')? '"' ((!'"' .))* '"'
fragment LETTER   <-   [a-z]  /  [A-Z]
fragment BIT   <-   [0-1]
fragment DIGIT   <-   [0-9]
fragment HEX_DIGIT   <-   ([0-9]  /  [a-f]  /  [A-F])
]===]

local g = Parser.match(s)
assert(g)
pretty = Pretty.new()
print(pretty:printg(g, nil, true))
local c2p = Cfg2Peg.new(g)
c2p:setUseUnique(false)
c2p:setUsePrefix(false)
c2p:convert('ID', true)
local peg = c2p.peg
print(pretty:printg(peg, nil, true))

--local p = Coder.makeg(peg)
--local dir = Util.getPath(arg[0])
--Util.testYes(dir .. '/examples/', '', p)
--Util.testYes(dir .. '/grammarinator/tests_01/', '', p)

