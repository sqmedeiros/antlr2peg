local Parser = require 'pegparser.parser'
local Pretty = require 'pegparser.pretty'
local Util = require'pegparser.util'
local Cfg2Peg = require'pegparser.cfg2peg'
local Coder = require'pegparser.coder'

local s = [===[
graph   <-   STRICT? (GRAPH   /  DIGRAPH ) id? '{' stmt_list '}' 
stmt_list   <-   (stmt ';'? )* 
stmt   <-   node_stmt   /  edge_stmt   /  attr_stmt   /  id '=' id   /  subgraph 
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
STRING   <-   '"' ('\\"'  /  .)*? '"'
ID   <-   LETTER (LETTER  /  DIGIT)*
LETTER   <-   [a-zA-Z\u0080-\u00FF_]
HTML_STRING   <-   '<' (TAG  /  (![<>] .))* '>'
TAG   <-   '<' .*? '>'
COMMENT   <-   '/*' .*? '*/'
LINE_COMMENT   <-   '//' .*? '\r'? '\n'
PREPROC   <-   '#' (![\r\n] .)*
WS   <-   [ \t\n\r]+
]===]

local g = Parser.match(s)
assert(g)
pretty = Pretty.new()
print(pretty:printg(g, nil, true))
local c2p = Cfg2Peg.new(g)
c2p:setUsePredicate(true) -- pass a true value
c2p:setUseUnique(true)
c2p:convert('ID', true)
local peg = c2p.peg
print(pretty:printg(peg, nil, true))

local p = Coder.makeg(peg)
local dir = Util.getPath(arg[0])
Util.testYes(dir .. '/yes/', 'dot', p)

