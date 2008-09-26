package edu.umass.eflux.nesc;
import java_cup.runtime.Symbol;


class Yylex implements java_cup.runtime.Scanner {
	private final int YY_BUFFER_SIZE = 512;
	private final int YY_F = -1;
	private final int YY_NO_STATE = -1;
	private final int YY_NOT_ACCEPT = 0;
	private final int YY_START = 1;
	private final int YY_END = 2;
	private final int YY_NO_ANCHOR = 4;
	private final int YY_BOL = 128;
	private final int YY_EOF = 129;

  public int getLine() {
    return yyline;
  }
	private java.io.BufferedReader yy_reader;
	private int yy_buffer_index;
	private int yy_buffer_read;
	private int yy_buffer_start;
	private int yy_buffer_end;
	private char yy_buffer[];
	private int yyline;
	private boolean yy_at_bol;
	private int yy_lexical_state;

	Yylex (java.io.Reader reader) {
		this ();
		if (null == reader) {
			throw (new Error("Error: Bad input stream initializer."));
		}
		yy_reader = new java.io.BufferedReader(reader);
	}

	Yylex (java.io.InputStream instream) {
		this ();
		if (null == instream) {
			throw (new Error("Error: Bad input stream initializer."));
		}
		yy_reader = new java.io.BufferedReader(new java.io.InputStreamReader(instream));
	}

	private Yylex () {
		yy_buffer = new char[YY_BUFFER_SIZE];
		yy_buffer_read = 0;
		yy_buffer_index = 0;
		yy_buffer_start = 0;
		yy_buffer_end = 0;
		yyline = 0;
		yy_at_bol = true;
		yy_lexical_state = YYINITIAL;
	}

