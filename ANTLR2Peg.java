import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

import java.util.*;

public class ANTLR2Peg extends ANTLRv4ParserBaseListener {
	ParseTreeProperty<String> prog = new ParseTreeProperty<String>();
  String fileExt;
  String pre;
  String pos;
  String ruleId;

  ANTLR2Peg (String fileExt, String ruleId) {
    super();
    this.fileExt = fileExt;
    this.ruleId = ruleId;
    setPre();
    setPos();
  }

  void setPre () {
    pre = "local Parser = require 'pegparser.parser'\n"
        + "local Pretty = require 'pegparser.pretty'\n"
        + "local Util = require'pegparser.util'\n"
        + "local Cfg2Peg = require'pegparser.cfg2peg'\n"
        + "local Coder = require'pegparser.coder'\n\n"
        + "local s = [===[\n";
  }

  void setPos () {
    pos = "]===]\n\n"
       + "local g = Parser.match(s)\n"
       + "assert(g)\n"
       + "pretty = Pretty.new()\n"
       + "print(pretty:printg(g, nil, true))\n"
       + "local c2p = Cfg2Peg.new(g)\n"
       + "c2p:setUsePredicate(false)\n"
       + "c2p:setUseUnique(false)\n"
       + "c2p:convert('" + this.ruleId + "', true)\n"
       + "local peg = c2p.peg\n"
       + "print(pretty:printg(peg, nil, true))\n\n"
       + "local p = Coder.makeg(peg)\n"
       + "local dir = Util.getPath(arg[0])\n"
       + "Util.testYes(dir .. '/yes/', '" + this.fileExt + "', p)\n";
  }
              
  final String assertMsg = "Opção não suportada pelo pegparser";
  
  public void setCode(ParseTree node, String code) { 
  	prog.put(node, code); 
  }
    
  public String getCode(ParseTree node) { 
  	return prog.get(node); 
  }
  
  public void copyCode (ParseTree node1, ParseTree node2) {
  	setCode(node1, getCode(node2));
  }
  
  public void copyText (ParseTree node1, ParseTree node2) {
  	setCode(node1, node2.getText());
  }

	public String unquoteString (String code) {
		return code.substring(1, code.length() - 1);		
	}

	public void assertFeature (boolean exp, ParserRuleContext ctx) {
		assert exp : "Linha " + ctx.start.getLine() + ": " + assertMsg;
	}

	@Override 
	public void exitGrammarSpec(ANTLRv4Parser.GrammarSpecContext ctx) {
		//grammarDecl prequelConstruct* rules modeSpec* EOF
		String code = pre;
    pre += getCode(ctx.grammarDecl());
		code += getCode(ctx.rules());
		code += pos;
		setCode(ctx, code);
	}
	
	@Override 
	public void exitGrammarDecl(ANTLRv4Parser.GrammarDeclContext ctx) {
		//grammarType identifier SEMI
		copyText(ctx, ctx.identifier());
	}
	
	// grammarType, prequelConstruct, optionsSpec -> do nothing
	// option, optionValue, delegateGrammars -> do nothing
	// delegateGrammar -> do nothing
	
	@Override public void exitTokensSpec(ANTLRv4Parser.TokensSpecContext ctx) { 
		assertFeature(false, ctx);
	}
	
	@Override public void exitChannelsSpec(ANTLRv4Parser.ChannelsSpecContext ctx) { 
		assertFeature(false, ctx);
	}
	
	//idList -> referenced only by tokensSpec and channelsSpec
	
	@Override 
	public void exitAction_(ANTLRv4Parser.Action_Context ctx) { 
		assertFeature(false, ctx);
	}
	
	//actionScopeName, actionBlock -> referenced only by action_
	
	@Override 
	public void exitArgActionBlock(ANTLRv4Parser.ArgActionBlockContext ctx) { 
		assertFeature(false, ctx);	
	}
	
	@Override public void exitModeSpec(ANTLRv4Parser.ModeSpecContext ctx) { 
		assertFeature(false, ctx);
	}
	
	@Override
	public void exitRules(ANTLRv4Parser.RulesContext ctx) { 
		StringBuilder buf = new StringBuilder();

    for (ANTLRv4Parser.RuleSpecContext rsctx : ctx.ruleSpec()) {
    	if (rsctx.parserRuleSpec() != null) {
    		//System.out.println("syn " + getCode(rsctx.parserRuleSpec()));
    		buf.append(getCode(rsctx.parserRuleSpec()) + "\n");
    	} else {
    		//System.out.println("lex: " + rsctx.lexerRuleSpec().getText());
    		buf.append(getCode(rsctx.lexerRuleSpec()) + "\n");
    	}
      
      //buf.append(getCode(rsctx) + "\n");
      //buf.append(getCode(rsctx.getChild(0)) + "\n");
    }
    setCode(ctx, buf.toString()); 
	}

	//ruleSpec -> handled by exitRules
	
	@Override 
	public void exitParserRuleSpec(ANTLRv4Parser.ParserRuleSpecContext ctx) {
		String code = ctx.RULE_REF().getText() + "   <-   ";
		code += getCode(ctx.ruleBlock());
		setCode(ctx, code);
	}
	
