@echo off

cd /d %~dp0
set PATH=h:\mingw32\bin;C:\ProgramFiles\mingw\bin;%PATH%

:: 务必使用TDM-GCC编译器
g++ -shared -Wl,-s -m32 -Os -o ../../../tws-amd64/tws-report.dll tree.cpp node.cpp main.cpp export.cpp -Wl,--add-stdcall-alias
