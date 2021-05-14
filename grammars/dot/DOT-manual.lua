local m = require 'pegparser.parser'
local pretty = require 'pegparser.pretty'
local coder = require 'pegparser.coder'
local recovery = require 'pegparser.recovery'
local ast = require'pegparser.ast'
local util = require'pegparser.util'
local first = require'pegparser.first'
--local cfg2peg = require'pegparser.cfg2peg'

-- Minimal changes required to pass the tests provided with the DOT grammar
-- We did not translate the lazy repetition in rules TAG, COMMENT and LINE_COMMENT
-- I think rule COMMENT is used by pegparser in rule SKIP, I'm not sure
-- if rule LINE_COMMENT is used
local s = [===[
graph   <-   STRICT? (GRAPH   /  DIGRAPH ) id? '{' stmt_list '}' 
stmt_list   <-   (stmt ';'? )* 
--[Original] stmt   <-   node_stmt   /  edge_stmt   /  attr_stmt   /  id '=' id   /  subgraph 
stmt   <-   edge_stmt   /  attr_stmt   /  id '=' id   /  node_stmt   /  subgraph
attr_stmt   <-   (GRAPH   /  NODE   /  EDGE ) attr_list 
attr_list   <-   ('[' a_list? ']' )+ 
a_list   <-   (id ('=' id )? ','? )+ 
edge_stmt   <-   (node_id   /  subgraph ) edgeRHS attr_list? 
edgeRHS   <-   (edgeop (node_id   /  subgraph ) )+ 
edgeop   <-   '->'   /  '--' 
node_stmt   <-   node_id attr_list? 
node_id   <-   id port? 
port   <-   ':' id (':' id )? 
subgraph   <-   (SUBGRAPH id? )? '{' stmt_list '}' 
id   <-   ID   /  STRING   /  HTML_STRING   /  NUMBER 
STRICT   <-   [Ss] [Tt] [Rr] [Ii] [Cc] [Tt]
GRAPH   <-   [Gg] [Rr] [Aa] [Pp] [Hh]
DIGRAPH   <-   [Dd] [Ii] [Gg] [Rr] [Aa] [Pp] [Hh]
NODE   <-   [Nn] [Oo] [Dd] [Ee]
EDGE   <-   [Ee] [Dd] [Gg] [Ee]
SUBGRAPH   <-   [Ss] [Uu] [Bb] [Gg] [Rr] [Aa] [Pp] [Hh]
NUMBER   <-   '-'? ('.' DIGIT+  /  DIGIT+ ('.' DIGIT*)?)
DIGIT   <-   [0-9]
--[Original] STRING   <-   '"' ('\\"'  /  .)*? '"'
STRING   <-   '"' (!'"' ('\\"'  /  .))* '"'
ID   <-   LETTER (LETTER  /  DIGIT)*
LETTER   <-   [a-zA-Z\u0080-\u00FF_]
HTML_STRING   <-   '<' (TAG  /  (![<>] .))* '>'
TAG   <-   '<' .*? '>'
COMMENT   <-   '/*' .*? '*/'
LINE_COMMENT   <-   '//' .*? '\r'? '\n'
PREPROC   <-   '#' (![\r\n] .)*
WS   <-   [ \t\n\r]+
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
util.testYes(dir .. '/yes/', 'dot', p)