	private boolean yy_eof_done = false;
	private final int YYINITIAL = 0;
	private final int yy_state_dtrans[] = {
		0
	};
	private void yybegin (int state) {
		yy_lexical_state = state;
	}
	private int yy_advance ()
		throws java.io.IOException {
		int next_read;
		int i;
		int j;

		if (yy_buffer_index < yy_buffer_read) {
			return yy_buffer[yy_buffer_index++];
		}

		if (0 != yy_buffer_start) {
			i = yy_buffer_start;
			j = 0;
			while (i < yy_buffer_read) {
				yy_buffer[j] = yy_buffer[i];
				++i;
				++j;
			}
			yy_buffer_end = yy_buffer_end - yy_buffer_start;
			yy_buffer_start = 0;
			yy_buffer_read = j;
			yy_buffer_index = j;
			next_read = yy_reader.read(yy_buffer,
					yy_buffer_read,
					yy_buffer.length - yy_buffer_read);
			if (-1 == next_read) {
				return YY_EOF;
			}
			yy_buffer_read = yy_buffer_read + next_read;
		}

		while (yy_buffer_index >= yy_buffer_read) {
			if (yy_buffer_index >= yy_buffer.length) {
				yy_buffer = yy_double(yy_buffer);
			}
			next_read = yy_reader.read(yy_buffer,
					yy_buffer_read,
					yy_buffer.length - yy_buffer_read);
			if (-1 == next_read) {
				return YY_EOF;
			}
			yy_buffer_read = yy_buffer_read + next_read;
		}
		return yy_buffer[yy_buffer_index++];
	}
	private void yy_move_end () {
		if (yy_buffer_end > yy_buffer_start &&
		    '\n' == yy_buffer[yy_buffer_end-1])
			yy_buffer_end--;
		if (yy_buffer_end > yy_buffer_start &&
		    '\r' == yy_buffer[yy_buffer_end-1])
			yy_buffer_end--;
	}
	private boolean yy_last_was_cr=false;
	private void yy_mark_start () {
		int i;
		for (i = yy_buffer_start; i < yy_buffer_index; ++i) {
			if ('\n' == yy_buffer[i] && !yy_last_was_cr) {
				++yyline;
			}
			if ('\r' == yy_buffer[i]) {
				++yyline;
				yy_last_was_cr=true;
			} else yy_last_was_cr=false;
		}
		yy_buffer_start = yy_buffer_index;
	}
	private void yy_mark_end () {
		yy_buffer_end = yy_buffer_index;
	}
	private void yy_to_mark () {
		yy_buffer_index = yy_buffer_end;
		yy_at_bol = (yy_buffer_end > yy_buffer_start) &&
		            ('\r' == yy_buffer[yy_buffer_end-1] ||
		             '\n' == yy_buffer[yy_buffer_end-1] ||
		             2028/*LS*/ == yy_buffer[yy_buffer_end-1] ||
		             2029/*PS*/ == yy_buffer[yy_buffer_end-1]);
	}
	private java.lang.String yytext () {
		return (new java.lang.String(yy_buffer,
			yy_buffer_start,
			yy_buffer_end - yy_buffer_start));
	}
	private int yylength () {
		return yy_buffer_end - yy_buffer_start;
	}
	private char[] yy_double (char buf[]) {
		int i;
		char newbuf[];
		newbuf = new char[2*buf.length];
		for (i = 0; i < buf.length; ++i) {
			newbuf[i] = buf[i];
		}
		return newbuf;
	}
	private final int YY_E_INTERNAL = 0;
	private final int YY_E_MATCH = 1;
	private java.lang.String yy_error_string[] = {
		"Error: Internal error.\n",
		"Error: Unmatched input.\n"
	};
	private void yy_error (int code,boolean fatal) {
		java.lang.System.out.print(yy_error_string[code]);
		java.lang.System.out.flush();
		if (fatal) {
			throw new Error("Fatal Error.\n");
		}
	}
	private int[][] unpackFromString(int size1, int size2, String st) {
		int colonIndex = -1;
		String lengthString;
		int sequenceLength = 0;
		int sequenceInteger = 0;

		int commaIndex;
		String workString;

		int res[][] = new int[size1][size2];
		for (int i= 0; i < size1; i++) {
			for (int j= 0; j < size2; j++) {
				if (sequenceLength != 0) {
					res[i][j] = sequenceInteger;
					sequenceLength--;
					continue;
				}
				commaIndex = st.indexOf(',');
				workString = (commaIndex==-1) ? st :
					st.substring(0, commaIndex);
				st = st.substring(commaIndex+1);
				colonIndex = workString.indexOf(':');
				if (colonIndex == -1) {
					res[i][j]=Integer.parseInt(workString);
					continue;
				}
				lengthString =
					workString.substring(colonIndex+1);
				sequenceLength=Integer.parseInt(lengthString);
				workString=workString.substring(0,colonIndex);
				sequenceInteger=Integer.parseInt(workString);
				res[i][j] = sequenceInteger;
				sequenceLength--;
			}
		}
		return res;
	}
	private int yy_acpt[] = {
		/* 0 */ YY_NOT_ACCEPT,
		/* 1 */ YY_NO_ANCHOR,
		/* 2 */ YY_NO_ANCHOR,
		/* 3 */ YY_NO_ANCHOR,
		/* 4 */ YY_NO_ANCHOR,
		/* 5 */ YY_NO_ANCHOR,
		/* 6 */ YY_NO_ANCHOR,
		/* 7 */ YY_NO_ANCHOR,
		/* 8 */ YY_NO_ANCHOR,
		/* 9 */ YY_NO_ANCHOR,
		/* 10 */ YY_NO_ANCHOR,
		/* 11 */ YY_NO_ANCHOR,
		/* 12 */ YY_NO_ANCHOR,
		/* 13 */ YY_NO_ANCHOR,
		/* 14 */ YY_NO_ANCHOR,
		/* 15 */ YY_NO_ANCHOR,
		/* 16 */ YY_NO_ANCHOR,
		/* 17 */ YY_NO_ANCHOR,
		/* 18 */ YY_NO_ANCHOR,
		/* 19 */ YY_NO_ANCHOR,
		/* 20 */ YY_NO_ANCHOR,
		/* 21 */ YY_NO_ANCHOR,
		/* 22 */ YY_NO_ANCHOR,
		/* 23 */ YY_NO_ANCHOR,
		/* 24 */ YY_NO_ANCHOR,
		/* 25 */ YY_NO_ANCHOR,
		/* 26 */ YY_NO_ANCHOR,
		/* 27 */ YY_NO_ANCHOR,
		/* 28 */ YY_NO_ANCHOR,
		/* 29 */ YY_NO_ANCHOR,
		/* 30 */ YY_NO_ANCHOR,
		/* 31 */ YY_NO_ANCHOR,
		/* 32 */ YY_NO_ANCHOR,
		/* 33 */ YY_NO_ANCHOR,
		/* 34 */ YY_NO_ANCHOR,
		/* 35 */ YY_NO_ANCHOR,
		/* 36 */ YY_NO_ANCHOR,
		/* 37 */ YY_NO_ANCHOR,
		/* 38 */ YY_NO_ANCHOR,
		/* 39 */ YY_NOT_ACCEPT,
		/* 40 */ YY_NO_ANCHOR,
		/* 41 */ YY_NO_ANCHOR,
		/* 42 */ YY_NOT_ACCEPT,
		/* 43 */ YY_NO_ANCHOR,
		/* 44 */ YY_NO_ANCHOR,
		/* 45 */ YY_NOT_ACCEPT,
		/* 46 */ YY_NO_ANCHOR,
		/* 47 */ YY_NOT_ACCEPT,
		/* 48 */ YY_NO_ANCHOR,
		/* 49 */ YY_NOT_ACCEPT,
		/* 50 */ YY_NO_ANCHOR,
		/* 51 */ YY_NOT_ACCEPT,
		/* 52 */ YY_NO_ANCHOR,
		/* 53 */ YY_NOT_ACCEPT,
		/* 54 */ YY_NO_ANCHOR,
		/* 55 */ YY_NOT_ACCEPT,
		/* 56 */ YY_NO_ANCHOR,
		/* 57 */ YY_NO_ANCHOR,
		/* 58 */ YY_NO_ANCHOR,
		/* 59 */ YY_NO_ANCHOR,
		/* 60 */ YY_NO_ANCHOR,
		/* 61 */ YY_NO_ANCHOR,
		/* 62 */ YY_NO_ANCHOR,
		/* 63 */ YY_NO_ANCHOR,
		/* 64 */ YY_NO_ANCHOR,
		/* 65 */ YY_NO_ANCHOR,
		/* 66 */ YY_NO_ANCHOR,
		/* 67 */ YY_NO_ANCHOR,
		/* 68 */ YY_NO_ANCHOR,
		/* 69 */ YY_NO_ANCHOR,
		/* 70 */ YY_NO_ANCHOR,
		/* 71 */ YY_NO_ANCHOR,
		/* 72 */ YY_NO_ANCHOR,
		/* 73 */ YY_NO_ANCHOR,
		/* 74 */ YY_NO_ANCHOR,
		/* 75 */ YY_NO_ANCHOR,
		/* 76 */ YY_NO_ANCHOR,
		/* 77 */ YY_NO_ANCHOR,
		/* 78 */ YY_NO_ANCHOR,
		/* 79 */ YY_NO_ANCHOR,
		/* 80 */ YY_NO_ANCHOR,
		/* 81 */ YY_NO_ANCHOR,
		/* 82 */ YY_NO_ANCHOR,
		/* 83 */ YY_NO_ANCHOR,
		/* 84 */ YY_NO_ANCHOR,
		/* 85 */ YY_NO_ANCHOR,
		/* 86 */ YY_NO_ANCHOR,
		/* 87 */ YY_NO_ANCHOR,
		/* 88 */ YY_NO_ANCHOR,
		/* 89 */ YY_NO_ANCHOR,
		/* 90 */ YY_NO_ANCHOR,
		/* 91 */ YY_NO_ANCHOR,
		/* 92 */ YY_NO_ANCHOR,
		/* 93 */ YY_NO_ANCHOR,
		/* 94 */ YY_NO_ANCHOR,
		/* 95 */ YY_NO_ANCHOR,
		/* 96 */ YY_NO_ANCHOR,
		/* 97 */ YY_NO_ANCHOR,
		/* 98 */ YY_NO_ANCHOR,
		/* 99 */ YY_NO_ANCHOR,
		/* 100 */ YY_NO_ANCHOR,
		/* 101 */ YY_NO_ANCHOR,
		/* 102 */ YY_NO_ANCHOR,
		/* 103 */ YY_NO_ANCHOR,
		/* 104 */ YY_NO_ANCHOR,
		/* 105 */ YY_NO_ANCHOR,
		/* 106 */ YY_NO_ANCHOR,
		/* 107 */ YY_NO_ANCHOR,
		/* 108 */ YY_NO_ANCHOR,
		/* 109 */ YY_NO_ANCHOR,
		/* 110 */ YY_NO_ANCHOR,
		/* 111 */ YY_NO_ANCHOR,
		/* 112 */ YY_NO_ANCHOR,
		/* 113 */ YY_NO_ANCHOR,
		/* 114 */ YY_NO_ANCHOR,
		/* 115 */ YY_NO_ANCHOR,
		/* 116 */ YY_NO_ANCHOR,
		/* 117 */ YY_NO_ANCHOR,
		/* 118 */ YY_NO_ANCHOR,
		/* 119 */ YY_NO_ANCHOR
	};
	private int yy_cmap[] = unpackFromString(1,130,
"43:9,41,42,43,42:2,43:18,41,15,17,16,38:4,3,4,14,38,12,9,13,37,39:10,10,11," +
"18,1,2,38:2,40:26,5,38,6,38,40,38,27,40,19,30,32,22,24,40,23,40:2,31,29,21," +
"20,33,36,26,34,28,25,35,40:4,7,38,8,43:2,0:2")[0];

