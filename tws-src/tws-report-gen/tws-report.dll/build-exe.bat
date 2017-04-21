@echo off

cd /d %~dp0
set PATH=h:\mingw32\bin;C:\ProgramFiles\mingw\bin;%PATH%

g++ -Wl,-s -Os -o tws-report.exe report-gen.cpp tree.cpp node.cpp
