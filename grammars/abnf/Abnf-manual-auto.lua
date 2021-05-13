local m = require 'pegparser.parser'
local pretty = require 'pegparser.pretty'
local coder = require 'pegparser.coder'
local recovery = require 'pegparser.recovery'
local ast = require'pegparser.ast'
local util = require'pegparser.util'
local first = require'pegparser.first'
--local cfg2peg = require'pegparser.cfg2peg'
--Manually fixing the problems after ANTLR2PEG
--Fixes try to follow an approach that is easy/viable to implement automatically

local s = [===[
rulelist   <-   rule_* EOF 
rule_   <-   ID '=' '/'? elements 
elements   <-   alternation 
alternation   <-   concatenation ('/' concatenation )* 
--[Original] concatenation   <-   repetition+
concatenation   <-   new_repetition

--[Solution]
--new_repetition <- repetition new_repetition  /  repetition &(ID  /  EOF  /  ']'  /  '/'  /  ')'  /  !.)
--[End solution]

--[Altenative solution, which may backtrack less]
new_repetition <- !ID (repetition new_repetition / repetition) /  &ID new_repetition_aux
new_repetition_aux <- repetition new_repetition / repetition &(ID  /  EOF  /  ']'  /  '/'  /  ')'  /  !.)
repetition   <-   repeat? element 
--[End alternative]

--[Original] repeat   <-   INT   /  (INT? '*' INT? ) 
repeat <- ( INT? '*' INT? ) / INT
element   <-   ID   /  group   /  option   /  STRING   /  NumberValue   /  ProseValue
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

g = m.match(s)
print(m.match(s))
print(pretty.printg(g, true), '\n')
first.calcFst(g)
first.calcFlw(g)
first.getChoiceReport(g)
first.getRepReport(g)
local p = coder.makeg(g, 'ast')
--local peg = cfg2peg.convert(g, 'ID')
--print(pretty.printg(peg, true), '\n')
local dir = util.getPath(arg[0])
util.testYes(dir .. '/yes/', 'abnf', p)