	private int yy_rmap[] = unpackFromString(1,120,
"0,1,2,1:7,3,1:4,4,1,5,1:2,6,7,1:3,4,8,4:5,1,4:6,2,9,10,3,1,11,12,13,14,15,1" +
"6,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,4" +
"1,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,6" +
"6,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,4,84,85")[0];

	private int yy_nxt[][] = unpackFromString(86,44,
"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,117:3,118,117,72,117,41," +
"117,93,117:2,83,119,117:3,40,43,21,117,22:2,43,-1:45,39,23,-1:43,24,-1:6,42" +
",-1:48,117,-1:4,117:18,-1:2,117:2,-1:26,45,-1:34,117,-1:4,117,94,117:16,-1:" +
"2,117:2,-1:42,21,-1:5,26:41,-1:39,26,-1:20,117,-1:4,117:15,25,117:2,-1:2,11" +
"7:2,-1:17,117,-1:4,117:15,27,117:2,-1:2,117:2,-1:24,47,-1:36,117,-1:4,117:9" +
",28,117:8,-1:2,117:2,-1:22,49,-1:38,117,-1:4,117:13,29,117:4,-1:2,117:2,-1:" +
"34,51,-1:26,117,-1:4,117:13,30,117:4,-1:2,117:2,-1:28,53,-1:32,117,-1:4,117" +
":11,31,117:6,-1:2,117:2,-1:33,55,-1:27,117,-1:4,117:15,33,117:2,-1:2,117:2," +
"-1:35,32,-1:25,117,-1:4,117:15,34,117:2,-1:2,117:2,-1:17,117,-1:4,117:13,35" +
",117:4,-1:2,117:2,-1:17,117,-1:4,117:15,36,117:2,-1:2,117:2,-1:17,117,-1:4," +
"117:2,37,117:15,-1:2,117:2,-1:17,117,-1:4,117:2,38,117:15,-1:2,117:2,-1:17," +
"117,-1:4,117:13,44,117:4,-1:2,117:2,-1:17,117,-1:4,117:2,46,117:15,-1:2,117" +
":2,-1:17,117,-1:4,117:6,48,117:11,-1:2,117:2,-1:17,117,-1:4,117:12,50,117:5" +
",-1:2,117:2,-1:17,117,-1:4,117:2,52,117:15,-1:2,117:2,-1:17,117,-1:4,117:13" +
",54,117:4,-1:2,117:2,-1:17,117,-1:4,117:13,56,117:4,-1:2,117:2,-1:17,117,-1" +
":4,57,117:17,-1:2,117:2,-1:17,117,-1:4,117:9,58,117:8,-1:2,117:2,-1:17,117," +
"-1:4,117,59,117:16,-1:2,117:2,-1:17,117,-1:4,117,60,117:16,-1:2,117:2,-1:17" +
",117,-1:4,117:2,84,117:12,61,117:2,-1:2,117:2,-1:17,117,-1:4,117:13,62,117:" +
"4,-1:2,117:2,-1:17,117,-1:4,117:17,63,-1:2,117:2,-1:17,117,-1:4,117:6,64,11" +
"7:11,-1:2,117:2,-1:17,117,-1:4,117:8,65,117:9,-1:2,117:2,-1:17,117,-1:4,117" +
":11,66,117:6,-1:2,117:2,-1:17,117,-1:4,117:11,67,117:6,-1:2,117:2,-1:17,117" +
",-1:4,117:8,68,117:9,-1:2,117:2,-1:17,117,-1:4,117:2,69,117:15,-1:2,117:2,-" +
"1:17,117,-1:4,117:4,70,117:13,-1:2,117:2,-1:17,117,-1:4,117:4,71,117:13,-1:" +
"2,117:2,-1:17,117,-1:4,117:16,73,117,-1:2,117:2,-1:17,117,-1:4,117:4,74,117" +
":13,-1:2,117:2,-1:17,117,-1:4,117:11,75,117:6,-1:2,117:2,-1:17,117,-1:4,117" +
":10,76,117:3,104,117:3,-1:2,117:2,-1:17,117,-1:4,117:6,77,117:11,-1:2,117:2" +
",-1:17,117,-1:4,117:4,78,117:13,-1:2,117:2,-1:17,117,-1:4,117:3,79,117:14,-" +
"1:2,117:2,-1:17,117,-1:4,117:13,80,117:4,-1:2,117:2,-1:17,117,-1:4,117:9,81" +
",117:8,-1:2,117:2,-1:17,117,-1:4,117:9,82,117:8,-1:2,117:2,-1:17,117,-1:4,1" +
"17,85,117:16,-1:2,117:2,-1:17,117,-1:4,117:2,98,117:7,86,117:7,-1:2,117:2,-" +
"1:17,117,-1:4,99,117:8,100,117:8,-1:2,117:2,-1:17,117,-1:4,117:14,101,117:3" +
",-1:2,117:2,-1:17,117,-1:4,117,102,117:16,-1:2,117:2,-1:17,117,-1:4,117:3,1" +
"03,117:14,-1:2,117:2,-1:17,117,-1:4,117:12,87,117:5,-1:2,117:2,-1:17,117,-1" +
":4,117:13,105,117:4,-1:2,117:2,-1:17,117,-1:4,117:12,106,117:5,-1:2,117:2,-" +
"1:17,117,-1:4,117:16,88,117,-1:2,117:2,-1:17,117,-1:4,117:4,107,117:13,-1:2" +
",117:2,-1:17,117,-1:4,117,108,117:16,-1:2,117:2,-1:17,117,-1:4,117:7,89,117" +
":10,-1:2,117:2,-1:17,117,-1:4,117:13,109,117:4,-1:2,117:2,-1:17,117,-1:4,11" +
"7:5,110,117:12,-1:2,117:2,-1:17,117,-1:4,117:2,90,117:15,-1:2,117:2,-1:17,1" +
"17,-1:4,117:10,111,117:7,-1:2,117:2,-1:17,117,-1:4,117:6,112,117:11,-1:2,11" +
"7:2,-1:17,117,-1:4,117:13,113,117:4,-1:2,117:2,-1:17,117,-1:4,117:7,114,117" +
":10,-1:2,117:2,-1:17,117,-1:4,117:2,115,117:15,-1:2,117:2,-1:17,117,-1:4,11" +
"7:8,91,117:9,-1:2,117:2,-1:17,117,-1:4,117:9,116,117:8,-1:2,117:2,-1:17,117" +
",-1:4,117:8,92,117:9,-1:2,117:2,-1:17,117,-1:4,117:2,95,117:7,96,117:7,-1:2" +
",117:2,-1:17,117,-1:4,117:7,97,117:10,-1:2,117:2,-1:3");

