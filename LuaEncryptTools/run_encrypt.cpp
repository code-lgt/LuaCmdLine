#include <io.h>
#include "run_encrypt.h"

#pragma comment(lib, "..//lib//DesSecurity.lib")
// ��/������Կ
#define STR_ENCRY_KEY	"b0fc74401d28879b2b1f5a77e13fd6fc5507c622"

// ��des�㷨���ܵ�ǰĿ¼������lua�ļ�
void UserDesDealLuaFile()
{
	// ��ȡ����lua�ļ�
	vector<string> luaFileVct;
	serachAllLuaFile(".//", luaFileVct);

	for (int i = 0; i < luaFileVct.size(); i++)
	{
		// ����
		EncryptSignalLua(luaFileVct[i].c_str(), STR_ENCRY_KEY);
	}
}

// ��ȡ��ǰĿ¼����lua�ļ�
void serachAllLuaFile(string curDir, vector<string> &luaFileVct)
{
	//�����ļ��б�
	string strSourceDir = curDir +"*.*";

	_finddata_t file;
	long longf;

	if ((longf = _findfirst(strSourceDir.c_str(), &file)) == -1L)
		//if ((longf = _findfirst("*.*", &file)) == -1L)
	{

	}
	else
	{
		string tempName;

		do{
			tempName = "";
			tempName = file.name;
			if (tempName == ".." || tempName == ".")
			{
				continue;
			}
			else if (file.attrib == 16)
			{
				// �ݹ���Ŀ¼
				serachAllLuaFile(curDir + file.name + "//", luaFileVct);
			}

			//�����ļ���
			if (memcmp(file.name + strlen(file.name) - 4, ".lua", 4) == 0)
			{
				luaFileVct.push_back(curDir + file.name);
			}	
		} while (_findnext(longf, &file) == 0);
	}
}