local Parser = require 'pegparser.parser'
local Pretty = require 'pegparser.pretty'
local Util = require'pegparser.util'
local Cfg2Peg = require'pegparser.cfg2peg'
local Coder = require'pegparser.coder'

local s = [===[
init   <-   a b 
a   <-   'x'* 'x'
b   <-   'x' 
ID  <-   [a-z][a-z]*
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

local p = Coder.makeg(peg)
local dir = Util.getPath(arg[0])
Util.testYes(dir .. '/examples/', '.rep', p)

