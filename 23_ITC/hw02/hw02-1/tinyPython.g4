/* https://github.com/antlr/grammars-v4/blob/master/python/tiny-python/tiny-grammar-without-actions/Python3.g4

https://stackoverflow.com/questions/62015426/tiny-python-add-skip-blank-line-rule-antlr4
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Bart Kiers
 * Copyright (c) 2019 Robert Einhorn
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 * Project      : Python3-parser; an ANTLR4 grammar for Python 3
 *                https://github.com/bkiers/Python3-parser
 * Developed by : Bart Kiers, bart@big-o.nl
 *
 * Project      : an ANTLR4 grammar for Tiny Python without embedded actions
 *                https://github.com/antlr/grammars-v4/tree/master/python/tiny-python/tiny-grammar-without-actions
 * Developed by : Robert Einhorn, robert.einhorn.hu@gmail.com
 */

// Based on the Bart Kiers's ANTLR4 Python 3.3 grammar: https://github.com/bkiers/Python3-parser
// and the Python 3.3.7 Language Reference:             https://docs.python.org/3.3/reference/grammar.html

grammar tinyPython; // tiny version     for Compiler CNU

@header {
    package tinyPython;
}
//    k = 2;
// tokens { INDENT, DEDENT }

/*
 * parser rules
 */

// startRules:
program:
    file_input { System.out.println("202102699 Rule start"); }
    ;

//single_input: NEWLINE | simple_stmt | compound_stmt NEWLINE;
file_input:
    (NEWLINE | stmt)* EOF {
        System.out.println("202102699 Rule 0");
    }
    ;

stmt:                           
      simple_stmt { System.out.println("202102699 Rule 1-1"); }
    | compound_stmt { System.out.println("202102699 Rule 1-2"); }
    ;

simple_stmt:
    small_stmt NEWLINE { System.out.println("202102699 Rule 2"); }
    ;

small_stmt:                     
      assignment_stmt { System.out.println("202102699 Rule 3-1"); }
    | flow_stmt { System.out.println("202102699 Rule 3-2"); }
    | print_stmt { System.out.println("202102699 Rule 3-3"); }
    | return_stmt { System.out.println("202102699 Rule 3-4"); }
    ;

assignment_stmt:
    NAME '=' expr { System.out.println("202102699 Rule 4"); }
    ;

flow_stmt:                      
      break_stmt { System.out.println("202102699 Rule 5-1"); }
    | continue_stmt { System.out.println("202102699 Rule 5-2"); }
    ;

break_stmt:
    'break' { System.out.println("202102699 Rule 6"); }
    ;

continue_stmt:
    'continue' { System.out.println("202102699 Rule 7"); }
    ;

compound_stmt:                  
      if_stmt { System.out.println("202102699 Rule 8-1"); }
    | while_stmt { System.out.println("202102699 Rule 8-2"); }
    | def_stmt { System.out.println("202102699 Rule 8-3"); }
    ;

if_stmt:
    'if' test ':' suite ('elif' test ':' suite)* ('else' ':' suite)?
    { System.out.println("202102699 Rule 9"); }
    ;

while_stmt:
    'while' test ':' suite { System.out.println("202102699 Rule 10"); }
    ;

def_stmt:
    'def' NAME OPEN_PAREN args CLOSE_PAREN ':' suite
    { System.out.println("202102699 Rule 11"); }
    ;

suite:                          
      simple_stmt { System.out.println("202102699 Rule 12-1"); }
    | NEWLINE  stmt+ { System.out.println("202102699 Rule 12-2"); }
    ;

args:                           
     { System.out.println("202102699 Rule 13-1"); }
    | NAME (',' NAME)* { System.out.println("202102699 Rule 13-2"); }
    ;

return_stmt:
    'return' expr? { System.out.println("202102699 Rule 14"); }
    ;

test:
    expr (comp_op expr)* { System.out.println("202102699 Rule 15"); }
    ;

print_stmt:
    'print' print_arg { System.out.println("202102699 Rule 16"); }
    ;

print_arg:                      
      STRING { System.out.println("202102699 Rule 17-1"); }
    | expr { System.out.println("202102699 Rule 17-2"); }
    ;

comp_op:                        
      '<' { System.out.println("202102699 Rule 18-1"); }
    | '>' { System.out.println("202102699 Rule 18-2"); }
    | '==' { System.out.println("202102699 Rule 18-3"); }
    | '>=' { System.out.println("202102699 Rule 18-4"); }
    | '<=' { System.out.println("202102699 Rule 18-5"); }
    | '!=' { System.out.println("202102699 Rule 18-6"); }
    ;

expr:                           
      NAME { System.out.println("202102699 Rule 19-1"); }
    | NUMBER { System.out.println("202102699 Rule 19-2"); }
    | '(' expr ')' { System.out.println("202102699 Rule 19-3"); }
    | expr (( '+' | '-' ) expr)+ { System.out.println("202102699 Rule 19-4"); }
 ;


/*
 * lexer rules
 */

STRING:
    STRING_LITERAL
    ;

NUMBER:
    INTEGER
    ;

// 왜 [0-9]+ 로 안하는거? 0으로 시작하는 숫자는 무조건 0으로 빠지게 하려고 (0001 이런거 안 받으려고)
//INTEGER:
//    [0-9]+
//    ;
INTEGER:
    DECIMAL_INTEGER
    ;

NEWLINE:
    ( '\r'? '\n' | '\r' | '\f' ) SPACES?
    ;

NAME:
    ID_START ID_CONTINUE*
    ;

STRING_LITERAL:
    '"' .*? '"'
    ;

DECIMAL_INTEGER:
      NON_ZERO_DIGIT DIGIT*
    | '0'+
    ;

OPEN_PAREN:     '(';
CLOSE_PAREN:    ')';
OPEN_BRACK:     '[';
CLOSE_BRACK:    ']';
OPEN_BRACE:     '{';
CLOSE_BRACE:    '}';

SKIP_:
    ( SPACES | COMMENT | LINE_JOINING ) -> skip
    ;

UNKNOWN_CHAR:
    .
    ;


/*
 * fragments
 */

fragment NON_ZERO_DIGIT:
    [1-9]
    ;

fragment DIGIT:
    [0-9]
    ;

fragment SPACES:
    [ \t]+
    ;

fragment COMMENT:
    '#' ~[\r\n\f]*
    ;

fragment LINE_JOINING:
    '\\' SPACES? ( '\r'? '\n' | '\r' | '\f' )
    ;

fragment ID_START:
    '_'
    | [A-Z]
    | [a-z]
    ;

fragment ID_CONTINUE:
    ID_START
    | [0-9]
    ;
