#pragma once

#ifdef __cplusplus
#define EXPORT_INTERFACE extern "C" __declspec(dllexport)
#else
#define EXPORT_INTERFACE __declspec(dllexport)
#endif

// 对单个文件加密
EXPORT_INTERFACE void EncryptSignalLua(const char* szPath, const char *szKey);

// 对单个文件解密
EXPORT_INTERFACE void DecryptSignalLua(const char* szPath, const char *szKey);

// 对字符串加密
EXPORT_INTERFACE void EncryptSignalString(const char *in, int in_len, char *out, int &out_len, const char *szKey);

// 对字符串解密
EXPORT_INTERFACE void DecryptSignalString(const char *in, int in_len, char *out, int &out_len, const char *szKey);