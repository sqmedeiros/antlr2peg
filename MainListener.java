import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

public class MainListener {
 
  public static void main(String[] args) throws Exception {
    CharStream input;
    if (args.length > 0)
      input = CharStreams.fromFileName(args[0]);
    else
      input = CharStreams.fromStream(System.in);
    
    ANTLRv4Lexer lexer = new ANTLRv4Lexer(input);
    CommonTokenStream tokens = new CommonTokenStream(lexer);
    ANTLRv4Parser parser = new ANTLRv4Parser(tokens);
    
    ParseTree tree = parser.grammarSpec();

    ParseTreeWalker walker = new ParseTreeWalker();
	
    ANTLR2Peg trans = new ANTLR2Peg();
    
    walker.walk(trans, tree);
    
    System.out.println(trans.getCode(tree));
  }
}
