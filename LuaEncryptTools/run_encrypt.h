#pragma once

#include "../include/desDll.h"
#include <vector>
using namespace std;

// ��des�㷨���ܵ�ǰĿ¼������lua�ļ�
void UserDesDealLuaFile();

// ��ȡ��ǰĿ¼����lua�ļ�
void serachAllLuaFile(string curDir, vector<string> &luaFileVct);