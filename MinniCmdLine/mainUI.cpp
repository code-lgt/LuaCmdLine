extern "C"
{
	#include "lua.h"
	#include "lualib.h"
	#include "lauxlib.h"
}

#include <iostream>
#include <fstream>
#include <cstdio>
#include "../include/desDll.h"
using namespace std;

#pragma comment(lib, "..//lib//DesSecurity.lib")

// 加/解密密钥
#define STR_ENCRY_KEY	"b0fc74401d28879b2b1f5a77e13fd6fc5507c622"

// 解密后以字符串形式，加载并执行lua文件
bool DecryptRunLuaByString(lua_State *l, const char* filePath);

int main(int argc, char* argv[])
{
	lua_State* L = lua_open();
	luaL_openlibs(L);

#ifndef _DBG
	if (DecryptRunLuaByString(L, ".//cmdlineFunc.lua"))
#else
	if (luaL_dofile(L, ".//cmdlineFunc.lua"))
#endif
	{
		printf("exe lua file error:%s\n", lua_tostring(L, -1));
		goto EXIT_PROG;
	}

	lua_getglobal(L, "M");
	lua_getfield(L, -1, "showUserOptUI");

	if (lua_pcall(L, 0, 0, 0))
	{
		printf("init env error:%s\n", lua_tostring(L, -1));
		goto EXIT_PROG;
	}

EXIT_PROG:
	lua_close(L);
	system("pause");

	return 0;
}

bool DecryptRunLuaByString(lua_State* l, const char* filePath)
{
	ifstream t(filePath, ios::binary);
	string buffer((istreambuf_iterator<char>(t)),
		istreambuf_iterator<char>());

	int out_len = buffer.length() * 2;
	char *szOut = new char[out_len];
	memset(szOut, 0, out_len);

	DecryptSignalString(buffer.c_str(), buffer.length(), szOut, out_len, STR_ENCRY_KEY);

	bool bRet = luaL_dostring(l, szOut);

	delete[] szOut;
	return bRet;
}