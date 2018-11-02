#include <io.h>
#include "run_encrypt.h"

#pragma comment(lib, "..//lib//DesSecurity.lib")
// 加/解密密钥
#define STR_ENCRY_KEY	"b0fc74401d28879b2b1f5a77e13fd6fc5507c622"

// 用des算法加密当前目录下所有lua文件
void UserDesDealLuaFile()
{
	// 获取所有lua文件
	vector<string> luaFileVct;
	serachAllLuaFile(".//", luaFileVct);

	for (int i = 0; i < luaFileVct.size(); i++)
	{
		// 加密
		EncryptSignalLua(luaFileVct[i].c_str(), STR_ENCRY_KEY);
	}
}

// 获取当前目录所有lua文件
void serachAllLuaFile(string curDir, vector<string> &luaFileVct)
{
	//保存文件列表
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
				// 递归子目录
				serachAllLuaFile(curDir + file.name + "//", luaFileVct);
			}

			//保存文件名
			if (memcmp(file.name + strlen(file.name) - 4, ".lua", 4) == 0)
			{
				luaFileVct.push_back(curDir + file.name);
			}	
		} while (_findnext(longf, &file) == 0);
	}
}