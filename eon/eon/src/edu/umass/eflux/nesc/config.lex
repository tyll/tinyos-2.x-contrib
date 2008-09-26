package edu.umass.eflux.nesc;

import java_cup.runtime.Symbol;

%%
%cup
%eofval{
  return new Symbol(sym.EOF);
%eofval}
%line

%{
  public int getLine() {
    return yyline;
  }
%}
%%
=+> { return new Symbol(sym.ARROW); }
"("  { return new Symbol(sym.LEFT_PAREN); }
")"  { return new Symbol(sym.RIGHT_PAREN); }
"["  { return new Symbol(sym.LEFT_SQ_BRACE); }
"]"  { return new Symbol(sym.RIGHT_SQ_BRACE); }
"{"  { return new Symbol(sym.LEFT_CR_BRACE); }
"}"  { return new Symbol(sym.RIGHT_CR_BRACE); }
-+>  { return new Symbol(sym.PIPE); }
":"  { return new Symbol(sym.COLON); }
";"  { return new Symbol(sym.SEMI); }
","  { return new Symbol(sym.COMMA); }
"."  { return new Symbol(sym.DOT); }
"="  { return new Symbol(sym.EQUALS); }
"*"  { return new Symbol(sym.STAR); }

"!"  { return new Symbol(sym.EXCLAMATION); }
"#"  { return new Symbol(sym.POUND); }
"\""  { return new Symbol(sym.QUOTE); }
"<"  { return new Symbol(sym.LESSTHAN); }
">"  { return new Symbol(sym.GREATERTHAN); }
"configuration" { return new Symbol(sym.CONFIGURATION); }
"module" { return new Symbol(sym.MODULE); }
"implementation" { return new Symbol(sym.IMPLEMENTATION); }
"components" { return new Symbol(sym.COMPONENTS); }
"includes"   { return new Symbol(sym.INCLUDES); }
"#include"   { return new Symbol(sym.INCLUDE); }
"provides"   { return new Symbol(sym.PROVIDES); }
"uses"   { return new Symbol(sym.USES); }
"command"   { return new Symbol(sym.COMMAND); }
"event"   { return new Symbol(sym.EVENT); }
"interface"   { return new Symbol(sym.INTERFACE); }
"as"   { return new Symbol(sym.AS); }
"unique"   { return new Symbol(sym.UNIQUE); }
/+/[ -}\t]*	{}
[0-9]+       { return new Symbol(sym.NUMBER, new Integer(yytext())); }
[a-zA-Z_*][a-zA-Z0-9_*]* { return new Symbol(sym.IDENTIFIER, new String(yytext()));}
[ \t\r\n\f] { /* ignore white space. */ }
. { System.err.println("Illegal character: "+yytext()); }

