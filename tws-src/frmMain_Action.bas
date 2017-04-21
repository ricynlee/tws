Attribute VB_Name = "frmMain_Action"
Option Explicit

Private Declare Function ReportHtml Lib "tws-report.dll" Alias "report" (ByVal src As String, ByVal dst As String) As Long

Public lsR As Integer, lsG As Integer, lsB As Integer
Public rsR As Integer, rsG As Integer, rsB As Integer

Public Sub SetStatus(ByVal Status As String, Optional ByVal Critical As Boolean = False) '// Critical表示高优先级
    If Critical Then
        frmMain.StatusBar.Caption = Replace(Replace(Status, Chr(10), " "), Chr(13), " ")
        frmMain.StatusBar.Tag = IIf(Status = "", False, True) '// Critical
    Else
        If frmMain.StatusBar.Tag = False Then _
            frmMain.StatusBar.Caption = Replace(Replace(Status, Chr(10), " "), Chr(13), " ")
    End If
End Sub

Public Sub lsRGB(ByVal R As Byte, ByVal G As Byte, ByVal B As Byte)
    lsR = R: lsG = G: lsB = B
    frmMain.tmrLeft.Enabled = True
End Sub

Public Sub rsRGB(ByVal R As Byte, ByVal G As Byte, ByVal B As Byte)
    rsR = R: rsG = G: rsB = B
    frmMain.tmrRight.Enabled = True
End Sub

Public Function CorrectCmdPath(ByVal Path As String) As String
    If InStr(Path, " ") > 0 Then
        Path = """" & Path & """"
    End If
    CorrectCmdPath = Path
End Function

' 返回1  : Dir
' 返回0  : 非Dir
' 返回-1 : 出错
Public Function IsDirectory(ByVal Path As String) As Integer
    On Error GoTo NotExist
    If (GetAttr(Path) And vbDirectory) = vbDirectory Then
        IsDirectory = 1
    Else
        IsDirectory = 0
    End If
    Exit Function
NotExist:
    '// Err.Number应为76
    IsDirectory = (-1)
End Function

