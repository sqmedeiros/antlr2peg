The *acme* directory has the following structure/files:
  - acme.g4: ANTLR grammar
  - acme.lua: PEG parser generated by antlr2peg from acme.g4. It is almost a direct translation.
  - acme-auto.lua: PEG parser generated by pegparser from acme.lua by rewriting non-disjoint repetitions, lexical rules, etc.
  - acme-auto-manual.lua: manually modified acme-auto.lua in order to achieve the expected behavior
  - examples/: directory with examples used to validate acme.g4
  - grammarinator/: directory with tests/files generated by grammarinator
  - outputNoTk/: directory with examples generated from examples/ by randomly removing a token
  - nonLiteralRewriting.ods: spreadsheet with the analysis of the non-literal rewritings
  - howtorun.md: file indicating how to run/generate the files.