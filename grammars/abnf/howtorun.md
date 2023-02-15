- To run the examples below it is necessary to download/install the following softwares:
  1. Java
  2. ANTLR
  3. Lua 5.4
  4. The pegparser Lua library

- To convert the ANTLR grammar .g4 file to a PEG parser, run the following commands from the antlrparser toplevel directory (you may need to adapt the CLASSPATH:
antlr4 ANTLRv4Parser.g4
javac -cp $CLASSPATH:./Java *.java 
java -cp $CLASSPATH:./Java MainListener grammars/abnf/Abnf.g4 abnf ID > grammars/abnf/Abnf.lua

- To run the generated PEG parser, execute the following command from the antlrparser toplevel directory (this step requires Lua and pegparser).
lua grammars/abnf/Abnf.lua

The previous command will run the test battery.
The parser stops when either it passes all the test or fails in a test.
