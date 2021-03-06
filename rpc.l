%option noyywrap
%option lex-compat
%option never-interactive

identifier    ([a-zA-Z_][a-zA-Z_0-9]*)
fileName	  ([a-zA-Z_0-9\.]*)
%{
#include <string>
#include "parser/Global.h"
#include "parser/DefType.h"
#include "rpc.tab.hpp"

void reserved_keyword(char* keyword) {
  yyerror("Cannot use reserved language keyword: \"%s\"\n", keyword);
}

#define MAX_INCLUDE_DEPTH 10
struct myBuffer
{
	std::string		name_;
	YY_BUFFER_STATE state_;
};

myBuffer include_stack[MAX_INCLUDE_DEPTH];
int include_stack_ptr = 0;

void switchBuf(const char* s)
{
	if ( include_stack_ptr >= MAX_INCLUDE_DEPTH )
	{
		yyerror( "Includes nested too deeply" );
	}
     
	int i=include_stack_ptr++;
	include_stack[i].state_ = YY_CURRENT_BUFFER;
	include_stack[i].name_=curFileName;
	curFileName=s;
	yyin = fopen( s, "r" );
	if(!yyin)
	{
		yyerror( "open %s fail ",s);
	}

	yy_switch_to_buffer( yy_create_buffer( yyin, YY_BUF_SIZE ) );
	BEGIN(0);
}
     
%}


whitespace    ([ \t\r\n]*)
sillycomm     ("/*""*"*"*/")
multicomm     ("/*"[^*]"/"*([^*/]|[^*]"/"|"*"[^/])*"*"*"*/")
comment       ("//"[^\n]*)
symbol        ([:;\,\{\}\(\)\=<>\[\]\"])
%%

"bool"              { return tok_bool;                 }
"uint8"             { return tok_uint8;               }
"int8"				{ return tok_int8;                 }
"uint16"            { return tok_uint16;               }
"int16"				{ return tok_int16;                 }
"uint32"            { return tok_uint32;               }
"int32"				{ return tok_int32;                 }
"int64"				{ return tok_int64;                 }
"float"			    { return tok_float;               }
"string"            { return tok_string;               }

"include"           { return tok_include;              }

"enum"			    {return tok_enum;               }
"struct"			{ return tok_struct;			}
"array"			    { return tok_array;             }
"map"               { return tok_map;              }

"service"           { return tok_service;          }

"dynamic"            { reserved_keyword(yytext); }
"make"				 { reserved_keyword(yytext); }
"go"				 { reserved_keyword(yytext); }
"chan"				 { reserved_keyword(yytext); }
"new"				 { reserved_keyword(yytext); }
"type"				 { reserved_keyword(yytext); }
"func"				 { reserved_keyword(yytext); }
"range"				 { reserved_keyword(yytext); }
"import"			 { reserved_keyword(yytext); }
"interface"			 { reserved_keyword(yytext); }
"as"				 { reserved_keyword(yytext); }
"int"				 { reserved_keyword(yytext); }
"uint"				 { reserved_keyword(yytext); }
"char"				 { reserved_keyword(yytext); }
"uchar"				 { reserved_keyword(yytext); }
"short"				 { reserved_keyword(yytext); }
"ushort"			 { reserved_keyword(yytext); }


{whitespace}         { /* do nothing */                 }
{sillycomm}          { /* do nothing */                 }
{multicomm}          { /* do nothing */                 }
{comment}            { /* do nothing */                 }
{symbol}             { return yytext[0];                }

{identifier}		 { yylval.str_ = new std::string(yytext, yyleng); return tok_identifier; } 
{fileName}			 { yylval.str_ = new std::string(yytext, yyleng); return tok_fileName; } 
<<EOF>> {
             if ( --include_stack_ptr < 0 )
                 {
                 yyterminate();
                 }
     
             else
                 {
                 yy_delete_buffer( YY_CURRENT_BUFFER );
                 yy_switch_to_buffer( include_stack[include_stack_ptr].state_ );
				 curFileName=include_stack[include_stack_ptr].name_;
                 }
	}    
%%