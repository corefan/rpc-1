//==============================================
/**
	@date:		2012:3:29  
	@file: 		As3Generator.h
	@author		zhangshuai
*/
//==============================================
#ifndef	__AS3GENERATOR_H__
#define	__AS3GENERATOR_H__

#include "Generator.h"

/** ����as3 ���*/
class As3Generator :public Generator
{
public:
	As3Generator(Program* pro,const std::string& name):Generator(pro,name){}

	virtual void generateProgram();
	void	generateEnum();
	void    generateStruct();
	std::string typeName(DefType* t);
	std::string DefaultValue( DefType* t );
private:
	std::ofstream	as3File_;
};

#endif