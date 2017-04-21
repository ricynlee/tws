#ifndef DLL_EXPORT
#define DLL_EXPORT

#include "commom.h"

#ifdef  __cplusplus
extern "C"{
#endif // __cplusplus

PORT CALL BOOL DllMain(HMODULE,DWORD,LPVOID);
PORT CALL long report(LPCSTR src, LPCSTR dst);

#ifdef  __cplusplus
}
#endif

#endif // DLL_EXPORT