	@Override 
	public void exitExceptionGroup(ANTLRv4Parser.ExceptionGroupContext ctx) {
		assertFeature(ctx.getChildCount() == 0, ctx);
	}
	
	//exceptionHandler, finallyClause -> referenced only by exceptionGroup
	
	@Override 
	public void exitRulePrequel(ANTLRv4Parser.RulePrequelContext ctx) { 
		assertFeature(false, ctx);
	}
	
	@Override 
	public void exitRuleReturns(ANTLRv4Parser.RuleReturnsContext ctx) { 
		assertFeature(false, ctx);
	}
	
	@Override 
	public void exitThrowsSpec(ANTLRv4Parser.ThrowsSpecContext ctx) { 
		assertFeature(false, ctx);
	}
	
	@Override 
	public void exitLocalsSpec(ANTLRv4Parser.LocalsSpecContext ctx) { 
		assertFeature(false, ctx);
	}
	
	@Override 
	public void exitRuleAction(ANTLRv4Parser.RuleActionContext ctx) { 
		assertFeature(false, ctx);
	}
	
	//ruleModifiers, ruleModifier
	
	@Override 
	public void exitRuleBlock(ANTLRv4Parser.RuleBlockContext ctx) { 
		setCode(ctx, getCode(ctx.ruleAltList()));
	}
	
	@Override 
	public void exitRuleAltList(ANTLRv4Parser.RuleAltListContext ctx) {
		int n = ctx.getChildCount();
		String code = getCode(ctx.getChild(0));
		for (int i = 2; i < n; i += 2) {
			code += "  /  " + getCode(ctx.getChild(i)); 
		}
		
		setCode(ctx, code);
	}
	
	@Override
	public void exitLabeledAlt(ANTLRv4Parser.LabeledAltContext ctx) { 
		setCode(ctx, getCode(ctx.alternative()));
	}
	
	@Override 
	public void exitLexerRuleSpec(ANTLRv4Parser.LexerRuleSpecContext ctx) { 
		String code = ctx.TOKEN_REF().getText() + "   <-   ";
		code += getCode(ctx.lexerRuleBlock());
		setCode(ctx, code);
	}
	
	@Override 
	public void exitLexerRuleBlock(ANTLRv4Parser.LexerRuleBlockContext ctx) { 
		copyCode(ctx, ctx.lexerAltList());
	}
	
	@Override 
	public void exitLexerAltList(ANTLRv4Parser.LexerAltListContext ctx) { 
		int n = ctx.getChildCount();
		String code = getCode(ctx.getChild(0));
		for (int i = 2; i < n; i += 2) {
			code += "  /  " + getCode(ctx.getChild(i)); 
		}
		setCode(ctx, code);	
	}
	
	@Override 
	public void exitLexerAlt(ANTLRv4Parser.LexerAltContext ctx) { 
		if (ctx.lexerElements() == null) {
			setCode(ctx, "''");
			return;
		}
		copyCode(ctx, ctx.lexerElements());
	}
	
	@Override 
	public void exitLexerElements(ANTLRv4Parser.LexerElementsContext ctx) {
		int n = ctx.getChildCount();
		
		if (n == 0) {
			setCode(ctx, "''");
			return;
		}
		
		String code = getCode(ctx.getChild(0));
		for (int i = 1; i < n; i ++) {
			code += " " + getCode(ctx.getChild(i)); 
		}
		setCode(ctx, code);	
	}
	
	@Override 
	public void exitLexerElement(ANTLRv4Parser.LexerElementContext ctx) {
		String code = getCode(ctx.getChild(0));
		if (ctx.getChildCount() > 1) {  //copy the text of ebnfsuffix or QUESTION
			code += ctx.getChild(1).getText();
		}
		setCode(ctx, code);
	}
	
	@Override 
	public void exitLabeledLexerElement(ANTLRv4Parser.LabeledLexerElementContext ctx) { 
		//identifier (ASSIGN | PLUS_ASSIGN) (lexerAtom | lexerBlock)
		assertFeature(false, ctx);
	}
	
	@Override 
	public void exitLexerBlock(ANTLRv4Parser.LexerBlockContext ctx) { 
		setCode(ctx, "(" + getCode(ctx.lexerAltList()) + ")");
	}
	
	@Override public void exitLexerCommands(ANTLRv4Parser.LexerCommandsContext ctx) {
		int n = ctx.getChildCount();
		String cmd = ctx.getChild(1).getText();
		//System.out.println("n = " + n + "  cmd = " + cmd + (cmd.equals("skip")));
		assertFeature(n == 2 && ctx.getChild(1).getText().equals("skip"), ctx);
	}
	
	//lexerCommand, lexerCommandName, lexerCommandExpr -> referenced only through lexerCommands
	
	@Override
	public void exitAltList(ANTLRv4Parser.AltListContext ctx) { 
		int n = ctx.getChildCount();
		String code = getCode(ctx.getChild(0));
		for (int i = 2; i < n; i += 2) {
			code += "  /  " + getCode(ctx.getChild(i)); 
		}
		setCode(ctx, code);
	}
	
