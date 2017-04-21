Attribute VB_Name = "Settings"
Option Explicit


'////////////////////////////////////////////////////
Global LeftPath As String
Global RightPath As String
Global Remember As Boolean
Global HideTerm As Boolean

Public Enum EnumSyncMode
    esmCompareOnly = 0
    esmLeftToRight = 1
    esmRightToLeft = 2
    esmMutualUpdate = 3
End Enum

Global SyncMode As EnumSyncMode

'/////////////////////////////////////////////////////
Public Sub LoadDefaultCfg()
    LeftPath = ""
    RightPath = ""
    Remember = True
    HideTerm = False
    SyncMode = EnumSyncMode.esmCompareOnly
End Sub

Public Function LoadCfg() As Boolean
    On Error GoTo Failure
    Remember = CBool(GetKeyValue(HKEY_CURRENT_USER, "Software\2WS", "Remember"))
    If Remember Then
        LeftPath = GetKeyValue(HKEY_CURRENT_USER, "Software\2WS", "LeftPath"): If IsDirectory(LeftPath) <> 1 Then LeftPath = ""
        RightPath = GetKeyValue(HKEY_CURRENT_USER, "Software\2WS", "RightPath"): If IsDirectory(RightPath) <> 1 Then RightPath = ""
        SyncMode = CInt(GetKeyValue(HKEY_CURRENT_USER, "Software\2WS", "SyncMode"))
        HideTerm = CBool(GetKeyValue(HKEY_CURRENT_USER, "Software\2WS", "HideTerm"))
    Else
        LeftPath = ""
        RightPath = ""
        HideTerm = False
        SyncMode = esmCompareOnly
    End If
    LoadCfg = True
    Exit Function
Failure:
    LoadCfg = False
End Function

Public Sub SaveCfg()
    On Error Resume Next
    Call SetKeyValue(HKEY_CURRENT_USER, "Software\2WS", "Remember", CStr(Remember))
    If Remember Then
        Call SetKeyValue(HKEY_CURRENT_USER, "Software\2WS", "LeftPath", LeftPath)
        Call SetKeyValue(HKEY_CURRENT_USER, "Software\2WS", "RightPath", RightPath)
        Call SetKeyValue(HKEY_CURRENT_USER, "Software\2WS", "SyncMode", CStr(SyncMode))
        Call SetKeyValue(HKEY_CURRENT_USER, "Software\2WS", "HideTerm", CStr(HideTerm))
    End If
End Sub


