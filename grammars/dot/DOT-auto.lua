local Parser = require 'pegparser.parser'
local Pretty = require 'pegparser.pretty'
local Util = require'pegparser.util'
local Cfg2Peg = require'pegparser.cfg2peg'
local Coder = require'pegparser.coder'

local s = [===[
graph           <-  STRICT? (GRAPH  /  DIGRAPH) id? ZLex_001 stmt_list ZLex_002 EOF
stmt_list       <-  (stmt ZLex_003?)*
stmt            <-  attr_stmt  /  node_stmt  /  edge_stmt  /  id ZLex_004 id  /  subgraph
attr_stmt       <-  (GRAPH  /  NODE  /  EDGE) attr_list
attr_list       <-  (ZLex_005 a_list? ZLex_006)+
a_list          <-  (id (ZLex_004 id)? ZLex_007?)+
edge_stmt       <-  (node_id  /  subgraph) edgeRHS attr_list?
edgeRHS         <-  (edgeop (node_id  /  subgraph))+
edgeop          <-  ZLex_008  /  ZLex_009
node_stmt       <-  node_id attr_list?
node_id         <-  id port?
port            <-  ZLex_010 id (ZLex_010 id)?
subgraph        <-  (SUBGRAPH id?)? ZLex_001 stmt_list ZLex_002
id              <-  ID  /  STRING  /  HTML_STRING  /  NUMBER
STRICT          <-  [Ss] [Tt] [Rr] [Ii] [Cc] [Tt] !__IdRest
GRAPH           <-  [Gg] [Rr] [Aa] [Pp] [Hh] !__IdRest
DIGRAPH         <-  [Dd] [Ii] [Gg] [Rr] [Aa] [Pp] [Hh] !__IdRest
NODE            <-  [Nn] [Oo] [Dd] [Ee] !__IdRest
EDGE            <-  [Ee] [Dd] [Gg] [Ee] !__IdRest
SUBGRAPH        <-  [Ss] [Uu] [Bb] [Gg] [Rr] [Aa] [Pp] [Hh] !__IdRest
NUMBER          <-  '-'? ('.' DIGIT+  /  DIGIT+ ('.' DIGIT*)?)
DIGIT           <-  [0-9]
STRING          <-  '"' (!'"' ('\\"'  /  .))* '"'
ID              <-  !__Keywords LETTER (LETTER  /  DIGIT)*
LETTER          <-  [a-zA-Z_]
HTML_STRING     <-  '<' (TAG  /  ![<>] .)* '>'
TAG             <-  '<' (!'>' .)* '>'
COMMENT         <-  '/*' (!'*/' .)* '*/'
LINE_COMMENT    <-  '//' (!('\r'? '\n') .)* '\r'? '\n'
PREPROC         <-  '#' (![\r\n] .)*
WS              <-  [ \t\n\r]+
EOF             <-  !.
ZLex_001        <-  '{'
ZLex_002        <-  '}'
ZLex_003        <-  ';'
ZLex_004        <-  '='
ZLex_005        <-  '['
ZLex_006        <-  ']'
ZLex_007        <-  ','
ZLex_008        <-  '->'
ZLex_009        <-  '--'
ZLex_010        <-  ':'
__IdBegin       <-  LETTER
__IdRest        <-  LETTER  /  DIGIT
__Keywords      <-  DIGRAPH  /  EDGE  /  GRAPH  /  NODE  /  STRICT  /  SUBGRAPH
]===]

local peg = Parser.match(s)
assert(peg)
pretty = Pretty.new()
print(pretty:printg(peg, nil, true))

local p = Coder.makeg(peg)
local dir = Util.getPath(arg[0])
Util.testYes(dir .. '/examples/', 'dot', p)
Util.testYes(dir .. '/grammarinator/tests_01/', 'dot', p)
Util.testYes(dir .. '/grammarinator/tests_02/', 'dot', p)
Util.testYes(dir .. '/grammarinator/tests_03/', 'dot', p)
Util.testYes(dir .. '/grammarinator/tests_04_SimpleId/', 'dot', p)
Util.testYes(dir .. '/outputNoTk/yes/', 'dot', p)
Util.testNo(dir .. '/outputNoTk/no/', 'dot', p)


