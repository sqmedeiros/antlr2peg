local Parser = require 'pegparser.parser'
local Pretty = require 'pegparser.pretty'
local Util = require'pegparser.util'
local Cfg2Peg = require'pegparser.cfg2peg'
local Coder = require'pegparser.coder'

local s = [===[
init            <-  a 
a               <-  __rep_001 ZLex_001
b               <-  ZLex_001
ID              <-  !__Keywords [a-z] [a-z]*
ZLex_001        <-  'x' !__IdRest
__rep_001       <-  ZLex_001 __rep_001  /  &ZLex_001
__IdBegin       <-  [a-z]
__IdRest        <-  [a-z]
__Keywords      <-  ZLex_001
]===]

local g = Parser.match(s)
assert(g)
pretty = Pretty.new()
print(pretty:printg(g, nil, true))
local peg = g


local p = Coder.makeg(peg)
local dir = Util.getPath(arg[0])
Util.testYes(dir .. '/examples/', '.y', p)

