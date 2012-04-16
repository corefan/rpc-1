//==============================================
/**
	@date:		2012:3:29  
	@file: 		CppGenerator.h
	@author		zhangshuai
*/
//==============================================

#ifndef	__CPPGENERATOR_H__
#define	__CPPGENERATOR_H__
#include "Generator.h"

/** ����cpp ���*/
class CppGenerator: public Generator
{
public:
	CppGenerator(Program* pro,const std::string& name);

	virtual void generateProgram();

private:
	void generateEnumHeader();
	void generateEnumSrc();

	void generateStructHeader();
	void generateStructSrc();

	void generateServiceHeader();
	void generateServiceSrc();

	void defineField(FieldDefType* t);
	std::string typeName(DefType* t,bool isAgr=false);
	std::string DefaultValue( DefType* t );

	void serializeField( DefType* t ,const std::string& fieldName );
	void deSerializeField( DefType* t ,const std::string& fieldName );

	void serializeFields( StructDefType* t );
	void deSerializeFields( StructDefType* t );

	void genServiceStubHeader();
	void genServiceStubSrc();
	void genServiceProxyHeader();
	void genServiceProxySrc();

	void genFunAgrList(std::ofstream& stream,StructDefType* agrList,bool onlyValue=false);
	void genFunStubDeclare(ServiceDefType* service);
	void genFunProxyDeclare(ServiceDefType* service);

	void genIncludeHeader(std::ofstream& stream);

	void genInterfaceDeclare(ServiceDefType* service);

private:
	std::ofstream	headerFile_;	//<ͷ�ļ�
	std::ofstream	srcFile_;		//<Դ�ļ�
	std::ofstream	ifFile_;		//<�ӿ��ļ�
};

#endif