	public java_cup.runtime.Symbol next_token ()
		throws java.io.IOException {
		int yy_lookahead;
		int yy_anchor = YY_NO_ANCHOR;
		int yy_state = yy_state_dtrans[yy_lexical_state];
		int yy_next_state = YY_NO_STATE;
		int yy_last_accept_state = YY_NO_STATE;
		boolean yy_initial = true;
		int yy_this_accept;

		yy_mark_start();
		yy_this_accept = yy_acpt[yy_state];
		if (YY_NOT_ACCEPT != yy_this_accept) {
			yy_last_accept_state = yy_state;
			yy_mark_end();
		}
		while (true) {
			if (yy_initial && yy_at_bol) yy_lookahead = YY_BOL;
			else yy_lookahead = yy_advance();
			yy_next_state = YY_F;
			yy_next_state = yy_nxt[yy_rmap[yy_state]][yy_cmap[yy_lookahead]];
			if (YY_EOF == yy_lookahead && true == yy_initial) {

  return new Symbol(sym.EOF);
			}
			if (YY_F != yy_next_state) {
				yy_state = yy_next_state;
				yy_initial = false;
				yy_this_accept = yy_acpt[yy_state];
				if (YY_NOT_ACCEPT != yy_this_accept) {
					yy_last_accept_state = yy_state;
					yy_mark_end();
				}
			}
			else {
				if (YY_NO_STATE == yy_last_accept_state) {
					throw (new Error("Lexical Error: Unmatched Input."));
				}
				else {
					yy_anchor = yy_acpt[yy_last_accept_state];
					if (0 != (YY_END & yy_anchor)) {
						yy_move_end();
					}
					yy_to_mark();
					switch (yy_last_accept_state) {
					case 1:
						
					case -2:
						break;
					case 2:
						{ return new Symbol(sym.EQUALS); }
					case -3:
						break;
					case 3:
						{ return new Symbol(sym.GREATERTHAN); }
					case -4:
						break;
					case 4:
						{ return new Symbol(sym.LEFT_PAREN); }
					case -5:
						break;
					case 5:
						{ return new Symbol(sym.RIGHT_PAREN); }
					case -6:
						break;
					case 6:
						{ return new Symbol(sym.LEFT_SQ_BRACE); }
					case -7:
						break;
					case 7:
						{ return new Symbol(sym.RIGHT_SQ_BRACE); }
					case -8:
						break;
					case 8:
						{ return new Symbol(sym.LEFT_CR_BRACE); }
					case -9:
						break;
					case 9:
						{ return new Symbol(sym.RIGHT_CR_BRACE); }
					case -10:
						break;
					case 10:
						{ System.err.println("Illegal character: "+yytext()); }
					case -11:
						break;
					case 11:
						{ return new Symbol(sym.COLON); }
					case -12:
						break;
					case 12:
						{ return new Symbol(sym.SEMI); }
					case -13:
						break;
					case 13:
						{ return new Symbol(sym.COMMA); }
					case -14:
						break;
					case 14:
						{ return new Symbol(sym.DOT); }
					case -15:
						break;
					case 15:
						{ return new Symbol(sym.STAR); }
					case -16:
						break;
					case 16:
						{ return new Symbol(sym.EXCLAMATION); }
					case -17:
						break;
					case 17:
						{ return new Symbol(sym.POUND); }
					case -18:
						break;
					case 18:
						{ return new Symbol(sym.QUOTE); }
					case -19:
						break;
					case 19:
						{ return new Symbol(sym.LESSTHAN); }
					case -20:
						break;
					case 20:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -21:
						break;
					case 21:
						{ return new Symbol(sym.NUMBER, new Integer(yytext())); }
					case -22:
						break;
					case 22:
						{ /* ignore white space. */ }
					case -23:
						break;
					case 23:
						{ return new Symbol(sym.ARROW); }
					case -24:
						break;
					case 24:
						{ return new Symbol(sym.PIPE); }
					case -25:
						break;
					case 25:
						{ return new Symbol(sym.AS); }
					case -26:
						break;
					case 26:
						{}
					case -27:
						break;
					case 27:
						{ return new Symbol(sym.USES); }
					case -28:
						break;
					case 28:
						{ return new Symbol(sym.EVENT); }
					case -29:
						break;
					case 29:
						{ return new Symbol(sym.UNIQUE); }
					case -30:
						break;
					case 30:
						{ return new Symbol(sym.MODULE); }
					case -31:
						break;
					case 31:
						{ return new Symbol(sym.COMMAND); }
					case -32:
						break;
					case 32:
						{ return new Symbol(sym.INCLUDE); }
					case -33:
						break;
					case 33:
						{ return new Symbol(sym.INCLUDES); }
					case -34:
						break;
					case 34:
						{ return new Symbol(sym.PROVIDES); }
					case -35:
						break;
					case 35:
						{ return new Symbol(sym.INTERFACE); }
					case -36:
						break;
					case 36:
						{ return new Symbol(sym.COMPONENTS); }
					case -37:
						break;
					case 37:
						{ return new Symbol(sym.CONFIGURATION); }
					case -38:
						break;
					case 38:
						{ return new Symbol(sym.IMPLEMENTATION); }
					case -39:
						break;
					case 40:
						{ System.err.println("Illegal character: "+yytext()); }
					case -40:
						break;
					case 41:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -41:
						break;
					case 43:
						{ System.err.println("Illegal character: "+yytext()); }
					case -42:
						break;
					case 44:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -43:
						break;
					case 46:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -44:
						break;
					case 48:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -45:
						break;
					case 50:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -46:
						break;
					case 52:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -47:
						break;
					case 54:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -48:
						break;
					case 56:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -49:
						break;
					case 57:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -50:
						break;
					case 58:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -51:
						break;
					case 59:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -52:
						break;
					case 60:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -53:
						break;
					case 61:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -54:
						break;
					case 62:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -55:
						break;
					case 63:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -56:
						break;
					case 64:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -57:
						break;
					case 65:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -58:
						break;
					case 66:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -59:
						break;
					case 67:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -60:
						break;
					case 68:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -61:
						break;
					case 69:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -62:
						break;
					case 70:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -63:
						break;
					case 71:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -64:
						break;
					case 72:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -65:
						break;
					case 73:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -66:
						break;
					case 74:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -67:
						break;
					case 75:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -68:
						break;
					case 76:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -69:
						break;
					case 77:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -70:
						break;
					case 78:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -71:
						break;
					case 79:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -72:
						break;
					case 80:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -73:
						break;
					case 81:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -74:
						break;
					case 82:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -75:
						break;
					case 83:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -76:
						break;
					case 84:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -77:
						break;
					case 85:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -78:
						break;
					case 86:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -79:
						break;
					case 87:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -80:
						break;
					case 88:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -81:
						break;
					case 89:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -82:
						break;
					case 90:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -83:
						break;
					case 91:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -84:
						break;
					case 92:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -85:
						break;
					case 93:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -86:
						break;
					case 94:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -87:
						break;
					case 95:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -88:
						break;
					case 96:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -89:
						break;
					case 97:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -90:
						break;
					case 98:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -91:
						break;
					case 99:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -92:
						break;
					case 100:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -93:
						break;
					case 101:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -94:
						break;
					case 102:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -95:
						break;
					case 103:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -96:
						break;
					case 104:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -97:
						break;
					case 105:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -98:
						break;
					case 106:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -99:
						break;
					case 107:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -100:
						break;
					case 108:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -101:
						break;
					case 109:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -102:
						break;
					case 110:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -103:
						break;
					case 111:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -104:
						break;
					case 112:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -105:
						break;
					case 113:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -106:
						break;
					case 114:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -107:
						break;
					case 115:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -108:
						break;
					case 116:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -109:
						break;
					case 117:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -110:
						break;
					case 118:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -111:
						break;
					case 119:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -112:
						break;
					default:
						yy_error(YY_E_INTERNAL,false);
					case -1:
					}
					yy_initial = true;
					yy_state = yy_state_dtrans[yy_lexical_state];
					yy_next_state = YY_NO_STATE;
					yy_last_accept_state = YY_NO_STATE;
					yy_mark_start();
					yy_this_accept = yy_acpt[yy_state];
					if (YY_NOT_ACCEPT != yy_this_accept) {
						yy_last_accept_state = yy_state;
						yy_mark_end();
					}
				}
			}
		}
	}
}
