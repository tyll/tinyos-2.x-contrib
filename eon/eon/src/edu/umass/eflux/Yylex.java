package edu.umass.eflux;
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
		/* 45 */ YY_NO_ANCHOR,
		/* 46 */ YY_NO_ANCHOR,
		/* 47 */ YY_NO_ANCHOR,
		/* 48 */ YY_NO_ANCHOR,
		/* 49 */ YY_NO_ANCHOR,
		/* 50 */ YY_NO_ANCHOR,
		/* 51 */ YY_NO_ANCHOR,
		/* 52 */ YY_NO_ANCHOR,
		/* 53 */ YY_NO_ANCHOR,
		/* 54 */ YY_NO_ANCHOR,
		/* 55 */ YY_NO_ANCHOR,
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
		/* 114 */ YY_NO_ANCHOR
	};
	private int yy_cmap[] = unpackFromString(1,130,
"47:9,45,46,47,46:2,47:18,45,15,41:6,3,4,13,41,12,9,41,40,42:10,10,11,41,1,2" +
",14,41,37,44:4,35,44:6,36,44,34,44:8,38,44:2,5,41,6,41,44,41,28,44,26,20,19" +
",21,33,27,32,44:2,30,31,29,23,18,44,25,22,16,24,44:2,39,17,44,7,43,8,47:2,0" +
":2")[0];

	private int yy_rmap[] = unpackFromString(1,115,
"0,1,2,1:10,3,1:2,4,5,1:3,6,1,3:16,2,7,8,7,9,10,11,12,13,14,15,16,17,18,19,2" +
"0,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,4" +
"5,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,3,67,68,69" +
",70,71,72,73,74,75,76,77,78,79")[0];

	private int yy_nxt[][] = unpackFromString(80,48,
"1,2,3,4,5,6,7,8,9,40,10,11,12,13,14,15,16,101,107,109,101:2,75,59,101:2,110" +
",111,112,101:2,60,101:2,61,101,62,101:3,43,3,17,3,101,18:2,3,-1:49,39,19,-1" +
":58,101,-1:2,101:24,-1:2,101,-1,101,-1:16,101,-1:2,101,113,101:14,76,101:7," +
"-1:2,101,-1,101,-1:25,22,-1:2,22,-1,22,-1,22,-1,22:2,-1:9,17,22,-1:5,21:45," +
"-1:4,20,-1:6,42,-1:51,101,-1:2,101:5,23,101:18,-1:2,101,-1,101,-1:43,21,-1:" +
"20,101,-1:2,101:23,24,-1:2,101,-1,101,-1:16,101,-1:2,101:19,25,101:4,-1:2,1" +
"01,-1,101,-1:16,101,-1:2,101:22,26,101,-1:2,101,-1,101,-1:16,101,-1:2,101:1" +
"0,27,101:13,-1:2,101,-1,101,-1:16,101,-1:2,101:9,28,101:14,-1:2,101,-1,101," +
"-1:16,101,-1:2,101:9,29,101:14,-1:2,101,-1,101,-1:16,101,-1:2,101:3,30,101:" +
"20,-1:2,101,-1,101,-1:16,101,-1:2,101:3,31,101:20,-1:2,101,-1,101,-1:16,101" +
",-1:2,101:10,32,101:13,-1:2,101,-1,101,-1:16,101,-1:2,101:5,33,101:18,-1:2," +
"101,-1,101,-1:16,101,-1:2,101:15,34,101:8,-1:2,101,-1,101,-1:16,101,-1:2,10" +
"1:13,35,101:10,-1:2,101,-1,101,-1:16,101,-1:2,101:15,36,101:8,-1:2,101,-1,1" +
"01,-1:16,101,-1:2,101:9,37,101:14,-1:2,101,-1,101,-1:16,101,-1:2,101:13,38," +
"101:10,-1:2,101,-1,101,-1:16,101,-1:2,101:5,41,101:18,-1:2,101,-1,101,-1:16" +
",101,-1:2,101:12,44,101:11,-1:2,101,-1,101,-1:16,101,-1:2,101:19,45,101:4,-" +
"1:2,101,-1,101,-1:16,101,-1:2,101:21,46,101:2,-1:2,101,-1,101,-1:16,101,-1:" +
"2,101:13,47,101:10,-1:2,101,-1,101,-1:16,101,-1:2,101:3,48,101:20,-1:2,101," +
"-1,101,-1:16,101,-1:2,101:7,49,101:16,-1:2,101,-1,101,-1:16,101,-1:2,101:10" +
",50,101:13,-1:2,101,-1,101,-1:16,101,-1:2,101:14,51,101:9,-1:2,101,-1,101,-" +
"1:16,101,-1:2,101:16,52,101:7,-1:2,101,-1,101,-1:16,101,-1:2,101:3,53,101:2" +
"0,-1:2,101,-1,101,-1:16,101,-1:2,101:12,54,101:11,-1:2,101,-1,101,-1:16,101" +
",-1:2,101:7,55,101:16,-1:2,101,-1,101,-1:16,101,-1:2,101:9,56,101:14,-1:2,1" +
"01,-1,101,-1:16,101,-1:2,101:3,57,101:20,-1:2,101,-1,101,-1:16,101,-1:2,101" +
":7,58,101:16,-1:2,101,-1,101,-1:16,101,-1:2,114,63,101,80,101:3,81,101:16,-" +
"1:2,101,-1,101,-1:16,101,-1:2,101:15,64,101:8,-1:2,101,-1,101,-1:16,101,-1:" +
"2,101:7,84,101:16,-1:2,101,-1,101,-1:16,101,-1:2,101:12,85,101:11,-1:2,101," +
"-1,101,-1:16,101,-1:2,101:9,65,101:14,-1:2,101,-1,101,-1:16,101,-1:2,101:6," +
"103,101:17,-1:2,101,-1,101,-1:16,101,-1:2,101:8,86,101:15,-1:2,101,-1,101,-" +
"1:16,101,-1:2,101:13,108,101:10,-1:2,101,-1,101,-1:16,101,-1:2,101:3,89,101" +
":20,-1:2,101,-1,101,-1:16,101,-1:2,101:17,90,101:6,-1:2,101,-1,101,-1:16,10" +
"1,-1:2,91,101:23,-1:2,101,-1,101,-1:16,101,-1:2,101:9,66,101:14,-1:2,101,-1" +
",101,-1:16,101,-1:2,101:4,67,101:19,-1:2,101,-1,101,-1:16,101,-1:2,101:15,6" +
"8,101:8,-1:2,101,-1,101,-1:16,101,-1:2,101:4,69,101:19,-1:2,101,-1,101,-1:1" +
"6,101,-1:2,101:9,70,101:14,-1:2,101,-1,101,-1:16,101,-1:2,101:5,94,101:18,-" +
"1:2,101,-1,101,-1:16,101,-1:2,101:3,95,101:20,-1:2,101,-1,101,-1:16,101,-1:" +
"2,101:16,71,101:7,-1:2,101,-1,101,-1:16,101,-1:2,101:7,72,101:16,-1:2,101,-" +
"1,101,-1:16,101,-1:2,101:7,97,101:16,-1:2,101,-1,101,-1:16,101,-1:2,101:10," +
"98,101:13,-1:2,101,-1,101,-1:16,101,-1:2,101:9,99,101:14,-1:2,101,-1,101,-1" +
":16,101,-1:2,100,101:23,-1:2,101,-1,101,-1:16,101,-1:2,101:4,73,101:19,-1:2" +
",101,-1,101,-1:16,101,-1:2,101:16,74,101:7,-1:2,101,-1,101,-1:16,101,-1:2,1" +
"01:7,88,101:16,-1:2,101,-1,101,-1:16,101,-1:2,101:6,93,101:17,-1:2,101,-1,1" +
"01,-1:16,101,-1:2,101:13,87,101:10,-1:2,101,-1,101,-1:16,101,-1:2,92,101:23" +
",-1:2,101,-1,101,-1:16,101,-1:2,101:3,96,101:20,-1:2,101,-1,101,-1:16,101,-" +
"1:2,101:9,77,101:4,78,101:9,-1:2,101,-1,101,-1:16,101,-1:2,101:13,106,101:1" +
"0,-1:2,101,-1,101,-1:16,101,-1:2,101:9,79,101:14,-1:2,101,-1,101,-1:16,101," +
"-1:2,101:7,82,101:16,-1:2,101,-1,101,-1:16,101,-1:2,101:12,104,101:11,-1:2," +
"101,-1,101,-1:16,101,-1:2,102,101:23,-1:2,101,-1,101,-1:16,101,-1:2,101:2,8" +
"3,101:21,-1:2,101,-1,101,-1:16,101,-1:2,101:12,105,101:11,-1:2,101,-1,101,-" +
"1:3");

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
						{ System.err.println("Illegal character: "+yytext()); }
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
						{ return new Symbol(sym.COLON); }
					case -11:
						break;
					case 11:
						{ return new Symbol(sym.SEMI); }
					case -12:
						break;
					case 12:
						{ return new Symbol(sym.COMMA); }
					case -13:
						break;
					case 13:
						{ return new Symbol(sym.STAR); }
					case -14:
						break;
					case 14:
						{ return new Symbol(sym.QUESTION); }
					case -15:
						break;
					case 15:
						{ return new Symbol(sym.EXCLAMATION); }
					case -16:
						break;
					case 16:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -17:
						break;
					case 17:
						{ return new Symbol(sym.NUMBER, new Integer(yytext())); }
					case -18:
						break;
					case 18:
						{ /* ignore white space. */ }
					case -19:
						break;
					case 19:
						{ return new Symbol(sym.ARROW); }
					case -20:
						break;
					case 20:
						{ return new Symbol(sym.PIPE); }
					case -21:
						break;
					case 21:
						{}
					case -22:
						break;
					case 22:
						{ return new Symbol(sym.TIME, new String(yytext())); }
					case -23:
						break;
					case 23:
						{ return new Symbol(sym.OFF); }
					case -24:
						break;
					case 24:
						{ return new Symbol(sym.MAX); }
					case -25:
						break;
					case 25:
						{ return new Symbol(sym.OFF); }
					case -26:
						break;
					case 26:
						{ return new Symbol(sym.MAX); }
					case -27:
						break;
					case 27:
						{ return new Symbol(sym.SYNC); }
					case -28:
						break;
					case 28:
						{ return new Symbol(sym.TIMER); }
					case -29:
						break;
					case 29:
						{ return new Symbol(sym.ERROR); }
					case -30:
						break;
					case 30:
						{ return new Symbol(sym.SOURCEDEF); }
					case -31:
						break;
					case 31:
						{ return new Symbol(sym.HANDLE); }
					case -32:
						break;
					case 32:
						{ return new Symbol(sym.ATOMIC); }
					case -33:
						break;
					case 33:
						{ return new Symbol(sym.TYPEDEF); }
					case -34:
						break;
					case 34:
						{ return new Symbol(sym.PROGRAM); }
					case -35:
						break;
					case 35:
						{ return new Symbol(sym.SESSION); }
					case -36:
						break;
					case 36:
						{ return new Symbol(sym.PLATFORM); }
					case -37:
						break;
					case 37:
						{ return new Symbol(sym.STATEORDER); }
					case -38:
						break;
					case 38:
						{ return new Symbol(sym.CONNECTION); }
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
					case 45:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -44:
						break;
					case 46:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -45:
						break;
					case 47:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -46:
						break;
					case 48:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -47:
						break;
					case 49:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -48:
						break;
					case 50:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -49:
						break;
					case 51:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -50:
						break;
					case 52:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -51:
						break;
					case 53:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -52:
						break;
					case 54:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -53:
						break;
					case 55:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -54:
						break;
					case 56:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -55:
						break;
					case 57:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -56:
						break;
					case 58:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -57:
						break;
					case 59:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -58:
						break;
					case 60:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -59:
						break;
					case 61:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -60:
						break;
					case 62:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -61:
						break;
					case 63:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -62:
						break;
					case 64:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -63:
						break;
					case 65:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -64:
						break;
					case 66:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -65:
						break;
					case 67:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -66:
						break;
					case 68:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -67:
						break;
					case 69:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -68:
						break;
					case 70:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -69:
						break;
					case 71:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -70:
						break;
					case 72:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -71:
						break;
					case 73:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -72:
						break;
					case 74:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -73:
						break;
					case 75:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -74:
						break;
					case 76:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -75:
						break;
					case 77:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -76:
						break;
					case 78:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -77:
						break;
					case 79:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -78:
						break;
					case 80:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -79:
						break;
					case 81:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -80:
						break;
					case 82:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -81:
						break;
					case 83:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -82:
						break;
					case 84:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -83:
						break;
					case 85:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -84:
						break;
					case 86:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -85:
						break;
					case 87:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -86:
						break;
					case 88:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -87:
						break;
					case 89:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -88:
						break;
					case 90:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -89:
						break;
					case 91:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -90:
						break;
					case 92:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -91:
						break;
					case 93:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -92:
						break;
					case 94:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -93:
						break;
					case 95:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -94:
						break;
					case 96:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -95:
						break;
					case 97:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -96:
						break;
					case 98:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -97:
						break;
					case 99:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -98:
						break;
					case 100:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -99:
						break;
					case 101:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -100:
						break;
					case 102:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -101:
						break;
					case 103:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -102:
						break;
					case 104:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -103:
						break;
					case 105:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -104:
						break;
					case 106:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -105:
						break;
					case 107:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -106:
						break;
					case 108:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -107:
						break;
					case 109:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -108:
						break;
					case 110:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -109:
						break;
					case 111:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -110:
						break;
					case 112:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -111:
						break;
					case 113:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -112:
						break;
					case 114:
						{ return new Symbol(sym.IDENTIFIER, new String(yytext()));}
					case -113:
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
