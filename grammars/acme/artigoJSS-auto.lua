local Parser = require 'pegparser.parser'
local Pretty = require 'pegparser.pretty'
local Util = require'pegparser.util'
local Cfg2Peg = require'pegparser.cfg2peg'
local Coder = require'pegparser.coder'

local s = [===[
acmeCompUnit    <-  acmeImportDeclaration* (acmeSystemDeclaration  /  acmeFamilyDeclaration  /  acmeDesignDeclaration)+ EOF
acmeImportDeclaration <-  IMPORT (filename  /  stringLiteral) SEMICOLON
stringLiteral   <-  STRING_LITERAL
filename        <-  (ZLex_001  /  ZLex_002)? IDENTIFIER ((ZLex_003  /  ZLex_004  /  ZLex_005  /  ZLex_006  /  ZLex_007  /  ZLex_008  /  ZLex_009  /  ZLex_001  /  ZLex_002)+ IDENTIFIER)*
identifier      <-  IDENTIFIER
codeLiteral     <-  STRING_LITERAL
acmeFamilyDeclaration <-  (FAMILY  /  STYLE) identifier (SEMICOLON  /  ASSIGN acmeFamilyBody SEMICOLON?  /  EXTENDS acmeFamilyRef (COMMA acmeFamilyRef)* (SEMICOLON  /  WITH acmeFamilyBody SEMICOLON?))
acmeFamilyBody  <-  LBRACE ((PUBLIC  /  PRIVATE)? (FINAL  /  ABSTRACT)? (acmePortTypeDeclaration  /  acmeRoleTypeDeclaration  /  acmeComponentTypeDeclaration  /  acmeConnectorTypeDeclaration  /  acmeGenericElementTypeDeclaration  /  acmePropertyTypeDeclaration  /  acmeGroupTypeDeclaration)  /  acmeDesignAnalysisDeclaration  /  designRule  /  acmePortDeclaration  /  acmeRoleDeclaration  /  acmeComponentDeclaration  /  acmeConnectorDeclaration  /  acmePropertyDeclaration  /  acmeGroupDeclaration  /  acmeAttachmentDeclaration)* RBRACE
acmeSystemDeclaration <-  SYSTEM identifier (COLON acmeFamilyRef (COMMA acmeFamilyRef)*)? (SEMICOLON  /  ASSIGN (acmeSystemBody SEMICOLON?  /  NEW acmeFamilyInstantiationRef (COMMA acmeFamilyInstantiationRef)* (SEMICOLON  /  EXTENDED WITH acmeSystemBody SEMICOLON?)))
acmeSystemBody  <-  LBRACE (acmePropertyDeclaration  /  acmeComponentDeclaration  /  acmeConnectorDeclaration  /  acmeAttachmentDeclaration  /  acmeGroupDeclaration  /  designRule)* RBRACE
acmeDesignDeclaration <-  DESIGN
acmeComponentTypeRef <-  identifier (DOT identifier)?
acmeComponentInstantiatedTypeRef <-  identifier (DOT identifier)?
acmeConnectorTypeRef <-  identifier (DOT identifier)?
acmeConnectorInstantiatedTypeRef <-  identifier (DOT identifier)?
acmePortTypeRef <-  identifier (DOT identifier)?
acmePortInstantiatedTypeRef <-  identifier (DOT identifier)?
acmeGroupTypeRef <-  identifier (DOT identifier)?
acmeGroupInstantiatedTypeRef <-  identifier (DOT identifier)?
acmeRoleTypeRef <-  identifier (DOT identifier)?
acmeRoleInstantiatedTypeRef <-  identifier (DOT identifier)?
acmeViewTypeRef <-  identifier (DOT identifier)?
acmeViewInstantiatedTypeRef <-  identifier (DOT identifier)?
acmeFamilyRef   <-  identifier (DOT identifier)?
acmeFamilyInstantiationRef <-  identifier
acmeElementTypeRef <-  identifier (DOT identifier)?
acmePropertyTypeDeclarationRef <-  identifier (DOT identifier)?
acmeInstanceRef <-  IDENTIFIER (DOT IDENTIFIER)*
acmeGenericElementTypeDeclaration <-  ELEMENT TYPE identifier (SEMICOLON  /  ASSIGN acmeGenericElementBody SEMICOLON?  /  EXTENDS acmeElementTypeRef (COMMA acmeElementTypeRef)* (SEMICOLON  /  WITH acmeGenericElementBody SEMICOLON?))
acmeGenericElementBody <-  LBRACE (acmePropertyDeclaration  /  designRule)* RBRACE
acmeGroupTypeDeclaration <-  GROUP TYPE identifier (SEMICOLON  /  ASSIGN acmeGroupBody SEMICOLON?  /  EXTENDS acmeGroupTypeRef (COMMA acmeGroupTypeRef)* (SEMICOLON  /  WITH acmeGroupBody SEMICOLON?))
acmeGroupDeclaration <-  GROUP identifier (COLON acmeGroupTypeRef (COMMA acmeGroupTypeRef)*)? (SEMICOLON  /  ASSIGN (acmeGroupBody SEMICOLON?  /  NEW acmeGroupInstantiatedTypeRef (COMMA acmeGroupInstantiatedTypeRef)* (SEMICOLON  /  EXTENDED WITH acmeGroupBody SEMICOLON?)))
acmeGroupBody   <-  LBRACE (acmeMembersBlock  /  acmePropertyDeclaration  /  designRule)* RBRACE
acmeMembersBlock <-  MEMBERS LBRACE (acmeInstanceRef (COMMA acmeInstanceRef)*)? RBRACE __rep_001
acmePortTypeDeclaration <-  PORT TYPE identifier (SEMICOLON  /  ASSIGN acmePortBody SEMICOLON?  /  EXTENDS acmePortTypeRef (COMMA acmePortTypeRef)* (SEMICOLON  /  WITH acmePortBody SEMICOLON?))
acmePortDeclaration <-  PORT identifier (COLON acmePortTypeRef (COMMA acmePortTypeRef)*)? (ASSIGN (acmePortBody SEMICOLON?  /  NEW acmePortInstantiatedTypeRef (COMMA acmePortInstantiatedTypeRef)* (SEMICOLON  /  EXTENDED WITH acmePortBody SEMICOLON?))  /  SEMICOLON?)
acmePortBody    <-  LBRACE (acmePropertyDeclaration  /  designRule  /  acmeRepresentationDeclaration)* RBRACE
acmeRoleTypeDeclaration <-  ROLE TYPE identifier (SEMICOLON  /  ASSIGN acmeRoleBody SEMICOLON?  /  EXTENDS acmeRoleTypeRef (COMMA acmeRoleTypeRef)* (SEMICOLON  /  WITH acmeRoleBody SEMICOLON?))
acmeRoleDeclaration <-  ROLE identifier (COLON acmeRoleTypeRef (COMMA acmeRoleTypeRef)*)? (SEMICOLON  /  ASSIGN (acmeRoleBody SEMICOLON?  /  NEW acmeRoleInstantiatedTypeRef (COMMA acmeRoleInstantiatedTypeRef)* (SEMICOLON  /  EXTENDED WITH acmeRoleBody SEMICOLON?)))
acmeRoleBody    <-  LBRACE (acmePropertyDeclaration  /  designRule  /  acmeRepresentationDeclaration)* RBRACE
acmeComponentTypeDeclaration <-  COMPONENT TYPE identifier (SEMICOLON  /  ASSIGN acmeComponentBody SEMICOLON?  /  EXTENDS acmeComponentTypeRef (COMMA acmeComponentTypeRef)* (SEMICOLON  /  WITH acmeComponentBody SEMICOLON?))
acmeComponentDeclaration <-  COMPONENT identifier (COLON acmeComponentTypeRef (COMMA acmeComponentTypeRef)*)? (SEMICOLON  /  ASSIGN (acmeComponentBody SEMICOLON?  /  NEW acmeComponentInstantiatedTypeRef (COMMA acmeComponentInstantiatedTypeRef)* (SEMICOLON  /  EXTENDED WITH acmeComponentBody SEMICOLON?)))
acmeComponentBody <-  LBRACE (acmePropertyDeclaration  /  acmePortDeclaration  /  designRule  /  acmeRepresentationDeclaration)* RBRACE
acmeConnectorTypeDeclaration <-  CONNECTOR TYPE identifier (SEMICOLON  /  ASSIGN acmeConnectorBody SEMICOLON?  /  EXTENDS acmeConnectorTypeRef (COMMA acmeConnectorTypeRef)* (SEMICOLON  /  WITH acmeConnectorBody SEMICOLON?))
acmeConnectorDeclaration <-  CONNECTOR identifier (COLON acmeConnectorTypeRef (COMMA acmeConnectorTypeRef)*)? (SEMICOLON  /  ASSIGN (acmeConnectorBody SEMICOLON?  /  NEW acmeConnectorInstantiatedTypeRef (COMMA acmeConnectorInstantiatedTypeRef)* (SEMICOLON  /  EXTENDED WITH acmeConnectorBody SEMICOLON?)))
acmeConnectorBody <-  LBRACE (acmePropertyDeclaration  /  acmeRoleDeclaration  /  designRule  /  acmeRepresentationDeclaration)* RBRACE
acmeRepresentationDeclaration <-  REPRESENTATION (IDENTIFIER ASSIGN)? LBRACE acmeSystemDeclaration acmeBindingsMapDeclaration? RBRACE __rep_002
acmeBindingsMapDeclaration <-  BINDINGS LBRACE acmeBindingDeclaration* RBRACE SEMICOLON?
acmeBindingDeclaration <-  acmeInstanceRef TO acmeInstanceRef (LBRACE acmePropertyDeclaration acmePropertyBlock RBRACE)? SEMICOLON
acmeAttachmentDeclaration <-  ATTACHMENT acmeInstanceRef TO acmeInstanceRef SEMICOLON
acmePropertyDeclaration <-  PROPERTY identifier (COLON acmePropertyTypeRef)? (ASSIGN acmePropertyValueDeclaration  /  CONTAINASSIGN acmePropertyValueDeclaration)? acmePropertyBlock? SEMICOLON
acmePropertyValueDeclaration <-  INTEGER_LITERAL  /  FLOATING_POINT_LITERAL  /  STRING_LITERAL  /  FALSE  /  TRUE  /  acmePropertySet  /  acmePropertyRecord  /  acmePropertySequence  /  enumidentifier
enumidentifier  <-  IDENTIFIER
acmePropertyElement <-  IDENTIFIER (ZLex_003 IDENTIFIER)*  /  acmePropertyCompoundElement
acmePropertyCompoundElement <-  acmePropertySet  /  acmePropertyRecord  /  acmePropertySequence
acmePropertySet <-  LBRACE (acmePropertyValueDeclaration (COMMA acmePropertyValueDeclaration)*)? RBRACE
acmePropertyRecordEntry <-  identifier (COLON acmePropertyTypeRef)? ASSIGN acmePropertyValueDeclaration
acmePropertyRecord <-  LBRACKET (acmePropertyRecordEntry __rep_003 SEMICOLON?)? RBRACKET
acmePropertySequence <-  LANGLE (acmePropertyValueDeclaration (COMMA acmePropertyValueDeclaration)*)? RANGLE
acmePropertyTypeRecord <-  RECORD LBRACKET acmePropertyRecordFieldDescription* RBRACKET
acmePropertyTypeSet <-  SET LBRACE acmeTypeRef? RBRACE
acmePropertyTypeSequence <-  SEQUENCE LANGLE acmePropertyTypeRef? RANGLE
acmePropertyTypeEnum <-  ENUM LBRACE identifier (COMMA identifier)* RBRACE
acmePropertyRecordFieldDescription <-  identifier COLON acmePropertyTypeRef SEMICOLON
acmePropertyTypeRef <-  acmePropertyTypeStructure  /  acmePropertyTypeDeclarationRef
acmePropertyTypeStructure <-  acmePropertyTypeAny  /  acmePropertyTypeInt  /  acmePropertyTypeFloat  /  acmePropertyTypeDouble  /  acmePropertyTypeString  /  acmePropertyTypeBoolean  /  acmePropertyTypeRecord  /  acmePropertyTypeSet  /  acmePropertyTypeSequence  /  acmePropertyTypeEnum
acmePropertyTypeDeclaration <-  PROPERTY TYPE identifier (SEMICOLON  /  ASSIGN (acmePropertyTypeInt  /  acmePropertyTypeFloat  /  acmePropertyTypeDouble  /  acmePropertyTypeString  /  acmePropertyTypeBoolean  /  acmePropertyTypeRecord  /  acmePropertyTypeSet  /  acmePropertyTypeSequence  /  acmePropertyTypeEnum  /  acmePropertyTypeAny) SEMICOLON)
acmePropertyBlockEntry <-  identifier (COLON acmePropertyTypeRef)? (ASSIGN acmePropertyValueDeclaration  /  CONTAINASSIGN acmePropertyValueDeclaration)? SEMICOLON
acmePropertyBlock <-  PROPBEGIN acmePropertyBlockEntry+ PROPEND
acmePropertyTypeInt <-  INT
acmePropertyTypeAny <-  ANY
acmePropertyTypeFloat <-  FLOAT
acmePropertyTypeDouble <-  DOUBLE
acmePropertyTypeString <-  STRING
acmePropertyTypeBoolean <-  BOOLEAN
acmeViewDeclaration <-  VIEW identifier (COLON acmeViewTypeRef)? (SEMICOLON  /  ASSIGN (acmeViewBody SEMICOLON?  /  NEW acmeViewInstantiatedTypeRef (SEMICOLON  /  EXTENDED WITH acmeViewBody SEMICOLON?)))
acmeViewTypeDeclaration <-  VIEW TYPE identifier (SEMICOLON  /  ASSIGN acmeViewBody SEMICOLON?  /  EXTENDS acmeViewTypeRef (SEMICOLON  /  WITH acmeViewBody SEMICOLON?))
acmeViewBody    <-  LBRACE RBRACE
designRule      <-  DESIGN? (RULE IDENTIFIER ASSIGN?)? (INVARIANT designRuleExpression  /  HEURISTIC designRuleExpression)? acmePropertyBlock? SEMICOLON
acmeDesignAnalysisDeclaration <-  DESIGN? ANALYSIS IDENTIFIER LPAREN (formalParam (COMMA formalParam)*)? RPAREN COLON acmeTypeRef ASSIGN designRuleExpression acmePropertyBlock? SEMICOLON  /  EXTERNAL DESIGN? ANALYSIS IDENTIFIER LPAREN (formalParam (COMMA formalParam)*)? RPAREN COLON acmeTypeRef ASSIGN (codeLiteral  /  identifier (DOT identifier)*) SEMICOLON
formalParam     <-  identifier COLON acmeTypeRef
terminatedDesignRuleExpression <-  designRuleExpression SEMICOLON
designRuleExpression <-  aSTDRImpliesExpression __rep_004
aSTDRImpliesExpression <-  dRIffExpression __rep_005
dRIffExpression <-  dRAndExpression __rep_006
dRAndExpression <-  dRNegateExpression __rep_007
dRNegateExpression <-  BANG dRNegateExpression  /  dREqualityExpression
dREqualityExpression <-  dRRelationalExpression __rep_008
dRRelationalExpression <-  dRAdditiveExpression __rep_009
dRAdditiveExpression <-  dRMultiplicativeExpression __rep_010
dRMultiplicativeExpression <-  dRNegativeExpression __rep_011
dRNegativeExpression <-  MINUS dRNegativeExpression  /  primitiveExpression
primitiveExpression <-  literalConstant  /  reference  /  parentheticalExpression  /  setExpression  /  literalRecord  /  quantifiedExpression  /  literalSequence  /  sequenceExpression
parentheticalExpression <-  LPAREN designRuleExpression RPAREN
reference       <-  identifier (DOT (identifier  /  setReference))* actualParams?
setReference    <-  TYPE  /  COMPONENTS  /  CONNECTORS  /  PORTS  /  ROLES  /  GROUPS  /  MEMBERS  /  PROPERTIES  /  REPRESENTATIONS  /  ATTACHEDPORTS  /  ATTACHEDROLES
actualParams    <-  LPAREN (designRuleExpression (COMMA designRuleExpression)*)? RPAREN
literalConstant <-  INTEGER_LITERAL  /  FLOATING_POINT_LITERAL  /  STRING_LITERAL  /  TRUE  /  FALSE  /  COMPONENT  /  GROUP  /  CONNECTOR  /  PORT  /  ROLE  /  SYSTEM  /  ELEMENT  /  PROPERTY  /  INT  /  FLOAT  /  DOUBLE  /  STRING  /  BOOLEAN  /  ENUM  /  SET  /  SEQUENCE  /  RECORD
quantifiedExpression <-  (FORALL  /  EXISTS UNIQUE?) variableSetDeclaration (COMMA variableSetDeclaration)* BIT_OR designRuleExpression
distinctVariableSetDeclaration <-  DISTINCT identifier (COMMA identifier)* ((COLON  /  SET_DECLARE) acmeTypeRef)? IN (setExpression  /  reference)
variableSetDeclaration <-  distinctVariableSetDeclaration  /  identifier (COMMA identifier)* ((COLON  /  SET_DECLARE) acmeTypeRef)? IN (setExpression  /  reference)
sequenceExpression <-  LANGLE pathExpression RANGLE
setExpression   <-  pathExpression  /  literalSet  /  setConstructor
pathExpression  <-  SLASH reference ((COLON  /  SET_DECLARE) acmeTypeRef)? (LBRACKET designRuleExpression RBRACKET)? __rep_012
pathExpressionContinuation <-  setReference ((COLON  /  SET_DECLARE) acmeTypeRef)? (LBRACKET designRuleExpression RBRACKET)? (SLASH pathExpressionContinuation)*  /  ELLIPSIS? reference
literalSet      <-  LBRACE RBRACE  /  LBRACE (literalConstant  /  reference) (COMMA (literalConstant  /  reference))* RBRACE
literalSequence <-  LANGLE RANGLE  /  LANGLE (literalConstant  /  reference) (COMMA (literalConstant  /  reference))* RANGLE
literalRecordEntry <-  identifier (COLON acmePropertyTypeRef)? ASSIGN literalConstant
literalRecord   <-  LBRACKET (literalRecordEntry __rep_013 SEMICOLON?)? RBRACKET
setConstructor  <-  LBRACE? SELECT variableSetDeclaration BIT_OR designRuleExpression RBRACE?  /  LBRACE? COLLECT reference COLON acmeTypeRef IN (setExpression  /  reference) BIT_OR designRuleExpression RBRACE?
acmeTypeRef     <-  SYSTEM  /  COMPONENT  /  GROUP  /  CONNECTOR  /  PORT  /  ROLE  /  PROPERTY  /  ELEMENT  /  TYPE  /  REPRESENTATION  /  reference  /  acmePropertyTypeStructure
ABSTRACT        <-  A B S T R A C T !__IdRest
ANALYSIS        <-  A N A L Y S I S !__IdRest
AND             <-  A N D !__IdRest
ANY             <-  A N Y !__IdRest
ASSIGN          <-  !EQ '='
ATTACHMENT      <-  A T T A C H M E N T !__IdRest
ATTACHMENTS     <-  A T T A C H M E N T S !__IdRest
ATTACHEDPORTS   <-  A T T A C H E D P O R T S !__IdRest
ATTACHEDROLES   <-  A T T A C H E D R O L E S !__IdRest
BANG            <-  !NE '!'
BINDINGS        <-  B I N D I N G S !__IdRest
COLON           <-  !SET_DECLARE ':'
COMMA           <-  ','
COLLECT         <-  C O L L E C T !__IdRest
COMPONENT       <-  C O M P O N E N T !__IdRest
COMPONENTS      <-  C O M P O N E N T S !__IdRest
CONNECTOR       <-  C O N N E C T O R !__IdRest
CONTAINASSIGN   <-  C O N T A I N A S S I G N !__IdRest
CONNECTORS      <-  C O N N E C T O R S !__IdRest
DESIGN          <-  D E S I G N !__IdRest
DISTINCT        <-  D I S T I N C T !__IdRest
DOT             <-  !ELLIPSIS '.'
DOUBLE          <-  D O U B L E !__IdRest
ELEMENT         <-  E L E M E N T !__IdRest
ENUM            <-  E N U M !__IdRest
EXTENDED        <-  E X T E N D E D !__IdRest
EXTENDS         <-  E X T E N D S !__IdRest
EXTERNAL        <-  E X T E R N A L !__IdRest
EXISTS          <-  E X I S T S !__IdRest
ELLIPSIS        <-  '...'
EQ              <-  '=='
FAMILY          <-  F A M I L Y !__IdRest
FINAL           <-  F I N A L !__IdRest
FORALL          <-  F O R A L L !__IdRest
FLOAT           <-  F L O A T !__IdRest
GROUP           <-  G R O U P !__IdRest
GROUPS          <-  G R O U P S !__IdRest
GE              <-  '>='
HEURISTIC       <-  H E U R I S T I C !__IdRest
IFF             <-  '<->'
IMPORT          <-  I M P O R T !__IdRest
IN              <-  I N !__IdRest
INT             <-  (I N T E G E R  /  I N T) !__IdRest
INVARIANT       <-  I N V A R I A N T !__IdRest
IMPLIES         <-  '->'
LBRACE          <-  '{'
RBRACE          <-  '}'
LBRACKET        <-  '['
RBRACKET        <-  ']'
LPAREN          <-  '('
RPAREN          <-  ')'
LANGLE          <-  !IFF !PROPBEGIN !LE '<'
RANGLE          <-  !GE !PROPEND '>'
LE              <-  '<='
NE              <-  '!='
NEW             <-  N E W !__IdRest
MEMBERS         <-  M E M B E R S !__IdRest
MINUS           <-  !IMPLIES '-'
OR              <-  O R !__IdRest
PATHSEPARATOR   <-  '.'  /  ':'  /  '-'  /  '+'  /  '\\\\'  /  '\\'  /  '/'  /  '$'  /  '%'
PUBLIC          <-  P U B L I C !__IdRest
PRIVATE         <-  P R I V A T E !__IdRest
POWER           <-  P O W E R !__IdRest
PLUS            <-  '+'
PORT            <-  P O R T !__IdRest
PORTS           <-  P O R T S !__IdRest
PROPERTY        <-  P R O P E R T Y !__IdRest
PROPERTIES      <-  P R O P E R T I E S !__IdRest
PROPBEGIN       <-  '<<'
PROPEND         <-  '>>'
RECORD          <-  R E C O R D !__IdRest
REPRESENTATION  <-  R E P R E S E N T A T I O N !__IdRest
REM             <-  '%'
REPRESENTATIONS <-  R E P R E S E N T A T I O N S !__IdRest
ROLE            <-  R O L E !__IdRest
RULE            <-  R U L E !__IdRest
ROLES           <-  R O L E S !__IdRest
SEQUENCE        <-  (S E Q U E N C E  /  S E Q) !__IdRest
SELECT          <-  S E L E C T !__IdRest
SEMICOLON       <-  ';'
SET             <-  S E T !__IdRest
SET_DECLARE     <-  ':!'
SLASH           <-  '/'
STAR            <-  '*'
STRING          <-  S T R I N G !__IdRest
STYLE           <-  S T Y L E !__IdRest
SYSTEM          <-  S Y S T E M !__IdRest
TO              <-  T O !__IdRest
TYPE            <-  T Y P E !__IdRest
UNIQUE          <-  U N I Q U E !__IdRest
WITH            <-  W I T H !__IdRest
VIEW            <-  V I E W !__IdRest
BIT_OR          <-  '|'
TRUE            <-  T R U E !__IdRest
FALSE           <-  F A L S E !__IdRest
A               <-  'a'  /  'A'
B               <-  'b'  /  'B'
C               <-  'c'  /  'C'
D               <-  'd'  /  'D'
E               <-  'e'  /  'E'
F               <-  'f'  /  'F'
G               <-  'g'  /  'G'
H               <-  'h'  /  'H'
I               <-  'i'  /  'I'
J               <-  'j'  /  'J'
K               <-  'k'  /  'K'
L               <-  'l'  /  'L'
M               <-  'm'  /  'M'
N               <-  'n'  /  'N'
O               <-  'o'  /  'O'
P               <-  'p'  /  'P'
Q               <-  'q'  /  'Q'
R               <-  'r'  /  'R'
S               <-  's'  /  'S'
T               <-  't'  /  'T'
U               <-  'u'  /  'U'
V               <-  'v'  /  'V'
W               <-  'w'  /  'W'
X               <-  'x'  /  'X'
Y               <-  'y'  /  'Y'
Z               <-  'z'  /  'Z'
BOOLEAN         <-  TRUE  /  FALSE
FLOATING_POINT_LITERAL <-  ('-'  /  '+')? [0-9]+ '.' [0-9]+
INTEGER_LITERAL <-  [0-9]+
STRING_LITERAL  <-  '"' (!'"' .)* '"'
IDENTIFIER      <-  !__Keywords [a-zA-Z] [a-zA-Z0-9_-]*
LINE_COMMENT    <-  '//' (![\r\n] .)*
BLOCK_COMMENT   <-  '/*' (!'*/' .)* '*/'
WS              <-  [ \r\n\t]+
EOF             <-  !.
ZLex_001        <-  '$'
ZLex_002        <-  '%'
ZLex_003        <-  !ELLIPSIS '.'
ZLex_004        <-  !SET_DECLARE ':'
ZLex_005        <-  !IMPLIES '-'
ZLex_006        <-  '+'
ZLex_007        <-  !ZLex_008 '\\'
ZLex_008        <-  '\\\\'
ZLex_009        <-  '/'
__rep_001       <-  SEMICOLON &(DESIGN  /  HEURISTIC  /  INVARIANT  /  MEMBERS  /  PROPBEGIN  /  PROPERTY  /  RBRACE  /  RULE  /  SEMICOLON)  /  ''
__rep_002       <-  SEMICOLON &(DESIGN  /  HEURISTIC  /  INVARIANT  /  PORT  /  PROPBEGIN  /  PROPERTY  /  RBRACE  /  REPRESENTATION  /  ROLE  /  RULE  /  SEMICOLON)  /  ''
__rep_003       <-  SEMICOLON acmePropertyRecordEntry __rep_003  /  &(RBRACKET  /  SEMICOLON)
__rep_004       <-  OR aSTDRImpliesExpression __rep_004  /  &(AND  /  BIT_OR  /  COMMA  /  EQ  /  GE  /  IFF  /  IMPLIES  /  LANGLE  /  LE  /  MINUS  /  NE  /  OR  /  PLUS  /  POWER  /  PROPBEGIN  /  RANGLE  /  RBRACE  /  RBRACKET  /  REM  /  RPAREN  /  SEMICOLON  /  SLASH  /  STAR)
__rep_005       <-  IMPLIES dRIffExpression __rep_005  /  &(AND  /  BIT_OR  /  COMMA  /  EQ  /  GE  /  IFF  /  IMPLIES  /  LANGLE  /  LE  /  MINUS  /  NE  /  OR  /  PLUS  /  POWER  /  PROPBEGIN  /  RANGLE  /  RBRACE  /  RBRACKET  /  REM  /  RPAREN  /  SEMICOLON  /  SLASH  /  STAR)
__rep_006       <-  IFF dRAndExpression __rep_006  /  &(AND  /  BIT_OR  /  COMMA  /  EQ  /  GE  /  IFF  /  IMPLIES  /  LANGLE  /  LE  /  MINUS  /  NE  /  OR  /  PLUS  /  POWER  /  PROPBEGIN  /  RANGLE  /  RBRACE  /  RBRACKET  /  REM  /  RPAREN  /  SEMICOLON  /  SLASH  /  STAR)
__rep_007       <-  AND dRNegateExpression __rep_007  /  &(AND  /  BIT_OR  /  COMMA  /  EQ  /  GE  /  IFF  /  IMPLIES  /  LANGLE  /  LE  /  MINUS  /  NE  /  OR  /  PLUS  /  POWER  /  PROPBEGIN  /  RANGLE  /  RBRACE  /  RBRACKET  /  REM  /  RPAREN  /  SEMICOLON  /  SLASH  /  STAR)
__rep_008       <-  (EQ dRRelationalExpression  /  NE dRRelationalExpression) __rep_008  /  &(AND  /  BIT_OR  /  COMMA  /  EQ  /  GE  /  IFF  /  IMPLIES  /  LANGLE  /  LE  /  MINUS  /  NE  /  OR  /  PLUS  /  POWER  /  PROPBEGIN  /  RANGLE  /  RBRACE  /  RBRACKET  /  REM  /  RPAREN  /  SEMICOLON  /  SLASH  /  STAR)
__rep_009       <-  (LANGLE dRAdditiveExpression  /  RANGLE dRAdditiveExpression  /  LE dRAdditiveExpression  /  GE dRAdditiveExpression) __rep_009  /  &(AND  /  BIT_OR  /  COMMA  /  EQ  /  GE  /  IFF  /  IMPLIES  /  LANGLE  /  LE  /  MINUS  /  NE  /  OR  /  PLUS  /  POWER  /  PROPBEGIN  /  RANGLE  /  RBRACE  /  RBRACKET  /  REM  /  RPAREN  /  SEMICOLON  /  SLASH  /  STAR)
__rep_010       <-  (PLUS dRMultiplicativeExpression  /  MINUS dRMultiplicativeExpression) __rep_010  /  &(AND  /  BIT_OR  /  COMMA  /  EQ  /  GE  /  IFF  /  IMPLIES  /  LANGLE  /  LE  /  MINUS  /  NE  /  OR  /  PLUS  /  POWER  /  PROPBEGIN  /  RANGLE  /  RBRACE  /  RBRACKET  /  REM  /  RPAREN  /  SEMICOLON  /  SLASH  /  STAR)
__rep_011       <-  (STAR dRNegativeExpression  /  SLASH dRNegativeExpression  /  REM dRNegativeExpression  /  POWER dRNegativeExpression) __rep_011  /  &(AND  /  BIT_OR  /  COMMA  /  EQ  /  GE  /  IFF  /  IMPLIES  /  LANGLE  /  LE  /  MINUS  /  NE  /  OR  /  PLUS  /  POWER  /  PROPBEGIN  /  RANGLE  /  RBRACE  /  RBRACKET  /  REM  /  RPAREN  /  SEMICOLON  /  SLASH  /  STAR)
__rep_012       <-  SLASH pathExpressionContinuation __rep_012  /  &(AND  /  BIT_OR  /  COMMA  /  EQ  /  GE  /  IFF  /  IMPLIES  /  LANGLE  /  LE  /  MINUS  /  NE  /  OR  /  PLUS  /  POWER  /  PROPBEGIN  /  RANGLE  /  RBRACE  /  RBRACKET  /  REM  /  RPAREN  /  SEMICOLON  /  SLASH  /  STAR)
__rep_013       <-  SEMICOLON literalRecordEntry __rep_013  /  &(RBRACKET  /  SEMICOLON)
__IdBegin       <-  [a-zA-Z]
__IdRest        <-  [a-zA-Z0-9_-]
__Keywords      <-  ABSTRACT  /  ANALYSIS  /  AND  /  ANY  /  ATTACHEDPORTS  /  ATTACHEDROLES  /  ATTACHMENT  /  ATTACHMENTS  /  BINDINGS  /  COLLECT  /  COMPONENT  /  COMPONENTS  /  CONNECTOR  /  CONNECTORS  /  CONTAINASSIGN  /  DESIGN  /  DISTINCT  /  DOUBLE  /  ELEMENT  /  ENUM  /  EXISTS  /  EXTENDED  /  EXTENDS  /  EXTERNAL  /  FALSE  /  FAMILY  /  FINAL  /  FLOAT  /  FORALL  /  GROUP  /  GROUPS  /  HEURISTIC  /  IMPORT  /  IN  /  INT  /  INVARIANT  /  MEMBERS  /  NEW  /  OR  /  PORT  /  PORTS  /  POWER  /  PRIVATE  /  PROPERTIES  /  PROPERTY  /  PUBLIC  /  RECORD  /  REPRESENTATION  /  REPRESENTATIONS  /  ROLE  /  ROLES  /  RULE  /  SELECT  /  SEQUENCE  /  SET  /  STRING  /  STYLE  /  SYSTEM  /  TO  /  TRUE  /  TYPE  /  UNIQUE  /  VIEW  /  WITH

]===]

local g = Parser.match(s)
assert(g)
pretty = Pretty.new()
print(pretty:printg(g, nil, true))
--local c2p = Cfg2Peg.new(g)
--c2p:setUseUnique(false)
--c2p:setUsePrefix(false)
--c2p:convert('IDENTIFIER', true)
local peg = g--c2p.peg
--print(pretty:printg(peg, nil, true))

local p = Coder.makeg(peg)
local dir = Util.getPath(arg[0])
Util.testYes(dir .. '/examples/cmu/', 'acmetest', p)
Util.testYes(dir .. '/grammarinator/tests_01/', 'acmetest', p)

