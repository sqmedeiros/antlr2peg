local m = require 'pegparser.parser'
local pretty = require 'pegparser.pretty'
local coder = require 'pegparser.coder'
local recovery = require 'pegparser.recovery'
local ast = require'pegparser.ast'
local util = require'pegparser.util'

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
BinaryValue   <-   'b' BIT+ (('.' BIT+)+  /  ('-' BIT+))?
DecimalValue   <-   'd' DIGIT+ (('.' DIGIT+)+  /  ('-' DIGIT+))?
HexValue   <-   'x' HEX_DIGIT+ (('.' HEX_DIGIT+)+  /  ('-' HEX_DIGIT+))?
ProseValue   <-   '<' (!('>') .)* '>'
ID   <-   LETTER (LETTER  /  DIGIT  /  '-')*
INT   <-   [0-9]+
COMMENT   <-   ';' !(('\n'  /  '\r')) .* '\r'? '\n'
WS   <-   (' '  /  '\t'  /  '\r'  /  '\n')
STRING   <-   ('%s'  /  '%i')? '"' (!('"') .)* '"'
LETTER   <-   [a-z]  /  [A-Z]
BIT   <-   [0-1]
DIGIT   <-   [0-9]
HEX_DIGIT   <-   ([0-9]  /  [a-f]  /  [A-F])
]===]

g = m.match(s)
print(m.match(s))
print(pretty.printg(g, true), '\n')
local p = coder.makeg(g, 'ast')
local dir = util.getPath(arg[0])
util.testYes(dir .. '/yes/', 'dot', p)