	@Override 
	public void exitAlternative(ANTLRv4Parser.AlternativeContext ctx) {
		if (ctx.getChildCount() == 0) { //matched the empty alternative
			setCode(ctx, "''");
			return;
		}
		
		StringBuilder buf = new StringBuilder();
    for (ANTLRv4Parser.ElementContext ectx : ctx.element()) {
    	buf.append(getCode(ectx) + " ");
    }
    setCode(ctx, buf.toString()); 
	}

	@Override 
	public void exitElement(ANTLRv4Parser.ElementContext ctx) {
		String code = "";
		
		if (ctx.labeledElement() != null) {
			assertFeature(false, ctx.labeledElement());
		} else if (ctx.atom() != null) {
			code = getCode(ctx.atom());
			if (ctx.ebnfSuffix() != null) {
				code += ctx.ebnfSuffix().getText();
			}
		} else if (ctx.ebnf() != null) {
			code = getCode(ctx.ebnf());	
		} else { //action block
			assertFeature(false, ctx.actionBlock());
		}
	
		setCode(ctx, code);
	}
	
	//labeledElement -> referenced only by element
	
	@Override
	public void exitEbnf(ANTLRv4Parser.EbnfContext ctx) { 
		String code = getCode(ctx.block());
		if (ctx.blockSuffix() != null) {
			code += ctx.blockSuffix().getText();
		}
		
		setCode(ctx, code);	
	}
	
	//blockSuffix, ebnfSuffix -> getText
	
	@Override 
	public void exitLexerAtom(ANTLRv4Parser.LexerAtomContext ctx) {		
	//characterRange | terminal | notSet | LEXER_CHAR_SET | DOT elementOptions?
		if (ctx.DOT() != null) {  //DOT elementOptions?
			assertFeature(ctx.elementOptions() == null, ctx);
			copyText(ctx, ctx.DOT());
		} else if (ctx.LEXER_CHAR_SET() != null) {
			copyText(ctx, ctx.LEXER_CHAR_SET());
		} else {
			copyCode(ctx, ctx.getChild(0));
		}
	}
	
	@Override 
	public void exitAtom(ANTLRv4Parser.AtomContext ctx) { 		
		if (ctx.DOT() != null) {  //DOT elementOptions?
			assertFeature(ctx.elementOptions() == null, ctx.elementOptions());
			copyText(ctx, ctx.DOT());
		} else {
			copyCode(ctx, ctx.getChild(0));
		}
	}
		
	@Override 
	public void exitNotSet(ANTLRv4Parser.NotSetContext ctx) {
		String code = "(!" + getCode(ctx.getChild(1)) + " .)";
		setCode(ctx, code);
	}
	
	@Override 
	public void exitBlockSet(ANTLRv4Parser.BlockSetContext ctx) { 
		int n = ctx.getChildCount();
		String code = "(" + getCode(ctx.getChild(1));
		for (int i = 3; i < n; i += 2) {
			code += "  /  " + getCode(ctx.getChild(i)); 
		}
		code += ")";
		setCode(ctx, code);
	}
	
	@Override 
	public void exitSetElement(ANTLRv4Parser.SetElementContext ctx) {
	  //setElement  <-  TOKEN_REF elementOptions?  |  STRING_LITERAL elementOptions?  
	  // | characterRange  |  LEXER_CHAR_SET
		assertFeature(ctx.getChildCount() == 1, ctx);
		//assertFeature(ctx.TOKEN_REF() != null, ctx);
		if (ctx.characterRange() != null) {
			copyCode(ctx, ctx.getChild(0));
		} else {
			copyText(ctx, ctx.getChild(0));
		}
	}
	
	@Override public void exitBlock(ANTLRv4Parser.BlockContext ctx) { 
		setCode(ctx, "(" + getCode(ctx.altList()) + ")");
	}
	
	@Override public void exitRuleref(ANTLRv4Parser.RulerefContext ctx) {
		//ruleref  <-  RULE_REF argActionBlock? elementOptions?
		assertFeature(ctx.getChildCount() == 1, ctx);
		copyText(ctx, ctx.RULE_REF());	
	}
	
	@Override 
	public void exitCharacterRange(ANTLRv4Parser.CharacterRangeContext ctx) { 
		//STRING_LITERAL RANGE STRING_LITERAL
		String range1 = unquoteString(ctx.STRING_LITERAL(0).getText());
		String range2 = unquoteString(ctx.STRING_LITERAL(1).getText());
		setCode(ctx, "[" + range1 + "-" + range2 + "]");
	}
	
	@Override public void exitTerminal(ANTLRv4Parser.TerminalContext ctx) { 
		//TOKEN_REF elementOptions?  |  STRING_LITERAL elementOptions?
		assertFeature(ctx.getChildCount() == 1, ctx);
		copyText(ctx, ctx.getChild(0));
	}
	
	@Override 
	public void exitElementOptions(ANTLRv4Parser.ElementOptionsContext ctx) { 
		assertFeature(false, ctx);
	}

	//getElementOption -> only callable through elementOptions
	//identifier -> getText
	
}
