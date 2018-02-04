@echo off
cd /d %~dp0
::  reg delete HKCU\Softare\2WS /f
::  rmdir %~dp0 /s /q

del core\*.pyc
del python\Lib\encodings\*.pyc
del python\Lib\*.pyc
del core\*.pyo
del python\Lib\encodings\*.pyo
del python\Lib\*.pyo
del report\report.txt
del report\report.html
