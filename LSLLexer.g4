//////////////////////////////////////
// Lexer

lexer grammar LSLLexer
	;

channels {
	WHITESPACE_CHANNEL,
	COMMENTS_CHANNEL
}

Integer
	: 'integer'
	;
Float
	: 'float'
	;
String
	: 'string'
	;
Key
	: 'key'
	;
Vector
	: 'vector'
	;
Quaternion
	: 'quaternion'
	;
Rotation
	: 'rotation'
	;
List
	: 'list'
	;

StateDefault
	: 'default'
	;
State
	: 'state'
	;
Event
	: 'event'
	;
Jump
	: 'jump'
	;
Return
	: 'return'
	;
If
	: 'if'
	;
Else
	: 'else'
	;
For
	: 'for'
	;
Do
	: 'do'
	;
While
	: 'while'
	;

Print
	: 'print'
	;

Dot
	: '.'
	;

IntegerTrue
	: 'TRUE'
	;
IntegerFalse
	: 'FALSE'
	;
ZeroVector
	: 'ZERO_Vector'
	;
ZeroRotation
	: 'ZERO_ROTATION'
	;
TouchInvalidVector
	: 'TOUCH_INVALID_Vector'
	;
TouchInvalidTexcoord
	: 'TOUCH_INVALID_TEXCOORD'
	;

PlusPlus
	: '++'
	;
MinusMinus
	: '--'
	;
PlusAssign
	: '+='
	;
MinusAssign
	: '-='
	;
StarAssign
	: '*='
	;
DivAssign
	: '/='
	;
ModAssign
	: '%='
	;
Semi
	: ';'
	;
Comma
	: ','
	;
Assign
	: '='
	;

LeftParen
	: '('
	;
RightParen
	: ')'
	;
LeftBracket
	: '['
	;
RightBracket
	: ']'
	;
LeftBrace
	: '{'
	;
RightBrace
	: '}'
	;

Plus
	: '+'
	;
Minus
	: '-'
	;
Asterisk
	: '*'
	;
At
	: '@'
	;
Greater
	: '>'
	;
Less
	: '<'
	;
EQ
	: '=='
	;
NEQ
	: '!='
	;
GreaterEqual
	: '>='
	;
LessEqual
	: '<='
	;
And
	: '&'
	;
Or
	: '|'
	;
Caret
	: '^'
	;
Tilde
	: '~'
	;
Not
	: '!'
	;
AndAnd
	: '&&'
	;
OrOr
	: '||'
	;
LeftShift
	: '<<'
	;
RightShift
	: '>>'
	;

StringConstant
	: '"' .*? '"'
	;
Slash
	: '/'
	;

Mod
	: '%'
	;

// DecimalLiteral: DecimalIntegerLiteral '.' [0-9] [0-9_]* ExponentPart? | '.' [0-9] [0-9_]*
// ExponentPart? | DecimalIntegerLiteral ExponentPart?;

// fragment DecimalIntegerLiteral: '0' | [1-9] [0-9_]*;

HexIntegerLiteral
	: '0' [xX] [0-9a-fA-F] HexDigit*
	;
// OctalIntegerLiteral: '0' [0-7]+ {!this.IsStrictMode()}?; OctalIntegerLiteral2: '0' [oO] [0-7]
// [_0-7]*;
BinaryIntegerLiteral
	: [01] [_01]* [bB]
	;
StringLiteral
	: (
		'"' DoubleStringCharacter* '"'
		| '\'' SingleStringCharacter* '\''
	)
	;

fragment HexDigit
	: [_0-9a-fA-F]
	;
fragment DoubleStringCharacter
	: ~["\\\r\n]
	| '\\' EscapeSequence
	| LineContinuation
	;

fragment SingleStringCharacter
	: ~['\\\r\n]
	| '\\' EscapeSequence
	| LineContinuation
	;
fragment LineContinuation
	: '\\' [\r\n\u2028\u2029]
	;

fragment EscapeSequence
	: CharacterEscapeSequence
	| '0' // no digit ahead! TODO
	| HexEscapeSequence
	;
fragment CharacterEscapeSequence
	: SingleEscapeCharacter
	| NonEscapeCharacter
	;
fragment SingleEscapeCharacter
	: ['"\\bfnrtv]
	;
fragment HexEscapeSequence
	: 'x' HexDigit HexDigit
	;
fragment NonEscapeCharacter
	: ~['"\\bfnrtv0-9xu\r\n]
	;

fragment IdentifierNondigit
	: Nondigit
	;
//|   // other implementation-defined characters...

fragment Nondigit
	: [a-zA-Z_]
	;

// Constant: IntegerConstant | FloatingConstant //| EnumerationConstant | CCharSequence | List |
// vector_constant | Quaternion; fragment IntegerConstant: DecimalConstant; | HexadecimalConstant |
// BinaryConstant;

// fragment CCharSequence: CChar+;

// fragment CChar: ~['\\\r\n] | EscapeSequence;

// StringLiteral: '"' SCharSequence? '"';

// fragment SCharSequence: SChar+;

// fragment SChar: ~["\\\r\n] | EscapeSequence | '\\\n' // Added line | '\\\r\n'; Added line

// fragment EscapeSequence: SimpleEscapeSequence | HexadecimalEscapeSequence;

// fragment SimpleEscapeSequence: '\\' ['"?abfnrtv\\]; fragment HexadecimalEscapeSequence: '\\x'
// HexadecimalDigit+;

fragment HexadecimalConstant
	: HexadecimalPrefix HexadecimalDigit+
	;
fragment HexadecimalPrefix
	: '0' [xX]
	;
fragment HexadecimalDigit
	: [0-9a-fA-F]
	;
fragment BinaryConstant
	: '0' [bB] [0-1]+
	;

fragment DecimalConstant
	: NonzeroDigit Digit*
	;
fragment NonzeroDigit
	: [1-9]
	;

FloatingConstant
	: DecimalFloatingConstant
	;

fragment HexadecimalDigitSequence
	: HexadecimalDigit+
	;

fragment DecimalFloatingConstant
	: FractionalConstant ExponentPart? FloatingSuffix?
	| DigitSequence ExponentPart FloatingSuffix?
	;

fragment FractionalConstant
	: DigitSequence? '.' DigitSequence
	| DigitSequence '.'
	;

fragment ExponentPart
	: [eE] Sign? DigitSequence
	;

fragment Sign
	: [+-]
	;

DigitSequence
	: Digit+
	;

fragment Digit
	: [0-9]
	;

fragment FloatingSuffix
	: [flFL]
	;

ComplexDefine
	: '#' Whitespace? 'define' ~[#\r\n]* -> channel(HIDDEN)
	;

IncludeDirective
	: '#' Whitespace? 'include' Whitespace? (
		'"' ~[\r\n]* '"'
		| '<' ~[\r\n]* '>'
	) Whitespace? Newline -> channel(HIDDEN)
	;

Whitespace
	: [ \t]+ -> skip
	;

Newline
	: (
		'\r' '\n'?
		| '\n'
	) -> skip
	;

BlockComment
	: '/*' .*? '*/' -> channel(COMMENTS_CHANNEL)
	;

LineComment
	: '//' ~[\r\n]* -> channel(COMMENTS_CHANNEL)
	;

Identifier
	: IdentifierNondigit (
		IdentifierNondigit
		| Digit
	)*
	;
