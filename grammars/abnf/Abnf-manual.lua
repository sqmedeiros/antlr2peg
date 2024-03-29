local Parser = require 'pegparser.parser'
local Pretty = require 'pegparser.pretty'
local Util = require'pegparser.util'
local Cfg2Peg = require'pegparser.cfg2peg'
local Coder = require'pegparser.coder'
--Manually fixing the problems after ANTLR2PEG
--Fixes are not necesseraly easy/viable to implement automatically

local s = [===[
rulelist   <-   rule_* EOF 
rule_   <-   ID '=' '/'? elements 
elements   <-   alternation 
alternation   <-   concatenation ('/' concatenation )* 
concatenation   <-   repetition+ 
repetition   <-   repeat? element 
--[Original] repeat   <-   INT   /  (INT? '*' INT? ) 
repeat <- ( INT? '*' INT? ) / INT
--[Original] element   <-   ID   /  group   /  option   /  STRING   /  NumberValue   /  ProseValue
element   <-   ID !'='   /  group   /  option   /  STRING   /  NumberValue   /  ProseValue    
group   <-   '(' alternation ')' 
option   <-   '[' alternation ']' 
NumberValue   <-   '%' (BinaryValue  /  DecimalValue  /  HexValue)
BinaryValue   <-   'b' BIT+ (('.' BIT+)+  /  ('-' BIT+))?
DecimalValue   <-   'd' DIGIT+ (('.' DIGIT+)+  /  ('-' DIGIT+))?
HexValue   <-   'x' HEX_DIGIT+ (('.' HEX_DIGIT+)+  /  ('-' HEX_DIGIT+))?
ProseValue   <-   '<' ((!'>' .))* '>'
ID   <-   LETTER (LETTER  /  DIGIT  /  '-')*
INT   <-   [0-9]+
COMMENT   <-   ';' (!('\n'  /  '\r') .)* '\r'? '\n'
WS   <-   (' '  /  '\t'  /  '\r'  /  '\n')
STRING   <-   ('%s'  /  '%i')? '"' ((!'"' .))* '"'
LETTER   <-   [a-z]  /  [A-Z]
BIT   <-   [0-1]
DIGIT   <-   [0-9]
HEX_DIGIT   <-   ([0-9]  /  [a-f]  /  [A-F])
]===]

local g = Parser.match(s)
assert(g)
pretty = Pretty.new()
print(pretty:printg(g, nil, true))
--local c2p = Cfg2Peg.new(g)
--c2p:setUsePredicate(false)
--c2p:setUseUnique(false)
--c2p:convert('ID', true)
--local peg = c2p.peg
--print(pretty:printg(peg, nil, true))

local p = Coder.makeg(g)
local dir = Util.getPath(arg[0])
Util.testYes(dir .. '/yes/', 'abnf', p)
Util.testYes(dir .. '/gramm-yes/', 'abnf', p)


