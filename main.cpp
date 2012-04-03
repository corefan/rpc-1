//==============================================
/**
	@date:		2012:3:27  
	@file: 		main.cpp
	@author		zhangshuai
*/
//==============================================

#include <stdio.h>
#include <string>
#include <assert.h>
#include <stdarg.h>

#include "parser/Global.h"
extern int yyparse();
extern FILE* yyin;
#include "generator/Generator.h"
#include "generator/As3Generator.h"
#include "generator/CppGenerator.h"
#include "parser/Program.h"

/**		�ճ�thrift 
		ǰ�˺ͺ�������� �Ժ���Ҫ�ع�!!!!
*/
int main(int argc,char** argv)
{
	Program::inst()->fileName_="zhang.txt";
	yyin = fopen(Program::inst()->fileName_.c_str() , "r" );
	assert(yyin);
	try {
		if (yyparse() != 0) 
		{
			printf("Parser error during include pass.");
		}
	} catch (std::string x) {
		printf(x.c_str());
	}
	/**������ɴ���*/

	Generator* cpp=new CppGenerator(Program::inst(),"cpp");
	Generator* as3=new As3Generator(Program::inst(),"as3");
	cpp->generateProgram();
	as3->generateProgram();
	return 0;
}