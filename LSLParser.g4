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
		'{' state_body? '}'
	)?
	;

llstate
	: State Identifier (
		'{' state_body? '}'
	)?
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
	: event state_body?
	;
///////////////////////////////////////////////////////////////////////////////
// Events
event
	: state_entry compound_statement
	| state_exit compound_statement
	| touch_start compound_statement
	| touch compound_statement
	| touch_end compound_statement
	| collision_start compound_statement
	| collision compound_statement
	| collision_end compound_statement
	| land_collision_start compound_statement
	| land_collision compound_statement
	| land_collision_end compound_statement
	| timer compound_statement
	| chat compound_statement
	| sensor compound_statement
	| no_sensor compound_statement
	| at_target compound_statement
	| not_at_target compound_statement
	| at_rot_target compound_statement
	| not_at_rot_target compound_statement
	| money compound_statement
	| email compound_statement
	| run_time_permissions compound_statement
	| changed compound_statement
	| attach compound_statement
	| dataserver compound_statement
	| control compound_statement
	| moving_start compound_statement
	| moving_end compound_statement
	| rez compound_statement
	| object_rez compound_statement
	| link_message compound_statement
	| remote_data compound_statement
	| http_response compound_statement
	| http_request compound_statement
	| transaction_result compound_statement
	| path_update compound_statement
	| experience_permissions compound_statement
	| experience_permissions_denied compound_statement
	| linkset_data compound_statement
	;

state_entry
	: StateEntry '(' ')'
	;

state_exit
	: StateExit '(' ')'
	;

touch_start
	: TouchStart '(' Integer Identifier ')'
	;

touch
	: Touch '(' Integer Identifier ')'
	;

touch_end
	: TouchEnd '(' Integer Identifier ')'
	;

collision_start
	: CollisionStart '(' Integer Identifier ')'
	;

collision
	: Collision '(' Integer Identifier ')'
	;

collision_end
	: CollisionEnd '(' Integer Identifier ')'
	;

land_collision_start
	: LandCollisionStart '(' Vector Identifier ')'
	;

land_collision
	: LandCollision '(' Vector Identifier ')'
	;

land_collision_end
	: LandCollisionEnd '(' Vector Identifier ')'
	;

at_target
	: AtTarget '(' Integer Identifier ',' Vector Identifier ',' Vector Identifier ')'
	;

not_at_target
	: NotAtTarget '(' ')'
	;

at_rot_target
	: AtRotTarget '(' Integer Identifier ',' (
		Quaternion
		| Rotation
	) Identifier ',' (
		Quaternion
		| Rotation
	) Identifier ')'
	;
not_at_rot_target
	: NotAtRotTarget '(' ')'
	;
money
	: Money '(' Key Identifier ',' Integer Identifier ')'
	;
email
	: Email '(' String Identifier ',' String Identifier ',' String Identifier ',' String Identifier
		',' Integer Identifier ')'
	;
run_time_permissions
	: RunTimePermissions '(' Integer Identifier ')'
	;

changed
	: Changed '(' Integer Identifier ')'
	;
attach
	: Attach '(' Key Identifier ')'
	;
dataserver
	: Dataserver '(' Key Identifier ',' String Identifier ')'
	;
moving_start
	: MovingStart '(' ')'
	;
moving_end
	: MovingEnd '(' ')'
	;
timer
	: Timer '(' ')'
	;
chat
	: Chat '(' Integer Identifier ',' String Identifier ',' Key Identifier ',' String Identifier ')'
	;
sensor
	: Sensor '(' Integer Identifier ')'
	;
no_sensor
	: NoSensor '(' ')'
	;
control
	: Control '(' Key Identifier ',' Integer Identifier ',' Integer Identifier ')'
	;
rez
	: Rez '(' Integer Identifier ')'
	;
object_rez
	: ObjectRez '(' Key Identifier ')'
	;
link_message
	: LinkMessage '(' Integer Identifier ',' Integer Identifier ',' String Identifier ',' Key
		Identifier ')'
	;
remote_data
	: RemoteData '(' Integer Identifier ',' Key Identifier ',' Key Identifier ',' String Identifier
		',' Integer Identifier ',' String Identifier ')'
	;
http_response
	: HttpResponse '(' Key Identifier ',' Integer Identifier ',' List Identifier ',' String
		Identifier ')'
	;
http_request
	: HttpRequest '(' Key Identifier ',' String Identifier ',' String Identifier ')'
	;
transaction_result
	: TransactionResult '(' Key Identifier ',' Integer Identifier ',' String Identifier ')'
	;
path_update
	: PathUpdate '(' Integer Identifier ',' List Identifier ')'
	;
experience_permissions
	: ExperiencePermissions '(' Key Identifier ')'
	;
experience_permissions_denied
	: ExperiencePermissionsDenied '(' Key Identifier ',' Integer Identifier ')'
	;

// integer action, string name, string value
linkset_data
	: LinksetData '(' Integer Identifier ',' String Identifier ',' String Identifier ')'
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
