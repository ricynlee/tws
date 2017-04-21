Attribute VB_Name = "Process"
Option Explicit

Private Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hWnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long) As Long
Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Const GWL_WNDPROC As Long = -4
Private Const GWL_USERDATA As Long = (-21)

Private Const WM_USER As Long = &H400
Private Const WM_MOUSEMOVE As Long = &H200&
Private Const WM_SYSCOMMAND As Long = &H112&
Private Const WM_LBUTTONDOWN = &H201&

Private Const WM_SyncDone As Long = WM_USER + 1

Public lpOldWndProc As Long '// Public

Public Function Hook(ByVal hWnd As Long) As Long
  Dim pOld As Long
'指定自定义的窗口过程
  pOld = SetWindowLong(hWnd, GWL_WNDPROC, AddressOf WindowProc)
'保存原来默认的窗口过程指针
  SetWindowLong hWnd, GWL_USERDATA, pOld
  Hook = pOld
End Function

Public Sub Unhook(ByVal hWnd As Long, ByVal lpWndProc As Long)
  Dim temp As Long
  '注释：Cease subclassing.
  temp = SetWindowLong(hWnd, GWL_WNDPROC, lpWndProc)
End Sub

Public Function WindowProc(ByVal hWnd As Long, ByVal uMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    If uMsg = WM_SyncDone Then
        '// 响应自定义消息
        SyncDone
    Else
        WindowProc = CallWindowProc(lpOldWndProc, hWnd, uMsg, wParam, lParam)
        If uMsg = WM_LBUTTONDOWN Then
            SetStatus ""
        ElseIf uMsg = WM_SYSCOMMAND And wParam = 61536 And lParam = 0 Then
            btnClose_Click
        '// ElseIf uMsg = WM_MOUSEMOVE Then
        '//     x = (lParam And &HFFFF&): y = (lParam And &HFFFF0000) / &H10000
        End If
    End If
End Function
