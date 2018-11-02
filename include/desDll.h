#pragma once

#ifdef __cplusplus
#define EXPORT_INTERFACE extern "C" __declspec(dllexport)
#else
#define EXPORT_INTERFACE __declspec(dllexport)
#endif

// �Ե����ļ�����
EXPORT_INTERFACE void EncryptSignalLua(const char* szPath, const char *szKey);

// �Ե����ļ�����
EXPORT_INTERFACE void DecryptSignalLua(const char* szPath, const char *szKey);

// ���ַ�������
EXPORT_INTERFACE void EncryptSignalString(const char *in, int in_len, char *out, int &out_len, const char *szKey);

// ���ַ�������
EXPORT_INTERFACE void DecryptSignalString(const char *in, int in_len, char *out, int &out_len, const char *szKey);