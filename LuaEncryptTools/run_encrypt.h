#pragma once

#include "../include/desDll.h"
#include <vector>
using namespace std;

// 用des算法加密当前目录下所有lua文件
void UserDesDealLuaFile();

// 获取当前目录所有lua文件
void serachAllLuaFile(string curDir, vector<string> &luaFileVct);