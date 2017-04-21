Attribute VB_Name = "modMain"
Option Explicit
Private Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Private Declare Function WaitForSingleObject Lib "kernel32" (ByVal hHandle As Long, ByVal dwMilliseconds As Long) As Long

Private Const PROCESS_QUERY_INFORMATION = &H400
Private Const STATUS_PENDING = &H103
Private Const SYNCHRONIZE = &H100000
Private Const INFINITE = &HFFFFFFFF

Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Const WM_USER As Long = &H400
Private Const WM_SyncDone As Long = WM_USER + 1

Sub Main()
On Error GoTo Failure
    If Command() = "" Then GoTo Failure
    Dim hWnd As Long, hProc As Long
    Dim HideTerm As Boolean
    Dim Cmdl As String
    Dim SepSpaceIndex As Integer
    
    Cmdl = LTrim(Command())
    SepSpaceIndex = InStr(Cmdl, " ")
    hWnd = CLng(Left(Cmdl, SepSpaceIndex - 1))
    Cmdl = Mid(Cmdl, SepSpaceIndex + 1)
    
    Cmdl = LTrim(Cmdl)
    SepSpaceIndex = InStr(Cmdl, " ")
    HideTerm = CBool(Left(Cmdl, SepSpaceIndex - 1))
    Cmdl = Mid(Cmdl, SepSpaceIndex + 1)
    
    hProc = OpenProcess(SYNCHRONIZE, 0, _
        Shell(Cmdl, IIf(HideTerm, vbHide, vbNormalNoFocus)))
    If hProc <> 0 Then
        Call WaitForSingleObject(hProc, INFINITE)
        Call CloseHandle(hProc)
    End If
    ' MsgBox "caller检测到同步完成!", vbInformation, "tws - caller"
    Call SendMessage(hWnd, WM_SyncDone, 0&, 0&)
Exit Sub
Failure:
    About
End Sub

Private Sub About()
On Error Resume Next
    Shell App.Path & "\res\about.exe", vbNormalFocus
End Sub
