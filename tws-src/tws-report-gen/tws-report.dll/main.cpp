//This cpp implements DllMain
#include "commom.h"
#include "export.h"

CALL BOOL DllMain(
    HMODULE hModule,
    DWORD ul_reason_for_call,
    LPVOID lpReserved
){
	switch(ul_reason_for_call){
	case DLL_PROCESS_ATTACH:
        // MessageBox(NULL,"Process attach","Dll called",0);
        break;
	case DLL_THREAD_ATTACH:
        // MessageBox(NULL,"Thread attach","Dll called",0);
        break;
	case DLL_THREAD_DETACH:
        // MessageBox(NULL,"Thread detach","Dll called",0);
        break;
	case DLL_PROCESS_DETACH:
        // MessageBox(NULL,"Process detach","Dll called",0);
        //break;
        ;
	}
	return TRUE;
}
