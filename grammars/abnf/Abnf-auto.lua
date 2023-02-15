local Parser = require 'pegparser.parser'
local Pretty = require 'pegparser.pretty'
local Util = require'pegparser.util'
local Cfg2Peg = require'pegparser.cfg2peg'
local Coder = require'pegparser.coder'

local s = [===[
rulelist        <-  rule_* EOF
rule_           <-  ID ZLex_001 ZLex_002? elements
elements        <-  alternation
alternation     <-  concatenation (ZLex_002 concatenation)*
concatenation   <-  __rep_001
repetition      <-  repeat? element
repeat          <-  INT? ZLex_003 INT?  /  INT
element         <-  ID  /  group  /  option  /  STRING  /  NumberValue  /  ProseValue
group           <-  ZLex_004 alternation ZLex_005
option          <-  ZLex_006 alternation ZLex_007
NumberValue     <-  '%' (BinaryValue  /  DecimalValue  /  HexValue)
BinaryValue     <-  'b' BIT+ (('.' BIT+)+  /  '-' BIT+)?
DecimalValue    <-  'd' DIGIT+ (('.' DIGIT+)+  /  '-' DIGIT+)?
HexValue        <-  'x' HEX_DIGIT+ (('.' HEX_DIGIT+)+  /  '-' HEX_DIGIT+)?
ProseValue      <-  '<' (!'>' .)* '>'
ID              <-  LETTER (LETTER  /  DIGIT  /  '-')*
INT             <-  [0-9]+
COMMENT         <-  ';' (!('\n'  /  '\r') .)* '\r'? '\n'
WS              <-  ' '  /  '\t'  /  '\r'  /  '\n'
STRING          <-  ('%s'  /  '%i')? '"' (!'"' .)* '"'
LETTER          <-  [a-z]  /  [A-Z]
BIT             <-  [0-1]
DIGIT           <-  [0-9]
HEX_DIGIT       <-  [0-9]  /  [a-f]  /  [A-F]
EOF             <-  !.
ZLex_001        <-  '='
ZLex_002        <-  '/'
ZLex_003        <-  '*'
ZLex_004        <-  '('
ZLex_005        <-  ')'
ZLex_006        <-  '['
ZLex_007        <-  ']'
__rep_001       <-  repetition __rep_001  /  repetition &(')'  /  '/'  /  ']'  /  EOF  /  ID)
__IdBegin       <-  LETTER
__IdRest        <-  LETTER  /  DIGIT  /  '-'
]===]

local g = Parser.match(s)
assert(g)
pretty = Pretty.new()
print(pretty:printg(g, nil, true))
--local c2p = Cfg2Peg.new(g)
--c2p:setUseUnique(false)
--c2p:setUsePrefix(true)
--c2p:convert('ID', true)
local peg = g--c2p.peg
--print(pretty:printg(peg, nil, true))

local p = Coder.makeg(peg)
local dir = Util.getPath(arg[0])
Util.testYes(dir .. '/examples/', 'abnf', p)
Util.testYes(dir .. '/grammarinator/tests_01/', 'abnf', p)
Util.testYes(dir .. '/grammarinator/tests_02/', 'abnf', p)
Util.testYes(dir .. '/grammarinator/tests_03/', 'abnf', p)
Util.testYes(dir .. '/grammarinator/tests_04/', 'abnf', p)
Util.testYes(dir .. '/outputNoTk/yes/', 'abnf', p)
Util.testNo(dir .. '/outputNoTk/no/', 'abnf', p)