Private Function GetDirName(ByVal Path As String) As String
    Dim LastSlashLoc As Integer
    If Right(Path, 1) = "\" Then Path = Left(Path, Len(Path) - 1)
    LastSlashLoc = InStrRev(Path, "\")
    Path = Mid(Path, LastSlashLoc + 1)
    GetDirName = Path
End Function

'/////////////////////////////////////////////////
Public Sub btnInfo_Click()
On Error Resume Next
    Shell App.Path & "\res\about.exe", vbNormalFocus
End Sub

Public Sub btnClose_Click()
    If Not frmMain.btnClose.Enabled Then Exit Sub
    Dim Frm As Form
    For Each Frm In Forms
        Unload Frm
    Next Frm
End Sub

Public Sub LeftBlock_DoubleClick()
    On Error Resume Next
    If LeftPath <> "" Then _
        Shell "explorer /e," & """" & LeftPath & """", vbNormalFocus
End Sub

Public Sub RightBlock_DoubleClick()
    On Error Resume Next
    If RightPath <> "" Then _
        Shell "explorer /e," & """" & RightPath & """", vbNormalFocus
End Sub

Public Sub LeftBlock_Drop(ByVal FileSysPath As String)
    SetStatus "", True
With frmMain
    If FileSysPath = RightPath Then
        SetStatus "左侧不可与右侧相同"
        Call lsRGB(255, 0, 0)
    ElseIf IsDirectory(FileSysPath) <> 1 Then
        ' .LeftBlock.Enabled = False
        SetStatus "左侧应为文件夹"
        Call lsRGB(255, 0, 0)
    Else
        LeftPath = FileSysPath
        .lblLeft.Caption = GetDirName(FileSysPath)
        .LeftBlock.ToolTipText = FileSysPath
        Call lsRGB(0, 255, 0)
    End If
End With
End Sub

Public Sub RightBlock_Drop(ByVal FileSysPath As String)
    SetStatus "", True
With frmMain
    If FileSysPath = LeftPath Then
        SetStatus "右侧不可与左侧相同"
        Call rsRGB(255, 0, 0)
    ElseIf IsDirectory(FileSysPath) <> 1 Then
        ' .RightBlock.Enabled = False
        SetStatus "右侧应为文件夹"
        Call rsRGB(255, 0, 0)
    Else
        RightPath = FileSysPath
        .lblRight.Caption = GetDirName(FileSysPath)
        .RightBlock.ToolTipText = FileSysPath
        Call rsRGB(0, 255, 0)
    End If
End With
End Sub

Public Sub btnGo_Click()
If LeftPath = "" And RightPath = "" Then
    SetStatus "左右文件夹设置有误": Call lsRGB(255, 0, 0): Call rsRGB(255, 0, 0): Exit Sub
ElseIf LeftPath = "" Then
    SetStatus "左侧文件夹设置有误": Call lsRGB(255, 0, 0): Exit Sub
ElseIf RightPath = "" Then
    SetStatus "右侧文件夹设置有误": Call rsRGB(255, 0, 0): Exit Sub
End If

If frmSupport.tmrMnuClick.Enabled = False Then
    If SyncMode = esmLeftToRight Then
        If Not TwsAsk("确定同步吗?", "当前同步模式是""左侧文件夹覆盖右侧"",需要进行文件复制、修改和删除操作,请确定是否进行同步.") Then Exit Sub
    ElseIf SyncMode = esmMutualUpdate Then
        If Not TwsAsk("确定同步吗?", "当前同步模式是""两侧文件夹相互更新"",需要进行文件复制、修改和删除操作,请确定是否进行同步.") Then Exit Sub
    ElseIf SyncMode = esmRightToLeft Then
        If Not TwsAsk("确定同步吗?", "当前同步模式是""右侧文件夹覆盖左侧"",需要进行文件复制、修改和删除操作,请确定是否进行同步.") Then Exit Sub
    End If
End If

    With frmMain
        .btnGo.Picture = LoadPicture(App.Path & "\res\going.bmp")
        .btnGo.Enabled = False
        .btnClose.Enabled = False
        .btnMenu.Enabled = False
        .LeftBlock.Enabled = False
        .RightBlock.Enabled = False
        .tmrSyncking.Enabled = True
    End With
    frmSupport.tmrMnuClick.Enabled = False
    SetStatus "同步中...", True
    On Error GoTo Failure
    Sync
    Exit Sub
Failure:
    Call SyncDone
End Sub

Public Sub SyncDone()
With frmMain
    .btnGo.Enabled = True
    .btnGo.Picture = LoadPicture(App.Path & "\res\to-go.bmp")
    .btnClose.Enabled = True
    .btnMenu.Enabled = True
    .LeftBlock.Enabled = True
    .RightBlock.Enabled = True
    .tmrSyncking.Enabled = False
    SetStatus "同步完成@" & CStr(Now()), True
End With
On Error Resume Next
    If SyncMode <> esmCompareOnly Then Exit Sub
    If ReportHtml(App.Path & "\report\report.txt", App.Path & "\report\report.html") = 0 Then '// Success
        Shell "explorer " & """" & App.Path & "\report\report.html" & """", vbNormalNoFocus
    End If
End Sub

Public Sub Sync()
    Dim cd As String
    cd = CurDir()
    ChDrive Left(App.Path, 2)
    ChDir App.Path
    Dim SyncCmd As String
    SyncCmd = ".\caller.exe " & CStr(frmMain.hWnd) & " " & CStr(HideTerm) & " .\python\python.exe .\core\twowaysync.py" & " " & _
        "--left " & CorrectCmdPath(LeftPath) & " " & _
        "--right " & CorrectCmdPath(RightPath) & " " & _
        "--report report/report.txt" & _
        IIf(SyncMode = esmLeftToRight, " --source=l", _
        IIf(SyncMode = esmRightToLeft, " --source=r", _
        IIf(SyncMode = esmMutualUpdate, " --source=m", "")))
    Call Shell(SyncCmd, vbHide)
    ChDrive Left(cd, 2)
    ChDir cd
End Sub

Public Function TwsAsk(ByVal Major As String, ByVal Minor As String) As Boolean
    frmMsg.msgMajor.Caption = Major
    frmMsg.msgMinor.Caption = Minor
    frmMsg.Show vbModal, frmMain
    TwsAsk = CBool(frmMsg.Tag)
End Function

