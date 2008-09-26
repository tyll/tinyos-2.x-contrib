package edu.umass.eflux;

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
"="  { return new Symbol(sym.EQUALS); }
"*"  { return new Symbol(sym.STAR); }
"?"  { return new Symbol(sym.QUESTION); }
"!"  { return new Symbol(sym.EXCLAMATION); }
"typedef"  { return new Symbol(sym.TYPEDEF); }
"source"   { return new Symbol(sym.SOURCEDEF); }
"handle"   { return new Symbol(sym.HANDLE); }
"error"    { return new Symbol(sym.ERROR); }
"atomic"   { return new Symbol(sym.ATOMIC); }
"program"  { return new Symbol(sym.PROGRAM); }
"timer"  { return new Symbol(sym.TIMER); }
"session"  { return new Symbol(sym.SESSION); }
"connection" { return new Symbol(sym.CONNECTION); }
"stateorder" { return new Symbol(sym.STATEORDER); }
"platform"   { return new Symbol(sym.PLATFORM); }
"sync"   { return new Symbol(sym.SYNC); }
"OFF"	 { return new Symbol(sym.OFF); }
"off"	 { return new Symbol(sym.OFF); }
"MAX"        { return new Symbol(sym.MAX); }
"max"        { return new Symbol(sym.MAX); }
/+/[ -}\t]*	{}
[0-9]+       { return new Symbol(sym.NUMBER, new Integer(yytext())); }
[0-9]+["hr"|"min"|"ms"|"s"] { return new Symbol(sym.TIME, new String(yytext())); }
[a-zA-Z_*][a-zA-Z0-9_*]* { return new Symbol(sym.IDENTIFIER, new String(yytext()));}
[ \t\r\n\f] { /* ignore white space. */ }
. { System.err.println("Illegal character: "+yytext()); }

