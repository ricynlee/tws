#ifndef DLL_COMMOM
#define DLL_COMMON

#include <Windows.h>

#define EXPORT_FUNC

#ifdef  EXPORT_FUNC
#define PORT __declspec(dllexport) //when making dll's
#else
#define PORT __declspec(dllimport) //when compiled using dll's
#endif // EXPORT_FUNC

#define CALL __stdcall //normal call convention
//#define CALL __cdecl //call(param) convention of C

#endif // DLL_COMMOM
