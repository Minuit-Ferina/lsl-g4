parser grammar LSLParser
	;
options {
	tokenVocab = LSLLexer;
}

lscript_program
	: global* llstates
	;

global
	: global_variable
	| global_function
	;

declaration
	: typename Identifier (
		'=' expression
	)?
	;

typename
	: Integer
	| Float
	| String
	| Key
	| Vector
	| Quaternion
	| Rotation
	| List
	;

name_type
	: typename identifier
	;

llstates
	: default_state llstate*
	;

default_state
	: StateDefault (
		'{' state_body '}'
	)
	;

llstate
	: State Identifier (
		'{' state_body '}'
	)
	;

global_variable
	: name_type (
		'=' simple_assignable
	)? ';'
	;

simple_assignable
	: simple_assignable_no_list
	| list_constant
	;

simple_assignable_no_list
	: Identifier
	| constant
	| special_constant
	;
constant
	: integer_constant
	| fp_constant
	| StringConstant
	;

fp_constant
	: FloatingConstant
	;

integer_constant
	:
	// IntegerConstant
	StringLiteral
	| numericLiteral
	| IntegerTrue
	| IntegerFalse
	;

numericLiteral
	: DigitSequence
	| HexIntegerLiteral
	| BinaryIntegerLiteral
	;

special_constant
	: vector_constant
	| quaternion_constant
	;

vector_constant
	: '<' simple_assignable ',' simple_assignable ',' simple_assignable '>'
	| ZeroVector
	| TouchInvalidVector
	| TouchInvalidTexcoord
	;
quaternion_constant
	: '<' simple_assignable ',' simple_assignable ',' simple_assignable ',' simple_assignable '>'
	| ZeroRotation
	;

list_constant
	: '[' list_entries? ']'
	;

list_entries
	: list_entry (
		',' list_entry
	)*
	;

list_entry
	: simple_assignable_no_list
	;

global_function
	: identifier '(' function_parameters? ')' compound_statement
	| name_type '(' function_parameters? ')' compound_statement
	;

function_parameters
	: function_parameter (
		',' function_parameter
	)*
	;
function_parameter
	: typename Identifier
	;

state_body
	: event*
	;
///////////////////////////////////////////////////////////////////////////////
// Events
event
	: Identifier '(' function_parameters? ')' compound_statement
	;

//////////////////////////////////////////////////////////////////////////////////////////////////
compound_statement
	: '{' statements? '}'
	;
statements
	: statement+
	;
statement
	: ';'
	| State identifier ';'
	| State StateDefault ';'
	| Jump identifier ';'
	| '@' identifier ';'
	| Return expression ';'
	| Return ';'
	| expression ';'
	| declaration ';'
	| compound_statement
	| If '(' expression ')' statement //prec LOWER_THAN_ELSE
	| If '(' expression ')' statement Else statement
	| For '(' forexpressionlist ';' expression ';' forexpressionlist ')' statement
	| Do statement While '(' expression ')' ';'
	| While '(' expression ')' statement
	;

forexpressionlist
	: nextforexpressionlist
	;

nextforexpressionlist
	: expression
	| expression ',' nextforexpressionlist
	;

funcexpressionlist
	: nextfuncexpressionlist
	;

nextfuncexpressionlist
	: expression (
		',' expression
	)*
	;

listexpressionlist
	: nextlistexpressionlist
	;

nextlistexpressionlist
	: expression (
		',' expression
	)*
	;

expression
	: unaryexpression
	| lvalue '=' expression
	| lvalue PlusAssign expression
	| lvalue MinusAssign expression
	| lvalue StarAssign expression
	| lvalue DivAssign expression
	| lvalue ModAssign expression
	| expression EQ expression
	| expression NEQ expression
	| expression LessEqual expression
	| expression GreaterEqual expression
	| expression '<' expression
	| expression '>' expression
	| expression '+' expression
	| expression '-' expression
	| expression '*' expression
	| expression '/' expression
	| expression '%' expression
	| expression '&' expression
	| expression '|' expression
	| expression '^' expression
	| expression AndAnd expression
	| expression OrOr expression
	| expression LeftShift expression
	| expression RightShift expression
	;

unaryexpression
	: '-' expression
	| '!' expression
	| '~' expression
	| PlusPlus lvalue
	| MinusMinus lvalue
	| typecast
	| unarypostfixexpression
	| '(' expression ')'
	;

typecast
	: '(' typename ')' lvalue
	| '(' typename ')' constant
	| '(' typename ')' unarypostfixexpression
	| '(' typename ')' '(' expression ')'
	;

unarypostfixexpression
	: vector_initializer
	| quaternion_initializer
	| list_initializer
	| lvalue
	| lvalue PlusPlus
	| lvalue MinusMinus
	| identifier '(' funcexpressionlist ')'
	| Print '(' expression ')'
	| constant
	;

vector_initializer
	: '<' expression ',' expression ',' expression '>' //prec INITIALIZER
	| ZeroVector
	| TouchInvalidVector
	| TouchInvalidTexcoord
	;

quaternion_initializer
	: '<' expression ',' expression ',' expression ',' expression '>' //prec INITIALIZER
	| ZeroRotation
	;

list_initializer
	: '[' listexpressionlist ']'
	| '[' ']'
	; //prec INITIALIZER;

lvalue
	: identifier
	| identifier Dot Identifier
	;
identifier
	: Identifier
	;

includeDirective
	: IncludeDirective
	;
